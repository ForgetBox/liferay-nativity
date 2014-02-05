//
//  NativityControl.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 05/02/14.
/**
 * Copyright (c) 2014 Forgetbox. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

#import "NativityControl.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@implementation NativityControl

static NativityControl* _sharedInstance = nil;

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[self alloc] init];
            
            [DDLog addLogger:[DDASLLogger sharedInstance]];
            [DDLog addLogger:[DDTTYLogger sharedInstance]];
        }
    });
    return _sharedInstance;
}

+ (NSAppleEventDescriptor*)executeScript:(NSString*)scriptName error:(NSError**)error
{
    NSBundle* bundle = [NSBundle bundleForClass:self];
    NSURL* scriptURL = [bundle URLForResource:scriptName withExtension:@"scpt"];
    if (scriptURL == nil)
    {
        if (error != NULL)
        {
            *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                         code:NSFileNoSuchFileError
                                     userInfo:nil];
        }
        
        return nil;
    }
    
    NSDictionary* errorDict;
    NSAppleScript* script = [[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:&errorDict] autorelease];
    if (script == nil)
    {
        if (error != NULL)
        {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:errorDict];
            userInfo[NSLocalizedDescriptionKey] = userInfo[NSAppleScriptErrorMessage];
            *error = [NSError errorWithDomain:@""
                                         code:[errorDict[NSAppleScriptErrorNumber] intValue]
                                     userInfo:userInfo
                      ];
        }
        
        return nil;
    }
    
    
    NSAppleEventDescriptor* aeDesc = [script executeAndReturnError:&errorDict];
    if (aeDesc == nil)
    {
        if (error != NULL)
        {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionaryWithDictionary:errorDict];
            userInfo[NSLocalizedDescriptionKey] = userInfo[NSAppleScriptErrorMessage];
            *error = [NSError errorWithDomain:@""
                                         code:[errorDict[NSAppleScriptErrorNumber] intValue]
                                     userInfo:userInfo
                      ];
        }
        
        return nil;
    }
    
    return aeDesc;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
    }
    return self;
}

- (BOOL)load
{
    NSError* error;
    NSAppleEventDescriptor* aeDesc = [self.class executeScript:@"load" error:&error];
    
    if (aeDesc == nil)
    {
        DDLogError(@"Error loading Nativity: %@", [error localizedDescription]);
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)unload
{
    NSError* error;
    NSAppleEventDescriptor* aeDesc = [self.class executeScript:@"unload" error:&error];
    
    if (aeDesc == nil)
    {
        DDLogError(@"Error unloading Nativity: %@", [error localizedDescription]);
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)isLoaded
{
    NSError* error;
    NSAppleEventDescriptor* aeDesc = [self.class executeScript:@"loaded" error:&error];
    
    if (aeDesc == nil)
    {
        DDLogError(@"Error checking Nativity load state: %@", [error localizedDescription]);
        return NO;
    }
    else
    {
        return (aeDesc.int32Value == 0);
    }
}

@end
