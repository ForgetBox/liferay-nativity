//
//  ToolbarManager.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 17/02/14.
//
//

#import "ToolbarManager.h"

#import <AppKit/NSApplication.h>
#import <AppKit/NSWindow.h>
#import <objc/message.h>

#import "Finder/Finder.h"

#import "IconCache.h"
#import "PopUpButton.h"

static ToolbarManager* _sharedInstance = nil;

@interface ToolbarManager ()

@property (atomic, assign) BOOL addOperationQueued;
@property (atomic, assign) BOOL removeOperationQueued;

@end

@implementation ToolbarManager
{
	NSMutableDictionary* _toolbarItems;
	NSMutableArray* _itemsToAdd;
}

+ (id)sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (_sharedInstance == nil)
		{
			_sharedInstance = [[ToolbarManager alloc] init];
		}
	});
	
	return _sharedInstance;
}

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		_toolbarItems = [[NSMutableDictionary alloc] init];
		_itemsToAdd = [[NSMutableArray alloc] init];
		_addOperationQueued = NO;
		_removeOperationQueued = NO;
	}
	return self;
}

- (void)dealloc
{
	[_toolbarItems release];
	[_itemsToAdd release];
	
	[super dealloc];
}

- (NSArray*)itemIdentifiers
{
	return _toolbarItems.allKeys;
}

- (void)addToolbarItem:(NSDictionary*)itemDictionary
{
	[_itemsToAdd addObject:itemDictionary];
	
	[self addToolbarItems];
}

- (TToolbarItem*)toolbarItemForIdentifier:(NSString*)identifier insertedIntoToolbar:(TToolbar*)toolbar
{
	NSDictionary* itemDictionary = _toolbarItems[identifier];
	
	TToolbarItem* item = objc_msgSend(objc_getClass("TToolbarItem"), @selector(alloc));
	item = [item initWithItemIdentifier:identifier];
	item.label = itemDictionary[@"title"];
	item.paletteLabel = itemDictionary[@"title"];
	item.toolTip = itemDictionary[@"toolTip"];
	
	NSButton* templateButton = [toolbar.delegate toolbarButtonTemplate];
	PopUpButton* button = [[[PopUpButton alloc] initWithFrame:templateButton.frame pullsDown:YES] autorelease];
	button.toolbarItem = item;
	button.autoenablesItems = NO;
	button.bezelStyle = templateButton.bezelStyle;
	
	NSMenu* menu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSMenuItem* menuItem = [[[NSMenuItem alloc] init] autorelease];
	menuItem.title = @"";
	[menuItem setEnabled:YES];
	[menu addItem:menuItem];
	
	button.menu = menu;
	[button selectItemAtIndex:0];
	
	NSNumber* imageId = itemDictionary[@"image"];
	if (imageId != nil)
	{
		NSImage* image = [[IconCache sharedInstance] getIcon:imageId];
		menuItem.image = image;
	}
	
	if (button.image == nil)
	{
		menuItem.title = itemDictionary[@"title"];
		[button sizeToFit];
	}
	item.view = button;
	
	return item;
}

- (void)addToolbarItems
{
	if (_itemsToAdd.count == 0)
	{
		return;
	}
	
	if (!self.addOperationQueued)
	{
		self. addOperationQueued = YES;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSApplication* application = [NSApplication sharedApplication];
			NSArray* windows = application.windows;
			
			for (NSWindow* window in windows)
			{
				if ([window.className isEqualToString:@"TBrowserWindow"])
				{
					TToolbar* toolbar = (TToolbar*)[[window browserWindowController] toolbar];
					
					for (NSDictionary* itemDictionary in _itemsToAdd)
					{
						NSString* identifier = itemDictionary[@"identifier"];
						_toolbarItems[identifier] = itemDictionary;
									  
						[toolbar insertItemWithItemIdentifier:identifier atIndex:5];
					}
					
					[_itemsToAdd removeAllObjects];
					
					break;
				}
			}
			
			self.addOperationQueued = NO;
		});
	}
}

- (void)removeToolbarItems:(NSArray *)identifiers
{
	if (identifiers.count == 0)
	{
		return;
	}
	
	if (!self.removeOperationQueued)
	{
		self. removeOperationQueued = YES;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			NSApplication* application = [NSApplication sharedApplication];
			NSArray* windows = application.windows;
			
			for (NSWindow* window in windows)
			{
				if ([window.className isEqualToString:@"TBrowserWindow"])
				{
					TToolbar* toolbar = (TToolbar*)[[window browserWindowController] toolbar];
					
					for (NSString* identifier in identifiers)
					{
						__block NSUInteger itemIndex = NSNotFound;
						[toolbar.items enumerateObjectsUsingBlock:^(NSToolbarItem* item, NSUInteger idx, BOOL *stop) {
							if ([item.itemIdentifier isEqualToString:identifier])
							{
								itemIndex = idx;
								*stop = YES;
							}
						}];
						
						if (itemIndex != NSNotFound)
						{
							[toolbar removeItemAtIndex:itemIndex];
						}
					}
					
					break;
				}
			}
			
			self.removeOperationQueued = NO;
		});
	}
}


@end
