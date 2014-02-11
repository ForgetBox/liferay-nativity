//
//  ToolbarItemControl.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 11/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ToolbarItemControl.h"

#import "NativityControl.h"

#import "Constants.h"

#import "DDLog.h"

@implementation ToolbarItemControl
{
    NativityControl* _nativityControl;
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    if (self != nil)
    {
        _nativityControl = [nativityControl retain];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl release];
    
    [super dealloc];
}

- (void)addToolbarItem
{
    [_nativityControl sendMessageWithCommand:ADD_TOOLBAR_ITEM andValue:@""];
}

@end
