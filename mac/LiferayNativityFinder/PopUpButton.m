//
//  PopUpButton.m
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 17/02/14.
//
//

#import "PopUpButton.h"

#import "MenuManager.h"

#import "Finder/Finder.h"

@implementation PopUpButton


- (void)mouseDown:(NSEvent*)theEvent
{
//	NSMenu* menu = self.menu;
//	while (menu.numberOfItems > 1)
//	{
//		[menu removeItemAtIndex:1];
//	}
//	
//	MenuManager* menuManager = [MenuManager sharedInstance];
	
	struct TFENodeVector nodes;
	id browserController = [[theEvent.window browserWindowController] activeBrowserViewController];
	[browserController getSelectedNodes:&nodes];
//	NSArray* selectedItems = [menuManager pathsForNodes:&nodes];
//
//	[_browserController getTargetSelection:&nodes includeTarget:YES];
//	selectedItems = [menuManager pathsForNodes:&nodes];
//	
//	selectedItems = [menuManager pathsForNodes:[_browserController resolvedTargetPath]];
	
//	[menuManager addItemsToMenu:menu forFiles:selectedItems];
	
	[super mouseDown:theEvent];
}

@end
