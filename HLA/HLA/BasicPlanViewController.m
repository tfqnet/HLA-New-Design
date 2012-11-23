//
//  BasicPlanViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicPlanViewController.h"
#import "RiderViewController.h"
#import "NewLAViewController.h"
#import "PremiumViewController.h"
#import "SIMenuViewController.h"
#import "SIHandler.h"
#import "MainScreen.h"
#import "BasicPlanHandler.h"


@interface BasicPlanViewController ()

@end

@implementation BasicPlanViewController
@synthesize btnPlan;
@synthesize termField;
@synthesize yearlyIncomeField;
@synthesize minSALabel;
@synthesize maxSALabel;
@synthesize btnHealthLoading;
@synthesize healthLoadingView;
@synthesize MOPSegment;
@synthesize incomeSegment;
@synthesize advanceIncomeSegment;
@synthesize cashDividendSegment;
@synthesize HLField;
@synthesize HLTermField;
@synthesize tempHLField;
@synthesize tempHLTermField;
@synthesize myScrollView;
@synthesize ageClient,requestSINo,termCover,planChoose,maxSA,minSA,SINoPlan;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,cashDividend;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize planCode,requestOccpCode,basicH,dataInsert, OccuClass;
@synthesize popoverController;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ageClient = basicH.storedAge;
    requestSINo = basicH.storedSINo;
    requestOccpCode = basicH.storedOccpCode;
    OccuClass = basicH.storedOccpClass;
    NSLog(@"BASIC-SINo:%@, age:%d, job:%@",requestSINo,ageClient,requestOccpCode);
    
    if (!planList) {
        planList = [[PlanList alloc] init];
        planList.delegate = self;
    }
    planChoose = [[NSString alloc] initWithFormat:@"%@",planList.selectedCode];
    [self.btnPlan setTitle:planList.selectedDesc forState:UIControlStateNormal];
    
    if (ageClient > 65) {
        advanceIncomeSegment.enabled = NO;
    }
    
    newSegment = YES;
    [self toggleSegment];
    
    healthLoadingView.alpha = 0;
    showHL = NO;
    useExist = NO;
    SINoPlan = [[NSString alloc] initWithFormat:@"%@",requestSINo];
    termField.enabled = NO;
    [self getTermRule];
    
    if (requestSINo) {
        [self checkingExisting];
        if (getSINo.length != 0) {
            NSLog(@"view selected field");
            [self getExistingBasic];
            [self toogleExistingField];
        } else {
            NSLog(@"create new");
        }
    } else {
        NSLog(@"SINo not exist!");
    }
}

-(void)toggleSegment
{
    if (ageClient > 50 && ageClient <=65)
    {
        UISegmentedControl *segName = [[UISegmentedControl alloc] init];
        
        if (newSegment) {
            NSArray *buttons = [NSArray arrayWithObjects:@"75", @"No", nil];
            segName = [[UISegmentedControl alloc] initWithItems:buttons];
            [self setAdvanceIncomeSegment:segName];
            segName.frame = CGRectMake(342, 363, 287, 44);
            segName.segmentedControlStyle = UISegmentedControlStylePlain;
            segName.momentary = NO;
            segName.selectedSegmentIndex = 1;
            segName.tag = 2001;
            [segName addTarget:self action:@selector(otherAdvancePressed:)
              forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:segName];
            NSLog(@"segment default");
        }
        else {
            NSArray *buttons = [NSArray arrayWithObjects:@"75", @"No", nil];
            segName = [[UISegmentedControl alloc] initWithItems:buttons];
            [self setAdvanceIncomeSegment:segName];
            segName.frame = CGRectMake(342, 363-45, 287, 44);
            segName.segmentedControlStyle = UISegmentedControlStylePlain;
            segName.momentary = NO;
            if (advanceYearlyIncome == 75) {
                segName.selectedSegmentIndex = 0;
            } else if (advanceYearlyIncome == 0) {
                segName.selectedSegmentIndex = 1;
            }
            [segName addTarget:self action:@selector(otherAdvancePressed:)
              forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:segName];
            NSLog(@"segment keyboard");
        }
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    newSegment = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 704-264);
    self.myScrollView.contentSize = CGSizeMake(1024, 704);
    
    newSegment = NO;
    [[self.view viewWithTag:2001] removeFromSuperview];
    [self toggleSegment];
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    minSALabel.text = @"";
    maxSALabel.text = @"";
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 704);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
        
        case 1:
            minSALabel.text = [NSString stringWithFormat:@"Min: %d",minSA];
            maxSALabel.text = [NSString stringWithFormat:@"Max: %d",maxSA];
            break;
            
        default:
            minSALabel.text = @"";
            maxSALabel.text = @"";
            break;
    }
    activeField = textField;
    return YES;
}


