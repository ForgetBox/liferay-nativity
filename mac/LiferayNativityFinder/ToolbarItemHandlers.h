//
//  ToolbarItemHandlers.h
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import <Foundation/Foundation.h>
#import "Finder/Finder.h"

@interface NSObject (ToolbarItemHandlers)

#pragma mark TToolbarController methods
- (id)ToolbarItemHandlers_toolbarAllowedItemIdentifiers:(id)arg1;
- (void)ToolbarItemHandlers_toolbarWillAddItem:(id)arg1;
- (void)ToolbarItemHandlers_toolbarDidRemoveItem:(id)arg1;

#pragma mark TToolbar methods
- (void)ToolbarItemHandlers_setSizeMode:(unsigned long long)arg1;
- (id)ToolbarItemHandlers__newItemFromItemIdentifier:(id)arg1 propertyListRepresentation:(id)arg2 requireImmediateLoad:(char)arg3 willBeInsertedIntoToolbar:(char)arg4;
- (void)ToolbarItemHandlers__notifyView_MovedFromIndex:(long long)arg1 toIndex:(long long)arg2;

@end
