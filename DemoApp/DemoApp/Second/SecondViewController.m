//
//  SecondViewController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/12/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "SecondViewController.h"
#import "Zuckerkit.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#warning @job - mejo buggy pa ito, specially sa send invite to friends.. d xa nag error pwo wala naman ma resev na notification, titignan ko pa to..


#pragma mark - REQUEST

- (void)newUserSession {
    
    [[Zuckerkit sharedInstance] openSessionWithBasicInfoThenRequestPublishPermissions:^(NSError *error) {
        if(error) {
            [[[UIAlertView alloc] initWithTitle:@"Fail" message:error.description
                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Authorization successful."
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }];
    
}

- (void)retrieveUserInfo {
    
    [[Zuckerkit sharedInstance] getUserInfo:^(id<FBGraphUser> user, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Fail" message:error.description
                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        NSLog(@"user are %@",user);
        [[[UIAlertView alloc] initWithTitle:@"success" message:@"done retrieving friend list"
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


- (void)endUserSession {
    
    [[Zuckerkit sharedInstance] logout];
    [[[UIAlertView alloc] initWithTitle:@"success" message:@"signout successfull"
                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)inviteFriend {
    
    [[Zuckerkit sharedInstance] sendRequest]; // MINE
//    [[Zuckerkit sharedInstance] showAppRequestDialogueWithMessage:@"testing" toUserId:@"100000620543264"]; //commented for testing..
}

- (void)retrieveFriendList {
    
    [[Zuckerkit sharedInstance] getFriends:^(NSArray *friends, NSError *error) {
        NSLog(@"FRIEND LIST ~: %@",friends);
    }];
}


#pragma mark - actionMEthods

- (IBAction)didTapLogin:(UIButton *)sender {
    
    if (!sender.tag) {
        [self.btnaction setTag:1];
        [self.btnaction setTitle:@"Sign Out" forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self newUserSession];
        });
    }
    else {
        
        [self.btnaction setTag:0];
        [self.btnaction setTitle:@"Login Facebook" forState:UIControlStateNormal];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endUserSession];
        });
    }
    
}

- (IBAction)didTapInfo {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self retrieveUserInfo];
    });
}

- (IBAction)didTapRequest {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self inviteFriend];
    });
}

- (IBAction)didTapFriends {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self retrieveFriendList];
    });
}


#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.mylabel setText:@"asdfasdf"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
