//
//  ToolbarItemControl.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 11/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CommandListener.h"

@class NativityControl;
@class ToolbarItem;

@interface ToolbarItemControl : NSObject <CommandListener>

- (id)initWithNativityControl:(NativityControl*)nativityControl;

- (void)addToolbarItem:(ToolbarItem*)item;

@end
