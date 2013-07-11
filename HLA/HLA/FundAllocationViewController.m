//
//  FundAllocationViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FundAllocationViewController.h"

@interface FundAllocationViewController ()

@end

@implementation FundAllocationViewController
@synthesize txt2023,txt2025,txt2028,txt2030,txt2035,txtAge,txtCashFund,txtExpireCashFund,txtExpireSecureFund;
@synthesize txtSecureFund, outletAge, outletReset,outletSustain, myScrollView;
@synthesize SINo,get2023,get2025,get2028,get2030,get2035,getCashFund,getExpiredCashFund,getExpiredSecureFund;
@synthesize getSecureFund, getSustainAge, getAge;
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
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	// Do any additional setup after loading the view.
	
	txt2023.delegate = self;
	txt2025.delegate = self;
	txt2028.delegate = self;
	txt2030.delegate = self;
	txt2035.delegate = self;
	txtSecureFund.delegate = self;
	txtCashFund.delegate = self;
	txtExpireCashFund.delegate = self;
	txtExpireSecureFund.delegate = self;
	txtAge.tag = 1;
	myScrollView.delegate = self;

	
	if (SINo) {
		[self getExisting];
		[self toggle];
	}
	else{
		txtAge.enabled = NO;
		txtAge.backgroundColor = [UIColor lightGrayColor];
		outletAge.enabled = FALSE;
		txtExpireCashFund.enabled = FALSE;
		txtExpireSecureFund.enabled = FALSE;
		txtExpireCashFund.backgroundColor = [UIColor lightGrayColor];
		txtExpireSecureFund.backgroundColor = [UIColor lightGrayColor];
	}


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
	 self.headerTitle.frame = CGRectMake(344, -20, 111, 44);
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

	self.myScrollView.frame = CGRectMake(0, 44, 768, 700);
    self.myScrollView.contentSize = CGSizeMake(768, 900);
	
	activeField = txtAge;
	
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];

}

-(void)keyboardDidHide:(NSNotificationCenter *)notification{
	self.myScrollView.frame = CGRectMake(0, 44, 768, 960);
}




-(void)InsertandUpdate{
	
	 sqlite3_stmt *statement;
	 if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
	 {
		 NSString *querySQL = [NSString stringWithFormat: @"UPDATE UL_DETAILS SET VU2023 = '%@', VU2025 = '%@', VU2028 = '%@', "
							   "VU2030 = '%@', VU2035 = '%@', VUCash = '%@', VURET = '%@', VUCashOpt='%@', VURetOpt='%@', "
							   "PolicySustainYear ='%@' where sino = '%@' ",
							   txt2023.text, txt2025.text, txt2028.text, txt2030.text, txt2035.text, txtCashFund.text,
							   txtSecureFund.text, txtExpireCashFund.text, txtExpireSecureFund.text, [self ReturnSustainAge], SINo ];
	 
		 //NSLog(@"%@", querySQL);
		 if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		 {
			 if (sqlite3_step(statement) == SQLITE_ROW)
			 {
	 
			 } else {
				 //NSLog(@"error check tbl_Adm_TrnTypeNo");
			 }
			 sqlite3_finalize(statement);
		 }
		 sqlite3_close(contactDB);
	 }
	 
}

