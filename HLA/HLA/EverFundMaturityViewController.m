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
	exist = FALSE;
	
	[outletDelete setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [outletDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	outletDelete.titleLabel.shadowColor = [UIColor lightGrayColor];
    outletDelete.titleLabel.shadowOffset = CGSizeMake(0, -1);
	
	[self GetExisting];
	[self toggleFund];
	
	
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
    return  [aMaturityFund count];
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
	int FontSize = 14;
	
	CGRect frame=CGRectMake(10,y, 135, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [NSString stringWithFormat:@"%@", [aMaturityFund objectAtIndex:indexPath.row] ];
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label1];
	
	CGRect frame2=CGRectMake(frame.origin.x + frame.size.width, y, 70, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= [NSString stringWithFormat:@"%@", [aFundOption objectAtIndex:indexPath.row] ];
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 2002;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label2];
	
	CGRect frame3=CGRectMake(frame2.origin.x + frame2.size.width, y, 70, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
	if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"ReInvest" ]) {
		label3.text= [NSString stringWithFormat:@"%d", 100];
	}
	else if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"Withdraw" ]) {
		label3.text= [NSString stringWithFormat:@"%d", 0];
	}
	else if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"Partial" ]) {
		label3.text= [NSString stringWithFormat:@"%d", [[aPercent objectAtIndex:indexPath.row] intValue ]];
	}
    label3.textAlignment = UITextAlignmentCenter;
    label3.tag = 2003;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label3];
	
	CGRect frame4=CGRectMake(frame3.origin.x + frame3.size.width, y, 70, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    //label4.text= [NSString stringWithFormat:@"%d", [[aPercent objectAtIndex:indexPath.row] intValue ] ];
	if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"ReInvest" ]) {
		label4.text= [NSString stringWithFormat:@"%d", 0];
	}
	else if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"Withdraw" ]) {
		label4.text= [NSString stringWithFormat:@"%d", 100];
	}
	else if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"Partial" ]) {
		label4.text= [NSString stringWithFormat:@"%d", 100 - [[aPercent objectAtIndex:indexPath.row] intValue ]];
	}
    label4.textAlignment = UITextAlignmentCenter;
    label4.tag = 2004;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label4];
	
	CGRect frame5=CGRectMake(frame4.origin.x + frame4.size.width, y, 60, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [NSString stringWithFormat:@"%@", [a2025 objectAtIndex:indexPath.row]];
    label5.textAlignment = UITextAlignmentCenter;
    label5.tag = 2005;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label5];
	
	CGRect frame6=CGRectMake(frame5.origin.x + frame5.size.width,y, 60, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    label6.text= [NSString stringWithFormat:@"%@", [a2028 objectAtIndex:indexPath.row]];
    label6.textAlignment = UITextAlignmentCenter;
    label6.tag = 2006;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label6];
	
	CGRect frame7=CGRectMake(frame6.origin.x + frame6.size.width,y, 60, 50);
    UILabel *label7=[[UILabel alloc]init];
    label7.frame=frame7;
    label7.text= [NSString stringWithFormat:@"%@", [a2030 objectAtIndex:indexPath.row]];
    label7.textAlignment = UITextAlignmentCenter;
    label7.tag = 2007;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label7];

	CGRect frame8=CGRectMake(frame7.origin.x + frame7.size.width,y, 50, 50);
    UILabel *label8=[[UILabel alloc]init];
    label8.frame=frame8;
    label8.text= [NSString stringWithFormat:@"%@", [a2035 objectAtIndex:indexPath.row]];
    label8.textAlignment = UITextAlignmentCenter;
    label8.tag = 2008;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label8];
	
	CGRect frame9=CGRectMake(frame8.origin.x + frame8.size.width,y, 50, 50);
    UILabel *label9=[[UILabel alloc]init];
    label9.frame=frame9;
    label9.text= [NSString stringWithFormat:@"%@", [aSecureFund objectAtIndex:indexPath.row]];
    label9.textAlignment = UITextAlignmentCenter;
    label9.tag = 2009;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label9];
	
	CGRect frame10=CGRectMake(frame9.origin.x + frame9.size.width,y, 70, 50);
    UILabel *label10=[[UILabel alloc]init];
    label10.frame=frame10;
    label10.text= [NSString stringWithFormat:@"%@", [aCashFund objectAtIndex:indexPath.row]];
    label10.textAlignment = UITextAlignmentCenter;
    label10.tag = 2010;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    [cell.contentView addSubview:label10];
	
	if (indexPath.row % 2 == 0) {
        label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label7.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label8.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label9.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
		label10.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label4.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label5.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label6.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label7.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label8.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label9.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label10.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		
    }
    else {
        label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		label7.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		label8.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		label9.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label10.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
		
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label4.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label5.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label6.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label7.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label8.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
		label9.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
        label10.font = [UIFont fontWithName:@"TreBuchet MS" size:FontSize];
    }
	
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	exist = TRUE;
	
	[outletFund setTitle:[aMaturityFund objectAtIndex:indexPath.row] forState:UIControlStateNormal];
	if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"ReInvest" ]) {
		outletOptions.selectedSegmentIndex = 0;
	}
	else if ([[aFundOption objectAtIndex:indexPath.row] isEqualToString:@"Withdraw" ]){
		outletOptions.selectedSegmentIndex = 1;
	}
	else{
		outletOptions.selectedSegmentIndex = 2;
	}
	txtPercentageReinvest.text = [NSString stringWithFormat:@"%.0f", [[aPercent objectAtIndex:indexPath.row] doubleValue]];
	txt2025.text = [NSString stringWithFormat:@"%.0f", [[a2025 objectAtIndex:indexPath.row] doubleValue]];
	txt2028.text = [NSString stringWithFormat:@"%.0f", [[a2028 objectAtIndex:indexPath.row] doubleValue]];
	txt2030.text = [NSString stringWithFormat:@"%.0f", [[a2030 objectAtIndex:indexPath.row] doubleValue]];
	txt2035.text = [NSString stringWithFormat:@"%.0f", [[a2035 objectAtIndex:indexPath.row] doubleValue]];
	txtCashFund.text = [NSString stringWithFormat:@"%.0f", [[aCashFund objectAtIndex:indexPath.row] doubleValue]];
	txtSecureFund.text = [NSString stringWithFormat:@"%.0f", [[aSecureFund objectAtIndex:indexPath.row] doubleValue]];
	outletOptions.enabled = TRUE;
	[self toggleFund];
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
	outletOptions.selectedSegmentIndex = 0;
	[self DisplayData];
	/*
	if (outletOptions.selectedSegmentIndex != 1) {
		exist = FALSE;
		[self toggleFund];
		[self DisplayData];
	}
	else{
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txtCashFund.text = @"0";
		txtSecureFund.text = @"0";
		txtPercentageReinvest.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txtPercentageReinvest.enabled = FALSE;
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
		txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
	}
	 */
	
	outletOptions.enabled = TRUE;
}

