//
//  ContextMenuCallback.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "ContextMenuCallback.h"

#import "Constants.h"
#import "NativityControl.h"
#import "NativityMessage.h"


@implementation ContextMenuCallback
{
    NativityControl* _nativityControl;
}

- (id)initWithNativityControl:(NativityControl*)nativityControl
{
    self = [super init];
    {
        _nativityControl = [nativityControl retain];
        
        [_nativityControl addListener:self forCommand:GET_CONTEXT_MENU_ITEMS];
    }
    return self;
}

- (void)dealloc
{
    [_nativityControl release];
    
    [super dealloc];
}

- (NativityMessage*)onCommand:(NSString *)command withValue:(NSData *)value
{
    return nil;
}

@end
