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
@synthesize incomeSegment,cashDivSgmntCP;
@synthesize advanceIncomeSegment;
@synthesize cashDividendSegment;
@synthesize HLField;
@synthesize HLTermField;
@synthesize tempHLField;
@synthesize tempHLTermField;
@synthesize myScrollView,labelSix,labelSeven,labelFour,labelFive;
@synthesize ageClient,requestSINo,termCover,planChoose,maxSA,minSA;
@synthesize MOP,yearlyIncome,advanceYearlyIncome,basicRate,cashDividend;
@synthesize getSINo,getSumAssured,getPolicyTerm,getHL,getHLTerm,getTempHL,getTempHLTerm;
@synthesize planCode,requestOccpCode,basicH,dataInsert,basicBH,basicPH,basicLa2ndH;
@synthesize SINo,LACustCode,PYCustCode,SIDate,SILastNo,CustDate,CustLastNo;
@synthesize NamePP,DOBPP,OccpCodePP,GenderPP,secondLACustCode,IndexNo,PayorIndexNo,secondLAIndexNo;
@synthesize delegate = _delegate;
@synthesize requestAge,OccpCode,requestIDPay,requestIDProf,idPay,idProf;
@synthesize requestAgePay,requestDOBPay,requestIndexPay,requestOccpPay,requestSexPay,requestSmokerPay;
@synthesize PayorAge,PayorDOB,PayorOccpCode,PayorSex,PayorSmoker;
@synthesize requestAge2ndLA,requestDOB2ndLA,requestIndex2ndLA,requestOccp2ndLA,requestSex2ndLA,requestSmoker2ndLA;
@synthesize secondLAAge,secondLADOB,secondLAOccpCode,secondLASex,secondLASmoker;
@synthesize LRiderCode,LSumAssured,expAge,minSATerm,maxSATerm,minTerm,maxTerm,riderCode,_maxRiderSA,maxRiderSA,GYI;
@synthesize requestOccpClass,OccpClass,MOPHLAIB,MOPHLACP,yearlyIncomeHLAIB,cashDividendHLAIB,cashDividendHLACP;
@synthesize advanceYearlyIncomeHLAIB,advanceYearlyIncomeHLACP,maxAge,labelAddHL;
@synthesize planList = _planList;
@synthesize planPopover = _planPopover;
@synthesize labelParAcc,labelParPayout,labelPercent1,labelPercent2,parAccField,parPayoutField,getParAcc,getParPayout;

#pragma mark - Cycle View