-(void)DisplayData{

	NSRange search;
	for (int a =0; a<aMaturityFund.count; a++ ) {
		search = [[aMaturityFund objectAtIndex:a ] rangeOfString:outletFund.titleLabel.text options:NSCaseInsensitiveSearch];
		
		if (search.location != NSNotFound) {
			exist = TRUE;

			if ([[aFundOption objectAtIndex:a] isEqualToString:@"ReInvest" ]) {
					outletOptions.selectedSegmentIndex = 0;
			}
			else if ([[aFundOption objectAtIndex:a] isEqualToString:@"Withdraw" ]){
				outletOptions.selectedSegmentIndex = 1;
			}
			else{
				outletOptions.selectedSegmentIndex = 2;
			}
			txtPercentageReinvest.text = [NSString stringWithFormat:@"%.0f", [[aPercent objectAtIndex:a] doubleValue]];
			txt2025.text = [NSString stringWithFormat:@"%.0f", [[a2025 objectAtIndex:a] doubleValue]];
			txt2028.text = [NSString stringWithFormat:@"%.0f", [[a2028 objectAtIndex:a] doubleValue]];
			txt2030.text = [NSString stringWithFormat:@"%.0f", [[a2030 objectAtIndex:a] doubleValue]];
			txt2035.text = [NSString stringWithFormat:@"%.0f", [[a2035 objectAtIndex:a] doubleValue]];
			txtCashFund.text = [NSString stringWithFormat:@"%.0f", [[aCashFund objectAtIndex:a] doubleValue]];
			txtSecureFund.text = [NSString stringWithFormat:@"%.0f", [[aSecureFund objectAtIndex:a] doubleValue]];
			[self toggleFund];
			break;
		}
	}
	
	if (search.location == NSNotFound) { //new
		exist = FALSE;
		txtPercentageReinvest.text = @"0";
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txtCashFund.text = @"100";
		txtSecureFund.text = @"0";
		[self toggleFund];
	}
	
}

- (IBAction)ACtionDone:(id)sender {
	//myTableView.hidden = FALSE;
	//outletTableLabel.hidden = FALSE;

	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
	
	if ([self Validation] == TRUE) {
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Confirm changes?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
		[alert setTag:1001];
		[alert show];
		
	}
		
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1001 && buttonIndex == 0) {
		
		[self InsertandUpdate];
	}
}

