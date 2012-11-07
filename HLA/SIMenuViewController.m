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
#import "SecondLAViewController.h"
#import "PayorViewController.h"
#import "PremiumViewController.h"
#import "MainScreen.h"
#import "ReportViewController.h"
#import "BrowserViewController.h"

@interface SIMenuViewController ()

@end

@implementation SIMenuViewController
@synthesize myTableView;
@synthesize RightView;
@synthesize ListOfSubMenu,SelectedRow;
@synthesize menuH,menuBH;
@synthesize getAge,getSINo,getOccpCode,getbasicSA;
@synthesize payorCustCode,payorSINo,CustCode2,clientID2;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    [self.view addSubview:myTableView];
    
    self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];
//    self.myTableView.separatorColor = [UIColor clearColor];
//    self.RightView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"IMG_0039.png"]];
    self.RightView.backgroundColor = [UIColor colorWithRed:(5.0/255.0) green:(150.0/255.0) blue:(200.0/255.0) alpha:1.0];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", @"Quotation", nil ];
    
    SelectedRow = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"4", @"5", @"6", nil ];
    
    getSINo = menuH.storedSINo;
    getAge = menuH.storedAge;
    getOccpCode = menuH.storedOccpCode;
    getbasicSA = menuBH.storedbasicSA;
    LAEmpty = YES;
    PlanEmpty = YES;
    
    if (getSINo)
    {
        LAEmpty = NO;
//        NSLog(@"la receive!");
    }

    if (getbasicSA)
    {
        PlanEmpty = NO;
//        NSLog(@"plan receive!");
    }
    
    [self toogleView];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
  
//    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
//    main.mainBH = nil;
//    main.mainH = nil;

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)toogleView
{
    if (LAEmpty)
    {
        [SelectedRow addObject:@"1" ];
        [SelectedRow addObject:@"2" ];
        
//        NSLog(@"LA empty");
    }
    else {
        [SelectedRow removeObject:@"1"];
        [SelectedRow removeObject:@"2"];
//        NSLog(@"LA not empty");
    }
    
    if (PlanEmpty)
    {
        [SelectedRow addObject:@"4"];
        [SelectedRow addObject:@"5"];
//        NSLog(@"Plan empty");
    }
    else {
        [SelectedRow removeObject:@"4"];
        [SelectedRow removeObject:@"5"];
        [SelectedRow removeObject:@"6"];
//        NSLog(@"Plan not empty");
    }
}


#pragma mark - action

-(void)select2ndLA
{
    if (getAge >= 18)
    {
        SecondLAViewController *secondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
        secondLA.modalPresentationStyle = UIModalPresentationFormSheet;
        secondLA.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        secondLA.la2ndH = menuH;
        [self presentModalViewController:secondLA animated:YES];
        secondLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
    }
    else if (getAge < 16){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Life Assured" message:@"Life Assured is less than 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSLog(@"age 16-17");
        [self checkingPayor];
        if (payorSINo.length != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            SecondLAViewController *secondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
            secondLA.modalPresentationStyle = UIModalPresentationFormSheet;
            secondLA.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            secondLA.la2ndH = menuH;
            [self presentModalViewController:secondLA animated:YES];
            secondLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
        }
    }
}

-(void)selectPayor
{
    if (getAge >= 18) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Life Assured's age must not greater or equal to 18 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (getAge < 16) {
        
        PayorViewController *payorView = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
        payorView.modalPresentationStyle = UIModalPresentationFormSheet;
        payorView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        payorView.payorH = menuH;
        [self presentModalViewController:payorView animated:YES];
        payorView.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
    }
    else {
        NSLog(@"age 16-17");
        
        [self checking2ndLA];
        if (CustCode2.length != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            PayorViewController *payorView = [self.storyboard instantiateViewControllerWithIdentifier:@"payorView"];
            payorView.modalPresentationStyle = UIModalPresentationFormSheet;
            payorView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            payorView.payorH = menuH;
            [self presentModalViewController:payorView animated:YES];
            payorView.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
        }
    }

}