id temp;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    self.healthLoadingView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //request LA details
    ageClient = requestAge;
    OccpCode = [self.requestOccpCode description];
    OccpClass = requestOccpClass;
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
    
    //--
    btnHealthLoading.hidden = YES;
    labelAddHL.hidden = YES;
    //--
    
    self.planList = [[PlanList alloc] init];
    _planList.delegate = self;
    planChoose = [[NSString alloc] initWithFormat:@"%@",self.planList.selectedCode];
    [self.btnPlan setTitle:self.planList.selectedDesc forState:UIControlStateNormal];
    temp = btnPlan.titleLabel.text;
    
    useExist = NO;
    termField.enabled = NO;
    healthLoadingView.alpha = 0;
    showHL = NO;
    [self tooglePlan];
    
    if (self.requestSINo) {
        [self checkingExisting];
        if (getSINo.length != 0) {
            NSLog(@"view selected field");
            [self getExistingBasic];
            if ([planChoose isEqualToString:@"HLACP"]) {
                [self.btnPlan setTitle:@"HLA Cash Promise" forState:UIControlStateNormal];
                temp = btnPlan.titleLabel.text;
            }
            [self tooglePlan];
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
    
    _planList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
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
    self.myScrollView.frame = CGRectMake(0, 44, 768, 960-264);
    self.myScrollView.contentSize = CGSizeMake(768, 960);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    minSALabel.text = @"";
    maxSALabel.text = @"";
    /*
    if (parAccField.text.length != 0||parPayoutField.text.length != 0) {
        
        NSRange rangeofDot = [parAccField.text rangeOfString:@"."];
        NSString *substring = @"";
        if (rangeofDot.location != NSNotFound) {
            substring = [parAccField.text substringFromIndex:rangeofDot.location ];
        }
        
        NSRange rangeofDot2 = [parPayoutField.text rangeOfString:@"."];
        NSString *substring2 = @"";
        if (rangeofDot2.location != NSNotFound) {
            substring2 = [parPayoutField.text substringFromIndex:rangeofDot2.location ];
        }
        
        int maxInc = 100;
        int totalInc = 0;
        int parAcc = 0;
        int parPayout = 0;
        
        parAcc = [parAccField.text intValue];
        parPayout = [parPayoutField.text intValue];
        totalInc = parAcc + parPayout;
        
        if (totalInc > 100) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Total Yearly Income must equal to 100." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        else if (substring.length > 1||substring2.length > 1) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Yearly Income must not contains decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            if (parAccField.text.length != 0 && parPayoutField.text.length == 0 && parAcc <=100) {
                parPayout = maxInc - parAcc;
                parPayoutField.text = [NSString stringWithFormat:@"%d",parPayout];
            }
        
            if (parPayoutField.text.length != 0 && parAccField.text.length == 0 && parPayout <=100) {
                parAcc = maxInc - parPayout;
                parAccField.text = [NSString stringWithFormat:@"%d",parAcc];
            }
        }
    } */
    
    self.myScrollView.frame = CGRectMake(0, 44, 768, 960);
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString     = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    if ([arrayOfString count] > 2 )
    {
        return NO;
    }
    
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
        return NO;
    }
    
    if ([textField isEqual:parAccField]) {
        
        int maxInc = 100;
        int parAcc = 0;
        int parPayout = 0;
        NSString *strAcc = [parAccField.text stringByReplacingCharactersInRange:range withString:string];
        
        parAcc = [strAcc intValue];
        parPayout = maxInc - parAcc;
        
        if (parAcc > 100) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Total Yearly Income must equal to 100." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            //parPayoutField.text = @"0";
        }
        else {
            //parPayoutField.text = [NSString stringWithFormat:@"%d",parPayout];
        }
    }
    
    if ([textField isEqual:parPayoutField]) {
        int maxInc = 100;
        int parAcc = 0;
        int parPayout = 0;
        NSString *strPayout = [parPayoutField.text stringByReplacingCharactersInRange:range withString:string];
        
        parPayout = [strPayout intValue];
        parAcc = maxInc - parPayout;
        
        if (parPayout > 100) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Total Yearly Income must equal to 100." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            //parAccField.text = @"0";
        }
        else {
            //parAccField.text = [NSString stringWithFormat:@"%d",parAcc];
        }
    }
    
    return YES;
}

#pragma mark - Action

- (IBAction)btnPlanPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        _planList.delegate = self;
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }
        
    [self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)MOPSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([MOPSegment selectedSegmentIndex]==0) {
        MOPHLAIB = 6;
    }
    else if (MOPSegment.selectedSegmentIndex == 1){
        MOPHLAIB = 9;
    }
    else if (MOPSegment.selectedSegmentIndex == 2) {
        MOPHLAIB = 12;
    }
    NSLog(@"MOP:%d",MOPHLAIB);
}

- (IBAction)incomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (incomeSegment.selectedSegmentIndex == 0) {
        yearlyIncomeHLAIB = @"ACC";
    }
    else if (incomeSegment.selectedSegmentIndex == 1) {
        yearlyIncomeHLAIB = @"POF";
    }
    NSLog(@"yearlyIncome:%@",yearlyIncomeHLAIB);
}

- (IBAction)cashDividendSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (cashDividendSegment.selectedSegmentIndex == 0) {
        cashDividendHLAIB = @"ACC";
    }
    else if (cashDividendSegment.selectedSegmentIndex == 1) {
        cashDividendHLAIB = @"POF";
    }
    NSLog(@"cashDiv:%@",cashDividendHLAIB);
}

