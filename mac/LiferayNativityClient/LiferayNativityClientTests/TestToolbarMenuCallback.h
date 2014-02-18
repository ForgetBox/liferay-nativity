//
//  TestContextMenuCallback.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToolbarMenuCallback.h"

@interface TestToolbarMenuCallback : ToolbarMenuCallback

@property (nonatomic, assign) long imageId;
@property (nonatomic, assign) BOOL hasClicked;

@end
