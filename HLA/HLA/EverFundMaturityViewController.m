//
//  EverFundMaturityViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverFundMaturityViewController.h"

@interface EverFundMaturityViewController ()

@end

@implementation EverFundMaturityViewController
@synthesize outletDelete,outletFund,outletOptions, outletTableLabel;
@synthesize txt2025,txt2028,txt2030,txt2035,txtCashFund,txtPercentageReinvest,txtSecureFund, myTableView;
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

- (IBAction)ACtionDone:(id)sender {
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
}

- (IBAction)ACtionFund:(id)sender {
	if (outletOptions.selectedSegmentIndex == 2) {
		txtPercentageReinvest.enabled = TRUE;
		txtPercentageReinvest.backgroundColor = [UIColor whiteColor];
	}
	else{
		txtPercentageReinvest.enabled = FALSE;
		txtPercentageReinvest.backgroundColor = [UIColor lightGrayColor];
		txtPercentageReinvest.text = @"0";
	}
}
@end
