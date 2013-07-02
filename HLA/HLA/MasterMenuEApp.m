//
//  MasterMenuEApp.m
//  iMobile Planner
//
//  Created by shawal sapuan on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MasterMenuEApp.h"

@interface MasterMenuEApp ()

@end

@implementation MasterMenuEApp
@synthesize SummaryVC = _SummaryVC;
@synthesize PolicyVC = _PolicyVC;
@synthesize NomineesVC = _NomineesVC;
@synthesize HealthVC = _HealthVC;
@synthesize AddQuestVC = _AddQuestVC;
@synthesize DeclareVC = _DeclareVC;
@synthesize myTableView,rightView,ListOfSubMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Summary", @"Personal Details", @"Policy Details", @"Nominees/Trustees", @"Health Questions", @"Additional Questions",@"Declaration", nil ];
    myTableView.rowHeight = 44;
    [myTableView reloadData];
    
    self.SummaryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryView"];
    [self addChildViewController:self.SummaryVC];
    [self.rightView addSubview:self.SummaryVC.view];
    selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
    self.myTableView.frame = CGRectMake(0, 0, 220, 748);
    [self hideSeparatorLine];
//    self.rightView.frame = CGRectMake(223, 0, 801, 748);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)hideSeparatorLine
{
    CGRect frame = myTableView.frame;
    frame.size.height = MIN(44 * [ListOfSubMenu count], 748);
    myTableView.frame = frame;
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

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = @"";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    return cell;
}


#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    
    if (indexPath.row == 0)     //summary
    {
        self.SummaryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryView"];
        [self addChildViewController:self.SummaryVC];
        [self.rightView addSubview:self.SummaryVC.view];
    }
    
    else if (indexPath.row == 1) {
        self.CustomerDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustDetailView"];
        [self addChildViewController:self.CustomerDataVC];
        [self.rightView addSubview:self.CustomerDataVC.view];
    }
    
    else if (indexPath.row == 2)     //policy details
    {
//        _PolicyVC.delegate = self;
        self.PolicyVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PolicyNavi"];
        [self addChildViewController:self.PolicyVC];
        [self.rightView addSubview:self.PolicyVC.view];
    }
    
    else if (indexPath.row == 3)     //nominees
    {
        self.NomineesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NomineesView"];
        [self addChildViewController:self.NomineesVC];
        [self.rightView addSubview:self.NomineesVC.view];
    }
    
    else if (indexPath.row == 4)     //health questions
    {
        self.HealthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthView"];
        [self addChildViewController:self.HealthVC];
        [self.rightView addSubview:self.HealthVC.view];
    }
    
    else if (indexPath.row == 5)     //Additional questions
    {
        self.AddQuestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddQuestView"];
        [self addChildViewController:self.AddQuestVC];
        [self.rightView addSubview:self.AddQuestVC.view];
    }
    
    else if (indexPath.row == 6)     //Declaration
    {
        self.DeclareVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeclareView"];
        [self addChildViewController:self.DeclareVC];
        [self.rightView addSubview:self.DeclareVC.view];
    }
}


#pragma mark - memory managemnet

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setRightView:nil];
    [super viewDidUnload];
}

@end
