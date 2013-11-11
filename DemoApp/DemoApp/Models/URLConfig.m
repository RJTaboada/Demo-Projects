//
//  URLConfig.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/7/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "URLConfig.h"

static NSString *const FlipBKBaseURLString = @"http://ec2-54-213-86-134.us-west-2.compute.amazonaws.com/index.php/api";
static NSString *const BaseURLString = @"http://www.raywenderlich.com/downloads/weather_sample/";


@implementation URLConfig


+ (NSString *)getSampleURL {
    return [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
}

#pragma mark - newURL

+ (NSString *)newsFeedURL {
    return [NSString stringWithFormat:@"%@/posts/getnewsfeeds/", FlipBKBaseURLString];
}

+ (NSString *)galleryFeedURL {
    return [NSString stringWithFormat:@"%@/posts/getgallery/", FlipBKBaseURLString];
}

+ (NSString *)checkNumberOfPostURL {
    return [NSString stringWithFormat:@"%@/posts/checktotalnumberofposts/", FlipBKBaseURLString];
}

+ (NSString *)userPostURL {
    return [NSString stringWithFormat:@"%@/posts/getpostsandcomments/", FlipBKBaseURLString];
}

+ (NSString *)registrationURL {
    return [NSString stringWithFormat:@"%@/posts/register/", FlipBKBaseURLString];
}


@end
