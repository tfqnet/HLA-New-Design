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
#import "EverRiderViewController.h"

#import "AppDelegate.h"

@interface EverSeriesMasterViewController ()

@end

@implementation EverSeriesMasterViewController
@synthesize EverLAController = _EverLAController;
@synthesize BasicAccount = _BasicAccount;
@synthesize EverRider = _EverRider;
@synthesize ListOfSubMenu, getAge,getCommDate,getIdPay,getIdProf,getLAIndexNo,getOccpClass;
@synthesize getOccpCode,getSex,getSmoker, Name2ndLA,NameLA,NamePayor, get2ndLAAge,get2ndLADOB,get2ndLAIndexNo;
@synthesize get2ndLAOccp,get2ndLASex,get2ndLASmoker,getbasicHL,getBasicPlan,getbasicSA,getbasicHLPct;
@synthesize getPayAge,getPayDOB,getPayOccp,getPayorIndexNo,getPaySex,getPaySmoker,getPlanCode;
@synthesize getSINo,getTerm, payorCustCode, payorSINo, requestSINo2, CustCode2, clientID2;
@synthesize getOccpCPA;
id EverRiderCount;

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
					 @"Basic Account", nil ];
	
	PlanEmpty = YES;
    added = NO;
    saved = YES;
    payorSaved = YES;
	
	if (_EverLAController == nil) {
        self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
		_EverLAController.delegate = self;
    }
	
	self.EverLAController.requestSINo = [self.requestSINo description];
    [self addChildViewController:self.EverLAController];
    [self.RightView addSubview:self.EverLAController.view];
	
	self.myTableView.delegate = self;
	self.myTableView.dataSource = self;
	self.myTableView.rowHeight = 44;
	self.myTableView.scrollEnabled = false;
    [self.myTableView reloadData];
	
	selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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



-(void)Reset
{
    if ([self.requestSINo isEqualToString:self.requestSINo2] || (self.requestSINo == NULL && self.requestSINo2 == NULL) ) {
        
        PlanEmpty = YES;
        added = NO;
		//        [SelectedRow addObject:@"4" ];
		//        [SelectedRow addObject:@"5" ];
        
        [self RemoveTab];
        [self clearDataLA];
        [self clearDataPayor];
        [self clearData2ndLA];
        [self clearDataBasic];
        
        [self hideSeparatorLine];
        [self.myTableView reloadData];
        
        self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
        _EverLAController.delegate = self;
        [self addChildViewController:self.EverLAController];
        [self.RightView addSubview:self.EverLAController.view];
        blocked = NO;
        selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
        previousPath = selectedPath;
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
		AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
		appDel.MhiMessage = Nil;
        appDel = Nil;
    }
    else {
        requestSINo2 = self.requestSINo;
    }
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
		
		if (getSINo.length != 0) {
			NSLog(@"with SI");
			self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
            _EverLAController.delegate = self;
            self.EverLAController.requestSINo = getSINo;
            [self addChildViewController:self.EverLAController];
            [self.RightView addSubview:self.EverLAController.view];
		}
		else{
			NSLog(@"no SI");
			self.EverLAController = [self.storyboard instantiateViewControllerWithIdentifier:@"EverLA"];
            _EverLAController.delegate = self;
            self.EverLAController.requestIndexNo = getLAIndexNo;
            self.EverLAController.requestLastIDPay = getIdPay;
            self.EverLAController.requestLastIDProf = getIdProf;
            self.EverLAController.requestCommDate = getCommDate;
            self.EverLAController.requestSex = getSex;
            self.EverLAController.requestSmoker = getSmoker;
            [self addChildViewController:self.EverLAController];
            [self.RightView addSubview:self.EverLAController.view];
		}

		previousPath = selectedPath;
        blocked = NO;
		
	}
	else if (indexPath.row == 1){
		
	}
	else if (indexPath.row == 2){
		
	}
	else if (indexPath.row == 3){
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else{
			if (!saved) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
																message:@"2nd Life Assured has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:1001];
				[alert show];
			}
			else if (!payorSaved) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
																message:@"Payor has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:2001];
				[alert show];
			}
			else {
				self.BasicAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"EverBasic"];
				_BasicAccount.delegate = self;
				
				//self.BasicAccount.requestAge = getAge;
				//[self addChildViewController:self.BasicAccount];
				//[self.RightView addSubview:self.BasicAccount.view];
				
				[self selectBasicPlan];
				[self hideSeparatorLine];
				[self.myTableView reloadData];
			}
			
		}
		
	}
	else if (indexPath.row == 4){ //Fund Allocation
		
	}
	else if (indexPath.row == 5){ //Rider
		if ([getOccpCode isEqualToString:@"OCC01975"]) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            alert = Nil;
			
		}
		else if (getAge > 100 ) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 100 for this product."
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			alert = Nil;
		}
		else{
			if (getAge < 10 && payorSINo.length == 0) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				blocked = YES;
			}
			else if (!saved) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:1002];
				[alert show];
			}
			else if (!payorSaved) {
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor has not been saved yet.Leave this page without saving?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
				[alert setTag:2002];
				[alert show];
			}
			else {
				self.EverRider = [self.storyboard instantiateViewControllerWithIdentifier:@"EverRider"];
				_EverRider.delegate = self;
				self.EverRider.requestAge = getAge;
				self.EverRider.requestSex = getSex;
				self.EverRider.requestOccpCode = getOccpCode;
				self.EverRider.requestOccpClass = getOccpClass;
				
				self.EverRider.requestSINo = getSINo;
				self.EverRider.requestPlanCode = getPlanCode;
				self.EverRider.requestCoverTerm = getTerm;
				self.EverRider.requestBasicSA = getbasicSA;
				self.EverRider.requestBasicHL = getbasicHL;
				self.EverRider.requestBasicHLPct = getbasicHLPct;
				self.EverRider.requestSmoker = getSmoker;
				self.EverRider.request2ndSmoker = get2ndLASmoker;
				self.EverRider.requestPayorSmoker = getPaySmoker;
				self.EverRider.requestOccpCPA = getOccpCPA;
				
				[self addChildViewController:self.EverRider];
				[self.RightView addSubview:self.EverRider.view];
				
				previousPath = selectedPath;
				blocked = NO;
				[self hideSeparatorLine];
				[self.myTableView reloadData];
			}
		
		}
	}
	else if (indexPath.row == 6){ //Health Loading
		
	}
	else if (indexPath.row == 7){ //Special Options
		
	}
	else if (indexPath.row == 8){ //Fund Maturity Options
		
	}
	else if (indexPath.row == 9){ //Quotation
		
	}
	else if (indexPath.row == 11){ //Eng PDS
		
	}
	else if (indexPath.row == 12){ //BM PDS
		
	}
}

