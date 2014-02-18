//
//  ToolbarItemControl.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 11/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ToolbarItemControl.h"
#import "ToolbarItem.h"
#import "ToolbarMenuCallback.h"
#import "MenuItem.h"

#import "NativityControl.h"
#import "NativityMessage.h"

#import "Constants.h"

#import "DDLog.h"

#import "NSArray+FilterMapReduce.h"

@implementation ToolbarItemControl
{
    NativityControl* _nativityControl;
    NSMutableDictionary* _items;
    NSMutableDictionary* _menuActions;
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    if (self != nil)
    {
        _nativityControl = [nativityControl retain];
        _items = [[NSMutableDictionary alloc] init];
        _menuActions = [[NSMutableDictionary alloc] init];
        
        [_nativityControl addListener:self forCommand:GET_TOOLBAR_MENU_ITEMS];
        [_nativityControl addListener:self forCommand:FIRE_TOOLBAR_MENU_ACTION];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl removeListener:self forCommand:GET_TOOLBAR_MENU_ITEMS];
    [_nativityControl removeListener:self forCommand:FIRE_TOOLBAR_MENU_ACTION];
    
    [_nativityControl release];
    [_items release];
    [_menuActions release];
    
    [super dealloc];
}

- (void)registerActionForItem:(MenuItem*)menuItem withIdentifier:(NSString*)identifier
{
    NSMutableDictionary* actions = _menuActions[identifier];
    if (actions == nil)
    {
        actions = [NSMutableDictionary dictionary];
        _menuActions[identifier] = actions;
    }
    
    actions[menuItem.uuid.UUIDString] = menuItem.action;
    
    NSUInteger childCount = menuItem.numberOfChildren;
    for (NSUInteger i = 0; i < childCount; i++)
    {
        [self registerActionForItem:[menuItem childAtIndex:i] withIdentifier:identifier];
    }
}

- (NativityMessage *)onCommand:(NSString *)command withValue:(id)value
{
    if ([command isEqualToString:GET_TOOLBAR_MENU_ITEMS])
    {
        [_menuActions removeAllObjects];
        
        NSDictionary* commandDict = value;
        
        NSString* identifier = commandDict[@"identifier"];
        NSArray* files = commandDict[@"files"];
        ToolbarItem* item = _items[identifier];
        if (item.callback != nil)
        {
            NSArray* menuItems = [item.callback getMenuItemsForPaths:files];
            
            for (MenuItem* menuItem in menuItems)
            {
                [self registerActionForItem:menuItem withIdentifier:identifier];
            }
            
            NSArray* messageValue = [menuItems map:^id(MenuItem* item) {
                return [item asDictionary];
            }];
            
            return [NativityMessage messageWithCommand:MENU_ITEMS andValue:messageValue];
        }
    }
    else if ([command isEqualToString:FIRE_TOOLBAR_MENU_ACTION])
    {
        NSDictionary* commandDict = value;
        NSString* identifier = commandDict[@"identifier"];
        ToolbarItem* item = _items[identifier];
        if (item != nil)
        {
            NSUUID* uuid = commandDict[@"uuid"];
            ActionBlock action = _menuActions[identifier][uuid];
            if (action != NULL)
            {
                NSArray* files = commandDict[@"files"];
                DDLogVerbose(@"Firing toolbar menu action: %@ uuid: %@ for: %@", identifier, uuid, files);
                dispatch_async(dispatch_get_main_queue(), ^{
                    action(files);
                });
            }
        }
    }
    
    return nil;
}

- (void)addToolbarItem:(ToolbarItem*)item
{
    _items[item.identifier] = item;
    [_nativityControl sendMessageWithCommand:ADD_TOOLBAR_ITEM andValue:[item asDictionary]];
}

@end
