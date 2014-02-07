//
//  NativityMessage.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "NativityMessage.h"

#import "DDLog.h"

#define SELF_AS_DICTIONARY @{@"command" : _command, @"value" : _value}

@implementation NativityMessage

+ (id)messageWithCommand:(NSString*)command andValue:(id)value
{
    return [[[self alloc] initWithCommand:command andValue:value] autorelease];
}

+ (id)messageWithJSONData:(NSData*)jsonData
{
    return  [[[self alloc] initWithJSONData:jsonData] autorelease];
}

+ (id)messageWithJSONString:(NSString*)jsonString
{
    return  [[[self alloc] initWithJSONString:jsonString] autorelease];
}

- (id)initWithCommand:(NSString*)command andValue:(id)value
{
    self = [super init];
    if (self != nil)
    {
        _command = [command retain];
        _value = [value retain];
    }
    return self;
}

- (id)initWithJSONData:(NSData*)jsonData
{
    NSDictionary* messageDict = [jsonData objectFromJSONData];
    if ((messageDict != nil) && (messageDict[@"command"] != nil) && (messageDict[@"value"]))
    {
        return [self initWithCommand:messageDict[@"command"] andValue:messageDict[@"value"]];
    }
    else
    {
        return nil;
    }
}

- (id)initWithJSONString:(NSString*)jsonString
{
    NSDictionary* messageDict = [jsonString objectFromJSONString];
    if ((messageDict != nil) && (messageDict[@"command"] != nil) && (messageDict[@"value"]))
    {
        return [self initWithCommand:messageDict[@"command"] andValue:messageDict[@"value"]];
    }
    else
    {
        return nil;
    }
}

- (void)dealloc
{
    [_command release];
    [_value release];
    
    [super dealloc];
}

- (NSData*)JSONData
{
    return [SELF_AS_DICTIONARY JSONDataWithOptions:JKSerializeOptionNone error:NULL];
}

- (NSData*)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error
{
    return [SELF_AS_DICTIONARY JSONDataWithOptions:serializeOptions error:error];
}

// NSString returning methods...

- (NSString*)JSONString
{
    return [SELF_AS_DICTIONARY JSONStringWithOptions:JKSerializeOptionNone error:NULL];
}

- (NSString*)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error
{
    return [SELF_AS_DICTIONARY JSONStringWithOptions:serializeOptions error:error];
}

@end
