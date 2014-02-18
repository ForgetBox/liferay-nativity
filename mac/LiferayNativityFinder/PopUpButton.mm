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

#include <vector>

@implementation PopUpButton


- (void)mouseDown:(NSEvent*)theEvent
{
	NSMenu* menu = self.menu;
	while (menu.numberOfItems > 1)
	{
		[menu removeItemAtIndex:1];
	}
	
	MenuManager* menuManager = [MenuManager sharedInstance];
	
	id browserController = [[theEvent.window browserWindowController] activeBrowserViewController];
	
	std::vector<TFENode*> nodeVector;
	struct TFENodeVector* nodes = (struct TFENodeVector *)&nodeVector;
	[browserController getSelectedNodes:nodes];
	NSArray* selectedItems = [menuManager pathsForNodes:nodes];
	
	[menuManager addItemsToMenu:menu forFiles:selectedItems withToolbarIdentifier:_toolbarItem.itemIdentifier];
	
	[super mouseDown:theEvent];
}

@end
