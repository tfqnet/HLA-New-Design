//
//  MasterMenuCFF.m
//  iMobile Planner
//
//  Created by shawal sapuan on 6/28/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MasterMenuCFF.h"

@interface MasterMenuCFF ()

@end

@implementation MasterMenuCFF
@synthesize DisclosureVC = _DisclosureVC;
@synthesize CustomerVC = _CustomerVC;
@synthesize CustomerDataVC = _CustomerDataVC;
@synthesize PotentialVC = _PotentialVC;
@synthesize PreferenceVC = _PreferenceVC;
@synthesize FinancialVC = _FinancialVC;
@synthesize RetirementVC = _RetirementVC;
@synthesize EducationVC = _EducationVC;
@synthesize SavingVC = _SavingVC;
@synthesize RecordVC = _RecordVC;
@synthesize RecordIIVC = _RecordIIVC;
@synthesize DeclareCFFVC = _DeclareCFFVC;
@synthesize ConfirmCFFVC = _ConfirmCFFVC;
@synthesize ListOfSubMenu,myTableView,RightView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Disclose of Intermediary Status", @"Customer's Choice", @"Customer's Personal Data", @"Potential Area for Discussion", @"Preference", @"Financial Analysis", @"Record of Advice", @"Declaration and Acknowledgement", @"Confirmation of Advice Given to", nil ];
    myTableView.rowHeight = 54;
    [myTableView reloadData];
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
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    return cell;
}


#pragma mark - table delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedPath = indexPath;
    
    if (indexPath.row == 0)     //disclosure
    {
        self.DisclosureVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DisclosureView"];
        [self addChildViewController:self.DisclosureVC];
        [self.RightView addSubview:self.DisclosureVC.view];
    }
    
    else if (indexPath.row == 1)     //customer choice
    {
        self.CustomerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerView"];
        [self addChildViewController:self.CustomerVC];
        [self.RightView addSubview:self.CustomerVC.view];
    }
    
    else if (indexPath.row == 2)     //customer data
    {
        self.CustomerDataVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CustDetailView"];
        [self addChildViewController:self.CustomerDataVC];
        [self.RightView addSubview:self.CustomerDataVC.view];
    }
    
    else if (indexPath.row == 3)     //potential area
    {
        self.PotentialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PotentialView"];
        [self addChildViewController:self.PotentialVC];
        [self.RightView addSubview:self.PotentialVC.view];
    }
    
    else if (indexPath.row == 4)     //preference
    {
        self.PreferenceVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PreferenceView"];
        [self addChildViewController:self.PreferenceVC];
        [self.RightView addSubview:self.PreferenceVC.view];
    }
    
    else if (indexPath.row == 5)     //financial analysis
    {
        self.FinancialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FinancialView"];
        _FinancialVC.delegate = self;
        [self addChildViewController:self.FinancialVC];
        [self.RightView addSubview:self.FinancialVC.view];
    }
    
    else if (indexPath.row == 6)     //record
    {
        self.RecordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordView"];
        _RecordVC.delegate = self;
        [self addChildViewController:self.RecordVC];
        [self.RightView addSubview:self.RecordVC.view];
    }
    
    else if (indexPath.row == 7)     //declare
    {
        self.DeclareCFFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DeclareCFFView"];
        [self addChildViewController:self.DeclareCFFVC];
        [self.RightView addSubview:self.DeclareCFFVC.view];
    }
    
    else if (indexPath.row == 8)     //declare
    {
        self.ConfirmCFFVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmCFFView"];
        [self addChildViewController:self.ConfirmCFFVC];
        [self.RightView addSubview:self.ConfirmCFFVC.view];
    }
}

#pragma mark - delegate action

-(void)swipeToRetirement
{
    self.RetirementVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RetirementView"];
    _RetirementVC.delegate = self;
    [self addChildViewController:self.RetirementVC];
    [self.RightView addSubview:self.RetirementVC.view];
}

-(void)swipeToEducation
{
    self.EducationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EducationView"];
    _EducationVC.delegate = self;
    [self addChildViewController:self.EducationVC];
    [self.RightView addSubview:self.EducationVC.view];
}

-(void)swipeToSavings
{
    self.SavingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SavingView"];
    [self addChildViewController:self.SavingVC];
    [self.RightView addSubview:self.SavingVC.view];
}

-(void)swipeToRecordAdviceII
{
    self.RecordIIVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecordIIView"];
    [self addChildViewController:self.RecordIIVC];
    [self.RightView addSubview:self.RecordIIVC.view];
}


#pragma mark - memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setRightView:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