-(void)selectBasicPlan
{
    if (getSINo) {
        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            BasicPlanViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
            zzz.modalPresentationStyle = UIModalPresentationFormSheet;
            zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            zzz.basicH = menuH;
            [self presentModalViewController:zzz animated:YES];
            zzz.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);
        }
    }
    else {
        BasicPlanViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"BasicPlanView"];
        zzz.modalPresentationStyle = UIModalPresentationFormSheet;
        zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        zzz.basicH = menuH;
        [self presentModalViewController:zzz animated:YES];
        zzz.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);
    }
}

-(void)calculatedPrem
{
    if (menuBH.storedSINo) {
        PremiumViewController *premView = [self.storyboard instantiateViewControllerWithIdentifier:@"premiumView"];
        premView.modalPresentationStyle = UIModalPresentationFormSheet;
        premView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        premView.premBH = menuBH;
        premView.premH = menuH;
        [self presentModalViewController:premView animated:YES];
        premView.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Error!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
}


#pragma mark - db

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checking2ndLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientID2 = sqlite3_column_int(statement, 9);
            } else {
                NSLog(@"error access Trad_LAPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
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
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:18];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NewLAViewController *newLA = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        newLA.modalPresentationStyle = UIModalPresentationFormSheet;
        newLA.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        newLA.laH = menuH;
        newLA.laBH = menuBH;
        [self presentModalViewController:newLA animated:YES];
        newLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
        
//        [self addChildViewController:newLA];
//        [self.RightView addSubview:newLA.view];
    }
    
    else if (indexPath.row == 1) {
        [self select2ndLA];
    }
    
    else if (indexPath.row == 2) {
        [self selectPayor];
    }
    
    else if (indexPath.row == 3) {
        [self selectBasicPlan];
    }
    
    else if (indexPath.row == 4) {
        
        RiderViewController *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"RiderView"];
        zzz.modalPresentationStyle = UIModalPresentationFormSheet;
        zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        zzz.riderBH = menuBH;
        zzz.riderH = menuH;
        [self presentModalViewController:zzz animated:YES];
        zzz.view.superview.bounds = CGRectMake(-284, 0, 1024, 748);

    }
    
    else if (indexPath.row == 5) {
        [self calculatedPrem];
    }
    
    else if (indexPath.row == 6) { //quotation
        ReportViewController *ReportPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
        ReportPage.SINo = getSINo;
        [self presentViewController:ReportPage animated:NO completion:^{
            [ReportPage dismissViewControllerAnimated:NO completion:^{
                
                //ReportViewController *reportVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Browser"];
                //[self presentViewController:reportVC animated:YES completion:Nil];
                BrowserViewController *controller = [[BrowserViewController alloc] init];
                controller.title = @"Pages";
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
                UINavigationController *container = [[UINavigationController alloc] init];
                [container setNavigationBarHidden:YES animated:NO];
                [container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
                [self presentModalViewController:container animated:TRUE];
            }];
        }];
    }
    
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BOOL found = false;
    
    if ([SelectedRow count ] == 0) {
        return  44;
    }
    else {
        NSString *aString = [[NSString alloc] initWithFormat:@"%d", indexPath.row ];
        for (int f = 0; f < [SelectedRow count]; f++) {
            NSString * stringFromArray = [SelectedRow objectAtIndex:f];
            if ([aString isEqualToString:stringFromArray]) {
                found = true;
                break;
            }
        }
        
        if (found) {
            return 0;
            
        }
        else {
            return  44;
        }
    }
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setMyTableView:nil];
    [self setRightView:nil];
    [self setGetSINo:nil];
    [self setGetOccpCode:nil];
    [self setPayorCustCode:nil];
    [self setPayorSINo:nil];
    [self setCustCode2:nil];
    [self setGetbasicSA:nil];
    [super viewDidUnload];
}

@end
