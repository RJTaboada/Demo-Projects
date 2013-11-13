//
//  FriendListViewController.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/14/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendListViewController : UITableViewController

@property (nonatomic, strong) NSArray *list;


- (IBAction)didTapCancel:(id)sender;

@end
