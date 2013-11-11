//
//  OutputViewController.h
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/6/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutputViewController : UIViewController

@property (strong, nonatomic) NSString *outputStr;
@property (weak, nonatomic) IBOutlet UITextView *txtResult;



@end
