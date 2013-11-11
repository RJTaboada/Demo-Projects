//
//  OutputViewController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/6/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "OutputViewController.h"


#import "WebServiceController.h"

#import "SharedVariables.h"

static NSString *const BaseURLString = @"http://www.raywenderlich.com/downloads/weather_sample/";

@interface OutputViewController () <WebServiceControllerDelegate> {
    
    WebServiceController *webServiceController;
}


@end

@implementation OutputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.txtResult.text = self.outputStr;
    
    webServiceController = [[WebServiceController alloc] init];
    webServiceController.mydelegate = self;
    
    SharedVariables *sharedInfo = [SharedVariables sharedManager];
    
    NSLog(@"\n ********* sharedInfo data ********* \n %@ \n *************************", sharedInfo.sharedInfo);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
 
    [self reloadResultData];
}


- (void)reloadResultData {
    
    [webServiceController retrieveSample];
}


#pragma mark - WebServiceControllerDelegate

- (void)fetcherService:(WebServiceController *)fetcher didFinishWithData:(NSDictionary *)info {
    
    NSLog(@"Success %@!!",[info objectForKey:@"data"]);
}

- (void)fetcherService:(WebServiceController *)fetcher didFailWithError:(NSString *)error {
    
    NSLog(@"Error message!!");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
