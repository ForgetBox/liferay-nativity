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

#import "GCDAsyncSocket.h"

static const int _commandSocketPort = 33001;
static const int _callbackSocketPort = 33002;

@implementation NativityControl
{
    dispatch_queue_t _commandQueue;
    GCDAsyncSocket* _commandSocket;
    
    dispatch_queue_t _callbackQueue;
    GCDAsyncSocket* _callbackSocket;
}

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
        _commandQueue = dispatch_queue_create("command queue", NULL);
        _commandSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_commandQueue];
        
        _callbackQueue = dispatch_queue_create("callback queue", NULL);
        _callbackSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_callbackQueue];
        
        _connected = NO;
    }
    return self;
}

- (void)dealloc
{
	[_commandSocket setDelegate:nil delegateQueue:NULL];
	[_commandSocket disconnect];
    [_commandSocket release];
    dispatch_release(_commandQueue);
    
	[_callbackSocket setDelegate:nil delegateQueue:NULL];
	[_callbackSocket disconnect];
    [_callbackSocket release];
    dispatch_release(_callbackQueue);
    
    [super dealloc];
}

- (BOOL)connect
{
    NSError* error;
    
    BOOL ret = [_commandSocket connectToHost:@"localhost"
                                      onPort:_commandSocketPort
                                       error:&error];
    if (ret)
    {
        DDLogDebug(@"Successfully connected to command socket: %d", _commandSocketPort);
        
        ret = [_callbackSocket connectToHost:@"localhost"
                                      onPort:_callbackSocketPort
                                       error:&error];
    }
    
    if (ret)
    {
        DDLogDebug(@"Successfully connected to callback socket: %d", _callbackSocketPort);
    }
    
    if (ret)
    {
        _connected = YES;
        return YES;
    }
    else
    {
        DDLogError(@"Error connecting to Nativity service: %@", [error localizedDescription]);
        
        [self disconnect];
        
        _connected = NO;
        return NO;
    }
}

- (BOOL)disconnect
{
    [_commandSocket disconnect];
    
    [_callbackSocket disconnect];
    
    DDLogDebug(@"Successfully disconnected");
    
    _connected = NO;
    
    return YES;
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

- (BOOL)loaded
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

#pragma mark
#pragma mark GCDAsyncSocketDelegate methods



@end