-(void)getExisting{
	sqlite3_stmt *statement;
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
	{
		NSString *querySQL = [NSString stringWithFormat: @"Select VU2023, VU2025, VU2028, "
							  "VU2030, VU2035, VUCash, VURET, VUCashOpt, VURetOpt, "
							  "PolicySustainYear FROM UL_Details where sino = '%@' ", SINo ];
		
		//NSLog(@"%@", querySQL);
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
		{
			if (sqlite3_step(statement) == SQLITE_ROW)
			{
					
				txt2023.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
				txt2025.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				txt2028.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
				txt2030.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
				txt2035.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
				txtCashFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
				txtSecureFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
				txtExpireCashFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
				txtExpireSecureFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
				getSustainAge = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 9)];

			} else {
				//NSLog(@"error check tbl_Adm_TrnTypeNo");
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}

-(void)toggle{
	if ([txtExpireCashFund.text isEqualToString:@"0"] && [txtExpireSecureFund.text isEqualToString:@"0"] ) {
		txt2023.enabled = true;
		txt2025.enabled = TRUE;
		txt2025.enabled = TRUE;
		txt2030.enabled = TRUE;
		txt2035.enabled = TRUE;
		txtCashFund.enabled = TRUE;
		txtSecureFund.enabled = TRUE;
		txtExpireCashFund.enabled = false;
		txtExpireSecureFund.enabled = false;
		txt2023.backgroundColor = [UIColor whiteColor];
		txt2025.backgroundColor = [UIColor whiteColor];
		txt2028.backgroundColor = [UIColor whiteColor];
		txt2030.backgroundColor = [UIColor whiteColor];
		txt2035.backgroundColor = [UIColor whiteColor];
		txtCashFund.backgroundColor = [UIColor whiteColor];
		txtSecureFund.backgroundColor = [UIColor whiteColor];
		txtExpireCashFund.backgroundColor = [UIColor lightGrayColor];
		txtExpireSecureFund.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txt2023.enabled = FALSE;
		txt2025.enabled = FALSE;
		txt2025.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txtExpireCashFund.enabled = TRUE;
		txtExpireSecureFund.enabled = TRUE;
		txt2023.backgroundColor = [UIColor lightGrayColor];
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
		txtExpireCashFund.backgroundColor = [UIColor whiteColor];
		txtExpireSecureFund.backgroundColor = [UIColor whiteColor];
	}
	

	if (![getSustainAge isEqualToString:@"0"]) {

		if ([getSustainAge isEqualToString:@"65"]) {
			outletSustain.selectedSegmentIndex = 0;
			outletAge.selectedSegmentIndex = 0;
			txtAge.enabled = FALSE;
			txtAge.text = @"";
			txtAge.backgroundColor = [UIColor lightGrayColor];
		}
		else if ([getSustainAge isEqualToString:@"85"]) {
			outletSustain.selectedSegmentIndex = 0;
			outletAge.selectedSegmentIndex = 1;
			txtAge.enabled = FALSE;
			txtAge.text = @"";
			txtAge.backgroundColor = [UIColor lightGrayColor];
		}
		else if ([getSustainAge isEqualToString:@"100"]) {
			outletSustain.selectedSegmentIndex = 0;
			outletAge.selectedSegmentIndex = 2;
			txtAge.enabled = FALSE;
			txtAge.text = @"";
			txtAge.backgroundColor = [UIColor lightGrayColor];
		}
		else{
			outletSustain.selectedSegmentIndex = 0;
			outletAge.selectedSegmentIndex = 3;
			txtAge.enabled = TRUE;
			txtAge.backgroundColor = [UIColor whiteColor];
			txtAge.text = getSustainAge;
		}
	}
	else{
		outletSustain.selectedSegmentIndex = 1;
		outletAge.enabled = FALSE;
		txtAge.enabled = FALSE;
		txtAge.backgroundColor = [UIColor lightGrayColor];
	}
}

-(BOOL)Validation{
	
	[self ValidateString];
	int total = [txt2023.text intValue] + [txt2025.text intValue] + [txt2028.text intValue] + [txt2030.text intValue] +
				[txt2035.text intValue] + [txtSecureFund.text intValue] + [txtCashFund.text intValue];
	
	if (total != 100){
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:@"The total of Fund Allocation should be 100%." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[failAlert show];
		[txt2023 becomeFirstResponder ];
		return FALSE;
	}
	else if ([txtCashFund.text isEqualToString:@"0"]) {
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:@"Fund Allocation for HLA Cash Fund canot be less than 1%." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[failAlert show];
		[txtCashFund becomeFirstResponder ];
		return FALSE;
	}
	else if([txtAge.text intValue ] < getAge + 10 ){
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:[NSString stringWithFormat:@"Minimum Policy Sustainability (Age) is %d ", getAge + 10] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[failAlert show];
		[txtAge becomeFirstResponder ];
		return FALSE;
	}
	else if ([txtSecureFund.text isEqualToString:@"0"] && [txtExpireCashFund.text isEqualToString:@"0"] &&
			 [txtExpireSecureFund.text isEqualToString:@"0"] ) {
		NSString *msg;
		if (![txt2035.text isEqualToString:@"0"]) {
			msg = @"Please insert the fund allocation after 25/11/2035 which HLA EverGreen 2035 is closed for investment";
		}
		else if (![txt2030.text isEqualToString:@"0"]){
			msg = @"Please insert the fund allocation after 25/11/2030 which HLA EverGreen 2030 is closed for investment";
		}
		else if (![txt2028.text isEqualToString:@"0"]){
			msg = @"Please insert the fund allocation after 25/11/2028 which HLA EverGreen 2028 is closed for investment";
		}
		else if (![txt2025.text isEqualToString:@"0"]){
			msg = @"Please insert the fund allocation after 25/11/2025 which HLA EverGreen 2025 is closed for investment";
		}
		else if (![txt2023.text isEqualToString:@"0"]){
			msg = @"Please insert the fund allocation after 25/11/2023 which HLA EverGreen 2023 is closed for investment";
		}
		
		UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		failAlert.tag = 1;
		[failAlert show];
		return FALSE;
	}
	else{
		return TRUE;
	}
	
}

-(void)ValidateString{
	if ([txt2023.text isEqualToString:@""]) {
		txt2023.text = @"0";
	}
	if ([txt2025.text isEqualToString:@""]) {
		txt2025.text = @"0";
	}
	if ([txt2028.text isEqualToString:@""]) {
		txt2028.text = @"0";
	}
	if ([txt2030.text isEqualToString:@""]) {
		txt2030.text = @"0";
	}
	if ([txt2035.text isEqualToString:@""]) {
		txt2035.text = @"0";
	}
	if ([txtCashFund.text isEqualToString:@""]) {
		txtCashFund.text = @"0";
	}
	if ([txtSecureFund.text isEqualToString:@""]) {
		txtSecureFund.text = @"0";
	}
	if ([txtExpireCashFund.text isEqualToString:@""]) {
		txt2023.text = @"0";
	}
	if ([txtExpireSecureFund.text isEqualToString:@""]) {
		txt2023.text = @"0";
	}
}

-(NSString *)ReturnSustainAge{
	NSString *returnValue;
	
	if (outletSustain.selectedSegmentIndex == 0) {
		if ([txtAge.text isEqualToString:@""]) {
			returnValue = getSustainAge;
		}
		else{
			returnValue = txtAge.text;
		}
	}
	else{
		returnValue = @"0";
	}
	
	return returnValue;
}

- (void)viewDidUnload {
	[self setTxt2023:nil];
	[self setTxt2025:nil];
	[self setTxt2028:nil];
	[self setTxt2030:nil];
	[self setTxt2035:nil];
	[self setTxtSecureFund:nil];
	[self setTxtCashFund:nil];
	[self setTxtExpireSecureFund:nil];
	[self setTxtExpireCashFund:nil];
	[self setOutletReset:nil];
	[self setOutletSustain:nil];
	[self setOutletAge:nil];
	[self setTxtAge:nil];
	[self setMyScrollView:nil];
	[super viewDidUnload];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

	if ([textField.text isEqualToString:@"0" ]) {
		textField.text = @"";
	}

	activeField = textField;
	return  YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

	NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
	if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
		return NO;
	}
	
    return YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	
	if (alertView.tag == 1001 && buttonIndex == 0) {
		
		[self InsertandUpdate];
	}
	else if (alertView.tag == 1) {
		txt2023.enabled = NO;
		txt2025.enabled = NO;
		txt2028.enabled = NO;
		txt2030.enabled = NO;
		txt2035.enabled = NO;
		txtCashFund.enabled = NO;
		txtSecureFund.enabled = NO;
		txt2023.backgroundColor = [UIColor lightGrayColor];
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
		
		txtExpireCashFund.enabled = TRUE;
		txtExpireSecureFund.enabled = TRUE;
		txtExpireCashFund.backgroundColor = [UIColor whiteColor];
		txtExpireSecureFund.backgroundColor = [UIColor whiteColor];
		txtExpireCashFund.text = @"20";
		txtExpireSecureFund.text = @"80";
	}
	
}

