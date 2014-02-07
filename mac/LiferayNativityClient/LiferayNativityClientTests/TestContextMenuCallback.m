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

- (NSArray *)getMenuItemsForPaths:(NSArray *)paths
{
    return @[[ContextMenuItem menuItemWithTitle:@"Hello World"]];
}

@end