#pragma mark - Action

- (IBAction)btnPlanPressed:(id)sender
{    
    if(![popoverController isPopoverVisible]){
        
		PlanList *popView = [[PlanList alloc] init];
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
		
		[popoverController setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
        [popoverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popoverController dismissPopoverAnimated:YES];
	}
}

- (IBAction)btnShowHealthLoadingPressed:(id)sender
{
    if (showHL) {
        [self.btnHealthLoading setTitle:@"Show" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            healthLoadingView.alpha = 0;
        }];
        showHL = NO;
    }
    else {
        
        [self.btnHealthLoading setTitle:@"Hide" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 animations:^{
            healthLoadingView.alpha = 1;
        }];
        showHL = YES;
    }
}

- (IBAction)MOPSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([MOPSegment selectedSegmentIndex]==0) {
        MOP = 6;
    }
    else if (MOPSegment.selectedSegmentIndex == 1){
        MOP = 9;
    }
    else if (MOPSegment.selectedSegmentIndex == 2) {
        MOP = 12;
    }
}

- (IBAction)incomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (incomeSegment.selectedSegmentIndex == 0) {
        yearlyIncome = @"ACC";
    }
    else if (incomeSegment.selectedSegmentIndex == 1) {
        yearlyIncome = @"POF";
    }
}

- (IBAction)advanceIncomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (advanceIncomeSegment.selectedSegmentIndex == 0) {
        advanceYearlyIncome = 60;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 1) {
        advanceYearlyIncome = 75;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 2) {
        advanceYearlyIncome = 0;
    }
}

-(void)otherAdvancePressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (advanceIncomeSegment.selectedSegmentIndex == 0) {
        advanceYearlyIncome = 75;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 1) {
        advanceYearlyIncome = 0;
    }
    NSLog(@"value:%d",advanceYearlyIncome);
}

- (IBAction)cashDividendSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (cashDividendSegment.selectedSegmentIndex == 0) {
        cashDividend = @"ACC";
    } else if (cashDividendSegment.selectedSegmentIndex == 1) {
        cashDividend = @"POF";
    }
}

- (IBAction)goBack:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (dataInsert.count != 0) {
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            BasicPlanHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainH = basicH;
            main.mainBH = ss;
            main.IndexTab = 3;
            main.showQuotation = @"NO";
            [self presentViewController:main animated:YES completion:nil];
        }
    } else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.mainH = basicH;
        main.IndexTab = 3;
        [self presentViewController:main animated:YES completion:nil];
    }
}

