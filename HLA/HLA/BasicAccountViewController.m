//
//  BasicAccountViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicAccountViewController.h"
#import "EverLAViewController.h"
#import "MainScreen.h"
#import "AppDelegate.h"

@interface BasicAccountViewController ()

@end

const double Anually = 1.00, Semi = 0.50, quarterly = 0.25, Monthly = 0.083333;

@implementation BasicAccountViewController
@synthesize outletBasic, txtBasicPremium, txtBasicSA,txtBUMP,txtCommFrom,txtFor;
@synthesize txtGrayRTUP,txtPolicyTerm,txtPremiumPayable,txtRTUP,txtTotalBAPremium;
@synthesize myScrollView, Label1, label2, labelComm, labelFor, segPremium;
@synthesize requestAge,requestAge2ndLA,requestAgePay,requestDOB2ndLA,requestDOBPay,requestIDPay,requestIDProf;
@synthesize requestIndex2ndLA,requestIndexPay,requestOccp2ndLA,requestOccpClass,requestOccpCode;
@synthesize requestOccpPay,requestSex2ndLA,requestSexPay,requestSINo,requestSmoker2ndLA,requestSmokerPay;
@synthesize ageClient,idPay,idProf,SINo,OccpClass, OccpCode, PayorAge, PayorDOB, PayorIndexNo;
@synthesize PayorOccpCode, PayorSex, PayorSmoker,secondLAAge,secondLADOB,secondLAIndexNo,secondLAOccpCode;
@synthesize secondLASex,secondLASmoker, minSA, minPremium, getPolicyTerm, getSINo, getSumAssured;
@synthesize GenderPP, SIDate, SILastNo, CustDate, CustLastNo, LACustCode, PYCustCode, planChoose, OccpCodePP, NamePP;
@synthesize DOBPP, IndexNo, termCover, secondLACustCode, getHL, getHLPct,getHLPctTerm,getHLTerm;
@synthesize getBumpMode, getBasicPrem, getPlanCode;
@synthesize delegate = _delegate;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
	self.planList = [[PlanList alloc] init];
    _planList.delegate = self;
	self.planList.TradOrEver = @"EVER";
	self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
	
	UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
														   forKey:UITextAttributeFont];
	[segPremium setTitleTextAttributes:attributes
							   forState:UIControlStateNormal];
	
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
	temp = outletBasic.titleLabel.text;
	
	    [self togglePlan];
	if (self.requestSINo) {
		[self checkingExisting];
		if (getSINo.length != 0) {
			NSLog(@"view selected field");
			[self getExistingBasic];
			
			if ([getPlanCode isEqualToString:@"UV"]) {
                [self.outletBasic setTitle:@"HLA EverLife" forState:UIControlStateNormal];
                temp = outletBasic.titleLabel.text;
            }
			
			[self togglePlan];
			[self toggleExistingField];
			
		}else {
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
	
	[txtBasicPremium addTarget:self action:@selector(BasicPremiumDidChanged) forControlEvents:UIControlEventAllEditingEvents];
	getBumpMode= @"A";
	
	Label1.hidden = YES;
	label2.hidden = YES;
	txtBasicPremium.tag = 0;
	txtBasicPremium.delegate = self;
	txtBasicSA.delegate = self;
	txtBasicSA.tag = 1;
	txtCommFrom.tag = 2;
	txtFor.tag = 2;
	txtCommFrom.delegate = self;
	txtFor.delegate = self;
	txtRTUP.tag = 3;
	txtRTUP.delegate = self;
	_planList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    /*
	 self.headerTitle.frame = CGRectMake(310, -20, 149, 44);
	 self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
	 self.view.frame = CGRectMake(0, 20, 768, 1004); */
    
    self.view.frame = CGRectMake(0, 0, 788, 1004);
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

-(void)keyboardDidHide:(NSNotificationCenter *)notification{
	Label1.hidden = TRUE;
	label2.hidden = TRUE;
	self.myScrollView.frame = CGRectMake(0, 44, 768, 960);
}

#pragma mark - delegate

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
	[outletBasic setTitle:aaDesc forState:UIControlStateNormal ];
	[self.planPopover dismissPopoverAnimated:YES];
	txtPolicyTerm.text =  [NSString stringWithFormat:@"%d", (100 - requestAge)];
	getPlanCode = aaCode;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	switch (textField.tag) {
        case 0:
			Label1.hidden = FALSE;
			label2.hidden = FALSE;
			
			if (segPremium.selectedSegmentIndex == 0) {
				minPremium = 780 * Anually;
				Label1.text =  [NSString stringWithFormat:@"Min: %.0f", minPremium];
				label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
			}
			else if (segPremium.selectedSegmentIndex == 1){
				minPremium= 780 * Semi;
				Label1.text =  [NSString stringWithFormat:@"Min: %.0f", 780 * minPremium];
				label2.text=  [NSString stringWithFormat:@"Max: Subject to underwriting"];
			}

            else if (segPremium.selectedSegmentIndex == 2){
				minPremium = 780 * quarterly;
				Label1.text =  [NSString stringWithFormat:@"Min: %.0f", 780 * minPremium];
				label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
			}
			else if (segPremium.selectedSegmentIndex == 3){
				minPremium = 780 * Monthly;
				Label1.text =  [NSString stringWithFormat:@"Min: %.0f", 780 * minPremium];
				label2.text =  [NSString stringWithFormat:@"Max: Subject to underwriting"];
			}
			
			break;
			
        case 1:
			Label1.hidden = FALSE;
			label2.hidden = FALSE;
			double SAFac = 0;
			
			if (requestAge < 17) {
				SAFac = 60;
				
			}
			else if (requestAge > 16 && requestAge < 26){
				SAFac = 55;
			}
			else if (requestAge > 25 && requestAge < 36){
				SAFac = 50;
			}
			else if (requestAge > 35 && requestAge < 46){
				SAFac = 35;
			}
			else if (requestAge > 45 && requestAge < 56){
				SAFac = 25;
			}
			else if (requestAge > 55){
				SAFac = 15;
			}
			minSA = SAFac * [txtBasicPremium.text doubleValue ];
			Label1.text = [ NSString stringWithFormat:@"Min: %.0f", minSA];
			label2.text = @"Max: Subject to underwriting";
            
            break;
			
		case 2:
			labelComm.text = [NSString stringWithFormat:@"Min: %d Max: %d", 1, 100- ageClient - 1];
			labelFor.text = [NSString stringWithFormat:@"Min: %d Max: %d", 1, 100- ageClient];
			
            break;
		case 3:
			Label1.hidden = TRUE;
			label2.hidden = TRUE;
        default:
            
            break;
    }
	activeField = textField;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{

	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	if ([string length ] == 0) {
		return  YES;
	}
	
	if (textField.tag == 0 || textField.tag == 3) {
		
		NSRange rangeofDot = [textField.text rangeOfString:@"."];
		if (rangeofDot.location != NSNotFound ) {
			NSString *substring = [textField.text substringFromIndex:rangeofDot.location ];
			
			if ([string isEqualToString:@"."]) {
				return NO;
			}
			
			if (substring.length > 2 )
			{
				return NO;
			}
		}
		
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			return NO;
		}
	}
	else{
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			return NO;
		}
	}
    
	return  YES;
}

