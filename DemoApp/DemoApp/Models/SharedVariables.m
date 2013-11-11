//
//  SharedVariables.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/11/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "SharedVariables.h"

@implementation SharedVariables

+ (SharedVariables *)sharedManager {
    static dispatch_once_t pred;
    static SharedVariables *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[SharedVariables alloc] init];
    });
    
    return shared;
}


@end
