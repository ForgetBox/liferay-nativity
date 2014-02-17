//
//  ToolbarItemHandlers.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import "ToolbarItemHandlers.h"
#import "ToolbarManager.h"

#import <objc/message.h>

@implementation NSObject (ToolbarItemHandlers)

#pragma mark TToolbarController methods

- (void)ToolbarItemHandlers_toolbarWillAddItem:(id)arg1
{
	[self ToolbarItemHandlers_toolbarWillAddItem:arg1];
}

- (void)ToolbarItemHandlers_toolbarDidRemoveItem:(id)arg1
{
	[self ToolbarItemHandlers_toolbarDidRemoveItem:arg1];
}

- (NSArray*)ToolbarItemHandlers_toolbarAllowedItemIdentifiers:(id)arg1
{
	NSMutableArray* arr = [NSMutableArray arrayWithArray:[self ToolbarItemHandlers_toolbarAllowedItemIdentifiers:arg1]];
	ToolbarManager* toolbarManager = [ToolbarManager sharedInstance];
	[arr addObjectsFromArray:toolbarManager.itemIdentifiers];
	
	return arr;
}

#pragma mark TToolbar methods

- (void)ToolbarItemHandlers_setSizeMode:(unsigned long long)arg1
{
	[self ToolbarItemHandlers_setSizeMode:arg1];
}

- (id)ToolbarItemHandlers__newItemFromItemIdentifier:(id)arg1 propertyListRepresentation:(id)arg2 requireImmediateLoad:(char)arg3 willBeInsertedIntoToolbar:(char)arg4
{
	ToolbarManager* toolbarManager = [ToolbarManager sharedInstance];
	if ([toolbarManager.itemIdentifiers containsObject:arg1])
	{
		TToolbar* realSelf = (TToolbar*)self;
		
		__block TToolbarItem* foundItem = nil;
		[realSelf.items enumerateObjectsUsingBlock:^(NSToolbarItem* item, NSUInteger idx, BOOL *stop) {
			if ([item.itemIdentifier isEqualToString:arg1])
			{
				foundItem = (TToolbarItem*)item;
				*stop = YES;
			}
		}];
		
		if (foundItem != nil && !arg4)
		{
			NSToolbarItemConfigWrapper* wrapper = objc_msgSend(objc_getClass("NSToolbarItemConfigWrapper"), @selector(alloc));
			[wrapper initWithWrappedItem:foundItem];
			return wrapper;
		}
		else
		{
			return [toolbarManager toolbarItemForIdentifier:arg1 insertedIntoToolbar:realSelf];
		}
	}
	else
	{
		id ret = [self ToolbarItemHandlers__newItemFromItemIdentifier:arg1
										   propertyListRepresentation:arg2
												 requireImmediateLoad:arg3
											willBeInsertedIntoToolbar:arg4];
		return ret;
	}
}

- (void)ToolbarItemHandlers__notifyView_MovedFromIndex:(long long)arg1 toIndex:(long long)arg2
{
	[self ToolbarItemHandlers__notifyView_MovedFromIndex:arg1 toIndex:arg2];
}



@end