-(void)BasicPremiumDidChanged{
	txtTotalBAPremium.text = txtBasicPremium.text;
	txtPremiumPayable.text = txtBasicPremium.text;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag == 1001 && buttonIndex == 0) {
        
	    EverLAViewController *EverLAPage  = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
        MainScreen *MainScreenPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        MainScreenPage.IndexTab = 3;
		EverLAPage.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:MainScreenPage animated:YES completion:^(){
            [MainScreenPage presentModalViewController:EverLAPage animated:NO];
			EverLAPage.view.superview.bounds =  CGRectMake(-300, 0, 1024, 748);
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


#pragma mark - handle data

-(void)togglePlan
{
    NSLog(@"tooglePlan");
    [self getTermRule];
	
}

-(void)toggleExistingField{
	
	txtPolicyTerm.text = [NSString stringWithFormat:@"%d", getPolicyTerm];
	txtBasicSA.text = [NSString stringWithFormat:@"%.f", getSumAssured ];
	txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", getBasicPrem ];
	
	txtPremiumPayable.text = txtBasicPremium.text;
	
	[_delegate BasicSI:getSINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover
			andBasicSA:txtBasicSA.text andBasicHL:getHL andBasicHLTerm:getHLTerm
		 andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm andPlanCode:getPlanCode];
	
}

-(void) getTermRule
{
    termCover = 100 - ageClient;
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM "
							  "prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
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


-(void)getExistingBasic
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT SINo, CovPeriod, BasicSA, "
							  "ATPrem, BUMPMode, HLoading, HLoadingTerm, HLoadingPct, HLoadingPctTerm, planCode FROM UL_Details"
							  " WHERE SINo=\"%@\"",SINo];

        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                getSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getPolicyTerm = sqlite3_column_int(statement, 1);
                getSumAssured = sqlite3_column_double(statement, 2);
				getBasicPrem = sqlite3_column_double(statement, 3);
				getBumpMode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 5);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 6);	
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 7);
                getHLPct = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getHLPctTerm = sqlite3_column_int(statement, 8);
				getPlanCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];
				//                NSLog(@"basicPlan:%@",planChoose);
                
            } else {
                NSLog(@"error access getExistingBasic");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
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

-(void)updateBasicPlan
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE UL_Details SET CovPeriod=\"%@\", BasicSA=\"%@\", "
							  "AtPrem = \"%@\", BumpMode = \"%@\", DateModified=%@ "
							  " WHERE SINo=\"%@\"", txtPolicyTerm.text, txtBasicSA.text, txtBasicPremium.text,
							  [self getBumpMode], @"datetime(\"now\", \"+8 hour\")", SINo];
        
        //NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"BasicPlan update!");
                //[self getPlanCodePenta];
                
				[_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:txtBasicSA.text
					andBasicHL:getHL andBasicHLTerm:getHLTerm andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm andPlanCode:getPlanCode];
				
				
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
    
    [self validateExistingRider];
}

