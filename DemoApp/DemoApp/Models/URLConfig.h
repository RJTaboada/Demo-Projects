//
//  URLConfig.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/7/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLConfig : NSObject

+ (NSString *)getSampleURL; // for testing

+ (NSString *)newsFeedURL;
+ (NSString *)galleryFeedURL;
+ (NSString *)checkNumberOfPostURL;
+ (NSString *)userPostURL;
+ (NSString *)registrationURL;


@end
