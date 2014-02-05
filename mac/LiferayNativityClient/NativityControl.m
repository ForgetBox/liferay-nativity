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



@end
