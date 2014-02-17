//
//  ToolbarManager.h
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 17/02/14.
//
//

#import <Foundation/Foundation.h>

@class TToolbar;
@class TToolbarItem;

@interface ToolbarManager : NSObject

+ (id)sharedInstance;

- (void)addToolbarItem:(NSDictionary*)itemDictionary;
- (TToolbarItem*)toolbarItemForIdentifier:(NSString*)identifier insertedIntoToolbar:(TToolbar*)toolbar;
- (NSArray*)itemIdentifiers;

@end
