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
#import "AppDelegate.h"


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
@synthesize ageClient,requestSINo,termCover,planChoose,maxSA,minSA;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,cashDividend;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize planCode,requestOccpCode,basicH,dataInsert,basicBH,basicPH,basicLa2ndH;
@synthesize popoverController,SINo,LACustCode,PYCustCode,SIDate,SILastNo,CustDate,CustLastNo;
@synthesize NamePP,DOBPP,OccpCodePP,GenderPP,secondLACustCode,IndexNo,PayorIndexNo,secondLAIndexNo;
@synthesize delegate = _delegate;
@synthesize requestAge,OccpCode,requestIDPay,requestIDProf,idPay,idProf;
@synthesize requestAgePay,requestDOBPay,requestIndexPay,requestOccpPay,requestSexPay,requestSmokerPay;
@synthesize PayorAge,PayorDOB,PayorOccpCode,PayorSex,PayorSmoker;
@synthesize requestAge2ndLA,requestDOB2ndLA,requestIndex2ndLA,requestOccp2ndLA,requestSex2ndLA,requestSmoker2ndLA;
@synthesize secondLAAge,secondLADOB,secondLAOccpCode,secondLASex,secondLASmoker;

#pragma mark - Cycle View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ageClient = requestAge;
    OccpCode = [self.requestOccpCode description];
    idPay = requestIDPay;
    idProf = requestIDProf;
    
    PayorIndexNo = requestIndexPay;
    PayorSmoker = [self.requestSmokerPay description];
    PayorSex = [self.requestSexPay description];
    PayorDOB = [self.requestDOBPay description];
    PayorAge = requestAgePay;
    PayorOccpCode = [self.requestOccpPay description];
    
    secondLAIndexNo = requestIndex2ndLA;
    secondLASmoker = [self.requestSmoker2ndLA description];
    secondLASex = [self.requestSex2ndLA description];
    secondLADOB = [self.requestDOB2ndLA description];
    secondLAAge = requestAge2ndLA;
    secondLAOccpCode = [self.requestOccp2ndLA description];
    
    SINo = [self.requestSINo description];
    NSLog(@"BASIC-SINo:%@, age:%d, job:%@",SINo,ageClient,OccpCode);
    NSLog(@"BASIC-idPayor:%d, idProfile:%d",idPay,idProf);
    
    if (!planList) {
        planList = [[PlanList alloc] init];
        planList.delegate = self;
    }
    planChoose = [[NSString alloc] initWithFormat:@"%@",planList.selectedCode];
    [self.btnPlan setTitle:planList.selectedDesc forState:UIControlStateNormal];
    
    if (ageClient > 65) {
        advanceIncomeSegment.enabled = NO;
    }
    
    if (ageClient > 50 && ageClient <=65)
    {
        [advanceIncomeSegment setEnabled:NO forSegmentAtIndex:0];
    }
    
    healthLoadingView.alpha = 0;
    showHL = NO;
    useExist = NO;
    termField.enabled = NO;
    [self getTermRule];
    
    if (self.requestSINo) {
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
    
    if (PayorIndexNo != 0) {
        NSLog(@"exist payor! Age:%d",PayorAge);
        IndexNo = PayorIndexNo;
        [self getProspectData];
    }
    
    if (secondLAIndexNo != 0) {
        NSLog(@"exist secondLA!");
        IndexNo = secondLAIndexNo;
        [self getProspectData];
        NSLog(@"2ndLAAge:%d",secondLAAge);
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
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 704-264);
    self.myScrollView.contentSize = CGSizeMake(1024, 704);
    
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

- (IBAction)doSavePlan:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSRange rangeofDotSUM = [yearlyIncomeField.text rangeOfString:@"."];
    NSString *substringSUM = @"";
    NSRange rangeofDotHL = [HLField.text rangeOfString:@"."];
    NSString *substringHL = @"";
    NSRange rangeofDotTempHL = [tempHLField.text rangeOfString:@"."];
    NSString *substringTempHL = @"";
    
    if (rangeofDotSUM.location != NSNotFound) {
        substringSUM = [yearlyIncomeField.text substringFromIndex:rangeofDotSUM.location ];
    }
    if (rangeofDotHL.location != NSNotFound) {
        substringHL = [HLField.text substringFromIndex:rangeofDotHL.location ];
    }
    if (rangeofDotTempHL.location != NSNotFound) {
        substringTempHL = [tempHLField.text substringFromIndex:rangeofDotTempHL.location ];
    }
    
    if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1001];
        [alert show];
    }
    else if (yearlyIncomeField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Desired Yearly Income is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    }
    else if (substringSUM.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Desired Yearly Income only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    }
    else if ([yearlyIncomeField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Desired Yearly Income must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        yearlyIncomeField.text = @"";
        [yearlyIncomeField becomeFirstResponder];
    }
    else if ([yearlyIncomeField.text intValue] < minSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Desired Yearly Income must be greater than or equal to %d",minSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
    }
    else if ([yearlyIncomeField.text intValue] > maxSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Desired Yearly Income must be less than or equal to %d",maxSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [yearlyIncomeField becomeFirstResponder];
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
    else if ([HLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if (substringHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) cannot greater than 10000." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLField.text intValue] > 0 && HLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] > 0 && HLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLField becomeFirstResponder];
    }
    else if ([HLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) into Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([HLTermField.text intValue] > termCover) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be greater than %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [HLTermField becomeFirstResponder];
    }
    else if ([tempHLField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if (substringTempHL.length > 3) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (Per 1k SA) only allow 2 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if ([tempHLTermField.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Temporary Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if ([tempHLField.text intValue] >= 10000) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (Per 1k SA) cannot greater than 10000" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if ([tempHLField.text intValue] > 0 && tempHLTermField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLTermField becomeFirstResponder];
    }
    else if ([tempHLTermField.text intValue] > 0 && tempHLField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Temporary Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLField becomeFirstResponder];
    }
    else if ([tempHLTermField.text intValue] > termCover) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Temporary Health Loading (per 1k SA) Term cannot be greater than %d",termCover] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [tempHLTermField becomeFirstResponder];
    }
    else {
        
        float num = [yearlyIncomeField.text floatValue];
        int basicSumA = num;
        
        if ((MOP == 9 && basicSumA < 1000 && ageClient >= 66 && ageClient <= 70)||
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

/*
-(void)closeScreen
{
    if (dataInsert.count != 0) {
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            BasicPlanHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainLaH = basicH;
            main.mainBH = ss;
            main.mainPH = basicPH;
            main.IndexTab = 3;
            main.showQuotation = @"NO";
            [self presentViewController:main animated:YES completion:nil];
        }
    } else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.mainLaH = basicH;
        main.IndexTab = 3;
        [self presentViewController:main animated:YES completion:nil];
    }
}
*/

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
//        [self closeScreen];
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
    
    if (advanceYearlyIncome == 60) {
        advanceIncomeSegment.selectedSegmentIndex = 0;
    } else if (advanceYearlyIncome == 75) {
        advanceIncomeSegment.selectedSegmentIndex = 1;
    } else if (advanceYearlyIncome == 0) {
        advanceIncomeSegment.selectedSegmentIndex = 2;
    }
    
    if (getHL.length != 0) {
        //HLField.text = getHL;
        NSRange rangeofDot = [getHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getHL substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getHL;
            }
        }
        else {
            valueToDisplay = getHL;
        }
        HLField.text = valueToDisplay;
    }
    
    if (getHLTerm != 0) {
        HLTermField.text = [NSString stringWithFormat:@"%d",getHLTerm];

    }
    
    if (getTempHL.length != 0) {
        //tempHLField.text = getTempHL;
        NSRange rangeofDot = [getTempHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getTempHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getTempHL substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getTempHL;
            }
        }
        else {
            valueToDisplay = getTempHL;
        }
        tempHLField.text = valueToDisplay;
    }
    
    if (getTempHLTerm != 0) {
        tempHLTermField.text = [NSString stringWithFormat:@"%d",getTempHLTerm];

    }
    [self getPlanCodePenta];
    
    /*
    dataInsert = [[NSMutableArray alloc] init];
    BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
    [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:getSINo andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome]];
    for (NSUInteger i=0; i< dataInsert.count; i++) {
        ss = [dataInsert objectAtIndex:i];
        NSLog(@"storedbasic:%@",ss.storedSINo);
    } */
    
    [_delegate BasicSI:getSINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome];
     
}


#pragma mark - Handle DB

-(void)getRunningSI
{
    sqlite3_stmt *statement;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"SI\" AND LastUpdated like \"%%%@%%\"", dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SILastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                SIDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastSINo:%d SIDate:%@",SILastNo,SIDate);
                
            } else {
                SILastNo = 0;
                SIDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [self updateFirstRunSI];
}

-(void)getRunningCustCode
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\" AND LastUpdated like \"%%%@%%\" ",dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustLastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                CustDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastCustNo:%d CustDate:%@",CustLastNo,CustDate);
                
            } else {
                CustLastNo = 0;
                CustDate = dateString;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    [self updateFirstRunCust];
}

-(void)updateFirstRunSI
{
    int newLastNo;
    newLastNo = SILastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated=\"%@\" WHERE TrnTypeCode=\"SI\"",newLastNo, dateString];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run SI update!");
                
            } else {
                NSLog(@"Run SI update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run Cust update!");
                
            } else {
                NSLog(@"Run Cust update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",SINo];
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
                @"SELECT SINo,PolicyTerm,BasicSA,PremiumPaymentOption,CashDividend,YearlyIncome,AdvanceYearlyIncome,HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",SINo];
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
    [self getRunningSI];
    [self getRunningCustCode];
    
    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoSI = SILastNo + 1;
    int runningNoCust = CustLastNo + 1;
    
    NSString *fooSI = [NSString stringWithFormat:@"%04d", runningNoSI];
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    SINo = [[NSString alloc] initWithFormat:@"SI%@-%@",currentdate,fooSI];
    LACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    NSLog(@"SINo:%@, CustCode:%@",SINo,LACustCode);
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
        @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm, CreatedAt,UpdatedAt) VALUES (\"%@\", \"HLAIB\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", %@ , %@)", SINo,  termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome, advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")"];

