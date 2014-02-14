//
//  ToolbarItem.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 14/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ActionBlock.h"

@class ToolbarMenuCallback;

@interface ToolbarItem : NSObject

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* toolTip;
@property (nonatomic, assign) long imageId;
@property (nonatomic, retain) ToolbarMenuCallback* callback;
@property (nonatomic, copy) ActionBlock action;

+ (id)toolbarItemWithIdentifier:(NSString*)identifier;

- (id)initWithIdentifier:(NSString*)identifier;

- (NSDictionary*)asDictionary;

@end
