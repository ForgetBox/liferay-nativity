//
//  ContextMenuCallback.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ContextMenuCallback.h"

#import "Constants.h"
#import "NativityControl.h"
#import "NativityMessage.h"
#import "ContextMenuItem.h"

#import "DDLog.h" 

#import "NSArray+FilterMapReduce.h"

@implementation ContextMenuCallback
{
    NativityControl* _nativityControl;
    NSMutableDictionary* _menuItemActions;
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    {
        _nativityControl = [nativityControl retain];
        _menuItemActions = [[NSMutableDictionary alloc] init];
        
        [_nativityControl addListener:self forCommand:GET_CONTEXT_MENU_ITEMS];
        [_nativityControl addListener:self forCommand:FIRE_CONTEXT_MENU_ACTION];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl release];
    [_menuItemActions release];
    
    [super dealloc];
}

- (void)registerActions:(ContextMenuItem*)menuItem
{
    if (menuItem.action != nil)
    {
        _menuItemActions[menuItem.uuid.UUIDString] = menuItem.action;
    }
    
    NSUInteger childCount = menuItem.numberOfChildren;
    for (NSUInteger i = 0; i < childCount; i++)
    {
        [self registerActions:[menuItem childAtIndex:i]];
    }
}

- (NativityMessage*)onCommand:(NSString*)command withValue:(id)value
{
    if ([command isEqualToString:GET_CONTEXT_MENU_ITEMS])
    {
        [_menuItemActions removeAllObjects];
        
        NSArray* paths = value;
        NSArray* menuItems = [self getMenuItemsForPaths:paths];
        
        for (ContextMenuItem* item in menuItems)
        {
            [self registerActions:item];
        }
        
        NSArray* messageValue = [menuItems map:^id(ContextMenuItem* item) {
            return [item asDictionary];
        }];
        
        return [NativityMessage messageWithCommand:MENU_ITEMS andValue:messageValue];
    }
    else if ([command isEqualToString:FIRE_CONTEXT_MENU_ACTION])
    {
        NSDictionary* commandDict = value;
        NSString* uuid = commandDict[@"uuid"];
        ActionBlock action = _menuItemActions[uuid];
        if (action != nil)
        {
            DDLogVerbose(@"Firing action uuid: %@ for: %@", uuid, commandDict[@"files"]);
            action(commandDict[@"files"]);
        }
    }
    
    return nil;
}

- (NSArray*)getMenuItemsForPaths:(NSArray*)paths
{
    DDLogWarn(@"-[ContextMenuCallback getMenuItemsForPaths:] should be reimplemented in your subclass.");
    
    return @[];
}

@end
