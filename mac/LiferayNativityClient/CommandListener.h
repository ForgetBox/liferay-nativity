//
//  MessageListener.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CommandListener <NSObject>

@required
- (void)onCommand:(NSString*)command withValue:(NSData*)value;

@end