- (IBAction)advanceIncomeSegmentPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (advanceIncomeSegment.selectedSegmentIndex == 0) {
        advanceYearlyIncomeHLAIB = 60;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 1) {
        advanceYearlyIncomeHLAIB = 75;
    }
    else if (advanceIncomeSegment.selectedSegmentIndex == 2) {
        advanceYearlyIncomeHLAIB = 0;
    }
    NSLog(@"advance:%d",advanceYearlyIncomeHLAIB);
}

- (IBAction)cashDivSgmntCPPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (cashDivSgmntCP.selectedSegmentIndex == 0) {
        cashDividendHLACP = @"ACC";
    }
    else if (cashDivSgmntCP.selectedSegmentIndex == 1) {
        cashDividendHLACP = @"POF";
    }
    NSLog(@"cashDivCP:%@",cashDividendHLACP);
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
    NSRange rangeofDotAcc = [parAccField.text rangeOfString:@"."];
    NSString *substringAcc = @"";
    NSRange rangeofDotPayout = [parPayoutField.text rangeOfString:@"."];
    NSString *substringPayout = @"";
    
    if (rangeofDotSUM.location != NSNotFound) {
        substringSUM = [yearlyIncomeField.text substringFromIndex:rangeofDotSUM.location ];
    }
    if (rangeofDotHL.location != NSNotFound) {
        substringHL = [HLField.text substringFromIndex:rangeofDotHL.location ];
    }
    if (rangeofDotTempHL.location != NSNotFound) {
        substringTempHL = [tempHLField.text substringFromIndex:rangeofDotTempHL.location ];
    }
    if (rangeofDotAcc.location != NSNotFound) {
        substringAcc = [parAccField.text substringFromIndex:rangeofDotAcc.location ];
    }
    if (rangeofDotPayout.location != NSNotFound) {
        substringPayout = [parPayoutField.text substringFromIndex:rangeofDotPayout.location ];
    }
    
    int maxParIncome = 0;
    if ([planChoose isEqualToString:@"HLAIB"]) {
        MOP = MOPHLAIB;
        yearlyIncome = yearlyIncomeHLAIB;
        cashDividend = cashDividendHLAIB;
        advanceYearlyIncome = advanceYearlyIncomeHLAIB;
    }
    else {
        MOP = MOPHLACP;
        cashDividend = cashDividendHLACP;
        advanceYearlyIncome = advanceYearlyIncomeHLACP;
        
        maxParIncome = [parAccField.text intValue] + [parPayoutField.text intValue];
        if ([parAccField.text intValue] == 0) {
            yearlyIncome = @"POF";
        }
        else {
            yearlyIncome = @"ACC";
        }
        
        if ([parAccField.text intValue] == 100) {
            parPayoutField.text = @"0";
        }
        if ([parPayoutField.text intValue] == 100) {
            parAccField.text = @"0";
        }
    }
    NSLog(@"MOP:%d, yearlyIncome:%@, cashDividend:%@, advanceYearlyIncome:%d",MOP,yearlyIncome,cashDividend,advanceYearlyIncome);
    
    if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1001];
        [alert show];
    }
    else if (ageClient > maxAge) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to %d for this product.",maxAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
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
    
    //----------
    else if ([planChoose isEqualToString:@"HLACP"] && parAccField.text.length==0 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please key in the Percentage of Total Yearly Income Option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:@"HLACP"] && parPayoutField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please key in the Percentage of Total Yearly Income Option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:@"HLACP"] && [parAccField.text intValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Percentage of Total Yearly Income Option must be 100%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:@"HLACP"] && [parPayoutField.text intValue] > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Percentage of Total Yearly Income Option must be 100%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:@"HLACP"] && substringAcc.length > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Yearly Income Option must not contains decimal places." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parAccField becomeFirstResponder];
    }
    else if ([planChoose isEqualToString:@"HLACP"] && substringPayout.length > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Yearly Income Option must not contains decimal places." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [parPayoutField becomeFirstResponder];
    }
    //--------------
    
    else if (cashDividend.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select Cash Dividend option." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    //-------HL
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) into Temporary Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
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
    //--end HL
	else if ([parAccField.text intValue] + [parPayoutField.text intValue] != 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Percentage of Total Yearly Income Option must be 100%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
    
    if ([planChoose isEqualToString:@"HLAIB"]) {
        
        MOPHLAIB = MOP;
        if (MOPHLAIB == 6) {
            MOPSegment.selectedSegmentIndex = 0;
        }
        else if (MOPHLAIB == 9) {
            MOPSegment.selectedSegmentIndex = 1;
        }
        else if (MOPHLAIB == 12) {
            MOPSegment.selectedSegmentIndex = 2;
        }
        
        yearlyIncomeHLAIB = yearlyIncome;
        if ([yearlyIncomeHLAIB isEqualToString:@"ACC"]) {
            incomeSegment.selectedSegmentIndex = 0;
        }
        else if ([yearlyIncomeHLAIB isEqualToString:@"POF"]) {
            incomeSegment.selectedSegmentIndex = 1;
        }
        
        cashDividendHLAIB = cashDividend;
        if ([cashDividendHLAIB isEqualToString:@"ACC"]) {
            cashDividendSegment.selectedSegmentIndex = 0;
        }
        else if ([cashDividendHLAIB isEqualToString:@"POF"]) {
            cashDividendSegment.selectedSegmentIndex = 1;
        }
        
        //--handle advance segment
        if (ageClient > 65) {
            if (advanceYearlyIncome != 0) {
                
                advanceYearlyIncome = 0;
                advanceIncomeSegment.selectedSegmentIndex = 2;
                sqlite3_stmt *statement;
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                {
                    NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET AdvanceYearlyIncome=\"%d\", UpdatedAt=%@ WHERE SINo=\"%@\"",advanceYearlyIncome,  @"datetime(\"now\", \"+8 hour\")", SINo];
                    
                    if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement) == SQLITE_DONE)
                        {
                            NSLog(@"BasicPlan update!");
                        }
                        else {
                            NSLog(@"BasicPlan update Failed!");
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(contactDB);
                }
            }
        }
        else if (ageClient > 50 && ageClient <=65)
        {
            if (advanceYearlyIncome == 60) {
                advanceYearlyIncome = 0;
                advanceIncomeSegment.selectedSegmentIndex = 2;
                
                sqlite3_stmt *statement;
                if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
                {
                    NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET AdvanceYearlyIncome=\"%d\", UpdatedAt=%@ WHERE SINo=\"%@\"",advanceYearlyIncome,  @"datetime(\"now\", \"+8 hour\")", SINo];
                    
                    if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                    {
                        if (sqlite3_step(statement) == SQLITE_DONE)
                        {
                            NSLog(@"BasicPlan update!");
                        }
                        else {
                            NSLog(@"BasicPlan update Failed!");
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(contactDB);
                }
            }
        }
        else {
            if (advanceYearlyIncome == 60) {
                advanceIncomeSegment.selectedSegmentIndex = 0;
            }
            else if (advanceYearlyIncome == 75) {
                advanceIncomeSegment.selectedSegmentIndex = 1;
            }
            else if (advanceYearlyIncome == 0) {
                advanceIncomeSegment.selectedSegmentIndex = 2;
            }
        }
        //--end--
    }
    else {
        
        parAccField.text = [NSString stringWithFormat:@"%d",getParAcc];
        parPayoutField.text = [NSString stringWithFormat:@"%d",getParPayout];
        
        cashDividendHLACP = cashDividend;
        if ([cashDividendHLACP isEqualToString:@"ACC"]) {
            cashDivSgmntCP.selectedSegmentIndex = 0;
        }
        else if ([cashDividendHLACP isEqualToString:@"POF"]) {
            cashDivSgmntCP.selectedSegmentIndex = 1;
        }
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
    
    [_delegate BasicSI:getSINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose];
}

