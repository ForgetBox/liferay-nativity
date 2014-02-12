//
//  ToolbarButtonHandlers.h
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (ToolbarButtonHandlers)

#pragma mark TToolbarController methods
- (id)ToolbarButtonHandlers_toolbarAllowedItemIdentifiers:(id)arg1;
- (void)ToolbarButtonHandlers_toolbarWillAddItem:(id)arg1;
- (void)ToolbarButtonHandlers_toolbarDidRemoveItem:(id)arg1;

#pragma mark TToolbar methods
- (void)ToolbarButtonHandlers_setSizeMode:(unsigned long long)arg1;
- (id)ToolbarButtonHandlers__newItemFromItemIdentifier:(id)arg1 propertyListRepresentation:(id)arg2 requireImmediateLoad:(char)arg3 willBeInsertedIntoToolbar:(char)arg4;
- (void)ToolbarButtonHandlers__notifyView_MovedFromIndex:(long long)arg1 toIndex:(long long)arg2;

@end
