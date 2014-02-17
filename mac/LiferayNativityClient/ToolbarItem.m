//
//  ToolbarItem.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 14/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ToolbarItem.h"

@implementation ToolbarItem

+ (id)toolbarItemWithIdentifier:(NSString *)identifier
{
    return [[[self alloc] initWithIdentifier:identifier] autorelease];
}

- (id)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self != nil)
    {
        _identifier = [identifier retain];
        _title = nil;
        _toolTip = nil;
        _imageId = -1;
        _callback = nil;
        _action = nil;
    }
    return self;
}

- (void)dealloc
{
    [_identifier release];
    [_title release];
    [_callback release];
    [_title release];
    [_action release];
    
    [super dealloc];
}

- (NSDictionary*)asDictionary
{
    NSMutableDictionary* ret = [NSMutableDictionary dictionaryWithCapacity:5];
    ret[@"identifier"] = _identifier;
    ret[@"title"] = _title ?: _identifier;
    ret[@"toolTip"] = _toolTip ?: [NSNull null];
    
    if (_imageId != -1)
    {
        ret[@"image"] = @(_imageId);
    }
    
    return ret;
}

@end