-(void)tooglePlan
{
    NSLog(@"tooglePlan");
    [self getTermRule];
    
    if ([planChoose isEqualToString:@"HLAIB"]) {
        
        cashDivSgmntCP.hidden = YES;
        labelFour.text = @"Premium Payment Option* :";
        labelFive.text = @"Yearly Income* :";
        labelSix.text = @"Cash Dividend* :";
        labelSeven.text = @"Advance Yearly Income (Age) :";
        labelParAcc.hidden = YES;
        labelParPayout.hidden = YES;
        labelPercent1.hidden = YES;
        labelPercent2.hidden = YES;
        parPayoutField.hidden = YES;
        parAccField.hidden = YES;
        MOPSegment.hidden = NO;
        incomeSegment.hidden = NO;
        cashDividendSegment.hidden = NO;
        advanceIncomeSegment.hidden = NO;
        [MOPSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [incomeSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [cashDividendSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        if (ageClient > 65) {
            advanceIncomeSegment.enabled = NO;
        }
        
        if (ageClient > 50 && ageClient <=65)
        {
            [advanceIncomeSegment setEnabled:NO forSegmentAtIndex:0];
            [[advanceIncomeSegment.subviews objectAtIndex:0] setAlpha:0.5];
        }
    }
    else {
        
//        parPayoutField.enabled = NO;
        cashDivSgmntCP.hidden = NO;
        labelFour.text = @"Yearly Income* :";
        labelFive.text = @"Cash Dividend* :";
        labelSix.text = @"";
        labelSeven.text = @"";
        labelParAcc.hidden = NO;
        labelParPayout.hidden = NO;
        labelPercent1.hidden = NO;
        labelPercent2.hidden = NO;
        parPayoutField.hidden = NO;
        parAccField.hidden = NO;
        MOPSegment.hidden = YES;
        incomeSegment.hidden = YES;
        cashDividendSegment.hidden = YES;
        advanceIncomeSegment.hidden = YES;
        [cashDivSgmntCP setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        MOPHLACP = 6;
        advanceYearlyIncomeHLACP = 0;
    }
}

-(void)calculateSA
{
    double basicSA = [yearlyIncomeField.text doubleValue];
    double dblPseudoBSA = basicSA / 0.05;
    double dblPseudoBSA2 = dblPseudoBSA * 0.1;
    double dblPseudoBSA3 = dblPseudoBSA * 5;
    double dblPseudoBSA4 = dblPseudoBSA * 2;
    int MaxUnit = 0;
    //    NSLog(@"dblPseudoBSA:%.f, dblPseudoBSA3:%.f",maxRiderSA,dblPseudoBSA3);
    
    if ([riderCode isEqualToString:@"CCTR"])
    {
        _maxRiderSA = dblPseudoBSA3;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"ETPD"])
    {
        _maxRiderSA = fmin(dblPseudoBSA2,120000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"I20R"]||[riderCode isEqualToString:@"I30R"]||[riderCode isEqualToString:@"I40R"]||[riderCode isEqualToString:@"ID20R"]||[riderCode isEqualToString:@"ID30R"]||[riderCode isEqualToString:@"ID40R"]||[riderCode isEqualToString:@"IE20R"]||[riderCode isEqualToString:@"IE30R"])
    {
        NSLog(@"enter gyi");
        [self getGYI];
        double BasicSA_GYI = basicSA * GYI;
        _maxRiderSA = fmin(BasicSA_GYI,9999999);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"CPA"])
    {
        if (OccpClass == 1 || OccpClass == 2) {
            if (dblPseudoBSA < 100000) {
                _maxRiderSA = fmin(dblPseudoBSA3,200000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
            else if (dblPseudoBSA >= 100000) {
                _maxRiderSA = fmin(dblPseudoBSA4,1000000);
                NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
                maxRiderSA = [a_maxRiderSA doubleValue];
            }
        }
        else if (OccpClass == 3 || OccpClass == 4) {
            _maxRiderSA = fmin(dblPseudoBSA3,100000);
            NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
            maxRiderSA = [a_maxRiderSA doubleValue];
        }
    }
    else if ([riderCode isEqualToString:@"PA"]) {
        _maxRiderSA = fmin(dblPseudoBSA3,1000000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"PTR"]) {
        _maxRiderSA = fmin(dblPseudoBSA3,500000);
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    else if ([riderCode isEqualToString:@"HB"]) {
        if (dblPseudoBSA >= 10000 && dblPseudoBSA <= 25000) {
            MaxUnit = 4;
        }
        else if (dblPseudoBSA >= 25001 && dblPseudoBSA <= 50000) {
            MaxUnit = 6;
        }
        else if (dblPseudoBSA >= 50001 && dblPseudoBSA <= 75000) {
            MaxUnit = 8;
        }
        else if (dblPseudoBSA > 75000) {
            MaxUnit = 10;
        }
        else {
            MaxUnit = 0;
        }
        maxRiderSA = MaxUnit;
    }
    else {
        _maxRiderSA = maxSATerm;
        NSString *a_maxRiderSA = [NSString stringWithFormat:@"%.2f",_maxRiderSA];
        maxRiderSA = [a_maxRiderSA doubleValue];
    }
    //    NSLog(@"maxSA(%@):%.f",riderCode,maxRiderSA);
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
                maxAge =  sqlite3_column_int(statement, 1);
                int maxTermB  =  sqlite3_column_int(statement, 3);
                minSA = sqlite3_column_int(statement, 4);
                maxSA = sqlite3_column_int(statement, 5);
                
                if ([planChoose isEqualToString:@"HLAIB"]) {
                    termCover = maxTermB - ageClient;
                }
                else {
                    termCover = maxTermB;
                }
                termField.text = [[NSString alloc] initWithFormat:@"%d",termCover];
                
                
                if (ageClient < minAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Age Last Birthday must be greater than or equal to %d for this product.",minAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                } else if (ageClient > maxAge) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to %d for this product.",maxAge] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                    [alert show];
                }
            } else {
                NSLog(@"error access getTermRule");
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
                @"SELECT SINo, PlanCode, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome,HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm,PartialAcc,PartialPayout FROM Trad_Details WHERE SINo=\"%@\"",SINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                getPolicyTerm = sqlite3_column_int(statement, 2);
                getSumAssured = sqlite3_column_double(statement, 3);
                MOP = sqlite3_column_int(statement, 4);
                cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                advanceYearlyIncome = sqlite3_column_int(statement, 7);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 8);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 9);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 10);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 11);
                getParAcc = sqlite3_column_int(statement, 12);
                getParPayout = sqlite3_column_int(statement, 13);
//                NSLog(@"basicPlan:%@",planChoose);
                
            } else {
                NSLog(@"error access getExistingBasic");
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
        @"INSERT INTO Trad_Details (SINo,  PlanCode, PTypeCode, Seq, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm, CreatedAt,UpdatedAt,PartialAcc,PartialPayout) VALUES (\"%@\", \"%@\", \"LA\", \"1\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", \"%d\", \"%@\", \"%d\", \"%@\", \"%d\", %@ , %@,%d,%d)", SINo, planChoose, termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome, advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",@"datetime(\"now\", \"+8 hour\")",[parAccField.text intValue],[parPayoutField.text intValue]];

        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
                [self updateLA];
                
                [self getPlanCodePenta];
                
                if (PayorIndexNo != 0) {
                    [self savePayor];
                }
                
                if (secondLAIndexNo != 0) {
                    [self saveSecondLA];
                }
                
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose];
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.SICompleted = YES;
                
            }
            else {
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
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Trad_Details SET PolicyTerm=\"%@\", BasicSA=\"%@\", PremiumPaymentOption=\"%d\", CashDividend=\"%@\", YearlyIncome=\"%@\", AdvanceYearlyIncome=\"%d\", HL1KSA=\"%@\", HL1KSATerm=\"%d\", TempHL1KSA=\"%@\", TempHL1KSATerm=\"%d\", UpdatedAt=%@, PartialAcc=\"%d\", PartialPayout=\"%d\" WHERE SINo=\"%@\"",termField.text, yearlyIncomeField.text, MOP, cashDividend, yearlyIncome,advanceYearlyIncome, HLField.text, [HLTermField.text intValue], tempHLField.text, [tempHLTermField.text intValue], @"datetime(\"now\", \"+8 hour\")",[parAccField.text intValue],[parPayoutField.text intValue], SINo];
        
        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                [self getPlanCodePenta];
                
                [_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:yearlyIncomeField.text andBasicHL:HLField.text andBasicTempHL:tempHLField.text andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome andBasicPlan:planChoose];
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
    
    [self getListingRider];
    BOOL dodelete = NO;
    for (int p=0; p<LRiderCode.count; p++) {
        
        riderCode = [LRiderCode objectAtIndex:p];
        [self getRiderTermRule];
        [self calculateSA];
        double riderSA = [[LSumAssured objectAtIndex:p] doubleValue];
        if (riderSA > maxRiderSA)
        {
            dodelete = YES;
            sqlite3_stmt *statement;
            if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
            {
                NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",SINo,riderCode];
                
                if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_DONE)
                    {
                        NSLog(@"rider delete!");
                    } else {
                        NSLog(@"rider delete Failed!");
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(contactDB);
            }
        }
    }
    if (dodelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Some Rider(s) has been deleted due to marketing rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [_delegate RiderAdded];
    }
}

