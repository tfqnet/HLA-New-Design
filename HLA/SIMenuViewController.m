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

@interface SIMenuViewController ()

@end

@implementation SIMenuViewController
@synthesize myTableView;
@synthesize RightView;
@synthesize ListOfSubMenu;
@synthesize menuH,menuBH;
@synthesize getAge,getSINo,getOccpCode;
@synthesize payorCustCode,payorSINo,CustCode2,clientID2;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:myTableView];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor", @"Basic Plan", @"Rider", @"Premium", nil ];
    
    getSINo = menuH.storedSINo;
    getAge = menuH.storedAge;
    getOccpCode = menuH.storedOccpCode;
//    NSLog(@"MENULA-SINo:%@ Age:%d OccCode:%@",getSINo,getAge,getOccpCode);
//    NSLog(@"MENUBasic-SINo:%@ Age:%d OccCode:%@",menuBH.storedSINo,menuBH.storedAge,menuBH.storedOccpCode);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


#pragma mark - action

-(void)select2ndLA
{
    if (getSINo) {
        
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
    else {
        
        SecondLAViewController *secondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
        secondLA.modalPresentationStyle = UIModalPresentationFormSheet;
        secondLA.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        secondLA.la2ndH = menuH;
        [self presentModalViewController:secondLA animated:YES];
        secondLA.view.superview.bounds = CGRectMake(-284, 0,1024, 748);
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
    
    [tableView reloadData];
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setRightView:nil];
    [self setGetSINo:nil];
    [self setGetOccpCode:nil];
    [self setPayorCustCode:nil];
    [self setPayorSINo:nil];
    [self setCustCode2:nil];
    [super viewDidUnload];
}

@end
