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

- (void)setIcon:(long)iconId forPath:(NSString*)path;
- (void)setIcons:(NSArray*)iconIds forPaths:(NSArray*)paths;
- (void)removeIconForPath:(NSString*)path;
- (void)removeIconsForPaths:(NSArray*)paths;
- (void)removeIconsForAllPaths;

@end
