//
//  FileIconControl.m
//  LiferayNativityClient
//
//  Created by Charles Francoise on 06/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import "FileIconControl.h"

#import "NativityControl.h"

#import "Constants.h"

#import "DDLog.h"

@implementation FileIconControl
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

- (void)enableFileIcons
{
    [_nativityControl sendMessageWithCommand:ENABLE_FILE_ICONS andValue:@YES];
}

- (void)disableFileIcons
{
    [_nativityControl sendMessageWithCommand:ENABLE_FILE_ICONS andValue:@NO];
}

- (void)setIcon:(long)iconId forPath:(NSString*)path
{
    [self setIcons:@[@(iconId)] forPaths:@[path]];
}

- (void)setIcons:(NSArray *)iconIds forPaths:(NSArray *)paths
{
    [_nativityControl sendMessageWithCommand:SET_FILE_ICONS andValue:[NSDictionary dictionaryWithObjects:iconIds forKeys:paths]];
}

- (void)removeIconForPath:(NSString*)path
{
    [self removeIconsForPaths:@[path]];
}

- (void)removeIconsForPaths:(NSArray*)paths
{
    [_nativityControl sendMessageWithCommand:REMOVE_FILE_ICONS andValue:paths];
}

- (void)removeIconsForAllPaths
{
    [_nativityControl sendMessageWithCommand:REMOVE_ALL_FILE_ICONS andValue:@""];
}

@end
