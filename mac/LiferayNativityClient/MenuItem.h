//
//  ContextMenuItem.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"
#import "ActionBlock.h"

@interface MenuItem : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, retain) NSString* helpText;
@property (nonatomic, readonly) NSUUID* uuid;
@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, assign) long imageId;
@property (nonatomic, copy) ActionBlock action;

+ (id)menuItemWithTitle:(NSString*)title;
+ (id)separatorMenuItem;

- (id)initWithTitle:(NSString*)title;

- (NSDictionary*)asDictionary;

- (NSUInteger)numberOfChildren;
- (MenuItem*)childAtIndex:(NSUInteger)index;
- (void)addChild:(MenuItem*)childItem;
- (void)removeChild:(MenuItem*)childItem;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)removeAllChildren;

- (void)setAction:(void (^)(NSArray* paths))action;

@end
