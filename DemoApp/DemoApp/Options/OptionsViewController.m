//
//  OptionsViewController.m
//  DemoApp
//
//  Created by Rene Jay Taboada on 11/6/13.
//  Copyright (c) 2013 reneboi. All rights reserved.
//

#import "OptionsViewController.h"


#import "OutputViewController.h"

#import "MyDefaults.h"
#import "SharedVariables.h"

@interface OptionsViewController () {
    
    OutputViewController *outputViewController;
}

@end

@implementation OptionsViewController


#pragma mark - init

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - someMethods

- (void)getMyDefaults:(id)info {
    
    NSLog(@"\n ********* retrieve session dictionary ********* \n %@ \n *************************", [MyDefaults retrieveSessionDictionary]);
    
    NSLog(@"\n ********* retrieve session originate ********* \n %@ \n *************************", [MyDefaults retriveOriginate]);
    
    NSLog(@"\n ********* retrieve session screen ********* \n %@ \n *************************", [MyDefaults retriveScreen]);
    
    NSLog(@"\n ********* retrieve session gallery ********* \n %@ \n *************************", [MyDefaults retriveGallery]);
}

#pragma mark - ViewCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set array
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Items" ofType:@"plist"];
    self.list = [NSArray arrayWithContentsOfFile:path];
    
    // UserDefault Sample..
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"gallery" , @"originate",
                          @"capture" , @"screen" ,
                          @"gallery" , @"previous" , nil];
    
    [MyDefaults saveSessionDictionary:info];
    [MyDefaults saveSessionKeys:info];
    // End UserDefault Sample..
    
    
    // create bar button item for testing..
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"GetSession"
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(getMyDefaults:)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    // end
    
    
    // sample for sharedVariables..
    SharedVariables *sharedInfo = [SharedVariables sharedManager];
    sharedInfo.sharedInfo = info; // insert dummy data..
    
    // to confirm if data is successfully inserted please push next view by tapping any of the cells..
    NSLog(@"to confirm if data is successfully inserted please push next view by tapping any of the cells..");
    // end
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"Title"];
    cell.detailTextLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"Description"];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *data = [NSString stringWithFormat:@"%@ \n \n %@",
                      [[self.list objectAtIndex:indexPath.row] objectForKey:@"Title"],
                      [[self.list objectAtIndex:indexPath.row] objectForKey:@"Description"]];
    
    NSLog(@"Did Select Row %d \n %@",indexPath.row, data);
    
    
    outputViewController.outputStr = data;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Result"]) {
        NSLog(@"prepare for seage");
        NSIndexPath *row = [self.tableView indexPathForSelectedRow];
        
        NSString *data = [NSString stringWithFormat:@"%@ \n \n %@",
                          [[self.list objectAtIndex:row.row] objectForKey:@"Title"],
                          [[self.list objectAtIndex:row.row] objectForKey:@"Description"]];
        
        outputViewController = [segue destinationViewController];
        outputViewController.outputStr = data;
    }
}

@end
