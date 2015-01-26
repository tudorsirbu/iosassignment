//
//  Created by Tudor Sirbu & Claudiu Tarta on 11/01/2015.
//  Copyright (c) 2015 sheffield. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"

@interface UserModelTest : XCTestCase
@end

@implementation UserModelTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor
{
    User* model = [[User alloc] initUserWith: @"12345" andName: @"John Doe"];
    XCTAssertEqual(@"12345", model.facebookId);
    XCTAssertEqual(@"John Doe", model.name);
}


-(void)testDefaultConstructor{
    User* model = [[User alloc] init];
    XCTAssertNotNil(model);
}

-(void) testNameSetterAndGetter{
    User* model = [[User alloc] init];
    model.name = @"John Doe";
    
    XCTAssertEqual(@"John Doe", model.name);
}

-(void) testFacebookIdSetterAndGetter{
    User* model = [[User alloc] init];
    model.facebookId = @"12345";
    XCTAssertEqual(@"12345", model.facebookId);
}

@end
