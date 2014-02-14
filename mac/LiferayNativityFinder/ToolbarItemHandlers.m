//
//  ToolbarItemHandlers.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 12/02/14.
//
//

#import "ToolbarItemHandlers.h"
#import "IconCache.h"
#import <objc/objc-runtime.h>

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
	[arr addObject:@"com.forgetbox.lima.LIMA"];
	return arr;
}

#pragma mark TToolbar methods

- (void)ToolbarItemHandlers_setSizeMode:(unsigned long long)arg1
{
	[self ToolbarItemHandlers_setSizeMode:arg1];
}

- (id)ToolbarItemHandlers__newItemFromItemIdentifier:(id)arg1 propertyListRepresentation:(id)arg2 requireImmediateLoad:(char)arg3 willBeInsertedIntoToolbar:(char)arg4
{
	if ([arg1 isEqualToString:@"com.forgetbox.lima.LIMA"])
	{
		TToolbar* realSelf = (TToolbar*)self;
		
		__block BOOL found = NO;
		[realSelf.items enumerateObjectsUsingBlock:^(NSToolbarItem* item, NSUInteger idx, BOOL *stop) {
			if ([item.itemIdentifier isEqualToString:@"com.forgetbox.lima.LIMA"])
			{
				found = YES;
				*stop = YES;
			}
		}];
		
		if (!found || !arg4)
		{
			TToolbarItem* item = objc_msgSend(objc_getClass("TToolbarItem"), @selector(alloc));
			item = [item initWithItemIdentifier:arg1];
			item.paletteLabel = @"Lima";
			item.toolTip = @"Lima";
			
			NSButton* templateButton = [realSelf.delegate toolbarButtonTemplate];
			NSPopUpButton* button = [[[NSPopUpButton alloc] initWithFrame:templateButton.frame pullsDown:YES] autorelease];
			button.pullsDown = YES;
			button.bezelStyle = templateButton.bezelStyle;
			button.image = [[IconCache sharedInstance] getIcon:@(1)];
			item.view = button;
			
			return [item autorelease];
		}
		
		return nil;
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