//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
                [self updateLA];
                
                [self getPlanCodePenta];
                
                /*
                dataInsert = [[NSMutableArray alloc] init];
                BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINo andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome]];
                for (NSUInteger i=0; i< dataInsert.count; i++) {
                    ss = [dataInsert objectAtIndex:i];
                    NSLog(@"storedbasic:%@",ss.storedSINo);
                } */
                
                if (PayorIndexNo != 0) {
                    [self savePayor];
                }
                
                if (secondLAIndexNo != 0) {
                    [self saveSecondLA];
                }
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [SuccessAlert setTag:1004];
                [SuccessAlert show];
                
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome];
                
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

-(void)savePayor
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    
    PYCustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"PY\",\"1\",\"%@\",\"hla\")",SINo, PYCustCode,dateStr];
        
//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        int ANB =PayorAge + 1;
        NSString *insertSQL2 = [NSString stringWithFormat:
                                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")", PYCustCode, NamePP, PayorSmoker, PayorSex, PayorDOB, PayorAge, ANB, PayorOccpCode, dateStr,PayorIndexNo];
    
//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                
            } else {
                NSLog(@"Failed LA2");
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)saveSecondLA
{
    [self getRunningCustCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];

    secondLACustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",SINo, secondLACustCode,dateStr];
        
//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        int ANB = secondLAAge + 1;
        NSString *insertSQL2 = [NSString stringWithFormat:
                    @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")", secondLACustCode, NamePP, secondLASmoker, secondLASex, secondLADOB, secondLAAge, ANB, secondLAOccpCode, dateStr,secondLAIndexNo];
        
//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                
            } else {
                NSLog(@"Failed LA2");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateLA
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Clt_Profile SET CustCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" WHERE id=\"%d\"",LACustCode,currentdate,idProf];
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE){
                //save
            }
            else {
                //failed
            }
            sqlite3_finalize(statement);
        }
        
        NSString *querySQL2 = [NSString stringWithFormat:
                @"UPDATE Trad_LAPayor SET SINo=\"%@\", CustCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" WHERE rowid=\"%d\"",SINo,LACustCode,currentdate,idPay];
        
//        NSLog(@"%@",querySQL2);
        if (sqlite3_prepare_v2(contactDB, [querySQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE){
                //save
            }
            else {
                //failed
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

-(void)updateBasicPlan
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET PolicyTerm=\"%@\", BasicSA=\"%@\", PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", UpdatedAt=%@ WHERE SINo=\"%@\"",termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")", SINo];
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                [self getPlanCodePenta];
                
                /*
                dataInsert = [[NSMutableArray alloc] init];
                BasicPlanHandler *ss = [[BasicPlanHandler alloc] init];
                [dataInsert addObject:[[BasicPlanHandler alloc] initWithSI:SINo andAge:ageClient andOccpCode:requestOccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome]];
                for (NSUInteger i=0; i< dataInsert.count; i++) {
                    ss = [dataInsert objectAtIndex:i];
                    NSLog(@"storedbasic:%@",ss.storedSINo);
                } */
                
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome];
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//                [SuccessAlert setTag:1004];
                [SuccessAlert show];
                
            }
            else {
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

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                DOBPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                GenderPP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                OccpCodePP = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
            } else {
                NSLog(@"error access prospect_profile");
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
