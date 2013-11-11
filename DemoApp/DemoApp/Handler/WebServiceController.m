//
//  WebServiceController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/7/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "WebServiceController.h"

#import "URLConfig.h"

//static NSString *const BaseURLString = @"http://www.raywenderlich.com/downloads/weather_sample/";
//static NSString *const BaseURLString = @"http://ec2-54-213-86-134.us-west-2.compute.amazonaws.com/index.php/api";



@interface WebServiceController () {
    
    AFJSONRequestOperation *operation;
}

@end


@implementation WebServiceController


#pragma mark - init

- (id)initWithURL:(NSString *)param {

    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
    
}


#pragma mark - URLMethods

- (void)retrieveSample {
    
    NSString *URL = [URLConfig getSampleURL];
    [self startFetchToURL:URL withParams:Nil];
}

- (void)retrieveNewsFeed {
    
    NSString *URL = [URLConfig newsFeedURL];
    
    // send some parameters here..
    // currently nil not sure about the parameters to be sent to the web services..
    [self startFetchToURL:URL withParams:Nil];
}

- (void)retrieveGalleryFeed {
    
    NSString *URL = [URLConfig galleryFeedURL];
    
    // send some parameters here..
    // currently nil not sure about the parameters to be sent to the web services..
    [self startFetchToURL:URL withParams:Nil];
}

- (void)retrieveNumberOfPostURL {
    
    NSString *URL = [URLConfig checkNumberOfPostURL];
    
    // send some parameters here..
    // currently nil not sure about the parameters to be sent to the web services..
    [self startFetchToURL:URL withParams:Nil];
}

- (void)retrieveUserPost {
    
    NSString *URL = [URLConfig userPostURL];
    
    // send some parameters here..
    // currently nil not sure about the parameters to be sent to the web services..
    [self startFetchToURL:URL withParams:Nil];
}

- (void)submitRegistration {
    
    NSString *URL = [URLConfig registrationURL];
    
    // send some parameters here..
    // currently nil not sure about the parameters to be sent to the web services..
    [self startFetchToURL:URL withParams:Nil];
}


#pragma mark - Send&Cancel Request

- (void)startFetchToURL:(NSString *)API_URL_STR withParams:(NSDictionary *)params {
    
    // define url and request
    NSURL *API_URL = [NSURL URLWithString:API_URL_STR];
    NSURLRequest *request = [NSURLRequest requestWithURL:API_URL];
    
    // do operation action to fectch raw data in JSON
    operation = [AFJSONRequestOperation
                 JSONRequestOperationWithRequest:request
                 
                 // successfully fetch data
                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                     [self fetcherWithJSON:(NSDictionary *)JSON]; //call method to return fetch data
                 }
                 
                 // failed and fetching data
                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                     [self fetcherWithError:JSON]; // call error method
                 }];
    
    // 5
    [operation start];
}

- (void)cancelRequest {
    
    NSLog(@"Cancel request");
    [operation cancel];
}


#pragma mark - WebServiceControllerDelegate

- (void)fetcherWithJSON:(NSDictionary *)info {
    
    // return data from main class
    [self.mydelegate fetcherService:self didFinishWithData:info];
}


- (void)fetcherWithError:(id)info {
    
    // return error message from main class
    [self.mydelegate fetcherService:self didFailWithError:@"error"];
}





@end
