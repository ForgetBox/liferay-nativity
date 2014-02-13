//
//  ToolbarButtonHandlers.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import "ToolbarButtonHandlers.h"
#import "IconCache.h"
#import <AppKit/NSToolbarItem.h>

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
	if ([arg1 isEqualToString:@"com.forgetbox.lima.LIMA"])
	{
		__block BOOL found = NO;
		[[self items] enumerateObjectsUsingBlock:^(NSToolbarItem* item, NSUInteger idx, BOOL *stop) {
			if ([item.itemIdentifier isEqualToString:@"com.forgetbox.lima.LIMA"])
			{
				found = YES;
				*stop = YES;
			}
		}];
		
		if (!found || !arg4)
		{
			NSToolbarItem* item = [[NSToolbarItem alloc] initWithItemIdentifier:@"com.forgetbox.lima.LIMA"];
			item.paletteLabel = @"Lima";
			item.toolTip = @"Lima";
			
			NSButton* templateButton = [[self delegate] toolbarButtonTemplate];
			NSData* buttonArchive = [NSArchiver archivedDataWithRootObject:templateButton];
			NSButton* button = [NSUnarchiver unarchiveObjectWithData:buttonArchive];
			
			button.image = [[IconCache sharedInstance] getIcon:@(1)];
			[button sizeToFit];
			item.view = button;
			
			return item;
		}
		
		return nil;
	}
	else
	{
		id ret = [self ToolbarButtonHandlers__newItemFromItemIdentifier:arg1
											 propertyListRepresentation:arg2
												   requireImmediateLoad:arg3
											  willBeInsertedIntoToolbar:arg4];
		return ret;
	}
}

- (void)ToolbarButtonHandlers__notifyView_MovedFromIndex:(long long)arg1 toIndex:(long long)arg2
{
	[self ToolbarButtonHandlers__notifyView_MovedFromIndex:arg1 toIndex:arg2];
}


@end
