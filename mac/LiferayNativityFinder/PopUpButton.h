//
//  PopUpButton.h
//  LiferayNativityFinder
//
//  Created by Charles Francoise on 17/02/14.
//
//

#import <Cocoa/Cocoa.h>

@class TToolbarItem;

@interface PopUpButton : NSPopUpButton

@property (nonatomic, assign) TToolbarItem* toolbarItem;

@end