#pragma mark - data handler

-(void)selectBasicPlan
{
    NSLog(@"select basic:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
        NSLog(@"with SI");
        
        [self checkingPayor];
        if (getAge < 10 && payorSINo.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
										message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else if (getAge > 100) {
			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 100 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else {
            
            self.BasicAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"EverBasic"];
            _BasicAccount.delegate = self;
            
            self.BasicAccount.requestAge = getAge;
            self.BasicAccount.requestOccpCode = getOccpCode;
            self.BasicAccount.requestOccpClass = getOccpClass;
            self.BasicAccount.requestIDPay = getIdPay;
            self.BasicAccount.requestIDProf = getIdProf;
            
            self.BasicAccount.requestIndexPay = getPayorIndexNo;
            self.BasicAccount.requestSmokerPay = getPaySmoker;
            self.BasicAccount.requestSexPay = getPaySex;
            self.BasicAccount.requestDOBPay = getPayDOB;
            self.BasicAccount.requestAgePay = getPayAge;
            self.BasicAccount.requestOccpPay = getPayOccp;
            
            self.BasicAccount.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicAccount.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicAccount.requestSex2ndLA = get2ndLASex;
            self.BasicAccount.requestDOB2ndLA = get2ndLADOB;
            self.BasicAccount.requestAge2ndLA = get2ndLAAge;
            self.BasicAccount.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicAccount.requestSINo = getSINo;
            
            [self addChildViewController:self.BasicAccount];
            [self.RightView addSubview:self.BasicAccount.view];
            
            previousPath = selectedPath;
            blocked = NO;
        }
    }
    else if (getOccpCode != 0 && getSINo.length == 0) {
        NSLog(@"no SI");
        
        if (getAge < 10 && getPayorIndexNo == 0) {
			
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
											message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            blocked = YES;
        }
        else {
            
            self.BasicAccount = [self.storyboard instantiateViewControllerWithIdentifier:@"EverBasic"];
            _BasicAccount.delegate = self;
            
            self.BasicAccount.requestAge = getAge;
            self.BasicAccount.requestOccpCode = getOccpCode;
            self.BasicAccount.requestOccpClass = getOccpClass;
            self.BasicAccount.requestIDPay = getIdPay;
            self.BasicAccount.requestIDProf = getIdProf;
            
            self.BasicAccount.requestIndexPay = getPayorIndexNo;
            self.BasicAccount.requestSmokerPay = getPaySmoker;
            self.BasicAccount.requestSexPay = getPaySex;
            self.BasicAccount.requestDOBPay = getPayDOB;
            self.BasicAccount.requestAgePay = getPayAge;
            self.BasicAccount.requestOccpPay = getPayOccp;
            
            self.BasicAccount.requestIndex2ndLA = get2ndLAIndexNo;
            self.BasicAccount.requestSmoker2ndLA = get2ndLASmoker;
            self.BasicAccount.requestSex2ndLA = get2ndLASex;
            self.BasicAccount.requestDOB2ndLA = get2ndLADOB;
            self.BasicAccount.requestAge2ndLA = get2ndLAAge;
            self.BasicAccount.requestOccp2ndLA = get2ndLAOccp;
            
            self.BasicAccount.requestSINo = getSINo;
            
            [self addChildViewController:self.BasicAccount];
            [self.RightView addSubview:self.BasicAccount.view];
            
            previousPath = selectedPath;
            blocked = NO;
        }
    }
    else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Please attach a prospect in Life Assured tab first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
		[alert show];
        NSLog(@"no where!");
        blocked = YES;
    }
}

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, "
							  "b.id FROM UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode "
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSLog(@"PayorSI:%@",payorSINo);
            }
            else {
                NSLog(@"error access checkingPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


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

-(void)checking2ndLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, "
							  "b.id FROM UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" "
							  "AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                clientID2 = sqlite3_column_int(statement, 9);
				
            } else {
                NSLog(@"error access checking2ndLA");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)toogleView
{
    if (PlanEmpty && added)
    {
        [ListOfSubMenu removeObject:@"Rider"];
        
    }
    else if (!PlanEmpty && !added) {
		[ListOfSubMenu addObject:@"Fund Allocation and Others"];
        [ListOfSubMenu addObject:@"Rider"];
		[ListOfSubMenu addObject:@"Health Loading"];
		[ListOfSubMenu addObject:@"Special Options"];
		[ListOfSubMenu addObject:@"Fund Maturity Options"];
        [ListOfSubMenu addObject:@"Quotation"];
        [ListOfSubMenu addObject:@"Proposal"];
        [ListOfSubMenu addObject:@"Product Disclosure Sheet"];
        [ListOfSubMenu addObject:@"   English"];
        [ListOfSubMenu addObject:@"   Malay"];
		
        added = YES;
    }
    [self CalculateRider];
    [self hideSeparatorLine];
    
    [self.myTableView reloadData];
}

-(void)CalculateRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select count(*) from UL_rider_details where sino = '%@' ", getSINo ];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
               EverRiderCount = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                
            } else {
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}



