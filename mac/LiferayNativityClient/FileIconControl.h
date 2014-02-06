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

- (id)initWithNativityControl:(NativityControl*)nativityControl;

- (void)enableFileIcons;
- (void)disableFileIcons;

- (long)registerIcon:(NSString*)iconPath;
- (void)unregisterIcon:(long)iconId;

- (void)setIcon:(long)iconId forPath:(NSString*)path;
- (void)setIcons:(NSDictionary*)iconIdsForPaths;
- (void)removeIconForPath:(NSString*)path;
- (void)removeIconsForPaths:(NSArray*)paths;
- (void)removeIconsForAllPaths;

@end
