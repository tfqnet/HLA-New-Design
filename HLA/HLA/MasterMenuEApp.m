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
@synthesize eAppPersonalDataVC = _eAppPersonalDataVC;
@synthesize HealthVC2 = _HealthVC2;
@synthesize HealthVC3 = _HealthVC3;
@synthesize myTableView,rightView,ListOfSubMenu;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Summary", @"Personal Details", @"Policy Details", @"Nominees/Trustees", @"Health Questions", @"Additional Questions",@"Declaration", nil ];
    myTableView.rowHeight = 44;
    [myTableView reloadData];
    
    UIStoryboard *nextStoryboard = [UIStoryboard storyboardWithName:@"LynnStoryboard" bundle:Nil];
    self.SummaryVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"SummaryScreen"];
    [self addChildViewController:self.SummaryVC];
    [self.rightView addSubview:self.SummaryVC.view];
    selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
    
    nextStoryboard = nil;
    
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
    UIStoryboard *nextStoryboard = [UIStoryboard storyboardWithName:@"LynnStoryboard" bundle:Nil];
    
    if (indexPath.row == 0)     //summary
    {
        self.SummaryVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"SummaryScreen"];
        [self addChildViewController:self.SummaryVC];
        [self.rightView addSubview:self.SummaryVC.view];
    }
    
    else if (indexPath.row == 1)
    {
        self.eAppPersonalDataVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"eAppDataScreen"];
        [self addChildViewController:self.eAppPersonalDataVC];
        [self.rightView addSubview:self.eAppPersonalDataVC.view];
    }
    
    else if (indexPath.row == 2)     //policy details
    {
        self.PolicyVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"MainPolicyScreen"];
        [self addChildViewController:self.PolicyVC];
        [self.rightView addSubview:self.PolicyVC.view];
    }
    
    else if (indexPath.row == 3)     //nominees
    {
        self.NomineesVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"MainNomineesScreen"];
        [self addChildViewController:self.NomineesVC];
        [self.rightView addSubview:self.NomineesVC.view];
    }
    
    else if (indexPath.row == 4)     //health questions
    {
        self.HealthVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"HealthQuestScreen"];
        _HealthVC.delegate = self;
        [self addChildViewController:self.HealthVC];
        [self.rightView addSubview:self.HealthVC.view];
    }
    
    else if (indexPath.row == 5)     //Additional questions
    {
        self.AddQuestVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"AddQuestScreen"];
        [self addChildViewController:self.AddQuestVC];
        [self.rightView addSubview:self.AddQuestVC.view];
    }
    
    else if (indexPath.row == 6)     //Declaration
    {
        self.DeclareVC = [nextStoryboard instantiateViewControllerWithIdentifier:@"DeclareEAppScreen"];
        [self addChildViewController:self.DeclareVC];
        [self.rightView addSubview:self.DeclareVC.view];
    }
    nextStoryboard = nil;
}

-(void) swipeToHQ2{
    self.HealthVC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"HQ2"];
    _HealthVC2.delegate = self;
    [self addChildViewController:self.HealthVC2];
    [self.rightView addSubview:self.HealthVC2.view];
    
}

-(void) swipeToHQ3 {
    self.HealthVC3 = [self.storyboard instantiateViewControllerWithIdentifier:@"HQ3"];
    [self addChildViewController:self.HealthVC3];
    [self.rightView addSubview:self.HealthVC3.view];
    
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
