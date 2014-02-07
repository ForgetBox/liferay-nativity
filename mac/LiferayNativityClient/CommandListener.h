//
//  MessageListener.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NativityMessage;

@protocol CommandListener <NSObject>

@required
- (NativityMessage*)onCommand:(NSString*)command withValue:(NSData*)value;

@end
