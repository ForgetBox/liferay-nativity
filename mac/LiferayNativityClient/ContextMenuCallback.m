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
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    {
        _nativityControl = [nativityControl retain];
        
        [_nativityControl addListener:self forCommand:GET_CONTEXT_MENU_ITEMS];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl release];
    
    [super dealloc];
}

- (NativityMessage*)onCommand:(NSString*)command withValue:(id)value
{
    if ([command isEqualToString:GET_CONTEXT_MENU_ITEMS])
    {
        NSArray* paths = value;
        NSArray* menuItems = [self getMenuItemsForPaths:paths];
        
        NSArray* messageValue = [menuItems map:^id(ContextMenuItem* item) {
            return [item asDictionary];
        }];
        
        return [NativityMessage messageWithCommand:MENU_ITEMS andValue:messageValue];
    }
    
    return nil;
}

- (NSArray*)getMenuItemsForPaths:(NSArray*)paths
{
    DDLogWarn(@"-[ContextMenuCallback getMenuItemsForPaths:] should be reimplemented in your subclass.");
    
    return @[];
}

@end