-(void)RemoveTab{
    [ListOfSubMenu removeObject:@"Quotation"];
    [ListOfSubMenu removeObject:@"Proposal"];
    [ListOfSubMenu removeObject:@"Product Disclosure Sheet"];
    [ListOfSubMenu removeObject:@"   English"];
    [ListOfSubMenu removeObject:@"   Malay"];
}

-(void)clearDataLA
{
    _EverLAController = nil;
    getAge = 0;
    getSex = nil;
    getSmoker = nil;
    getOccpClass = 0;
    getOccpCode = nil;
    getCommDate = nil;
    getIdPay = 0;
    getIdProf = 0;
    getLAIndexNo = 0;
    NameLA = nil;
}

-(void)clearDataPayor
{
    //_PayorController = nil;
    getPayorIndexNo = 0;
    getPaySmoker = nil;
    getPaySex = nil;
    getPayDOB = nil;
    getPayAge = 0;
    getPayOccp = nil;
    NamePayor = nil;
    payorSINo = nil;
}

-(void)clearData2ndLA
{
    //_SecondLAController = nil;
    get2ndLAIndexNo = 0;
    get2ndLASmoker = nil;
    get2ndLASex = nil;
    get2ndLADOB = nil;
    get2ndLAAge = 0;
    get2ndLAOccp = nil;
    Name2ndLA = nil;
    CustCode2 = nil;
}

-(void)clearDataBasic
{
    //_BasicController = nil;
    getSINo = nil;
    getTerm = 0;
    getbasicSA = nil;
    getbasicHL = nil;
    getPlanCode = nil;
    getBasicPlan = nil;
}

-(void)copySIToDoc{
	
}


#pragma mark - delegate
// from LA
-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
	andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate
	   andSmoker:(NSString *)aaSmoker andOccpCPA:(NSString *)aaOccpCPA{
	getAge = aaAge;
    getSex = aaSex;
    getSmoker = aaSmoker;
    getOccpClass = aaOccpClass;
    getOccpCode = aaOccpCode;
    getCommDate = aaCommDate;
    getIdPay = aaIdPayor;
    getIdProf = aaIdProfile;
    getLAIndexNo = aaIndexNo;
	getOccpCPA = aaOccpCPA;
	
	[self getLAName];
	[self.myTableView reloadData];
	if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

//from LA and Basic
-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered
	andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicHLTerm:(int)aaBasicHLTerm
	andBasicHLPct:(NSString *)aaBasicHLPct andBasicHLPctTerm:(int)aaBasicHLPctTerm andPlanCode:(NSString *)aaPlanCode{
	
	NSLog(@"::receive databasicSINo:%@, PlanCode:%@",aaSINo,aaPlanCode);
    getSINo = aaSINo;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getbasicHLPct = aaBasicHLPct;
    getPlanCode = aaPlanCode;
    
    if (getbasicSA.length != 0)
    {
        PlanEmpty = NO;
    }
    
    [self checkingPayor];
    [self checking2ndLA];
    
    [self toogleView];
    if (blocked) {
        [self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        [self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

}

-(void)BasicSARevised:(NSString *)aabasicSA{
	
}

-(void)RiderAdded{
	
}

-(void)PayorDeleted{
	
}

-(void)secondLADelete{
	
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
