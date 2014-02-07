//
//  TestContextMenuCallback.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "TestContextMenuCallback.h"

#import "ContextMenuItem.h"

@implementation TestContextMenuCallback

NSArray* generateRandomMenu(NSUInteger itemCount)
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; i++)
    {
        ContextMenuItem* menuItem = [ContextMenuItem menuItemWithTitle:[NSString stringWithFormat:@"Item %ld", i]];
        menuItem.enabled = random() % 2;
        if (itemCount > 1)
        {
            NSArray* children = generateRandomMenu(random() % ((itemCount / 2) + 1));
            for (ContextMenuItem* child in children)
            {
                [menuItem addChild:child];
            }
        }
        [array addObject:menuItem];
    }
    return array;
}

- (NSArray*)getMenuItemsForPaths:(NSArray*)paths
{
    return generateRandomMenu(4);
}

@end
