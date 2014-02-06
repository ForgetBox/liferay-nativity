//
//  ContextMenuCallback.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommandListener.h"

@class NativityControl;

@interface ContextMenuCallback : NSObject <CommandListener>

- (id)initWithNativityControl:(NativityControl*)nativityControl;

@end