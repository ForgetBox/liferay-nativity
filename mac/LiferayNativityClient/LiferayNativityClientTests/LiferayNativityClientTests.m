 //
//  LiferayNativityClientTests.m
//  LiferayNativityClientTests
//
//  Created by Charles Francoise on 05/02/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LiferayNativityClient.h"

#import "TestContextMenuCallback.h"
#import "TestToolbarMenuCallback.h"

@interface LiferayNativityClientTests : XCTestCase

@end

@implementation LiferayNativityClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    srandomdev();
    
    NativityControl* nativityControl = [NativityControl sharedInstance];
    XCTAssert([nativityControl load], @"Could not load Nativity");
    XCTAssert([nativityControl loaded], @"Nativity not loaded during setup");
    XCTAssert([nativityControl connect], @"Could not connect to Nativity");
}

- (void)tearDown
{
    NativityControl* nativityControl = [NativityControl sharedInstance];
    XCTAssert([nativityControl loaded], @"Nativity not loaded during teardown");
    XCTAssert([nativityControl disconnect], @"Could not disconnect from Nativity");
    XCTAssert([nativityControl unload], @"Could not unload Nativity");
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFileIcons
{
    NativityControl* nativityControl = [NativityControl sharedInstance];
    [nativityControl setFilterPath:@"/Users/chrales/Work/lima/overlay-test"];
    
    FileIconControl* fileIconControl = [[[FileIconControl alloc] initWithNativityControl:nativityControl] autorelease];
    
    [fileIconControl enableFileIcons];
    
    long iconId = [nativityControl registerImage:@"/Users/chrales/Work/lima/overlay-test/test_icon.icns"];
    
    [fileIconControl setIcon:iconId forPath:@"/Users/chrales/Work/lima/overlay-test/test.db"];
    
    [fileIconControl disableFileIcons];
    
    [fileIconControl enableFileIcons];
    
    [fileIconControl removeIconForPath:@"/Users/chrales/Work/lima/overlay-test/test.db"];
    
    [nativityControl unregisterImage:iconId];
    
    [fileIconControl disableFileIcons];
}

- (void)testMenuCallback
{
    NativityControl* nativityControl = [NativityControl sharedInstance];
    [nativityControl setFilterPath:@"/Users/chrales/Work/lima/overlay-test"];
    long iconId = [nativityControl registerImage:@"/Users/chrales/Work/lima/overlay-test/menu-item-image.png"];
    
    TestContextMenuCallback* callback = [[TestContextMenuCallback alloc] initWithNativityControl:nativityControl];
    callback.imageId = iconId;
    
    while (!callback.hasClicked)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
}

- (void)testToolbarItem
{
    NativityControl* nativityControl = [NativityControl sharedInstance];
    [nativityControl setFilterPath:@"/Users/chrales/Work/lima/overlay-test"];
    long iconId = [nativityControl registerImage:@"/Users/chrales/Work/lima/overlay-test/menu-item-image.png"];
    
    ToolbarItemControl* toolbarItemControl = [[[ToolbarItemControl alloc] initWithNativityControl:nativityControl] autorelease];
    ToolbarItem* item = [ToolbarItem toolbarItemWithIdentifier:@"com.forgetbox.lima"];
    item.title = @"Lima";
    item.toolTip = @"Access Lima-related operations";
    item.imageId = iconId;
    [toolbarItemControl addToolbarItem:item];
    
    TestToolbarMenuCallback* callback = [[TestToolbarMenuCallback alloc] init];
    callback.imageId = iconId;
    item.callback = callback;
    
    while (!callback.hasClicked)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.01]];
    }
    
    
}

@end
