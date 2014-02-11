//
//  ToolbarItemControl.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 11/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NativityControl;

@interface ToolbarItemControl : NSObject

- (id)initWithNativityControl:(NativityControl*)nativityControl;

- (void)addToolbarItem;

@end
