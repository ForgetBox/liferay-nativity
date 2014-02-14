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
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    if (self != nil)
    {
        _nativityControl = [nativityControl retain];
        _items = [[NSMutableDictionary alloc] init];
        
        [_nativityControl addListener:self forCommand:GET_TOOLBAR_MENU_ITEMS];
        [_nativityControl addListener:self forCommand:FIRE_TOOLBAR_ITEM_ACTION];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl removeListener:self forCommand:GET_TOOLBAR_MENU_ITEMS];
    [_nativityControl removeListener:self forCommand:FIRE_TOOLBAR_ITEM_ACTION];
    
    [_nativityControl release];
    [_items release];
    
    [super dealloc];
}

- (void)registerActionForItem:(MenuItem*)menuItem withIdentifier:(NSString*)identifier
{
    
}

- (NativityMessage *)onCommand:(NSString *)command withValue:(id)value
{
    if ([command isEqualToString:GET_TOOLBAR_MENU_ITEMS])
    {
        NSDictionary* commandDict = value;
        
        NSString* identifier = value[@"identifier"];
        NSArray* paths = value[@"paths"];
        ToolbarItem* item = _items[identifier];
        if (item.callback != nil)
        {
            NSArray* menuItems = [item.callback getMenuItemsForPaths:paths];
            
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
        NSString* uuid = commandDict[@"uuid"];
        ActionBlock action = _menuItemActions[uuid];
        if (action != nil)
        {
            DDLogVerbose(@"Firing action uuid: %@ for: %@", uuid, commandDict[@"files"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                action(commandDict[@"files"]);
            });
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
