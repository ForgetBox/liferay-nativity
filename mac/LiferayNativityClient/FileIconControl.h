//
//  FileIconControl.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NativityControl;

@interface FileIconControl : NSObject

+ (id)sharedInstance;

- (id)initWithNativityControl:(NativityControl*)nativityControl;



@end
