//
//  SecondViewController.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/12/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *btnInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnaction;
@property (weak, nonatomic) IBOutlet UILabel *mylabel;

- (IBAction)didTapLogin:(UIButton *)sender;
- (IBAction)didTapInfo;
- (IBAction)didTapRequest;
- (IBAction)didTapFriends;

@end
