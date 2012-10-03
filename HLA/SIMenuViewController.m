//
//  SIMenuViewController.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIMenuViewController.h"
#import "NewLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"

@interface SIMenuViewController ()

@end

@implementation SIMenuViewController
@synthesize myTableView;
@synthesize RightView;
@synthesize ListOfSubMenu;
@synthesize handler;
@synthesize getAge,getSINo,getOccpCode;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:myTableView];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", nil ];
    
    getSINo = handler.SINo;
    getAge = handler.Age;
    getOccpCode = handler.OccpCode;
    NSLog(@"getSI:%@ getAge:%d getOccCode:%@",getSINo,getAge,getOccpCode);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return ListOfSubMenu.count;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NewLAViewController *newLA = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        
        newLA.modalPresentationStyle = UIModalPresentationFormSheet;
        newLA.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:newLA animated:YES];
        newLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
    }
    
    else if (indexPath.row == 3) {
    
        BasicPlanViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
        zzz.modalPresentationStyle = UIModalPresentationFormSheet;
        zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:zzz animated:YES];
        zzz.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);
    }
    else if (indexPath.row == 4) {
        
        RiderViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        zzz.modalPresentationStyle = UIModalPresentationFormSheet;
        zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:zzz animated:YES];
        zzz.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);
    }
    
    [tableView reloadData];
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setRightView:nil];
    [self setGetSINo:nil];
    [self setGetOccpCode:nil];
    [super viewDidUnload];
}

@end