-(void)InsertandUpdate{
	
	 if (exist == TRUE) {
		 sqlite3_stmt *statement;
		 if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
		 {
				NSString *querySQL = [NSString stringWithFormat: @"Update UL_Fund_Maturity_Option SET Option = '%@', "
										"Partial_Withd_Pct='%@', EverGreen2025='%@', "
									  "EverGreen2028= '%@', EverGreen2030='%@', EverGreen2035='%@', CashFund='%@', RetireFund='%@' "
									  " Where sino = '%@' AND Fund = '%@' ",
									  [self ReturnOption], txtPercentageReinvest.text, txt2025.text,
									  txt2028.text, txt2030.text, txt2035.text, txtCashFund.text, txtSecureFund.text, SINo, outletFund.titleLabel.text];
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
			 NSString *querySQL = [NSString stringWithFormat: @"INSERT INTO UL_Fund_Maturity_Option(SINO, Fund, Option, Partial_Withd_Pct, EverGreen2025,"
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
	 
	
	[self GetExisting];
	[self.myTableView reloadData];

}

-(void)GetExisting{
	
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
	
	sqlite3_stmt *statement;
	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
	{
		NSString *querySQL = [NSString stringWithFormat: @"Select Fund, Option, Partial_Withd_Pct, EverGreen2025, "
							  "EverGreen2028, EverGreen2030, EverGreen2035, CashFund, RetireFund From UL_Fund_Maturity_Option where SINO = '%@'  ",
							SINo];
		
		//NSLog(@"%@", querySQL);
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
			while (sqlite3_step(statement) == SQLITE_ROW){
				
				[aMaturityFund addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
				[aFundOption addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
				[aPercent addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
				[a2025 addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]];
				[a2028 addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]];
				[a2030 addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]];
				[a2035 addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]];
				[aCashFund addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]];
				[aSecureFund addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)]];
				
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
	if ([aMaturityFund count] > 0) {
		myTableView.hidden = NO;
		outletTableLabel.hidden = NO;
		[myTableView reloadData];
	}
	else{
		myTableView.hidden = YES;
		outletTableLabel.hidden = YES;
	}

}

-(NSString*)ReturnOption{
	if (outletOptions.selectedSegmentIndex  == 0) {
		return @"ReInvest";
	}
	else if (outletOptions.selectedSegmentIndex == 1){
		return @"Withdraw";
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
	
	if (outletOptions.selectedSegmentIndex == 2) {
		if ([[txtPercentageReinvest.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@"" ]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:@"Percentage ReInvest must be greater than 0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			return  FALSE;
		}
	}
	
	if (outletOptions.selectedSegmentIndex != 1) {
		if ([txt2025.text intValue ] + [txt2028.text intValue ] + [txt2030.text intValue ] + [txt2035.text intValue ] +
			[txtCashFund.text intValue ] + [txtSecureFund.text intValue ] != 100) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
															message:@"Total Fund Percentage must be 100%" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			return  FALSE;
		}
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
		txtPercentageReinvest.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txtPercentageReinvest.enabled = FALSE;
		txt2025.backgroundColor = [UIColor lightGrayColor];
		txt2028.backgroundColor = [UIColor lightGrayColor];
		txt2030.backgroundColor = [UIColor lightGrayColor];
		txt2035.backgroundColor = [UIColor lightGrayColor];
		txtCashFund.backgroundColor = [UIColor lightGrayColor];
		txtSecureFund.backgroundColor = [UIColor lightGrayColor];
		txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		[self toggleFund];
	}
}

-(void)toggleFund{
	
	if (outletOptions.selectedSegmentIndex == 1 || [outletFund.titleLabel.text isEqualToString:@"Please Select"]) {
		txt2025.text = @"0";
		txt2028.text = @"0";
		txt2030.text = @"0";
		txt2035.text = @"0";
		txtCashFund.text = @"0";
		txtSecureFund.text = @"0";
		txtPercentageReinvest.text = @"0";
		txt2025.enabled = FALSE;
		txt2028.enabled = FALSE;
		txt2030.enabled = FALSE;
		txt2035.enabled = FALSE;
		txtCashFund.enabled = FALSE;
		txtSecureFund.enabled = FALSE;
		txtPercentageReinvest.enabled = FALSE;
	}
	else{
		if (outletOptions.selectedSegmentIndex == 2) {
			txtPercentageReinvest.enabled = TRUE;
		}
		else{
			txtPercentageReinvest.enabled = FALSE;
		}
		
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
			txt2025.enabled = FALSE;
			txt2028.enabled = FALSE;
			txt2030.enabled = TRUE;
			txt2035.enabled = TRUE;
			txtCashFund.enabled = TRUE;
			txtSecureFund.enabled = TRUE;
		}
		else if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2025"]) {
			txt2025.text = @"0";
			txt2025.enabled = FALSE;
			txt2028.enabled = TRUE;
			txt2030.enabled = TRUE;
			txt2035.enabled = TRUE;
			txtCashFund.enabled = TRUE;
			txtSecureFund.enabled = TRUE;
		}
		else if ([outletFund.titleLabel.text isEqualToString:@"HLA EverGreen 2023"]) {
			txt2025.enabled = TRUE;
			txt2028.enabled = TRUE;
			txt2030.enabled = TRUE;
			txt2035.enabled = TRUE;
			txtCashFund.enabled = TRUE;
			txtSecureFund.enabled = TRUE;
		}
		
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
	
	if (txtPercentageReinvest.enabled == FALSE) {
		txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
	}
	else{
		txtPercentageReinvest.backgroundColor = [UIColor whiteColor];
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