- (IBAction)doSavePlan:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
//    NSString *SAInput = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    if (requestSINo.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1001];
        [alert show];
    }
    else if (yearlyIncomeField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Desired Yearly Income is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([yearlyIncomeField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Desired Yearly Income must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        yearlyIncomeField.text = @"";
    }
    else if ([yearlyIncomeField.text intValue] < minSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Desired Yearly Income must be greater than or equal to %d",minSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([yearlyIncomeField.text intValue] > maxSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Desired Yearly Income must be less than or equal to %d",maxSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (!(MOP)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select Premium Payment option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (yearlyIncome.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select Yearly Income Option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (cashDividend.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select Cash Dividend option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) cannot greater than 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLField.text intValue] > 0 && HLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLTermField.text intValue] > 0 && HLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([tempHLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (Per 1k SA) cannot greater than 10000" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([tempHLField.text intValue] > 0 && tempHLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([tempHLTermField.text intValue] > 0 && tempHLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLTermField.text intValue] > termCover) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([tempHLTermField.text intValue] > termCover) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Temporary Health Loading (per 1k SA) Term cannot be greater thann %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([HLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) into Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([tempHLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([tempHLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        
        float num = [yearlyIncomeField.text floatValue];
        int basicSumA = num;
        float basicFraction = num - basicSumA;
        NSString *msg = [formatter stringFromNumber:[NSNumber numberWithFloat:basicFraction]];
        
        float numHL = [HLField.text floatValue];
        int HLValue = numHL;
        float HLFraction = numHL - HLValue;
        NSString *msg2 = [formatter stringFromNumber:[NSNumber numberWithFloat:HLFraction]];
        
        float numTempHL = [tempHLField.text floatValue];
        int tempHLValue = numTempHL;
        float tempHLFraction = numTempHL - tempHLValue;
        NSString *msg3 = [formatter stringFromNumber:[NSNumber numberWithFloat:tempHLFraction]];
        
        if (msg.length > 4) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Desired Yearly Income only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else if (msg2.length > 4) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else if (msg3.length > 4) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else if ((MOP == 9 && basicSumA < 1000 && ageClient >= 66 && ageClient <= 70)||
            (MOP == 9 && basicSumA >= 1000 && ageClient >= 68 && ageClient <= 70)||
            (MOP == 12 && basicSumA < 1000 && ageClient >= 59 && ageClient <= 70)||
            (MOP == 12 && basicSumA >= 1000 && ageClient >= 61 && ageClient <= 70))
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please note that the Guaranteed Benefit payout for selected plan maybe lesser than total premium outlay.\nChoose OK to proceed.\nChoose CANCEL to select other plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
            [alert setTag:1002];
            [alert show];
            
        } else {
            
            NSString *msg;
            [self checkingExisting];
            if (useExist) {
                msg = @"Confirm changes?";
            } else {
                msg = @"Confirm creating new record?";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
            [alert setTag:1003];
            [alert show];
        }
    }
}

-(void)checkingSave
{
    if (useExist) {
        NSLog(@"will update");
        [self updateBasicPlan];
    } else {
        NSLog(@"will save");
        [self saveBasicPlan];
    }
}

-(void)closeScreen
{
    if (dataInsert.count != 0) {
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            BasicPlanHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainH = basicH;
            main.mainBH = ss;
            main.IndexTab = 3;
            main.showQuotation = @"NO";
            [self presentViewController:main animated:YES completion:nil];
        }
    } else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.mainH = basicH;
        main.IndexTab = 3;
        [self presentViewController:main animated:YES completion:nil];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 && buttonIndex == 0) {
        
        NewLAViewController *NewLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
        MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        MainScreenPage.IndexTab = 3;
        NewLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
//        NewLAPage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:MainScreenPage animated:YES completion:^(){
            [MainScreenPage presentModalViewController:NewLAPage animated:NO];
//            MainScreenPage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            NewLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
            
        }];
    }
    else if (alertView.tag==1002 && buttonIndex == 0) {
        [self checkingSave];
    }
    else if (alertView.tag==1003 && buttonIndex == 0) {
        [self checkingSave];
    }
    else if (alertView.tag==1004 && buttonIndex == 0) {
        [self closeScreen];
    }
    else if (alertView.tag==1005 && buttonIndex == 0) {
        [self closeScreen];
    }
    
}


#pragma mark - Toogle view

-(void)toogleExistingField
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:getSumAssured]];
    sumAss = [sumAss stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    yearlyIncomeField.text = [[NSString alloc] initWithFormat:@"%@",sumAss];
    if (MOP == 6) {
        MOPSegment.selectedSegmentIndex = 0;
    } else if (MOP == 9) {
        MOPSegment.selectedSegmentIndex = 1;
    } else if (MOP == 12) {
        MOPSegment.selectedSegmentIndex = 2;
    }
    
    if ([yearlyIncome isEqualToString:@"ACC"]) {
        incomeSegment.selectedSegmentIndex = 0;
    } else if ([yearlyIncome isEqualToString:@"POF"]) {
        incomeSegment.selectedSegmentIndex = 1;
    }
    
    if ([cashDividend isEqualToString:@"ACC"]) {
        cashDividendSegment.selectedSegmentIndex = 0;
    } else if ([cashDividend isEqualToString:@"POF"]) {
        cashDividendSegment.selectedSegmentIndex = 1;
    }
    
    if (ageClient > 50 && ageClient <=65) {
        if (advanceYearlyIncome == 75) {
            advanceIncomeSegment.selectedSegmentIndex = 0;
        } else if (advanceYearlyIncome == 0) {
            advanceIncomeSegment.selectedSegmentIndex = 1;
        }
    } else {
        if (advanceYearlyIncome == 60) {
            advanceIncomeSegment.selectedSegmentIndex = 0;
        } else if (advanceYearlyIncome == 75) {
            advanceIncomeSegment.selectedSegmentIndex = 1;
        } else if (advanceYearlyIncome == 0) {
            advanceIncomeSegment.selectedSegmentIndex = 2;
        }
    }
    
    if (getHL.length != 0) {
        HLField.text = getHL;
    }
    
    if (getHLTerm != 0) {
        HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];
    }
    
    if (getTempHL.length != 0) {
        tempHLField.text = getTempHL;
    }
    
    if (getTempHLTerm != 0) {
        tempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];
    }
    [self getPlanCodePenta];
    
    dataInsert = [[NSMutableArray alloc] init];
    BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
    [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:getSINo andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode]];
    for (NSUInteger i=0; i< dataInsert.count; i++) {
        ss = [dataInsert objectAtIndex:i];
        NSLog(@"storedbasic:%@",ss.storedSINo);
    }
}