#pragma mark - Button action

- (IBAction)ActionDone:(id)sender {
	
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
	
	if ([self Validation]  == TRUE) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Confirm changes?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
		[alert setTag:1001];
		[alert show];
	}
	
}


- (IBAction)ActionReset:(id)sender {
	txt2023.text = @"0";
	txt2025.text = @"0";
	txt2028.text = @"0";
	txt2030.text = @"0";
	txt2035.text = @"40";
	txtCashFund.text = @"20";
	txtSecureFund.text = @"40";
	txtExpireCashFund.text = @"0";
	txtExpireSecureFund.text = @"0";
	
	txt2023.enabled = true;
	txt2025.enabled = TRUE;
	txt2025.enabled = TRUE;
	txt2030.enabled = TRUE;
	txt2035.enabled = TRUE;
	txtCashFund.enabled = TRUE;
	txtSecureFund.enabled = TRUE;
	txtExpireCashFund.enabled = false;
	txtExpireSecureFund.enabled = false;
	txt2023.backgroundColor = [UIColor whiteColor];
	txt2025.backgroundColor = [UIColor whiteColor];
	txt2028.backgroundColor = [UIColor whiteColor];
	txt2030.backgroundColor = [UIColor whiteColor];
	txt2035.backgroundColor = [UIColor whiteColor];
	txtCashFund.backgroundColor = [UIColor whiteColor];
	txtSecureFund.backgroundColor = [UIColor whiteColor];
	txtExpireCashFund.backgroundColor = [UIColor lightGrayColor];
	txtExpireSecureFund.backgroundColor = [UIColor lightGrayColor];
}
- (IBAction)ActionSustain:(id)sender {
	if (outletSustain.selectedSegmentIndex == 0) {
		outletAge.enabled = TRUE;
	}
	else{
		outletAge.enabled = NO;
		outletAge.selectedSegmentIndex = -1;
		txtAge.text = @"";
		txtAge.backgroundColor = [UIColor lightGrayColor];
	}

}
- (IBAction)ActionAge:(id)sender {
	if (outletAge.selectedSegmentIndex == 0) {
		getSustainAge = @"60";
		txtAge.text = @"";
		txtAge.enabled = NO;
		txtAge.backgroundColor = [UIColor lightGrayColor];
	}
	else if (outletAge.selectedSegmentIndex == 1){
		getSustainAge = @"85";
		txtAge.text = @"";
		txtAge.enabled = NO;
		txtAge.backgroundColor = [UIColor lightGrayColor];
	}
	else if (outletAge.selectedSegmentIndex == 2){
		getSustainAge = @"100";
		txtAge.text = @"";
		txtAge.enabled = NO;
		txtAge.backgroundColor = [UIColor lightGrayColor];
	}
	else if (outletAge.selectedSegmentIndex == 3){
		txtAge.enabled = YES;
		txtAge.backgroundColor = [UIColor whiteColor];
	}
	
}
@end
