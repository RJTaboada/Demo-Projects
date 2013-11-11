//
//  SharedVariables.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/11/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedVariables : NSObject


// properties
@property (assign) int  sharedNum;
@property (assign) BOOL sharedBOOL;

@property (strong, nonatomic) NSArray *sharedList;
@property (strong, nonatomic) NSString *sharedStr;
@property (strong, nonatomic) NSDictionary *sharedInfo;

// methods
+ (SharedVariables *)sharedManager;



@end