-(void)validateExistingRider{
	
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
							   @"INSERT INTO UL_Details (SINo,  PlanCode, CovTypeCode, ATPrem, BasicSA, CovPeriod, OccpCode, "
							   "BumpMode, VU2023, VU2025,VU2028,VU2030,VU2035,VURet,VUCash,VURetOpt,VUCashOpt, PolicySustainYear, "
							   "DateCreated, CreatedBy, DateModified, ModifiedBy) VALUES "
							   "(\"%@\", \"UV\", \"IC\", \"%@\", \"%@\", \"%d\", \"%@\", \"%@\", '0', '0', "
							   "'0','0','40','40','20','0','0','0', "
							   "datetime('now', '+8 hour'), 'HLA', datetime('now', '+8 hour'), 'HLA') ",
							   SINo, txtBasicPremium.text, txtBasicSA.text, termCover, OccpCode,
							   [self getBumpMode]];
		
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Saved BasicPlan!");
                [self updateLA];
                
                if (PayorIndexNo != 0) {
                    [self savePayor];
                }
                
                if (secondLAIndexNo != 0) {
                    [self saveSecondLA];
                }
				
				[_delegate BasicSI:SINo andAge:ageClient andOccpCode:OccpCode andCovered:termCover andBasicSA:txtBasicSA.text
						andBasicHL:getHL andBasicHLTerm:getHLTerm andBasicHLPct:getHLPct andBasicHLPctTerm:getHLPctTerm
						andPlanCode:getPlanCode];

		
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


-(void)updateLA
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Clt_Profile SET CustCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" "
							  "WHERE id=\"%d\"",LACustCode,currentdate,idProf];
        
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
							   @"UPDATE UL_LAPayor SET SINo=\"%@\", CustCode=\"%@\", DateModified=\"%@\", "
							   "ModifiedBy=\"hla\" WHERE rowid=\"%d\"",SINo,LACustCode,currentdate,idPay];
        
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
                               @"INSERT INTO UL_LAPayor (SINo, CustCode,PTypeCode,Seq,DateCreated,CreatedBy) VALUES "
							   "(\"%@\",\"%@\",\"PY\",\"1\",\"%@\",\"hla\")",SINo, PYCustCode,dateStr];
        
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
                                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, "
								"CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")",
								PYCustCode, NamePP, PayorSmoker, PayorSex, PayorDOB, PayorAge, ANB, PayorOccpCode, dateStr,PayorIndexNo];
		
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
                               @"INSERT INTO UL_LAPayor (SINo, CustCode,PTypeCode,Seq,DateCreated,CreatedBy) VALUES "
							   "(\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",SINo, secondLACustCode,dateStr];
        
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


-(NSString *)getBumpMode{
	
	NSString *result;
	if (segPremium.selectedSegmentIndex == 0) {
		result = @"A";
	}
	else if (segPremium.selectedSegmentIndex == 1){
		result = @"S";
	}
	else if (segPremium.selectedSegmentIndex == 1){
		result = @"Q";
	}
	else if (segPremium.selectedSegmentIndex == 1){
		result = @"M";
	}
	
	return result;
}

-(void)getRunningSI
{
    sqlite3_stmt *statement;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"UL\" AND LastUpdated "
							  "like \"%%%@%%\"", dateString];
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
                              @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\" AND "
							  "LastUpdated like \"%%%@%%\" ",dateString];
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
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated=\"%@\" WHERE TrnTypeCode=\"UL\"",
							  newLastNo, dateString];
        
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
                              @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",
							  newLastNo,dateString];
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



#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
	[self setMyScrollView:nil];
	[self setOutletBasic:nil];
	[self setTxtPolicyTerm:nil];
	[self setSegPremium:nil];
	[self setTxtBasicPremium:nil];
	[self setTxtBasicSA:nil];
	[self setTxtGrayRTUP:nil];
	[self setTxtRTUP:nil];
	[self setTxtCommFrom:nil];
	[self setTxtFor:nil];
	[self setTxtBUMP:nil];
	[self setTxtTotalBAPremium:nil];
	[self setTxtPremiumPayable:nil];
	[self setLabel1:nil];
	[self setLabel2:nil];
	[self setLabelComm:nil];
	[self setLabelFor:nil];
	[super viewDidUnload];
}

