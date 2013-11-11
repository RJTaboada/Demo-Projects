//
//  MyDefaults.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/11/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDefaults : NSObject

+ (BOOL)saveSessionKeys:(NSDictionary *)info;
+ (BOOL)saveSessionDictionary:(NSDictionary *)info;
+ (NSDictionary *)retrieveSessionDictionary;


+ (NSString *)retriveOriginate;
+ (NSString *)retriveScreen;
+ (NSString *)retriveGallery;

@end