#pragma mark - Handle DB

-(void) getTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,MinTerm,MaxTerm,MinSA,MaxSA FROM Trad_Sys_Mtn WHERE PlanCode=\"%@\"",planChoose];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int minAge =  sqlite3_column_int(statement, 0);
                int maxAge =  sqlite3_column_int(statement, 1);
                int maxTerm  =  sqlite3_column_int(statement, 3);
                minSA = sqlite3_column_int(statement, 4);
                maxSA = sqlite3_column_int(statement, 5);
                
                termCover = maxTerm - ageClient;
                termField.text = [[NSString alloc] initWithFormat:@"%d",termCover];
                
                if (ageClient < minAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Age Last Birthday must be greater than or equal to %d for this product.",minAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                } else if (ageClient > maxAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to %d for this product.",maxAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                }
            } else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (getSINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)getExistingBasic
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT SINo,PolicyTerm,BasicSA,PremiumPaymentOption,CashDividend,YearlyIncome,AdvanceYearlyIncome,HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",SINoPlan];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getPolicyTerm = sqlite3_column_int(statement, 1);
                getSumAssured = sqlite3_column_double(statement, 2);
                MOP = sqlite3_column_int(statement, 3);
                cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                advanceYearlyIncome = sqlite3_column_int(statement, 6);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 7);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 8);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 9);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 10);
                
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveBasicPlan
{
    /*
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    */
    
//    NSString *SAInput = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
        @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm, CreatedAt,UpdatedAt) VALUES (\"%@\", \"HLAIB\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", %@ , %@)", SINoPlan,  termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome, advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")"];
//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
                [self getPlanCodePenta];
                
                dataInsert = [[NSMutableArray alloc] init];
                BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINoPlan andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode]];
                for (NSUInteger i=0; i< dataInsert.count; i++) {
                    ss = [dataInsert objectAtIndex:i];
                    NSLog(@"storedbasic:%@",ss.storedSINo);
                }
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert setTag:1004];
                [SuccessAlert show];
                
            } else {
                NSLog(@"Failed Save basicPlan!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateBasicPlan
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
//    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
//    NSString *SAInput = [yearlyIncomeField.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET PolicyTerm=\"%@\", BasicSA=\"%@\", PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", UpdatedAt=%@ WHERE SINo=\"%@\"",termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")", SINoPlan];
        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                [self getPlanCodePenta];
                
                dataInsert = [[NSMutableArray alloc] init];
                BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINoPlan andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode]];
                for (NSUInteger i=0; i< dataInsert.count; i++) {
                    ss = [dataInsert objectAtIndex:i];
                    NSLog(@"storedbasic:%@",ss.storedSINo);
                }
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert setTag:1005];
                [SuccessAlert show];
                
            } else {
                NSLog(@"BasicPlan update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPlanCodePenta
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"HLAIB\" AND PremPayOpt=\"%d\"",MOP];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access PentaPlanCode");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - delegate

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc
{
    planChoose = [[NSString alloc] initWithFormat:@"%@",aaCode];
    [self.btnPlan setTitle:aaDesc forState:UIControlStateNormal];
    
    [popoverController dismissPopoverAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString     = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2 )
    {
        return NO;
    }
    
    return YES;
}

#pragma mark - Memory Management
- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setSINoPlan:nil];
    [self setGetSINo:nil];
    [self setTermField:nil];
    [self setYearlyIncomeField:nil];
    [self setMinSALabel:nil];
    [self setMaxSALabel:nil];
    [self setBtnHealthLoading:nil];
    [self setHealthLoadingView:nil];
    [self setRequestSINo:nil];
    [self setMOPSegment:nil];
    [self setIncomeSegment:nil];
    [self setAdvanceIncomeSegment:nil];
    [self setYearlyIncome:nil];
    [self setHLField:nil];
    [self setPlanChoose:nil];
    [self setCashDividendSegment:nil];
    [self setCashDividend:nil];
    [self setHLTermField:nil];
    [self setTempHLField:nil];
    [self setTempHLTermField:nil];
    [self setGetHL:nil];
    [self setGetTempHL:nil];
    [self setPlanCode:nil];
    [self setRequestOccpCode:nil];
    [self setMyScrollView:nil];
    [self setBtnPlan:nil];
    [super viewDidUnload];
}

@end
