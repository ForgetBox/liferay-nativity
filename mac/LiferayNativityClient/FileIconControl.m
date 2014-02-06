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

- (long)registerIcon:(NSString*)iconPath
{
    NSData* iconIdData = [_nativityControl sendMessageWithCommand:REGISTER_ICON andValue:iconPath];
    
    if (iconIdData == nil || iconIdData.length == 0)
    {
        DDLogError(@"Could not register icon at path: \"%@\"", iconPath);
        return -1;
    }
    
    char bytes[iconIdData.length];
    [iconIdData getBytes:bytes];
    
    long iconId = strtol(bytes, NULL, 10);
    return iconId;
}

- (void)unregisterIcon:(long)iconId
{
    [_nativityControl sendMessageWithCommand:UNREGISTER_ICON andValue:@(iconId)];
}

- (void)setIcon:(long)iconId forPath:(NSString*)path
{
    [self setIcons:@{path : @(iconId)}];
}

- (void)setIcons:(NSDictionary*)iconIdsForPaths
{
    [_nativityControl sendMessageWithCommand:SET_FILE_ICONS andValue:iconIdsForPaths];
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
