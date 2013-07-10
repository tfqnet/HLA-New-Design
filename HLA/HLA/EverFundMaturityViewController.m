//
//  EverFundMaturityViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverFundMaturityViewController.h"
#import "PopOverFundViewController.h"
#import "ColorHexCode.h"

@interface EverFundMaturityViewController ()

@end

BOOL exist;

@implementation EverFundMaturityViewController
@synthesize outletDelete,outletFund,outletOptions, outletTableLabel, SINo;
@synthesize txt2025,txt2028,txt2030,txt2035,txtCashFund,txtPercentageReinvest,txtSecureFund, myTableView;
@synthesize a2023,a2025,a2028,a2030,a2035,aCashFund,aFundOption,aMaturityFund,aSecureFund,aPercent;
@synthesize FundList = _FundList;
@synthesize FundPopover = _FundPopover;
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
	
	a2023 = [[NSMutableArray alloc] init ];
	a2025 = [[NSMutableArray alloc] init ];
	a2028 = [[NSMutableArray alloc] init ];
	a2030 = [[NSMutableArray alloc] init ];
	a2035 = [[NSMutableArray alloc] init ];
	aCashFund = [[NSMutableArray alloc] init ];
	aSecureFund = [[NSMutableArray alloc] init ];
	aPercent = [[NSMutableArray alloc] init ];
	aFundOption = [[NSMutableArray alloc] init ];
	aMaturityFund = [[NSMutableArray alloc] init ];
	
	outletTableLabel.hidden = YES;
	myTableView.hidden = YES;
	myTableView.delegate = self;
	myTableView.dataSource = self;
	
	myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    [self.view addSubview:myTableView];
	
	UIFont *font = [UIFont boldSystemFontOfSize:16.0f];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
														   forKey:UITextAttributeFont];
	[outletOptions setTitleTextAttributes:attributes
							   forState:UIControlStateNormal];
	
	txtPercentageReinvest.enabled = FALSE;
	txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
	outletOptions.enabled =FALSE;
	txt2025.delegate = self;
		txt2028.delegate = self;
		txt2030.delegate = self;
		txt2035.delegate = self;
		txtCashFund.delegate = self;
		txtSecureFund.delegate = self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
	/*
	 + 	 self.headerTitle.frame = CGRectMake(309, -20, 151, 44);
	 + 	 self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
	 + 	 self.view.frame = CGRectMake(0, 20, 768, 1004); */
	
	self.view.frame = CGRectMake(0, 0, 788, 1004);
	[super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
	[[cell.contentView viewWithTag:2001] removeFromSuperview ];
    [[cell.contentView viewWithTag:2002] removeFromSuperview ];
    [[cell.contentView viewWithTag:2003] removeFromSuperview ];
    [[cell.contentView viewWithTag:2004] removeFromSuperview ];
    [[cell.contentView viewWithTag:2005] removeFromSuperview ];
    [[cell.contentView viewWithTag:2006] removeFromSuperview ];
    [[cell.contentView viewWithTag:2007] removeFromSuperview ];
    [[cell.contentView viewWithTag:2008] removeFromSuperview ];
    [[cell.contentView viewWithTag:2009] removeFromSuperview ];
    [[cell.contentView viewWithTag:2010] removeFromSuperview ];
	
	ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    int y = 0;
	/*
	CGRect frame=CGRectMake(10,y, 70, 50); //ridercode
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [NSString stringWithFormat:@"    %@", ];
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
	*/
	//cell.detailTextLabel.text = @"dsadas";
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	
	if ([string length ] == 0) {
		return  YES;
	}
	
	if (textField.text.length > 2) {
		return NO;
	}
	
	NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
	if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
		return NO;
	}
	
	return  YES;
}


-(void)Fundlisting:(PopOverFundViewController *)inController andDesc:(NSString *)aaDesc{
	
	[outletFund setTitle:aaDesc forState:UIControlStateNormal];
	[self.FundPopover dismissPopoverAnimated:YES];
	
	if (outletOptions.selectedSegmentIndex != 1) {
		[self toggleFund];
		//[self DisplayExisting];
	}
	else{
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txtCashFund.text = @"0";
		txtSecureFund.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
	}
	
	outletOptions.enabled = TRUE;
}

- (IBAction)ACtionDone:(id)sender {
	//myTableView.hidden = FALSE;
	//outletTableLabel.hidden = FALSE;

	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
	
	if ([self Validation] == TRUE) {
		
		if (exist == TRUE) {
			sqlite3_stmt *statement;
			if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			{
				NSString *querySQL = [NSString stringWithFormat: @"Update UL_Fund_Maturity_Option SET Option = '%@', "
									  "Partial_Withd_Percen='%@', EverGreen2025='%@', "
									  "EverGreen2028= '%@', EverGreen2030='%@', EverGreen2035='%@', CashFund='%@', RetireFund='%@' Where sino = '%@' ",
									  [self ReturnOption], txtPercentageReinvest.text, txt2025.text,
									  txt2028.text, txt2030.text, txt2035.text, txtCashFund.text, txtSecureFund.text, SINo];
				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_DONE){
						
					}
					sqlite3_finalize(statement);
				}
				sqlite3_close(contactDB);
			}
		}
		else{
			sqlite3_stmt *statement;
			if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			{
				NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO UL_Fund_Maturity_Option(SINO, Fund, Option, Partial_Withd_Percen, EverGreen2025,"
									  "EverGreen2028, EverGreen2030, EverGreen2035, CashFund, RetireFund) VALUES('%@', '%@', '%@', "
									  "'%@', '%@', '%@', '%@', '%@', '%@', '%@') ",
									  SINo, outletFund.titleLabel.text, [self ReturnOption], txtPercentageReinvest.text, txt2025.text,
									  txt2028.text, txt2030.text, txt2035.text, txtCashFund.text, txtSecureFund.text];
				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
					if (sqlite3_step(statement) == SQLITE_DONE){
						
					}
					sqlite3_finalize(statement);
				}
				sqlite3_close(contactDB);
			}
		}
		
		[myTableView reloadData];
	}
		

}

