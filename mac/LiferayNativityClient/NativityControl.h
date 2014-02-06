//
//  NativityControl.h
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

#import <Foundation/Foundation.h>

#import "GCDAsyncSocket.h"

@protocol CommandListener;

@interface NativityControl : NSObject <GCDAsyncSocketDelegate>

@property (nonatomic, readonly) BOOL loaded;
@property (nonatomic, readonly) BOOL connected;

+ (id)sharedInstance;

- (id)init;

- (void)addListener:(id<CommandListener>)listener forCommand:(NSString*)command;

- (BOOL)connect;
- (BOOL)disconnect;
- (NSData*)sendData:(NSData*)data;
- (id)sendMessageWithCommand:(NSString*)command andValue:(id)value;
- (void)replyWithCommand:(NSString*)command andValue:(id)value;

- (BOOL)load;
- (BOOL)unload;

- (void)setFilterPath:(NSString*)filterPath;

@end
