//
//  TestContextMenuCallback.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "TestToolbarMenuCallback.h"

#import "MenuItem.h"

@implementation TestToolbarMenuCallback

- (NSArray*)generateRandomMenu:(NSUInteger)itemCount
{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSUInteger i = 0; i < itemCount; i++)
    {
        MenuItem* menuItem = [MenuItem menuItemWithTitle:[NSString stringWithFormat:@"Item %ld", i]];
        menuItem.enabled = random() % 2;
        menuItem.imageId = _imageId;
        menuItem.action = ^(NSArray* paths)
        {
            NSLog(@"User clicked %@", menuItem.title);
            _hasClicked = YES;
        };
        if (itemCount > 1)
        {
            NSArray* children = [self generateRandomMenu:(random() % ((itemCount / 2) + 1))];
            for (MenuItem* child in children)
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
    return [self generateRandomMenu:4];
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _hasClicked = NO;
    }
    return self;
}

@end
