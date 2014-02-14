/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

#import "MenuManager.h"
#import "Finder/Finder.h"
#import "RequestManager.h"
#import "IconCache.h"

@implementation MenuManager

static MenuManager* sharedInstance = nil;

+ (MenuManager*)sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil)
		{
			sharedInstance = [[self alloc] init];
		}
	}
	return sharedInstance;
}

- init
{
	return [super init];
}

- (void)addChildrenSubMenuItems:(NSMenuItem*)parentMenuItem withChildren:(NSArray*)menuItemsDictionaries forFiles:(NSArray*)files
{
	NSMenu* menu = [[NSMenu alloc] init];

	for (int i = 0; i < [menuItemsDictionaries count]; ++i)
	{
		NSDictionary* menuItemDictionary = [menuItemsDictionaries objectAtIndex:i];

		NSString* submenuTitle = [menuItemDictionary objectForKey:@"title"];
		BOOL enabled = [[menuItemDictionary objectForKey:@"enabled"] boolValue];
		NSString* uuid = [menuItemDictionary objectForKey:@"uuid"];
		NSArray* childrenSubMenuItems = (NSArray*)[menuItemDictionary objectForKey:@"contextMenuItems"];
		NSNumber* imageId = menuItemDictionary[@"image"];
		NSImage* itemImage = nil;
		if (imageId != nil)
		{
			itemImage = [[IconCache sharedInstance] getIcon:imageId];
		}

		if ([submenuTitle isEqualToString:@"_SEPARATOR_"])
		{
			[menu addItem:[NSMenuItem separatorItem]];
		}
		else if (childrenSubMenuItems != nil && [childrenSubMenuItems count] != 0)
		{
			NSMenuItem* submenuItem = [menu addItemWithTitle:submenuTitle action:nil keyEquivalent:@""];
			if (itemImage != nil)
			{
				submenuItem.image = itemImage;
			}

			[self addChildrenSubMenuItems:submenuItem withChildren:childrenSubMenuItems forFiles:files];
		}
		else
		{
			[self createActionMenuItemIn:menu withTitle:submenuTitle withIndex:i image:itemImage enabled:enabled withUuid:uuid forFiles:files];
		}
	}

	[parentMenuItem setSubmenu:menu];

	[menu release];
}

- (void)addItemsToMenu:(NSMenu*)menu forFiles:(NSArray*)files
{
	NSArray* menuItemsArray = [[RequestManager sharedInstance] menuItemsForFiles:files];

	if (menuItemsArray == nil)
	{
		return;
	}

	if ([menuItemsArray count] == 0)
	{
		return;
	}

	NSInteger prevMenuIndex = -1;

	for (NSDictionary* menuItemDictionary in menuItemsArray)
	{
		NSNumber* index = menuItemDictionary[@"index"];
		NSInteger menuIndex;
		if (index == nil)
		{
			if (prevMenuIndex == -1)
			{
				menuIndex = 4;
			}
			else
			{
				menuIndex = prevMenuIndex + 1;
			}
		}
		else
		{
			menuIndex = [index integerValue];
		}
		
		if (prevMenuIndex + 1 != menuIndex)
		{
			BOOL hasSeparatorAfter = [[menu itemAtIndex:prevMenuIndex  + 1] isSeparatorItem];
			if (!hasSeparatorAfter)
			{
				[menu insertItem:[NSMenuItem separatorItem] atIndex:prevMenuIndex + 1];
				menuIndex++;
			}
			BOOL hasSeparatorBefore = [[menu itemAtIndex:menuIndex - 1] isSeparatorItem];
			if (!hasSeparatorBefore)
			{
				[menu insertItem:[NSMenuItem separatorItem] atIndex:menuIndex];
				menuIndex++;
			}
		}

		NSString* mainMenuTitle = [menuItemDictionary objectForKey:@"title"];

		if ([mainMenuTitle isEqualToString:@""])
		{
			continue;
		}

		BOOL enabled = [[menuItemDictionary objectForKey:@"enabled"] boolValue];
		NSString* uuid = [menuItemDictionary objectForKey:@"uuid"];
		NSArray* childrenSubMenuItems = (NSArray*)[menuItemDictionary objectForKey:@"contextMenuItems"];
		NSNumber* imageId = menuItemDictionary[@"image"];
		NSImage* itemImage = nil;
		if (imageId != nil)
		{
			itemImage = [[IconCache sharedInstance] getIcon:imageId];
		}
		
		if (childrenSubMenuItems != nil && [childrenSubMenuItems count] != 0)
		{
			NSMenuItem* mainMenuItem = [menu insertItemWithTitle:mainMenuTitle action:nil keyEquivalent:@"" atIndex:menuIndex];
			if (itemImage != nil)
			{
				mainMenuItem.image = itemImage;
			}

			[self addChildrenSubMenuItems:mainMenuItem withChildren:childrenSubMenuItems forFiles:files];
		}
		else
		{
			[self createActionMenuItemIn:menu withTitle:mainMenuTitle withIndex:menuIndex image:itemImage enabled:enabled withUuid:uuid forFiles:files];
		}
		
		prevMenuIndex = menuIndex;
	}
	
	BOOL hasSeparatorAfter = [[menu itemAtIndex:prevMenuIndex  + 1] isSeparatorItem];
	if (!hasSeparatorAfter)
	{
		[menu insertItem:[NSMenuItem separatorItem] atIndex:prevMenuIndex + 1];
	}
}

- (void)createActionMenuItemIn:(NSMenu*)menu withTitle:(NSString*)title withIndex:(NSInteger*)index image:(NSImage*)image enabled:(BOOL)enabled withUuid:(NSString*)uuid forFiles:(NSArray*)files
{
	NSMenuItem* mainMenuItem = [menu insertItemWithTitle:title action:@selector(menuItemClicked:) keyEquivalent:@"" atIndex:index];

	if (enabled)
	{
		[mainMenuItem setTarget:self];
	}
	
	if (image != nil)
	{
		mainMenuItem.image = image;
	}

	NSDictionary* menuActionDictionary = [[NSMutableDictionary alloc] init];
	[menuActionDictionary setValue:uuid forKey:@"uuid"];
	NSMutableArray* filesArray = [files copy];
	[menuActionDictionary setValue:filesArray forKey:@"files"];

	[mainMenuItem setRepresentedObject:menuActionDictionary];

	[filesArray release];
	[menuActionDictionary release];
}

- (void)menuItemClicked:(id)param
{
	[[RequestManager sharedInstance] menuItemClicked:[param representedObject]];
}

- (NSArray*)pathsForNodes:(const struct TFENodeVector*)nodes
{
	struct TFENode* start = nodes->_M_impl._M_start;
	struct TFENode* end = nodes->_M_impl._M_finish;

	int count = end - start;

	NSMutableArray* selectedItems = [[NSMutableArray alloc] initWithCapacity:count];
	struct TFENode* current;

	for (current = start; current < end; ++current)
	{
		FINode* node = (FINode*)[NSClassFromString(@"FINode") nodeFromNodeRef:current->fNodeRef];

		NSString* path = [[node previewItemURL] path];

		if (path)
		{
			[selectedItems addObject:path];
		}
	}

	return [selectedItems autorelease];
}

@end