//
//  MyDefaults.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/11/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "MyDefaults.h"

@implementation MyDefaults

// dictionary keys for userdefaults used in FLPGalleryViewController
static NSString *const orig = @"originate";
static NSString *const screen = @"screen";
static NSString *const gallery = @"previous";

static NSString *const session = @"session"; // RJ..
// END

// for sample only.. base of code is used in FLPGalleryViewController.m
// method "(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender"
+ (BOOL)saveSessionKeys:(NSDictionary *)info {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:[info objectForKey:orig] forKey:orig];
    [defaults setObject:[info objectForKey:screen] forKey:screen];
    [defaults setObject:[info objectForKey:gallery] forKey:gallery];
    
    if ([defaults synchronize]) {
        NSLog(@"yes");
        return YES;
    }
    else {
        NSLog(@"no");
        return NO;
    }
}

+ (BOOL)saveSessionDictionary:(NSDictionary *)info {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:info forKey:session];
    
    if ([defaults synchronize]) {
        NSLog(@"yes");
        return YES;
    }
    else {
        NSLog(@"no");
        return NO;
    }
}

+ (NSDictionary *)retrieveSessionDictionary {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:session];
}


+ (NSString *)retriveOriginate {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:orig];
}

+ (NSString *)retriveScreen {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:screen];
}

+ (NSString *)retriveGallery {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:gallery];
}



@end
