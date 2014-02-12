//
//  ToolbarButtonHandlers.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import "ToolbarButtonHandlers.h"

@implementation NSObject (ToolbarButtonHandlers)

#pragma mark TToolbarController methods

- (void)ToolbarButtonHandlers_toolbarWillAddItem:(id)arg1
{
	[self ToolbarButtonHandlers_toolbarWillAddItem:arg1];
}

- (void)ToolbarButtonHandlers_toolbarDidRemoveItem:(id)arg1
{
	[self ToolbarButtonHandlers_toolbarDidRemoveItem:arg1];
}

- (NSArray*)ToolbarButtonHandlers_toolbarAllowedItemIdentifiers:(id)arg1
{
	NSMutableArray* arr = [NSMutableArray arrayWithArray:[self ToolbarButtonHandlers_toolbarAllowedItemIdentifiers:arg1]];
	[arr addObject:@"com.forgetbox.lima.LIMA"];
	return arr;
}

#pragma mark TToolbar methods

- (void)ToolbarButtonHandlers_setSizeMode:(unsigned long long)arg1
{
	[self ToolbarButtonHandlers_setSizeMode:arg1];
}

- (id)ToolbarButtonHandlers__newItemFromItemIdentifier:(id)arg1 propertyListRepresentation:(id)arg2 requireImmediateLoad:(char)arg3 willBeInsertedIntoToolbar:(char)arg4
{
	id ret = [self ToolbarButtonHandlers__newItemFromItemIdentifier:arg1
										 propertyListRepresentation:arg2
											   requireImmediateLoad:arg3
										  willBeInsertedIntoToolbar:arg4];
	return ret;
}

- (void)ToolbarButtonHandlers__notifyView_MovedFromIndex:(long long)arg1 toIndex:(long long)arg2
{
	[self ToolbarButtonHandlers__notifyView_MovedFromIndex:arg1 toIndex:arg2];
}


@end
