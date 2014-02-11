//
//  ContextMenuItem.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"

typedef void (^ActionBlock) (NSArray*);

@interface ContextMenuItem : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, retain) NSString* helpText;
@property (nonatomic, readonly) NSUUID* uuid;
@property (nonatomic, assign) NSInteger menuIndex;
@property (nonatomic, assign) long imageId;
@property (nonatomic, copy) ActionBlock action;

+ (id)menuItemWithTitle:(NSString*)title;
+ (id)menuItemWithJSONData:(NSData*)jsonData;
+ (id)menuItemWithJSONString:(NSString*)jsonString;
+ (id)separatorMenuItem;

- (id)initWithTitle:(NSString*)title;
- (id)initWithJSONData:(NSData*)jsonData;
- (id)initWithJSONString:(NSString*)jsonString;

- (NSDictionary*)asDictionary;

- (NSUInteger)numberOfChildren;
- (ContextMenuItem*)childAtIndex:(NSUInteger)index;
- (void)addChild:(ContextMenuItem*)childItem;
- (void)removeChild:(ContextMenuItem*)childItem;
- (void)removeChildAtIndex:(NSUInteger)index;
- (void)removeAllChildren;

- (void)setAction:(void (^)(NSArray* paths))action;

@end
