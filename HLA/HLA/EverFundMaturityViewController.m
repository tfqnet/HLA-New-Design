//
//  EverFundMaturityViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverFundMaturityViewController.h"
#import "PopOverFundViewController.h"

@interface EverFundMaturityViewController ()

@end

@implementation EverFundMaturityViewController
@synthesize outletDelete,outletFund,outletOptions, outletTableLabel;
@synthesize txt2025,txt2028,txt2030,txt2035,txtCashFund,txtPercentageReinvest,txtSecureFund, myTableView;
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
    
	cell.detailTextLabel.text = @"dsadas";
	return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Fundlisting:(PopOverFundViewController *)inController andDesc:(NSString *)aaDesc{
	
	[outletFund setTitle:aaDesc forState:UIControlStateNormal];
	[self.FundPopover dismissPopoverAnimated:YES];
	
	if (outletOptions.selectedSegmentIndex != 1) {
		[self toggleFund];
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
	myTableView.hidden = FALSE;
	outletTableLabel.hidden = FALSE;
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
        
		self.FundList = [[PopOverFundViewController alloc] init];
        _FundList.delegate = self;
        self.FundPopover = [[UIPopoverController alloc] initWithContentViewController:_FundList];
	}
    [self.FundPopover setPopoverContentSize:CGSizeMake(350.0f, 300.0f)];
    [self.FundPopover presentPopoverFromRect:[sender frame] inView:self.view
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
@end
