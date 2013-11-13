//
//  SecondViewController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/12/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "SecondViewController.h"
#import "Zuckerkit.h"

#import "FriendListViewController.h"

@interface SecondViewController () {
    NSArray *friendlist;
}

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


#pragma mark - User Session

- (void)newUserSession {
    
    [[Zuckerkit sharedInstance] openSessionWithBasicInfoThenRequestPublishPermissions:^(NSError *error) {
        if(error) {
            [[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Unable to Authenticate your Account!"
                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Authorization successful."
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self.btnaction setTitle:@"Sign Out" forState:UIControlStateNormal];
        NSLog(@"after login current token is : %@",[[Zuckerkit sharedInstance] accessToken]);
    }];
}

- (void)endUserSession {
    
    [[Zuckerkit sharedInstance] logout];
    [[[UIAlertView alloc] initWithTitle:@"success" message:@"signout successfull"
                               delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.btnaction setTitle:@"Login Facebook" forState:UIControlStateNormal];
    NSLog(@"after logout .current token is : %@",[[Zuckerkit sharedInstance] accessToken]);
}

- (void)newUserSessionWithAudienceType {
    
    [[Zuckerkit sharedInstance] openSessionWithBasicInfoThenRequestPublishPermissionsAndGetAudienceType:^(NSError *error, NSInteger FacebookAudienceType) {
        
        if(error) {
            [[[UIAlertView alloc] initWithTitle:@"Fail" message:@"Unable to Authenticate your Account!"
                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Authorization successful."
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }];
}


#pragma mark - get Profile

- (void)retrieveUserInfo {
    
    [[Zuckerkit sharedInstance] getUserInfo:^(id<FBGraphUser> user, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Fail" message:error.description
                                       delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            return;
        }
        NSLog(@"user are %@",user);
        [[[UIAlertView alloc] initWithTitle:@"success" message:@"done retrieving user info"
                                   delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}

// unused migrated code to friendlist table
- (void)inviteFriend {
    
    [[Zuckerkit sharedInstance] sendRequest]; // MINE
//    [[Zuckerkit sharedInstance] showAppRequestDialogueWithMessage:@"testing" toUserId:@"100000620543264"]; //commented for testing..    100000620543264
}


// unused migrated code to friendlist table
- (void)retrieveFriendList {
    
//    [[Zuckerkit sharedInstance] getFriends:^(NSArray *friends, NSError *error) {
//        NSLog(@"FRIEND LIST ~: %@",friends);
//        friendlist = [NSArray arrayWithArray:friends];
//        
//        FriendListViewController *friendListViewController = [[FriendListViewController alloc] init];
//        friendListViewController.list = friendlist;
//        UINavigationController *navbar = [[UINavigationController alloc] initWithRootViewController:friendListViewController];
//        [self presentViewController:navbar animated:YES completion:nil];
//    }];
}


#pragma mark - actionMEthods

- (IBAction)didTapLogin:(UIButton *)sender {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (![[Zuckerkit sharedInstance] accessToken]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self newUserSession];
        });
    }
    else {
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

// modified now only used for pushing view
- (IBAction)didTapFriends {
    
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self retrieveFriendList];
//    });
}


#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.mylabel setText:@"asdfasdf"];
    
    friendlist = [[NSArray alloc] init];
    
    NSLog(@"current token is : %@",[[Zuckerkit sharedInstance] accessToken]);
    
    if ([[Zuckerkit sharedInstance] accessToken]) {
        [self.btnaction setTitle:@"Sign Out" forState:UIControlStateNormal];
    }
    else {
        [self.btnaction setTitle:@"Login Facebook" forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"test"]) {
        FriendListViewController *friendListViewController = [[FriendListViewController alloc] init];
        friendListViewController.list = friendlist;
    }
}



@end
