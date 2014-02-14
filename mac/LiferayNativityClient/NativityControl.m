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

#import "Constants.h"
#import "CommandListener.h"
#import "NativityMessage.h"

#import "DDLog.h"
#import "DDASLLogger.h"
#import "DDTTYLogger.h"

#import "GCDAsyncSocket.h"

#import "JSONKit.h"

static const int _commandSocketPort = 33001;
static const int _callbackSocketPort = 33002;

static NativityControl* _sharedInstance = nil;

@implementation NativityControl
{
    dispatch_queue_t _commandQueue;
    GCDAsyncSocket* _commandSocket;
    dispatch_semaphore_t _commandSemaphore;
    
    dispatch_queue_t _callbackQueue;
    GCDAsyncSocket* _callbackSocket;
    
    NSData* _responseData;
    NSMutableDictionary* _commandListeners;
}

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
        _commandSemaphore = dispatch_semaphore_create(0);
        _responseData = nil;
        
        _callbackQueue = dispatch_queue_create("callback queue", NULL);
        _callbackSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_callbackQueue];
        
        _commandListeners = [[NSMutableDictionary alloc] init];
        
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
    
    dispatch_release(_commandSemaphore);
    
    [_responseData release];
    [_commandListeners release];
    
    [super dealloc];
}

- (void)addListener:(id<CommandListener>)listener forCommand:(NSString *)command
{
    if (_commandListeners[command] == nil)
    {
        _commandListeners[command] = [NSMutableArray arrayWithCapacity:1];
    }
    
    [_commandListeners[command] addObject:listener];
}

- (void)removeListener:(id<CommandListener>)listener forCommand:(NSString *)command
{
    if (_commandListeners[command] != nil)
    {
        [_commandListeners[command] removeObject:listener];
    }
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

- (NSData*)sendData:(NSData*)data
{
    if (!_connected)
    {
        DDLogWarn(@"Liferay Nativity is not connected");
        return nil;
    }
    
    NSMutableData* messageData = [NSMutableData dataWithData:data];
    [messageData appendData:[GCDAsyncSocket CRLFData]];
    [_commandSocket writeData:messageData withTimeout:-1 tag:0];
    
    DDLogDebug(@"Sent on socket %d: %@", _commandSocketPort, [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
    
    [_commandSocket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    
    long wait = dispatch_semaphore_wait(_commandSemaphore, DISPATCH_TIME_FOREVER);
    if (wait == 0)
    {
        NSData* responseData = [_responseData subdataWithRange:NSMakeRange(0, _responseData.length - 2)];
        [_responseData release];
        _responseData = nil;
        
        DDLogDebug(@"Received on socket %d: %@", _commandSocketPort, [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]);
        
        return responseData;
    }
    else
    {
        DDLogError(@"Request timed out");
        return nil;
    }
}

- (NSData*)sendMessage:(NativityMessage*)message
{
    return [self sendData:[message JSONData]];
}

- (NSData*)sendMessageWithCommand:(NSString*)command andValue:(id)value;
{
    return [self sendMessage:[NativityMessage messageWithCommand:command andValue:value]];
}

- (BOOL)load
{
    DDLogVerbose(@"Loading Liferay Nativity");
    
    NSError* error;
    NSAppleEventDescriptor* aeDesc = [self.class executeScript:@"load" error:&error];
    
    if (aeDesc == nil)
    {
        DDLogError(@"Error loading Liferay Nativity: %@", [error localizedDescription]);
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)unload
{
    DDLogVerbose(@"Unloading Liferay Nativity");
    
    NSError* error;
    NSAppleEventDescriptor* aeDesc = [self.class executeScript:@"unload" error:&error];
    
    if (aeDesc == nil)
    {
        DDLogError(@"Error unloading Liferay Nativity: %@", [error localizedDescription]);
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
        DDLogError(@"Error checking Liferay Nativity load state: %@", [error localizedDescription]);
        return NO;
    }
    else
    {
        return (aeDesc.int32Value == 0);
    }
}

- (void)setFilterPath:(NSString *)filterPath
{
    [self sendMessageWithCommand:SET_FILTER_PATH andValue:filterPath];
}

- (long)registerImage:(NSString*)imagePath
{
    NSData* iconIdData = [self sendMessageWithCommand:REGISTER_ICON andValue:imagePath];
    
    if (iconIdData == nil || iconIdData.length == 0)
    {
        DDLogError(@"Could not register image at path: \"%@\"", imagePath);
        return -1;
    }
    
    char bytes[iconIdData.length];
    [iconIdData getBytes:bytes];
    
    long iconId = strtol(bytes, NULL, 10);
    return iconId;
}

- (void)unregisterImage:(long)imageId
{
    [self sendMessageWithCommand:UNREGISTER_ICON andValue:@(imageId)];
}

#pragma mark
#pragma mark GCDAsyncSocketDelegate methods


- (void)socket:(GCDAsyncSocket*)socket didConnectToHost:(NSString*)host port:(UInt16)port
{
    if (socket == _callbackSocket)
    {
        [socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    }
}

- (void)socket:(GCDAsyncSocket*)socket didReadData:(NSData*)data withTag:(long)tag
{
    if (socket == _commandSocket)
    {
        _responseData = [data retain];
        
        dispatch_semaphore_signal(_commandSemaphore);
    }
    
    if (socket == _callbackSocket)
    {
        NSData* messageData =[data subdataWithRange:NSMakeRange(0, data.length - 2)];
        
        DDLogDebug(@"Received on socket %d: %@", _commandSocketPort, [[[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding] autorelease]);
        
        NativityMessage* message = [NativityMessage messageWithJSONData:messageData];
        
        NSString* command = message.command;
        NSArray* listeners = _commandListeners[command];
        if (listeners != nil)
        {
            for (id<CommandListener> listener in listeners)
            {
                NativityMessage* reply = [listener onCommand:command withValue:message.value];
                
                if (reply != nil)
                {
                    NSMutableData* replyData = [NSMutableData dataWithData:[reply JSONData]];
                    [replyData appendData:[GCDAsyncSocket CRLFData]];
                    [_callbackSocket writeData:replyData withTimeout:-1 tag:0];
                    
                    DDLogDebug(@"Sent on socket %d: %@", _callbackSocketPort, [[[NSString alloc] initWithData:[reply JSONData] encoding:NSUTF8StringEncoding] autorelease]);
                }
            }
        }
        
        [socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
    }
}

- (NSTimeInterval)socket:(GCDAsyncSocket*)socket shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
	return 0.0;
}

@end

