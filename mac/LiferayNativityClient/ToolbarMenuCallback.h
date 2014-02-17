//
//  ToolbarMenuCallback.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 14/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActionBlock.h"

@interface ToolbarMenuCallback : NSObject

- (NSArray*)getMenuItemsForPaths:(NSArray*)paths;

@end