#pragma mark - handle data
-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM UL_Details WHERE SINo=\"%@\"",SINo];
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


#pragma mark - button

- (IBAction)ACtionBasic:(id)sender {
	[self resignFirstResponder];
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
	
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        _planList.delegate = self;
		self.planList.TradOrEver = @"EVER";
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }

	[self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
- (IBAction)ActionDone:(id)sender {
	[self resignFirstResponder];
    [self.view endEditing:YES];
	
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
	
	NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    //NSRange rangeofDotSA = [txtBasicSA.text rangeOfString:@"."];
	
	if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert setTag:1001];
        [alert show];
    }
	else if (ageClient > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
									message:[NSString stringWithFormat:@"Age Last Birthday must be less than or equal to 100 for this product."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([txtBasicPremium.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Invalid input format. Basic Premium must be numeric 0 to 9 or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
		txtBasicPremium.text = @"";
        [txtBasicPremium becomeFirstResponder];
    }
	else if ([txtBasicSA.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Invalid input format. Basic Sum Assured must be numeric 0 to 9 only" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
		txtBasicSA.text = @"";
        [txtBasicSA becomeFirstResponder];
    }
	else if ([txtBasicSA.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Sum Assured is required"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
		[txtBasicSA becomeFirstResponder];
    }
    else if ([txtBasicPremium.text doubleValue] < minPremium) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Annual Premium must be at least %.0f",minPremium] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtBasicPremium becomeFirstResponder];
    }
    else if ([txtBasicSA.text intValue] < minSA) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Basic Sum Assured will be revised to %.0f", minSA] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
		txtBasicSA.text = [NSString stringWithFormat:@"%.0f", minSA];
        
    }
	/*
	else if (rangeofDotSA.location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:[NSString stringWithFormat:@"Decimal place is not allow for Basic Sum Assured"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
		[txtBasicSA becomeFirstResponder];
    }*/
	else {
		NSString *msg;
		[self checkingExisting];
		if (useExist) {
			msg = @"Confirm changes?";
		} else {
			msg = @"Confirm creating new record?";
		}
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
		[alert setTag:1003];
		[alert show];
	}




}






- (IBAction)ActionPayment:(id)sender {
	double tempBasicPrem = [txtBasicPremium.text doubleValue ];
	double tempBasicSA = [txtBasicSA.text doubleValue ];
	double tempPremiumPayable = [txtPremiumPayable.text doubleValue ];
	
	if (segPremium.selectedSegmentIndex == 0) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			
			if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem /Semi   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA /Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable /Semi   ];
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem /quarterly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA /quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable /quarterly   ];
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem/Monthly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA/Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable/Monthly   ];
			}
		
		}
		getBumpMode	= @"A";
	}
	else if (segPremium.selectedSegmentIndex == 1) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * Semi   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * Semi   ];
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem/quarterly) * Semi   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA/quarterly) * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable/quarterly) * Semi   ];
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Monthly) * Semi   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Monthly) * Semi   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Monthly) * Semi   ];
			}
			
		}
		getBumpMode= @"S";
	
	}
	else if (segPremium.selectedSegmentIndex == 2) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * quarterly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * quarterly   ];
			}
			else if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem/Semi) * quarterly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA/Semi) * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable/Semi) * quarterly   ];
				
			}
			else if ([getBumpMode isEqualToString:@"M"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Monthly) * quarterly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Monthly) * quarterly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Monthly) * quarterly   ];
			}
			
		}
		getBumpMode = @"Q";
		
	}
	else if (segPremium.selectedSegmentIndex == 3) {
		if (![txtBasicPremium.text isEqualToString:@""]) {
			if ([getBumpMode isEqualToString:@"A"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", tempBasicPrem * Monthly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", tempBasicSA * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", tempPremiumPayable * Monthly   ];
			}
			else if ([getBumpMode isEqualToString:@"S"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /Semi) * Monthly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /Semi) * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /Semi) * Monthly   ];
				
			}
			else if ([getBumpMode isEqualToString:@"Q"]) {
				txtBasicPremium.text = [NSString stringWithFormat:@"%.2f", (tempBasicPrem /quarterly) * Monthly   ];
				txtBasicSA.text = [NSString stringWithFormat:@"%.2f", (tempBasicSA /quarterly) * Monthly   ];
				txtPremiumPayable.text = [NSString stringWithFormat:@"%.2f", (tempPremiumPayable /quarterly) * Monthly   ];
			}
			
		}
		getBumpMode = @"M";
		
	}
}
@end
