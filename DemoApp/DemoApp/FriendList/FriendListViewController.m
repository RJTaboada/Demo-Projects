//
//  FriendListViewController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/14/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "FriendListViewController.h"

#import "Zuckerkit.h"

@interface FriendListViewController ()

@end

@implementation FriendListViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - sortFriends 

+ (NSArray *)sortFriendList:(NSArray *)friends {
    
    NSMutableArray *temp = [NSMutableArray arrayWithArray:friends];
    NSSortDescriptor *theDescriptor = [[NSSortDescriptor alloc]
                                       initWithKey:@"name"
                                       ascending:NO
                                       selector:@selector(compare:)];
    NSArray *sortDescriptors = [NSArray arrayWithObject:theDescriptor];
    
    [temp sortUsingDescriptors:sortDescriptors];
    
    friends = [NSArray arrayWithArray:temp];
    return friends;
}


#pragma mark - getFriends

- (void)getfriendID:(NSString *)fid {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self inviteFriendWithID:fid];
    });
}

- (void)retrieveFriendList {
    
    [[Zuckerkit sharedInstance] getFriends:^(NSArray *friends, NSError *error) {

        self.list = [[self class] sortFriendList:friends];
        
        [self.tableView reloadData];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
}


#pragma mark - sendFriendRequest

- (void)inviteFriendWithID:(NSString *)fid {
    
//    [[Zuckerkit sharedInstance] sendRequest]; // MINE
    [[Zuckerkit sharedInstance] showAppRequestDialogueWithMessage:@"Demo FlpBK app" toUserId:fid]; //commented for testing..    100000620543264
}


#pragma mark - viewcylce

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [[NSArray alloc] init];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self retrieveFriendList];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *row = [self.tableView indexPathForSelectedRow];
    [self getfriendID:[[self.list objectAtIndex:row.row] objectForKey:@"id"]];
}


- (IBAction)didTapCancel:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
