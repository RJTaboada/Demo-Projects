//
//  WebServiceController.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/7/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#import "URLConfig.h"


@class WebServiceController;

@protocol WebServiceControllerDelegate <NSObject>

// optional success delegate
@optional
- (void)fetcherService:(WebServiceController *)fetcher didFinishWithData:(NSDictionary *)info;

// required delegate
@required
- (void)fetcherService:(WebServiceController *)fetcher didFailWithError:(NSString *)error;

@end


@interface WebServiceController : NSObject



@property (nonatomic, assign) id <WebServiceControllerDelegate> mydelegate;


- (void)retrieveSample;
- (void)retrieveNewsFeed;

@end

