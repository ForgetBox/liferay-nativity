//
//  ContextMenuItem.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ContextMenuItem.h"

#import "NSArray+FilterMapReduce.h"

@implementation ContextMenuItem
{
    NSMutableArray* _children;
}

+ (id)menuItemWithTitle:(NSString*)title
{
    return [[[self alloc] initWithTitle:title] autorelease];
}

+ (id)menuItemWithJSONData:(NSData*)jsonData
{
    return [[[self alloc] initWithJSONData:jsonData] autorelease];
}

+ (id)menuItemWithJSONString:(NSString*)jsonString
{
    return [[[self alloc] initWithJSONString:jsonString] autorelease];
}

+ (id)menuItemWithDictionary:(NSDictionary*)menuItemDict
{
    return [[[self alloc] initWithDictionary:menuItemDict] autorelease];
}

+ (id)separatorMenuItem
{
    return [[[self alloc] initWithTitle:@"_SEPARATOR_"] autorelease];
}

- (id)initWithTitle:(NSString*)title
{
    self = [super init];
    if (self != nil)
    {
        _title = [title retain];
        _enabled = YES;
        _helpText = nil;
        _uuid = [[NSUUID alloc] init];
        _children = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithJSONData:(NSData*)jsonData
{
    return [self initWithDictionary:[jsonData objectFromJSONData]];
}

- (id)initWithJSONString:(NSString*)jsonString
{
    return [self initWithDictionary:[jsonString objectFromJSONString]];
}

- (id)initWithDictionary:(NSDictionary*)menuItemDict
{
    NSString* title = menuItemDict[@"title"];
    if ((menuItemDict != nil) && (title != nil))
    {
        self = [super init];
        if (self != nil)
        {
            _title = [title retain];
            
            NSNumber* enabled = menuItemDict[@"enabled"];
            if (enabled != nil)
            {
                _enabled = [enabled boolValue];
            }
            else
            {
                _enabled = YES;
            }
            
            NSString* helpText = menuItemDict[@"helpText"];
            if (helpText != nil)
            {
                _helpText = [helpText retain];
            }
            else
            {
                _helpText = nil;
            }
            
            NSString* uuidString = menuItemDict[@"uuid"];
            if (uuidString != nil)
            {
                _uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
            }
            else
            {
                _uuid = [[NSUUID alloc] init];
            }
            
            _children = [[NSMutableArray alloc] init];
            NSArray* children = menuItemDict[@"contextMenuItems"];
            if (children != nil)
            {
                for (NSDictionary* childDict in children)
                {
                    [_children addObject:[ContextMenuItem menuItemWithDictionary:childDict]];
                }
            }
        }
        return self;
    }
    else
    {
        return nil;
    }
}

- (void)dealloc
{
    [_children release];
    [_action release];
    
    [super dealloc];
}

- (NSUInteger)numberOfChildren
{
    return _children.count;
}

- (ContextMenuItem*)childAtIndex:(NSUInteger)index
{
    return _children[index];
}

- (void)addChild:(ContextMenuItem*)childItem
{
    [_children addObject:childItem];
}

- (void)removeChild:(ContextMenuItem*)childItem
{
    [_children removeObject:childItem];
}

- (void)removeChildAtIndex:(NSUInteger)index
{
    [_children removeObjectAtIndex:index];
}

- (void)removeAllChildren
{
    [_children removeAllObjects];
}

- (NSDictionary*)asDictionary
{
    return @{ @"title" : _title,
              @"enabled" : @(_enabled),
              @"helpText" : [NSNull null],
              @"uuid" : [_uuid UUIDString],
              @"contextMenuItems" : [_children map:^id(ContextMenuItem* item){ return [item asDictionary]; }],
              @"menuIndex" : @(_menuIndex)
            };
}

@end