-(void)GetExisting{
	
	sqlite3_stmt *statement;
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
	{
		NSString *querySQL = [NSString stringWithFormat: @"Select Fund, Option, Partial_Withd_Percen, EverGreen2025,"
							  "EverGreen2028, EverGreen2030, EverGreen2035, CashFund, RetireFund From UL_Fund_Maturity_Option where SINO = '%@'  ",
							SINo];
		
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
			while (sqlite3_step(statement) == SQLITE_ROW){
				
				outletFund.titleLabel.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
				if([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"ReInvest"]){
					outletOptions.selectedSegmentIndex = 0;
				}
				else if ([[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)] isEqualToString:@"FullyWithdraw"]){
					outletOptions.selectedSegmentIndex = 1;
				}
				else{
					outletOptions.selectedSegmentIndex = 2;
				}
				txtPercentageReinvest.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
				txt2025.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
				txt2028.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
				txt2030.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
				txt2035.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
				txtCashFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
				txtSecureFund.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
}

-(NSString*)ReturnOption{
	if (outletOptions.selectedSegmentIndex  == 0) {
		return @"ReInvest";
	}
	else if (outletOptions.selectedSegmentIndex == 1){
		return @"FullyWithdraw";
	}
	else{
		return @"Partial";
	}
	
}

- (BOOL)Validation{
	if ([outletFund.titleLabel.text isEqualToString:@"Please Select"]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Please select a Maturity Fund." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];

		return FALSE;
	}
	
	if ([txt2025.text intValue ] + [txt2028.text intValue ] + [txt2030.text intValue ] + [txt2035.text intValue ] +
		[txtCashFund.text intValue ] + [txtSecureFund.text intValue ] != 100) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
						message:@"Total Fund Percentage must be 100%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        return  FALSE;
	}

	return  TRUE;
}

- (void)viewDidUnload {
	[self setOutletFund:nil];
	[self setOutletOptions:nil];
	[self setTxtPercentageReinvest:nil];
	[self setTxt2025:nil];
	[self setTxt2030:nil];
	[self setTxtSecureFund:nil];
	[self setTxt2028:nil];
	[self setTxt2035:nil];
	[self setTxtCashFund:nil];
	[self setOutletDelete:nil];
	[self setACtionDelete:nil];
	[self setMyTableView:nil];
	[self setOutletTableLabel:nil];
	[super viewDidUnload];
}

- (IBAction)ActionOptions:(id)sender {
	if (outletOptions.selectedSegmentIndex == 2) {
		txtPercentageReinvest.enabled = TRUE;
		txtPercentageReinvest.backgroundColor = [UIColor whiteColor];
	}
	else{
		txtPercentageReinvest.enabled = FALSE;
		txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
		txtPercentageReinvest.text = @"0";
	}
	
	if (outletOptions.selectedSegmentIndex == 1) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txtCashFund.text = @"0";
		txtSecureFund.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		[self toggleFund];
	}
}

-(void)toggleFund{
	
	if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2035"]) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = TRUE;
		txtSecureFund.enabled = TRUE;
	}
	else if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2030"]) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = TRUE;
		txtCashFund.enabled = TRUE;
		txtSecureFund.enabled = TRUE;
	}
	else if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2028"]) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = TRUE;
		txt2035.enabled = TRUE;
		txtCashFund.enabled = TRUE;
		txtSecureFund.enabled = TRUE;
	}
	else if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2025"]) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = TRUE;
		txt2030.enabled = TRUE;
		txt2035.enabled = TRUE;
		txtCashFund.enabled = TRUE;
		txtSecureFund.enabled = TRUE;
	}
	
	
	if (txt2025.enabled == FALSE) {
		txt2025.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txt2025.backgroundColor = [UIColor whiteColor];
	}
	
	if (txt2028.enabled == FALSE) {
		txt2028.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txt2028.backgroundColor = [UIColor whiteColor];
	}
	
	if (txt2030.enabled == FALSE) {
		txt2030.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txt2030.backgroundColor = [UIColor whiteColor];
	}
	
	if (txt2035.enabled == FALSE) {
		txt2035.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txt2035.backgroundColor = [UIColor whiteColor];
	}
	
	if (txtCashFund.enabled == FALSE) {
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txtCashFund.backgroundColor = [UIColor whiteColor];
	}
	
	if (txtSecureFund.enabled == FALSE) {
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txtSecureFund.backgroundColor = [UIColor whiteColor];
	}
}

- (IBAction)ACtionFund:(id)sender {
	if(_FundList == nil){
        
		self.FundList = [[PopOverFundViewController alloc] initWithString:SINo];
        _FundList.delegate = self;
        self.FundPopover = [[UIPopoverController alloc] initWithContentViewController:_FundList];
	}
    [self.FundPopover setPopoverContentSize:CGSizeMake(350.0f, 300.0f)];
    [self.FundPopover presentPopoverFromRect:[sender frame] inView:self.view
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
@end
