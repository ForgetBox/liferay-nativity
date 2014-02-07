//
//  NativityMessage.h
//  LiferayNativityClient
//
//  Created by Charles Francoise on 07/02/14.
//  Copyright (c) 2014 Forgetbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONKit.h"

@interface NativityMessage : NSObject

@property (nonatomic, retain) NSString* command;
@property (nonatomic, retain) id value;

+ (id)messageWithCommand:(NSString*)command andValue:(id)value;
+ (id)messageWithJSONData:(NSData*)jsonData;
+ (id)messageWithJSONString:(NSString*)jsonString;

- (id)initWithCommand:(NSString*)command andValue:(id)value;
- (id)initWithJSONData:(NSData*)jsonData;
- (id)initWithJSONString:(NSString*)jsonString;

- (NSData*)JSONData;
- (NSData*)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSString*)JSONString;
- (NSString*)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;

@end
