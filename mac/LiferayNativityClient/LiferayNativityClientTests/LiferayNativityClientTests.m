//
//  LiferayNativityClientTests.m
//  LiferayNativityClientTests
//
//  Created by Charles Francoise on 05/02/14.
//  Copyright (c) 2014 Charles Francoise. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LiferayNativityClient.h"

@interface LiferayNativityClientTests : XCTestCase

@end

@implementation LiferayNativityClientTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    NativityControl* nativityControl = [NativityControl sharedInstance];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
}

@end
