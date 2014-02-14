//
//  ContextMenuItem.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "MenuItem.h"

#import "NSArray+FilterMapReduce.h"

@implementation MenuItem
{
    NSMutableArray* _children;
}

+ (id)menuItemWithTitle:(NSString*)title
{
    return [[[self alloc] initWithTitle:title] autorelease];
}

//+ (id)menuItemWithDictionary:(NSDictionary*)menuItemDict
//{
//    return [[[self alloc] initWithDictionary:menuItemDict] autorelease];
//}

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
        _menuIndex = -1;
    }
    return self;
}

//- (id)initWithDictionary:(NSDictionary*)menuItemDict
//{
//    NSString* title = menuItemDict[@"title"];
//    if ((menuItemDict != nil) && (title != nil))
//    {
//        self = [super init];
//        if (self != nil)
//        {
//            _title = [title retain];
//            
//            NSNumber* enabled = menuItemDict[@"enabled"];
//            if (enabled != nil)
//            {
//                _enabled = [enabled boolValue];
//            }
//            else
//            {
//                _enabled = YES;
//            }
//            
//            NSString* helpText = menuItemDict[@"helpText"];
//            if (helpText != nil)
//            {
//                _helpText = [helpText retain];
//            }
//            else
//            {
//                _helpText = nil;
//            }
//            
//            NSString* uuidString = menuItemDict[@"uuid"];
//            if (uuidString != nil)
//            {
//                _uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
//            }
//            else
//            {
//                _uuid = [[NSUUID alloc] init];
//            }
//            
//            _children = [[NSMutableArray alloc] init];
//            NSArray* children = menuItemDict[@"contextMenuItems"];
//            if (children != nil)
//            {
//                for (NSDictionary* childDict in children)
//                {
//                    [_children addObject:[MenuItem menuItemWithDictionary:childDict]];
//                }
//            }
//            
//            NSNumber* index = menuItemDict[@"index"];
//            if (index == nil)
//            {
//                _menuIndex = [index integerValue];
//            }
//            else
//            {
//                _menuIndex = -1;
//            }
//        }
//        return self;
//    }
//    else
//    {
//        return nil;
//    }
//}

- (void)dealloc
{
    [_title release];
    [_helpText release];
    [_uuid release];
    [_children release];
    [_action release];
    
    [super dealloc];
}

- (NSUInteger)numberOfChildren
{
    return _children.count;
}

- (MenuItem*)childAtIndex:(NSUInteger)index
{
    return _children[index];
}

- (void)addChild:(MenuItem*)childItem
{
    [_children addObject:childItem];
}

- (void)removeChild:(MenuItem*)childItem
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
    NSMutableDictionary* ret = [NSMutableDictionary dictionaryWithCapacity:6];
    ret[@"title"] = _title;
    ret[@"enabled"] = @(_enabled);
    ret[@"helpText"] = (_helpText == nil) ? [NSNull null] : _helpText;
    ret[@"uuid"] = [_uuid UUIDString];
    ret[@"contextMenuItems"] = [_children map:^id(MenuItem* item){ return [item asDictionary]; }];
    
    if (_menuIndex != -1)
    {
        ret[@"index"] = @(_menuIndex);
    }
    
    if (_imageId != -1)
    {
        ret[@"image"] = @(_imageId);
    }
    
    return ret;
}

@end
