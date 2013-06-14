//
//  EverSeriesMasterViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverSeriesMasterViewController.h"
#import "EverLAViewController.h"
#import "BasicAccountViewController.h"

#import "AppDelegate.h"

@interface EverSeriesMasterViewController ()

@end

@implementation EverSeriesMasterViewController
@synthesize EverLAController = _EverLAController;
@synthesize BasicAccount = _BasicAccount;
@synthesize ListOfSubMenu, getAge,getCommDate,getIdPay,getIdProf,getLAIndexNo,getOccpClass;
@synthesize getOccpCode,getSex,getSmoker, Name2ndLA,NameLA,NamePayor;

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
	[self resignFirstResponder];
	

	self.myTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-linen.png"]];

	NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	
	[self.view addSubview:self.myTableView];
    [self.view addSubview:self.RightView];
	
	ListOfSubMenu = [[NSMutableArray alloc] initWithObjects:@"Life Assured", @"   2nd Life Assured", @"   Payor",
					 @"Basic Account", @"Fund Allocation & Others", @"Riders",  nil ];
	
	PlanEmpty = YES;
    added = NO;
    saved = YES;
    payorSaved = YES;
	
	if (_EverLAController == nil) {
        self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"LAView"];
		_EverLAController.delegate = self;
    }
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.myTableView.rowHeight = 44;
	self.myTableView.scrollEnabled = false;
    [self.myTableView reloadData];
	
	selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
}

-(void)viewWillAppear:(BOOL)animated{
	self.view.autoresizesSubviews = NO;
	
    self.myTableView.frame = CGRectMake(0, 0, 220, 748);
    [self hideSeparatorLine];
    self.RightView.frame = CGRectMake(223, 0, 801, 748);
}

-(void)hideSeparatorLine
{
    CGRect frame = self.myTableView.frame;
    frame.size.height = MIN(44 * [ListOfSubMenu count], 748);
    self.myTableView.frame = frame;
}


-(void)Reset{
	NSLog(@"");
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
	
	//--detail text label
	
    if (indexPath.row == 0) {
        if (NameLA.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",NameLA];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
	
	cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:17];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
	
	return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	selectedPath = indexPath;
	if (indexPath.row == 0) {

		self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
		_EverLAController.delegate = self;
		//self.EverLAController.requestSINo = getSINo;
		[self addChildViewController:self.EverLAController];
		[self.RightView addSubview:self.EverLAController.view];
	}
	else if (indexPath.row == 3){
		self.BasicAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"EverBasic"];
		_BasicAccount.delegate = self;
		[self addChildViewController:self.BasicAccount];
		[self.RightView addSubview:self.BasicAccount.view];
	}
}

#pragma mark - data handler
-(void)getLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",getLAIndexNo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NameLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
				
            } else {
                NSLog(@"error access getLAName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


#pragma mark - delegate
-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker{
	getAge = aaAge;
    getSex = aaSex;
    getSmoker = aaSmoker;
    getOccpClass = aaOccpClass;
    getOccpCode = aaOccpCode;
    getCommDate = aaCommDate;
    getIdPay = aaIdPayor;
    getIdProf = aaIdProfile;
    getLAIndexNo = aaIndexNo;
	
	[self getLAName];
	[self.myTableView reloadData];
	if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setMyTableView:nil];
	[self setRightView:nil];
	[super viewDidUnload];
}
@end