-(void)getPlanCodePenta
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = nil;
        if ([planChoose isEqualToString:@"HLAIB"]) {
            querySQL = [NSString stringWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"%@\" AND PremPayOpt=\"%d\"",planChoose, MOP];
        }
        else {
            querySQL = [NSString stringWithFormat:@"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"%@\"",planChoose];
        }
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access getPlanCodePenta");
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

-(void)getListingRider
{
    LRiderCode = [[NSMutableArray alloc] init];
    LSumAssured = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT RiderCode, SumAssured FROM Trad_Rider_Details WHERE SINo=\"%@\" ORDER by RiderCode asc",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                const char *aaRidCode = (const char *)sqlite3_column_text(statement, 0);
                [LRiderCode addObject:aaRidCode == NULL ? @"" : [[NSString alloc] initWithUTF8String:aaRidCode]];
                
                const char *aaRidSA = (const char *)sqlite3_column_text(statement, 1);
                [LSumAssured addObject:aaRidSA == NULL ? @"" :[[NSString alloc] initWithUTF8String:aaRidSA]];
            }
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getRiderTermRule
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT MinAge,MaxAge,ExpiryAge,MinTerm,MaxTerm,MinSA,MaxSA,MaxSAFactor FROM Trad_Sys_Rider_Mtn WHERE RiderCode=\"%@\"",riderCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                expAge =  sqlite3_column_int(statement, 2);
                minTerm =  sqlite3_column_int(statement, 3);
                maxTerm =  sqlite3_column_int(statement, 4);
                minSATerm = sqlite3_column_int(statement, 5);
                maxSATerm = sqlite3_column_int(statement, 6);
                NSLog(@"expiryAge(%@):%d,minTerm:%d,maxTerm:%d,minSA:%d,maxSA:%d",riderCode,expAge,minTerm,maxTerm,minSATerm,maxSATerm);
                
            } else {
                NSLog(@"error access getRiderTermRule");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getGYI
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL;
        if (MOP == 6) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_6 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,ageClient,ageClient];
            
        } else if (MOP == 9) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_9 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,ageClient,ageClient];
            
        } else if (MOP == 12) {
            querySQL = [[NSString alloc] initWithFormat:
                        @"SELECT PremPayOpt_12 FROM Trad_Sys_Rider_GYI WHERE PlanCode=\"%@\" AND FromAge <=\"%d\" AND ToAge >= \"%d\"",riderCode,ageClient,ageClient];
        }
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                GYI = sqlite3_column_int(statement, 0);
                NSLog(@"GYI:%d",GYI);
            }
            else {
                NSLog(@"error access getGYI");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - delegate

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc
{
    
    if (aaCode == NULL) {
        [btnPlan setTitle:temp forState:UIControlStateNormal];
    }
    else {
        [self.btnPlan setTitle:aaDesc forState:UIControlStateNormal];
        planChoose = [[NSString alloc] initWithFormat:@"%@",aaCode];
    }
    
    if (![aaCode isEqualToString:planChoose]) {
        MOPHLAIB = 0;
        MOPHLACP = 0;
        yearlyIncomeHLAIB = nil;
        cashDividendHLAIB = nil;
        cashDividendHLACP = nil;
        advanceYearlyIncomeHLAIB = 0;
        advanceYearlyIncomeHLACP = 0;
    }
    
    [self tooglePlan];
    if (getSumAssured != 0) {
        [self toogleExistingField];
    }
    
    [self.planPopover dismissPopoverAnimated:YES];
}

#pragma mark - Memory Management
- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setPlanPopover:nil];
    [self setPlanList:nil];
    [self setDelegate:nil];
    [self setRequestOccpCode:nil];
    [self setRequestSINo:nil];
    [self setRequestSmokerPay:nil];
    [self setRequestSexPay:nil];
    [self setRequestDOBPay:nil];
    [self setRequestOccpPay:nil];
    [self setRequestSmoker2ndLA:nil];
    [self setRequestSex2ndLA:nil];
    [self setRequestDOB2ndLA:nil];
    [self setRequestOccp2ndLA:nil];
    [self setOccpCode:nil];
    [self setSINo:nil];
    [self setPayorSmoker:nil];
    [self setPayorSex:nil];
    [self setPayorDOB:nil];
    [self setPayorOccpCode:nil];
    [self setSecondLASmoker:nil];
    [self setSecondLASex:nil];
    [self setSecondLADOB:nil];
    [self setSecondLAOccpCode:nil];
    [self setBtnPlan:nil];
    [self setTermField:nil];
    [self setYearlyIncomeField:nil];
    [self setMinSALabel:nil];
    [self setMaxSALabel:nil];
    [self setBtnHealthLoading:nil];
    [self setHealthLoadingView:nil];
    [self setMOPSegment:nil];
    [self setIncomeSegment:nil];
    [self setAdvanceIncomeSegment:nil];
    [self setCashDividendSegment:nil];
    [self setHLField:nil];
    [self setHLTermField:nil];
    [self setTempHLField:nil];
    [self setTempHLTermField:nil];
    [self setMyScrollView:nil];
    [self setMyToolBar:nil];
    [self setSIDate:nil];
    [self setCustDate:nil];
    [self setLACustCode:nil];
    [self setPYCustCode:nil];
    [self setSecondLACustCode:nil];
    [self setPlanChoose:nil];
    [self setNamePP:nil];
    [self setDOBPP:nil];
    [self setGenderPP:nil];
    [self setOccpCodePP:nil];
    [self setYearlyIncome:nil];
    [self setCashDividend:nil];
    [self setPlanCode:nil];
    [self setGetSINo:nil];
    [self setGetHL:nil];
    [self setGetTempHL:nil];
    [self setLRiderCode:nil];
    [self setLSumAssured:nil];
    [self setRiderCode:nil];
    [self setLabelFive:nil];
    [self setCashDivSgmntCP:nil];
    [self setLabelFour:nil];
    [self setLabelSix:nil];
    [self setLabelSeven:nil];
    [self setLabelFive:nil];
    [self setLabelSix:nil];
    [self setLabelSeven:nil];
    [self setLabelParAcc:nil];
    [self setLabelParPayout:nil];
    [self setLabelPercent1:nil];
    [self setLabelPercent2:nil];
    [self setParAccField:nil];
    [self setParPayoutField:nil];
    [self setLabelAddHL:nil];
    [super viewDidUnload];
}

@end
