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
#import "EverSecondLAViewController.h"
#import "FundAllocationViewController.h"
#import "AppDelegate.h"
#import "EverLifeViewController.h"
#import "demo.h"
#import "BrowserViewController.h"

@interface EverSeriesMasterViewController ()

@end

@implementation EverSeriesMasterViewController
@synthesize EverLAController = _EverLAController;
@synthesize BasicAccount = _BasicAccount;
@synthesize EverRider = _EverRider;
@synthesize EverSecondLA = _EverSecondLA;
@synthesize EverPayor = _EverPayor;
@synthesize EverHLoad = _EverHLoad;
@synthesize EverFund = _EverFund;
@synthesize EverSpecial = _EverSpecial;
@synthesize EverFundMaturity = _EverFundMaturity;
@synthesize ListOfSubMenu, getAge,getCommDate,getIdPay,getIdProf,getLAIndexNo,getOccpClass;
@synthesize getOccpCode,getSex,getSmoker, Name2ndLA,NameLA,NamePayor, get2ndLAAge,get2ndLADOB,get2ndLAIndexNo;
@synthesize get2ndLAOccp,get2ndLASex,get2ndLASmoker,getbasicHL,getBasicPlan,getbasicSA,getbasicHLPct;
@synthesize getPayAge,getPayDOB,getPayOccp,getPayorIndexNo,getPaySex,getPaySmoker,getPlanCode;
@synthesize getSINo,getTerm, payorCustCode, payorSINo, requestSINo2, CustCode2, clientID2;
@synthesize getOccpCPA, getBumpMode, getLADOB, getOccLoading, PDFCreator;
@synthesize FS = _FS;
id EverRiderCount;

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF *)htmlToPDF{
	BrowserViewController *controller = [[BrowserViewController alloc] initWithFilePath:htmlToPDF.PDFpath PDSorSI:PDSorSI];
	if([PDSorSI isEqualToString:@"PDS"]){
		controller.title = [NSString stringWithFormat:@"PDS_%@.pdf",self.getSINo];
		
	}
	else{
		controller.title = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
	}
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    UINavigationController *container = [[UINavigationController alloc] init];
    [container setNavigationBarHidden:YES animated:NO];
    [container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
	
	[spinner_SI stopAnimating ];
	[self.view setUserInteractionEnabled:YES];
	
	UIView *v =  [[self.view subviews] objectAtIndex:[self.view subviews].count - 1 ];
	[v removeFromSuperview];
	v = Nil;
	
	if (previousPath == Nil) {
		previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
	}
	
	[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
	selectedPath = previousPath;
	spinner_SI = Nil;
	
	[self presentModalViewController:container animated:YES];
    container = Nil;
	controller= Nil;
}

-(void)HTMLtoPDFDidFail:(NDHTMLtoPDF *)htmlToPDF{
	NSLog(@"HTMLtoPDF did fail (%@)", htmlToPDF);
}

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
	
	//selectedPath = [NSIndexPath indexPathForRow:0 inSection:0];
	//[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewRowAnimationNone];
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
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
		
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
	
	if (PlanEmpty) {
        cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    }
    else {
        if (indexPath.row == 5) {
            cell.textLabel.text = [[ListOfSubMenu objectAtIndex:indexPath.row] stringByAppendingFormat:@"(%@)", EverRiderCount ];
        }
        else {
            cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
        }
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
	else if (indexPath.row == 1) {
        if (Name2ndLA.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",Name2ndLA];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
	else if (indexPath.row == 2) {
        if (NamePayor.length != 0) {
            NSString *str = [[NSString alloc] initWithFormat:@"%@",NamePayor];
            str = [str substringToIndex:MIN(20, [str length])];
            cell.detailTextLabel.text = str;
        }
        else {
            cell.detailTextLabel.text = @"";
        }
    }
    else {
        cell.detailTextLabel.text = @"";
    }
	
	//cell.textLabel.text = [ListOfSubMenu objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:16];
    cell.textLabel.textAlignment = UITextAlignmentLeft;
	
	cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Trebuchet MS" size:12];
    cell.detailTextLabel.textAlignment = UITextAlignmentLeft;
	
	return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	[activeInstance performSelector:@selector(dismissKeyboard)];
	BOOL bContinue = FALSE;
	
	//NSLog(@"%d", previousPath.row);
	
	if (previousPath.row == 0) { //LA
		if ([self.EverLAController NewDone] == FALSE) {
			bContinue = FALSE;
		}
		else{
			bContinue = TRUE;
		}
		
	}
	else if (previousPath.row == 1) { //second LA
		if (_EverSecondLA != Nil) {
			if ([self.EverSecondLA NewDone] == FALSE) {
				bContinue = FALSE;
			}
			else{
				bContinue = TRUE;
			}
		}
		
	}
	else if (previousPath.row == 1) { //Payor
		
			if ([self.EverPayor NewDone] == FALSE) {
				bContinue = FALSE;
			}
			else{
				bContinue = TRUE;
			}
			
		
		
	}
	else if (previousPath.row == 3) { //basic plan
		if ([self.BasicAccount NewDone] == FALSE) {
			bContinue = FALSE;
		}
		else{
			bContinue = TRUE;
		}
		
	}
	else if (previousPath.row == 4) { //Fund Allocation

			if ([self.EverFund NewDone] == FALSE) {
				bContinue = FALSE;
			}
			else{
				bContinue = TRUE;
			}

		
	}
	else if (previousPath.row == 5) { //Rider
		bContinue = TRUE;
	}
	else if (previousPath.row == 6) { //HL
		if ([self.EverHLoad NewDone] == FALSE) {
			bContinue = FALSE;
		}
		else{
			bContinue = TRUE;
		}
		
	}
	else if (previousPath.row == 7) { //Special Option
		if ([self.EverSpecial NewDone] == FALSE) {
			bContinue = FALSE;
		}
		else{
			bContinue = TRUE;
		}
		
	}
	else if (previousPath.row == 8) { //Fund maturity option

			bContinue = TRUE;
		
	}
	
	
	if (bContinue == TRUE) {
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
		else if (indexPath.row == 1){ //2nd LA
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
				[self select2ndLA];
				[self hideSeparatorLine];
				[self.myTableView reloadData];
				[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			
		}
		else if (indexPath.row == 2){ //payor
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
				[self selectPayor];
				[self hideSeparatorLine];
				[self.myTableView reloadData];
				[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			
		}
		else if (indexPath.row == 3){ //basic plan
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
					[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
				}
				
			}
			
		}
		else if (indexPath.row == 4){ //Fund Allocation
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
				
				self.EverFund = [self.storyboard instantiateViewControllerWithIdentifier:@"EverFund"];
				_EverFund.delegate = self;
				
				self.EverFund.SINo = getSINo;
				self.EverFund.getAge = getAge;
				[self addChildViewController:self.EverFund];
				[self.RightView addSubview:self.EverFund.view];
				previousPath = selectedPath;
				blocked = NO;
				[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			
			
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
					
					self.EverRider.requestBumpMode = getBumpMode;
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
					[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
				}
				
			}
		}
		else if (indexPath.row == 6){ //Health Loading
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
				if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
					self.EverHLoad = [self.storyboard instantiateViewControllerWithIdentifier:@"EverHLoading"];
					_EverHLoad.delegate = self;
					self.EverHLoad.ageClient = getAge;
					self.EverHLoad.SINo = getSINo;
					self.EverHLoad.planChoose = getBasicPlan;
					
					[self addChildViewController:self.EverHLoad];
					[self.RightView addSubview:self.EverHLoad.view];
					
					previousPath = selectedPath;
					blocked = NO;
					[self hideSeparatorLine];
					[self.myTableView reloadData];
					[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
				}
				else {
					NSLog(@"no where!");
					blocked = YES;
				}
			}
		}
		else if (indexPath.row == 7){ //Special Options
			if ([getOccpCode isEqualToString:@"OCC01975"]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
																message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
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
				
				self.EverSpecial = [self.storyboard instantiateViewControllerWithIdentifier:@"EverSpecial"];
				_EverSpecial.delegate = self;
				
				self.EverSpecial.SINo = getSINo;
				self.EverSpecial.getAge = getAge;
				self.EverSpecial.getBasicSA = getbasicSA;
				[self addChildViewController:self.EverSpecial];
				[self.RightView addSubview:self.EverSpecial.view];
				previousPath = selectedPath;
				blocked = NO;
				
			}
			
		}
		else if (indexPath.row == 8){ //Fund Maturity Options
			if ([getOccpCode isEqualToString:@"OCC01975"]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
																message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
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
				self.EverFundMaturity = [self.storyboard instantiateViewControllerWithIdentifier:@"EverFundMaturity"];
				_EverFundMaturity.delegate = self;
				
				self.EverFundMaturity.SINo = getSINo;
				[self addChildViewController:self.EverFundMaturity];
				[self.RightView addSubview:self.EverFundMaturity.view];
				previousPath = selectedPath;
				blocked = NO;
				
			}
		}
		else if (indexPath.row == 9){ //Quotation
			/*
			 AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			 if (![zzz.EverMessage isEqualToString:@""]) {
			 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:zzz.EverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			 alert.tag = 1007;
			 [alert show];
			 zzz.EverMessage = @"";
			 }
			 */
			PDSorSI = @"SI";
			
			if ([getOccpCode isEqualToString:@"OCC01975"]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				alert = Nil;
				if (previousPath == Nil) {
					previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
				}
				
				[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			else if (getAge > 100 ) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 100 for this product."
															   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
				[alert show];
				alert = Nil;
				if (previousPath == Nil) {
					previousPath =	[NSIndexPath indexPathForRow:0 inSection:0];
				}
				
				[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
			}
			else{
				sqlite3_stmt *statement;
				BOOL cont = FALSE;
				
				if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
				{
					// NSString *querySQL = [NSString stringWithFormat:@"SELECT * from SI_Store_Premium "];
					
					NSString *QuerySQL = [ NSString stringWithFormat:@"select \"CovPeriod\", \"BasicSA\"  "
										  "\"HLoading\",  \"sex\" from UL_Details as A, "
										  "Clt_Profile as B, UL_LaPayor as C where A.Sino = C.Sino AND C.custCode = B.custcode AND "
										  "A.sino = \"%@\" AND \"seq\" = 1 ", getSINo];
					
					
					
					if (sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
					{
						if (sqlite3_step(statement) == SQLITE_ROW)
						{
							cont = TRUE;
							
						} else {
							cont = FALSE;
							//NSLog(@"error access SI_Store_Premium");
						}
						sqlite3_finalize(statement);
					}
					sqlite3_close(contactDB);
				}
				
				if (_FS == Nil) {
					self.FS = [FSVerticalTabBarController alloc];
					_FS.delegate = self;
				}
				/*
				 demo *demoPage = [self.storyboard instantiateViewControllerWithIdentifier:@"demo"];
				 demoPage.modalPresentationStyle = UIModalPresentationFullScreen;
				 [self presentViewController:demoPage animated:NO completion:Nil];
				 */
				if (cont == TRUE) {
					
					spinner_SI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
					spinner_SI.center = CGPointMake(400, 350);
					
					//spinner_SI.hidesWhenStopped = YES;
					[self.view addSubview:spinner_SI];
					UILabel *spinnerLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 370, 120, 40) ];
					spinnerLabel.text  = @" Please Wait...";
					spinnerLabel.backgroundColor = [UIColor blackColor];
					spinnerLabel.opaque = YES;
					spinnerLabel.textColor = [UIColor whiteColor];
					[self.view addSubview:spinnerLabel];
					[self.view setUserInteractionEnabled:NO];
					[spinner_SI startAnimating];
					
					
					
					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
						
						EverLifeViewController *UVReport;
						
						//NSLog(@"dadas %@", getBasicPlan);
						if([getPlanCode isEqualToString:@"UV" ]){
							UVReport = [[EverLifeViewController alloc] init ];
							UVReport.SINo = getSINo;
							UVReport.requestOccLoading = getOccLoading;
							UVReport.requestPlanCommDate = getCommDate;
							UVReport.PDSorSI = @"SI";
							UVReport.requestDOB = getLADOB;
							UVReport.requestSexLA = getSex;
							UVReport.requestSmokerLA = getSmoker;
							UVReport.requestOccpClass = getOccpClass;
							UVReport.SimpleOrDetail = @"Detail";
							[self presentViewController:UVReport animated:NO completion:Nil];
						}
						
						[self generateJSON_UV];
						[self copySIToDoc];
						
						dispatch_async(dispatch_get_main_queue(), ^{
							if([getPlanCode isEqualToString:@"UV" ]){
								[UVReport dismissViewControllerAnimated:NO completion:Nil];
							}
							
							NSString *path = [[NSBundle mainBundle] pathForResource:@"EverLife_SI/Page1" ofType:@"html"];
							NSURL *pathURL = [NSURL fileURLWithPath:path];
							NSArray* path_forDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
							NSString* documentsDirectory = [path_forDirectory objectAtIndex:0];
							
							NSData* data = [NSData dataWithContentsOfURL:pathURL];
							[data writeToFile:[NSString stringWithFormat:@"%@/SI_Temp.html",documentsDirectory] atomically:YES];
							
							NSString *HTMLPath = [documentsDirectory stringByAppendingPathComponent:@"SI_Temp.html"];
							
							if([[NSFileManager defaultManager] fileExistsAtPath:HTMLPath]) {
								NSURL *targetURL = [NSURL fileURLWithPath:HTMLPath];
								NSString *SIPDFName = [NSString stringWithFormat:@"%@.pdf",self.getSINo];
								self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:targetURL
																	 pathForPDF:[documentsDirectory stringByAppendingPathComponent:SIPDFName]
																	   delegate:self
																	   pageSize:kPaperSizeA4
																		margins:UIEdgeInsetsMake(0, 0, 0, 0)];
							}
							
						});
					});
					
				}
			}
			
			
		}
		else if (indexPath.row == 11){ //Eng PDS
			AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			if (![zzz.EverMessage isEqualToString:@""]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:zzz.EverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				alert.tag = 1007;
				[alert show];
				zzz.EverMessage = @"";
			}
			else{
				
			}
			
		}
		else if (indexPath.row == 12){ //BM PDS
			AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
			if (![zzz.EverMessage isEqualToString:@""]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:zzz.EverMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
				alert.tag = 1007;
				[alert show];
				zzz.EverMessage = @"";
			}
			else{
				
			}
			
		}
	}
	else{
		[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
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

			self.BasicAccount.requestPlanCommDate = getCommDate;
			
            self.BasicAccount.requestAge = getAge;
            self.BasicAccount.requestOccpCode = getOccpCode;
            self.BasicAccount.requestOccpClass = getOccpClass;
            self.BasicAccount.requestIDPay = getIdPay;
            self.BasicAccount.requestIDProf = getIdProf;
			self.BasicAccount.requestSexLA = getSex;
			self.BasicAccount.requestSmokerLA = getSmoker;
			self.BasicAccount.requestDOB = getLADOB;
			self.BasicAccount.requestOccLoading = getOccLoading;
            
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
            
			self.BasicAccount.requestPlanCommDate = getCommDate;
			
            self.BasicAccount.requestAge = getAge;
            self.BasicAccount.requestOccpCode = getOccpCode;
            self.BasicAccount.requestOccpClass = getOccpClass;
            self.BasicAccount.requestIDPay = getIdPay;
            self.BasicAccount.requestIDProf = getIdProf;
			self.BasicAccount.requestSexLA = getSex;
			self.BasicAccount.requestSmokerLA = getSmoker;
			self.BasicAccount.requestDOB = getLADOB;
			self.BasicAccount.requestOccLoading = getOccLoading;
            
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
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Seq=1",getSINo];
        
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
							  "AND a.PTypeCode=\"LA\" AND a.Seq=2",getSINo];
        
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
		[ListOfSubMenu removeObject:@"Fund Allocation and Others"];
        [ListOfSubMenu removeObject:@"Rider"];
		[ListOfSubMenu removeObject:@"Health Loading"];
		[ListOfSubMenu removeObject:@"Special Options"];
		[ListOfSubMenu removeObject:@"Fund Maturity Options"];
        
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

-(void)select2ndLA
{
    NSLog(@"select 2ndLA:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getAge >= 18 && getAge <=70 && ![getOccpCode isEqualToString:@"(null)"])
    {
        if (_EverSecondLA == nil) {
            self.EverSecondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"EverSecondLA"];
			_EverSecondLA.delegate = self;
        }
        self.EverSecondLA.requestLAIndexNo = getLAIndexNo;
        self.EverSecondLA.requestCommDate = getCommDate;
        self.EverSecondLA.requestSINo = getSINo;
        [self addChildViewController:self.EverSecondLA];
        [self.RightView addSubview:self.EverSecondLA.view];
        
        previousPath = selectedPath;
        blocked = NO;
    }
    else if (getAge > 70) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        blocked = YES;
    }
    else if (getAge < 16 && getOccpCode.length != 0 && ![getOccpCode isEqualToString:@"(null)"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Life Assured" message:@"Life Assured is less than 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        blocked = YES;
    }
    else if (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"]) {
        NSLog(@"no where!");
        blocked = YES;
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
            NSLog(@"with SI");
            
            [self checkingPayor];
            if (payorSINo.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                
                self.EverSecondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                _EverSecondLA.delegate = self;
                self.EverSecondLA.requestLAIndexNo = getLAIndexNo;
                self.EverSecondLA.requestCommDate = getCommDate;
                self.EverSecondLA.requestSINo = getSINo;
                [self addChildViewController:self.EverSecondLA];
                [self.RightView addSubview:self.EverSecondLA.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
        else {
            if (getPayorIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                if (_EverSecondLA == nil) {
                    self.EverSecondLA = [self.storyboard instantiateViewControllerWithIdentifier:@"secondLAView"];
                    _EverSecondLA.delegate = self;
                }
                self.EverSecondLA.requestLAIndexNo = getLAIndexNo;
                self.EverSecondLA.requestCommDate = getCommDate;
                self.EverSecondLA.requestSINo = getSINo;
                [self addChildViewController:self.EverSecondLA];
                [self.RightView addSubview:self.EverSecondLA.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
    }
}

-(void)selectPayor
{
    NSLog(@"select payor:: age:%d, occp:%@, SI:%@",getAge,getOccpCode,getSINo);
    if (getAge >= 18 && ![getOccpCode isEqualToString:@"(null)"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Life Assured's age must not greater or equal to 18 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        blocked = YES;
    }
    else if (getAge < 16 && getOccpCode.length != 0) {
        
        if ([getSINo isEqualToString:@"(null)"] || getSINo.length == 0) {
            
            if (_EverPayor == nil) {
                self.EverPayor = [self.storyboard instantiateViewControllerWithIdentifier:@"EverPayor"];
                _EverPayor.delegate = self;
            }
            self.EverPayor.requestLAIndexNo = getLAIndexNo;
            self.EverPayor.requestLAAge = getAge;
            self.EverPayor.requestCommDate = getCommDate;
            self.EverPayor.requestSINo = getSINo;
            [self addChildViewController:self.EverPayor];
            [self.RightView addSubview:self.EverPayor.view];
        }
        else {
            
            self.EverPayor = [self.storyboard instantiateViewControllerWithIdentifier:@"EverPayor"];
            _EverPayor.delegate = self;
            
            self.EverPayor.requestLAIndexNo = getLAIndexNo;
            self.EverPayor.requestLAAge = getAge;
            self.EverPayor.requestCommDate = getCommDate;
            self.EverPayor.requestSINo = getSINo;
            [self addChildViewController:self.EverPayor];
            [self.RightView addSubview:self.EverPayor.view];
        }
        previousPath = selectedPath;
        blocked = NO;
    }
    else if (getOccpCode.length == 0 || [getOccpCode isEqualToString:@"(null)"]) {
        NSLog(@"no where!");
        blocked = YES;
    }
    else {
        NSLog(@"age 16-17");
        if (getSINo.length != 0 && ![getSINo isEqualToString:@"(null)"]) {
            
            NSLog(@"with SI");
            [self checking2ndLA];
            if (CustCode2.length != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                
                self.EverPayor = [self.storyboard instantiateViewControllerWithIdentifier:@"EverPayor"];
                _EverPayor.delegate = self;
                
                self.EverPayor.requestLAIndexNo = getLAIndexNo;
                self.EverPayor.requestLAAge = getAge;
                self.EverPayor.requestCommDate = getCommDate;
                self.EverPayor.requestSINo = getSINo;
                [self addChildViewController:self.EverPayor];
                [self.RightView addSubview:self.EverPayor.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
        else {
            if (get2ndLAIndexNo != 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payor" message:@"Not allowed as Payor/ 2nd LA has been attached" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                blocked = YES;
            }
            else {
                if (_EverPayor == nil) {
                    self.EverPayor = [self.storyboard instantiateViewControllerWithIdentifier:@"EverPayor"];
                    _EverPayor.delegate = self;
                }
                self.EverPayor.requestLAIndexNo = getLAIndexNo;
                self.EverPayor.requestLAAge = getAge;
                self.EverPayor.requestCommDate = getCommDate;
                self.EverPayor.requestSINo = getSINo;
                [self addChildViewController:self.EverPayor];
                [self.RightView addSubview:self.EverPayor.view];
                
                previousPath = selectedPath;
                blocked = NO;
            }
        }
    }
}


-(void)get2ndLAName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",get2ndLAIndexNo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                Name2ndLA = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSLog(@"name2ndLA:%@",Name2ndLA);
            } else {
                NSLog(@"error access get2ndLAName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPayorName
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName FROM prospect_profile WHERE IndexNo= \"%d\"",getPayorIndexNo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NamePayor = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSLog(@"namePayor:%@",NamePayor);
            } else {
                NSLog(@"error access getPayorName");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}


-(void)RemoveTab{

	[ListOfSubMenu removeObject:@"Fund Allocation and Others"];
	[ListOfSubMenu removeObject:@"Rider"];
	[ListOfSubMenu removeObject:@"Health Loading"];
	[ListOfSubMenu removeObject:@"Special Options"];
	[ListOfSubMenu removeObject:@"Fund Maturity Options"];
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
    _EverSecondLA = nil;
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
    _BasicAccount = nil;
    getSINo = nil;
    getTerm = 0;
    getbasicSA = nil;
    getbasicHL = nil;
    getPlanCode = nil;
    getBasicPlan = nil;
}

#pragma mark - Global save validation
-(BOOL)GlobalValidation{
	
	//Rider Part
	sqlite3_stmt *statement;
	NSMutableArray *Ridercode = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderTerm = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderSumAssured = [[NSMutableArray alloc] init ];
	NSMutableArray *BasicSA = [[NSMutableArray alloc] init ];
	NSMutableArray *MinAge = [[NSMutableArray alloc] init ];
	NSMutableArray *MaxAge = [[NSMutableArray alloc] init ];
	NSMutableArray *MinSA = [[NSMutableArray alloc] init ];
	NSMutableArray *MaxSA = [[NSMutableArray alloc] init ];
	NSMutableArray *MinTerm = [[NSMutableArray alloc] init ];
	NSMutableArray *MaxTerm = [[NSMutableArray alloc] init ];
	NSMutableArray *ExpiryAge = [[NSMutableArray alloc] init ];
	NSMutableArray *RRTUOFrom = [[NSMutableArray alloc] init ];
	NSMutableArray *RRTUOYear = [[NSMutableArray alloc] init ];
	NSMutableArray *RiderToDelete = [[NSMutableArray alloc] init ];
	NSString *OccpCat;
	NSString *querySQL;
	
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
		querySQL = [NSString stringWithFormat:@"select A.RiderCode, A.RiderTerm, A.SumAssured, B.BasicSA, C.minAge, "
							  "C.MaxAge, C.minSA, C.MaxSA, C.MinTerm, C.MaxTerm, C.ExpiryAge, A.RRTUOFromYear, A.RRTUOYear from UL_rider_details as A, ul_details as B, "
							  "ul_rider_mtn as C  where A.sino = B.sino AND A.ridercode = C.ridercode AND A.seq = C.seq AND A.Sino = '%@'", getSINo];
        
        //NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
				[Ridercode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
				[RiderTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
				[RiderSumAssured addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]];
				[BasicSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)]];
				[MinAge addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)]];
				[MaxAge addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)]];
				[MinSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)]];
				[MaxSA addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)]];
				[MinTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)]];
				[MaxTerm addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)]];
				[ExpiryAge addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)]];
				[RRTUOFrom addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)]];
				[RRTUOYear addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)]];
            }
            
            sqlite3_finalize(statement);
        }

		querySQL = [NSString stringWithFormat:@"select OccpCatCode from Adm_OccpCat_Occp where occpcode = '%@' ", getOccpCode];
		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
				OccpCat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
            
            sqlite3_finalize(statement);
        }
		

		sqlite3_close(contactDB);
	}

	NSString *tempRiderCode ;
	NSString *tempRiderTerm ;
	NSString *tempRiderSumAssured ;
	NSString *tempBasicSA ;
	NSString *tempExpiryAge ;
	NSString *tempRRTUOFrom ;
	NSString *tempRRTUOFor ;
	
	for (int i = 0; i < Ridercode.count; i++) {

		tempRiderCode = [Ridercode objectAtIndex:i];
		tempRiderTerm = [RiderTerm objectAtIndex:i];
		tempRiderSumAssured = [RiderSumAssured objectAtIndex:i];
		tempBasicSA = [BasicSA objectAtIndex:i];
		tempExpiryAge = [ExpiryAge objectAtIndex:i];
		tempRRTUOFrom = [RRTUOFrom objectAtIndex:i];
		tempRRTUOFor = [RRTUOYear objectAtIndex:i];
		int NewExpiryAge;
		if ([tempExpiryAge intValue] < 0) {
			NewExpiryAge = 0 -[tempExpiryAge intValue] - getAge;
		}
		else{
			NewExpiryAge = [tempExpiryAge intValue];
		}
		
		/*
		NSString *tempMinAge = [MinAge objectAtIndex:i];
		NSString *tempMaxAge = [MaxAge objectAtIndex:i];
		NSString *tempMinSA = [MinSA objectAtIndex:i];
		NSString *tempMaxSA = [MaxSA objectAtIndex:i];
		NSString *tempMinTerm = [MinTerm objectAtIndex:i];
		NSString *tempMaxTerm = [MaxTerm objectAtIndex:i];
		 */

		// for SA
		if ([tempRiderCode isEqualToString:@"ACIR"]) {
			if ([tempRiderSumAssured doubleValue ] > [tempBasicSA doubleValue ]) {
				[RiderToDelete addObject:tempRiderCode];
			}
		}
		else if ([tempRiderCode isEqualToString:@"DCA"]){
			if ([tempRiderSumAssured doubleValue ] > MIN(5 * [tempBasicSA doubleValue ], 1000000.00)) {
				[RiderToDelete addObject:tempRiderCode];
			}
			else{
				if ([tempRiderTerm doubleValue ] > NewExpiryAge) {
					[RiderToDelete addObject:tempRiderCode];
				}
			}
			
		}
		else if ([tempRiderCode isEqualToString:@"DHI"]){

			// for Term
			if ([tempRiderTerm doubleValue ] > NewExpiryAge) {
				[RiderToDelete addObject:tempRiderCode];
			}
			else{
				// for SA
				if ([OccpCat isEqualToString:@"EMP"]) {
					if ([tempRiderSumAssured doubleValue ] > 800.00) {
						[RiderToDelete addObject:tempRiderCode];
					}
				}
				else if ([OccpCat isEqualToString:@"UNEMP"]) {
					if ([tempRiderSumAssured doubleValue ] > 0.00) {
						[RiderToDelete addObject:tempRiderCode];
					}
				}
				else {
					if ([tempRiderSumAssured doubleValue ] > 200.00) {
						[RiderToDelete addObject:tempRiderCode];
					}
				}
			}
			
			
		}
		else if ([tempRiderCode isEqualToString:@"PA"]){
			if ([tempRiderSumAssured doubleValue ] > 5 * [tempBasicSA doubleValue ]) {
				[RiderToDelete addObject:tempRiderCode];
			}
			else{
				// for Term
				if ([tempRiderTerm doubleValue ] > NewExpiryAge) {
					[RiderToDelete addObject:tempRiderCode];
				}
			}
			
		}

		// for Term
		if ([tempRiderCode isEqualToString:@"CIWP"] || [tempRiderCode isEqualToString:@"LCWP"] ||
			[tempRiderCode isEqualToString:@"PR"] || [tempRiderCode isEqualToString:@"TPDWP"] ){
			if ([tempRiderTerm doubleValue ] > MIN(NewExpiryAge, getTerm)) {
				[RiderToDelete addObject:tempRiderCode];
			}
		}
		else if ([tempRiderCode isEqualToString:@"MR"] || [tempRiderCode isEqualToString:@"TPDMLA"] ||
				 [tempRiderCode isEqualToString:@"WI"]){
			
			if ([tempRiderTerm doubleValue ] > NewExpiryAge) {
				[RiderToDelete addObject:tempRiderCode];
			}
		}
		else if ([tempRiderCode isEqualToString:@"RRTUO"]){
			if ([tempRRTUOFrom doubleValue ] + [tempRRTUOFor doubleValue] > getTerm - 1) {
				[RiderToDelete addObject:tempRiderCode];
			}
		}
		
	}
	
	
	if (RiderToDelete.count > 0) {
		NSString *msg = @"Some Rider(s) has been deleted due to marketing rule.\n";
		NSString *tempQuery = @"";
		for (int i = 0; i < RiderToDelete.count; i++) {
			if (i == RiderToDelete.count - 1) {
				tempQuery = [tempQuery stringByAppendingFormat:@"'%@'", [RiderToDelete objectAtIndex:i]];
			}
			else{
				tempQuery = [tempQuery stringByAppendingFormat:@"'%@',", [RiderToDelete objectAtIndex:i]];
			}
			
			msg = [msg stringByAppendingFormat:@"%d. %@\n", i + 1, [RiderToDelete objectAtIndex:i] ];
		}
		
		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
		{
			querySQL = [NSString stringWithFormat:@"Delete FROM UL_Rider_Details where ridercode in (%@)", tempQuery];
			
			//NSLog(@"%@", querySQL);
			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{
				if (sqlite3_step(statement) == SQLITE_DONE)
				{
					
				}
				sqlite3_finalize(statement);
			}
			
			sqlite3_close(contactDB);
		}
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ever & EverLove Series"
														message:msg delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
		[alert show ];
		[self toogleView];
	}
	
	tempRiderCode = Nil ;
	tempRiderTerm = Nil ;
	tempRiderSumAssured = Nil ;
	tempBasicSA = Nil ;
	tempExpiryAge = Nil ;
	tempRRTUOFrom = Nil ;
	tempRRTUOFor = Nil ;
	Ridercode = Nil;
	RiderTerm = Nil;
	RiderSumAssured = Nil;
	BasicSA = Nil;
	MinAge = Nil;
	MaxAge = Nil;
	MinSA = Nil;
	MaxSA = Nil;
	MinTerm = Nil;
	MaxTerm = Nil;
	ExpiryAge = Nil;
	RRTUOFrom = Nil;
	RRTUOYear = Nil;
	RiderToDelete = Nil;

	
	return TRUE;
}

#pragma mark - delegate
// from LA
-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
		andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate
		andSmoker:(NSString *)aaSmoker andOccpCPA:(NSString *)aaOccpCPA andLADOB:(NSString *)aaLADOB
		andLAOccLoading:(NSString *)aaLAOccLoading{
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
	getLADOB = aaLADOB;
	getOccLoading = aaLAOccLoading;
	
	[self getLAName];
	[self.myTableView reloadData];
	if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
	
}

//from LA and Basic
-(void)BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered
	andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicHLTerm:(int)aaBasicHLTerm
	andBasicHLPct:(NSString *)aaBasicHLPct andBasicHLPctTerm:(int)aaBasicHLPctTerm andPlanCode:(NSString *)aaPlanCode
	andBumpMode:(NSString *)aaBumpMode{
	
	NSLog(@"::receive Ever basicSINo:%@, PlanCode:%@",aaSINo,aaPlanCode);
    getSINo = aaSINo;
    getTerm = aaCovered;
    getbasicSA = aaBasicSA;
    getbasicHL = aaBasicHL;
    getbasicHLPct = aaBasicHLPct;
    getPlanCode = aaPlanCode;
	getBumpMode = aaBumpMode;
	
    if (getbasicSA.length != 0)
    {
        PlanEmpty = NO;
    }
    
    [self checkingPayor];
    [self checking2ndLA];
    
    [self toogleView];
    if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }

}

-(void)BasicSARevised:(NSString *)aabasicSA{
	
}

-(void)RiderAdded{
	NSLog(@"::receive data rider added!");
    [self toogleView];
    if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)PayorDeleted{
	
}

-(void)secondLADelete{
	NSLog(@"::receive data 2ndLA deleted!");
    [self clearData2ndLA];
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)LA2ndIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    NSLog(@"::receive data 2ndLAIndex:%d",aaIndexNo);
    get2ndLAIndexNo = aaIndexNo;
    get2ndLASmoker = aaSmoker;
    get2ndLASex = aaSex;
    get2ndLADOB = aaDOB;
    get2ndLAAge = aaAge;
    get2ndLAOccp = aaOccpCode;
    
    [self get2ndLAName];
    [self.myTableView reloadData];
    if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)saved:(BOOL)aaTrue
{
    saved = aaTrue;
}

-(void)LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
	andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate
	   andSmoker:(NSString *)aaSmoker
{
    NSLog(@"::receive data LAIndex:%d, commDate:%@",aaIndexNo,aaCommDate);
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
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)PayorIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    NSLog(@"::receive data PayorIndex:%d",aaIndexNo);
    getPayorIndexNo = aaIndexNo;
    getPaySmoker = aaSmoker;
    getPaySex = aaSex;
    getPayDOB = aaDOB;
    getPayAge = aaAge;
    getPayOccp = aaOccpCode;
    
    [self getPayorName];
    [self.myTableView reloadData];
    if (blocked) {
        //[self.myTableView selectRowAtIndexPath:previousPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else {
        //[self.myTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void)payorSaved:(BOOL)aaTrue
{
    payorSaved = aaTrue;
}

-(void)HLInsert:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL
{
    NSLog(@"::received EverHL");
    getbasicHL = aaBasicHL;
    getbasicHLPct = aaBasicTempHL;
	
}

-(void)BasicGlobalSave{
	[self GlobalValidation];
}

-(void)FundAllocationGlobalSave{
	[self GlobalValidation];
}

-(void)HLGlobalSave{
	[self GlobalValidation];
}
#pragma mark - Json
-(void)copySIToDoc{
	NSString *directory = @"EverLife_SI";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentSIFolderPath = [documentsDirectory stringByAppendingPathComponent:directory];
    NSString *resourceSIFolderPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:directory];
    
    
    if (![fileManager fileExistsAtPath:documentSIFolderPath]) {
        [fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
    }
	else{
		[fileManager removeItemAtPath:documentSIFolderPath error:&error];
		[fileManager createDirectoryAtPath:documentSIFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
	}
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:resourceSIFolderPath error:&error];
    for (NSString *SIFiles in fileList) {
        NSString *newFilePath = [documentSIFolderPath stringByAppendingPathComponent:SIFiles];
        NSString *oldFilePath = [resourceSIFolderPath stringByAppendingPathComponent:SIFiles];
        [fileManager copyItemAtPath:oldFilePath toPath:newFilePath error:&error];
    }
}


-(void)generateJSON_UV{
	NSArray *paths2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath2 = [paths2 objectAtIndex:0];
    NSString *path2 = [docsPath2 stringByAppendingPathComponent:@"hladb.sqlite"];

	
	FMDatabase *database = [FMDatabase databaseWithPath:path2];
    [database open];
	
	FMResultSet *results;
    NSString *query;
    int totalRecords = 0;
    int currentRecord = 0;
    
    results = [database executeQuery:@"select AgentCode,AgentName from Agent_profile"];
    NSString *agentCode;
    NSString *agentName;
    while([results next]) {
        agentCode = [results stringForColumn:@"AgentCode"];
        agentName  = [results stringForColumn:@"AgentName"];
    }
	
	results = [database executeQuery:[NSString stringWithFormat:@"select Class,OccLoading_UL from Adm_Occp_Loading_Penta where occpcode = '%@'", getOccpCode]];
    NSString *OccpClass;
	NSString *OccpLoading;
    while([results next]) {
		OccpClass = [results stringForColumn:@"Class"];
		OccpLoading = [results stringForColumn:@"OccLoading_UL"];
    }
	
	int TotalPages = 0;
	
	results = [database executeQuery:@"select count(*) as cnt from UL_Temp_Pages"];
	
	if ([results next]) {
        TotalPages = [results intForColumn:@"cnt"];
    }
	
	results = Nil;
	query = [NSString stringWithFormat:@"Select FromYear, ForYear, Amount from UL_TPExcess where SINo ='%@'",getSINo];
	
	results = [database executeQuery:query];
	NSString *TopupStart;
	NSString *TopupEnd;
	NSString *TopupAmount;
	if ( results.next == TRUE) {
		//[results next];
		TopupStart = [NSString stringWithFormat:@"%d", [[results stringForColumnIndex:0] integerValue ] - 1];
		TopupEnd = [NSString stringWithFormat:@"%d", [TopupStart intValue ] + [[results stringForColumnIndex:1] intValue ]];
		TopupAmount = [NSString stringWithFormat:@"%f",[[results stringForColumnIndex:2] doubleValue ]];
	}
	else{
		TopupStart = @"-";
		TopupEnd = @"-";
		TopupAmount = @"-";
	}
	
	results = Nil;
	query = [NSString stringWithFormat:@"Select FromAge, ToAge, YearInt, Amount  from UL_RegWithdrawal where SINo ='%@'",getSINo];
	
	results = [database executeQuery:query];
	NSString *WithdrawAgeFrom;
	NSString *WithdrawAgeTo;
	NSString *WithdrawAmount;
	NSString *WithdrawInterval;
	if ( results.next == TRUE) {
		WithdrawAgeFrom = [results stringForColumnIndex:0];
		WithdrawAgeTo = [results stringForColumnIndex:1];
		WithdrawInterval = [results stringForColumnIndex:2];
		WithdrawAmount = [results stringForColumnIndex:3];

	}
	else{
		WithdrawAgeFrom = @"-";
		WithdrawAgeTo = @"-";
		WithdrawAmount = @"-";
		WithdrawInterval = @"-";
	}
	
	results = Nil;
	query = [NSString stringWithFormat:@"Select RRTUOFromYear, RRTUOYear, Premium from UL_Rider_Details where SINo ='%@' AND ridercode = 'RRTUO'",getSINo];
	
	results = [database executeQuery:query];
	NSString *RRTUOFrom;
	NSString *RRTUOTo;
	NSString *RRTUOAmount;

	if ( results.next == TRUE) {
		RRTUOFrom = [results stringForColumnIndex:0];
		RRTUOTo = [NSString stringWithFormat:@"%d", [[results stringForColumnIndex:1] intValue ] + [RRTUOFrom intValue ] - 1];
		RRTUOAmount = [results stringForColumnIndex:2];
		
	}
	else{
		RRTUOFrom = @"-";
		RRTUOTo = @"-";
		RRTUOAmount = @"-";

	}
	
	query = [NSString stringWithFormat:@"SELECT col8,col9 FROM UL_Temp_ECAR55 where seqno = '1'"];
    results = [database executeQuery:query];
	NSString *Annuity;
	NSString *AnnuityPrem;
	
	if ([results next]) {
		Annuity = [results stringForColumnIndex:0];
		AnnuityPrem = [results stringForColumnIndex:1];
	}
	
	query = [NSString stringWithFormat:@"Select DateModified, ComDate, ATPrem, basicSA, CovPeriod, Hloading, HloadingTerm, "
											"hloadingPct, hloadingPctTerm from UL_Details where SINo ='%@'",getSINo];

	results = [database executeQuery:query];
    NSString *DateModified;
	NSString *ComDate;
	NSString *ATPrem;
	NSString *bSA;
	NSString *CovPeriod;
	NSString *HLoad;
	NSString *HLoadTerm;
	NSString *HLoadPct;
	NSString *HLoadPctTerm;
	
    if ([results next]) {
		DateModified = [results stringForColumnIndex:0];
        ComDate = [results stringForColumnIndex:1];
		ATPrem = [results stringForColumnIndex:2];
		bSA = [results stringForColumnIndex:3];
		CovPeriod = [results stringForColumnIndex:4];
		HLoad = [results stringForColumnIndex:5];
		HLoadTerm = [results stringForColumnIndex:6];
		HLoadPct = [results stringForColumnIndex:7];
		HLoadPctTerm = [results stringForColumnIndex:8];
    }
	
	NSString *jsonFile = [docsPath2 stringByAppendingPathComponent:@"SI.json"];
	NSString *content = @"{\n";
    content = [content stringByAppendingString:@"\"SI\": [\n"];
	
	content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingFormat:@"\"agentCode\":\"%@\",\n", agentCode];
    content = [content stringByAppendingFormat:@"\"agentName\":\"%@\",\n", agentName];
	content = [content stringByAppendingFormat:@"\"DateModified\":\"%@\",\n", DateModified];
	content = [content stringByAppendingFormat:@"\"TotalPages\":\"%d\",\n", TotalPages];
	content = [content stringByAppendingFormat:@"\"ComDate\":\"%@\",\n", ComDate];
	content = [content stringByAppendingFormat:@"\"ATPrem\":\"%@\",\n", ATPrem];
	content = [content stringByAppendingFormat:@"\"BasicSA\":\"%@\",\n", bSA];
	content = [content stringByAppendingFormat:@"\"CovPeriod\":\"%@\",\n", CovPeriod];
	content = [content stringByAppendingFormat:@"\"HLoad\":\"%@\",\n", HLoad];
	content = [content stringByAppendingFormat:@"\"HLoadTerm\":\"%@\",\n", HLoadTerm];
	content = [content stringByAppendingFormat:@"\"HLoadPct\":\"%@\",\n", HLoadPct];
	content = [content stringByAppendingFormat:@"\"HLoadPctTerm\":\"%@\",\n", HLoadPctTerm];
	content = [content stringByAppendingFormat:@"\"TopupStart\":\"%@\",\n", TopupStart];
	content = [content stringByAppendingFormat:@"\"TopupEnd\":\"%@\",\n", TopupEnd];
	content = [content stringByAppendingFormat:@"\"TopupAmount\":\"%@\",\n", TopupAmount];
	content = [content stringByAppendingFormat:@"\"WithdrawAgeFrom\":\"%@\",\n", WithdrawAgeFrom];
	content = [content stringByAppendingFormat:@"\"WithdrawAgeTo\":\"%@\",\n", WithdrawAgeTo];
	content = [content stringByAppendingFormat:@"\"WithdrawAmount\":\"%@\",\n", WithdrawAmount];
	content = [content stringByAppendingFormat:@"\"WithdrawInterval\":\"%@\",\n", WithdrawInterval];
	content = [content stringByAppendingFormat:@"\"RRTUOFrom\":\"%@\",\n", RRTUOFrom];
	content = [content stringByAppendingFormat:@"\"RRTUOTo\":\"%@\",\n", RRTUOTo];
	content = [content stringByAppendingFormat:@"\"RRTUOAmount\":\"%@\",\n", RRTUOAmount];
	content = [content stringByAppendingFormat:@"\"Annuity\":\"%@\",\n", Annuity];
	content = [content stringByAppendingFormat:@"\"AnnuityPrem\":\"%@\",\n", AnnuityPrem];
	content = [content stringByAppendingFormat:@"\"SINo\":\"%@\",\n", getSINo];
	if ([OccpClass integerValue ] > 4) {
		content = [content stringByAppendingFormat:@"\"OccpClass\":\" Class D\",\n"];
	}
	else{
		content = [content stringByAppendingFormat:@"\"OccpClass\":\"%@\",\n", OccpClass ];
	}
	if ([OccpLoading integerValue ] > 0) {
		content = [content stringByAppendingFormat:@"\"OccpLoading\":\"%@\",\n", OccpLoading ];
	}
	else{
		content = [content stringByAppendingFormat:@"\"OccpLoading\":\"STD\",\n" ];
	}
	
	//UL_Temp_Trad_LA start
    totalRecords = 0;
    currentRecord = 0;
    
    query = [NSString stringWithFormat:@"Select count(*) as cnt from UL_Temp_Trad_LA where SINo ='%@'",getSINo];
    results = [database executeQuery:query];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"Select LADesc,LADescM,Name,Age,Sex,Smoker,PTypeCode from UL_Temp_trad_LA where SINo ='%@'",getSINo];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_trad_LA\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"LADesc\":\"%@\",\n", [results stringForColumn:@"LADesc"]];
        content = [content stringByAppendingFormat:@"\"LADescM\":\"%@\",\n", [results stringForColumn:@"LADescM"]];
        content = [content stringByAppendingFormat:@"\"Name\":\"%@\",\n", [results stringForColumn:@"Name"]];
        content = [content stringByAppendingFormat:@"\"Age\":\"%@\",\n", [results stringForColumn:@"Age"]];
        content = [content stringByAppendingFormat:@"\"Sex\":\"%@\",\n", [results stringForColumn:@"Sex"]];
        content = [content stringByAppendingFormat:@"\"Smoker\":\"%@\",\n", [results stringForColumn:@"Smoker"]];
        content = [content stringByAppendingFormat:@"\"PTypeCode\":\"%@\"\n", [results stringForColumn:@"PTypeCode"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //UL_Temp_Trad_LA end
	
	//UL_Temp_Pages start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from UL_Temp_Pages"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
	
	if (totalRecords == 0) {
		NSLog(@"generate json - no data found in UL_Temp_Pages ");
	}
	
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM UL_Temp_Pages ORDER BY PageNum"];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_Pages\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"htmlName\":\"%@\",\n", [results stringForColumn:@"htmlName"]];
        content = [content stringByAppendingFormat:@"\"PageNum\":\"%@\",\n", [results stringForColumn:@"PageNum"]];
        content = [content stringByAppendingFormat:@"\"PageDesc\":\"%@\",\n", [results stringForColumn:@"PageDesc"]];
        content = [content stringByAppendingFormat:@"\"riders\":\"%@\"\n", [results stringForColumn:@"riders"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Pages end
	
	//UL_Temp_Fund start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery: [NSString stringWithFormat:@"select count(*) as cnt from UL_Fund_Maturity_Option Where sino = '%@'", getSINo]];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
	
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM UL_Fund_Maturity_Option Where sino = '%@' order by Fund", getSINo];
    results = [database executeQuery:query];
    
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_Fund\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"Fund\":\"%@\",\n", [results stringForColumn:@"Fund"]];
        content = [content stringByAppendingFormat:@"\"Option\":\"%@\",\n", [results stringForColumn:@"option"]];
        content = [content stringByAppendingFormat:@"\"Partial\":\"%@\",\n", [results stringForColumn:@"Partial_Withd_Pct"]];
		content = [content stringByAppendingFormat:@"\"Fund2025\":\"%@\",\n", [results stringForColumn:@"EverGreen2025"]];
		content = [content stringByAppendingFormat:@"\"Fund2028\":\"%@\",\n", [results stringForColumn:@"EverGreen2028"]];
		content = [content stringByAppendingFormat:@"\"Fund2030\":\"%@\",\n", [results stringForColumn:@"EverGreen2030"]];
		content = [content stringByAppendingFormat:@"\"Fund2035\":\"%@\",\n", [results stringForColumn:@"EverGreen2035"]];
		content = [content stringByAppendingFormat:@"\"CashFund\":\"%@\",\n", [results stringForColumn:@"CashFund"]];
        content = [content stringByAppendingFormat:@"\"RetireFund\":\"%@\"\n", [results stringForColumn:@"RetireFund"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //UL_Temp_Fund end
	
	
	//UL_Temp_Trad_Details start
    totalRecords = 0;
    currentRecord = 0;
    
    query = [NSString stringWithFormat:@"Select count(*) as cnt from UL_Rider_Details where SINo ='%@'",getSINo];
    results = [database executeQuery:query];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"Select RiderCode, RiderDesc, PTypeCode, Seq, RiderTerm, SumAssured, Units, "
										"PlanOption, HLoading, HLoadingTerm, HLoadingPct, HLoadingPctTerm, Premium, "
										"PaymentTerm, Deductible, RRTUOFromYear,RRTUOYear from UL_Rider_Details where SINo ='%@' ORDER BY RiderCode",getSINo];
	
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_trad_Details\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"RiderCode\":\"%@\",\n", [results stringForColumn:@"RiderCode"]];
        content = [content stringByAppendingFormat:@"\"RiderDesc\":\"%@\",\n", [results stringForColumn:@"RiderDesc"]];
		
		if ([[results stringForColumn:@"PTypeCode" ] isEqualToString:@"LA"]) {
			if ([[results stringForColumn:@"Seq" ] isEqualToString:@"1" ]) {
				content = [content stringByAppendingFormat:@"\"InsuredLives\":\"1st Life Assured\",\n" ];
			}
			else{
				content = [content stringByAppendingFormat:@"\"InsuredLives\":\"2nd Life Assured\",\n"];
			}
		}
		else{
			content = [content stringByAppendingFormat:@"\"InsuredLives\":\"Payor\",\n"];	
		}

        content = [content stringByAppendingFormat:@"\"SumAssured\":\"%@\",\n", [results stringForColumn:@"SumAssured"]];
        content = [content stringByAppendingFormat:@"\"CovPeriod\":\"%@\",\n", [results stringForColumn:@"RiderTerm"]];
        content = [content stringByAppendingFormat:@"\"PaymentTerm\":\"%@\",\n", [results stringForColumn:@"PaymentTerm"]];
        content = [content stringByAppendingFormat:@"\"AnnualTarget\":\"%@\",\n", [results stringForColumn:@"Premium"]];
		content = [content stringByAppendingFormat:@"\"AnnualLoading\":\"%@\",\n", @"0.00"];
		content = [content stringByAppendingFormat:@"\"RiderHLoading\":\"%@\",\n", [results stringForColumn:@"HLoading"]];
		content = [content stringByAppendingFormat:@"\"RiderHLoadingTerm\":\"%@\",\n", [results stringForColumn:@"HLoadingTerm"]];
		content = [content stringByAppendingFormat:@"\"RiderHLoadingPct\":\"%@\",\n", [results stringForColumn:@"HLoadingPct"]];
		content = [content stringByAppendingFormat:@"\"RiderHLoadingPctTerm\":\"%@\",\n", [results stringForColumn:@"HLoadingPctTerm"]];
		content = [content stringByAppendingFormat:@"\"TotalPremium\":\"%@\",\n", [results stringForColumn:@"Premium"]];
		content = [content stringByAppendingFormat:@"\"PlanOption\":\"%@\",\n", [results stringForColumn:@"PlanOption"]];
		content = [content stringByAppendingFormat:@"\"Deductible\":\"%@\",\n", [results stringForColumn:@"Deductible"]];
		content = [content stringByAppendingFormat:@"\"RRTUOFromYear\":\"%@\",\n", [results stringForColumn:@"RRTUOFromYear"]];
		content = [content stringByAppendingFormat:@"\"RRTUOYear\":\"%@\"\n", [results stringForColumn:@"RRTUOYear"]];
		
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //UL_Temp_Trad_Details end

	//UL_Temp_Trad_Basic start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from UL_Temp_Trad_Basic where DataType = 'DATA'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    
	if (totalRecords == 0) {
		NSLog(@"generate json - no data found in UL_Temp_Trad_Basic ");
	}
	
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT col0_1,col0_2,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10 "
										",col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22, "
										"col23,col24,col25,col26,col27,col28,col29,col30,col31 FROM UL_Temp_Trad_Basic where DataType = 'DATA'"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_Trad_Basic\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\",\n", [results stringForColumn:@"col12"]];
        content = [content stringByAppendingFormat:@"\"col13\":\"%@\",\n", [results stringForColumn:@"col13"]];
        content = [content stringByAppendingFormat:@"\"col14\":\"%@\",\n", [results stringForColumn:@"col14"]];
        content = [content stringByAppendingFormat:@"\"col15\":\"%@\",\n", [results stringForColumn:@"col15"]];
        content = [content stringByAppendingFormat:@"\"col16\":\"%@\",\n", [results stringForColumn:@"col16"]];
        content = [content stringByAppendingFormat:@"\"col17\":\"%@\",\n", [results stringForColumn:@"col17"]];
        content = [content stringByAppendingFormat:@"\"col18\":\"%@\",\n", [results stringForColumn:@"col18"]];
        content = [content stringByAppendingFormat:@"\"col19\":\"%@\",\n", [results stringForColumn:@"col19"]];
        content = [content stringByAppendingFormat:@"\"col20\":\"%@\",\n", [results stringForColumn:@"col20"]];
        content = [content stringByAppendingFormat:@"\"col21\":\"%@\",\n", [results stringForColumn:@"col21"]];
        content = [content stringByAppendingFormat:@"\"col22\":\"%@\",\n", [results stringForColumn:@"col22"]];
        content = [content stringByAppendingFormat:@"\"col23\":\"%@\",\n", [results stringForColumn:@"col23"]];
		content = [content stringByAppendingFormat:@"\"col24\":\"%@\",\n", [results stringForColumn:@"col24"]];
        content = [content stringByAppendingFormat:@"\"col25\":\"%@\",\n", [results stringForColumn:@"col25"]];
        content = [content stringByAppendingFormat:@"\"col26\":\"%@\",\n", [results stringForColumn:@"col26"]];
        content = [content stringByAppendingFormat:@"\"col27\":\"%@\",\n", [results stringForColumn:@"col27"]];
        content = [content stringByAppendingFormat:@"\"col28\":\"%@\",\n", [results stringForColumn:@"col28"]];
        content = [content stringByAppendingFormat:@"\"col29\":\"%@\",\n", [results stringForColumn:@"col29"]];
        content = [content stringByAppendingFormat:@"\"col30\":\"%@\",\n", [results stringForColumn:@"col30"]];
        content = [content stringByAppendingFormat:@"\"col31\":\"%@\"\n", [results stringForColumn:@"col31"]];

        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Trad_Basic end
    
	//SI_Temp_Trad_Rider start
    content = [content stringByAppendingString:@"\"UL_Temp_Trad_Rider\":{\n"];
    //page1 start
    content = [content stringByAppendingString:@"\"p1\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM UL_Temp_Trad_Rider where PageNo = '1' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM UL_Temp_Trad_Rider where PageNo = '1' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"],\n"];
    //page1 end
    
    //page2 start
    content = [content stringByAppendingString:@"\"p2\":[\n"];
    content = [content stringByAppendingString:@"{\n"];
    content = [content stringByAppendingString:@"\"data\":[\n"];
    
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"SELECT count(*) as cnt FROM UL_Temp_Trad_Rider where PageNo = '8' order by CAST(SeqNo AS INT) asc"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT * FROM UL_Temp_Trad_Rider where PageNo = '8' order by CAST(SeqNo AS INT) asc"];
    results = [database executeQuery:query];
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"SeqNo\":\"%@\",\n", [results stringForColumn:@"SeqNo"]];
        content = [content stringByAppendingFormat:@"\"DataType\":\"%@\",\n", [results stringForColumn:@"DataType"]];
        content = [content stringByAppendingFormat:@"\"PageNo\":\"%@\",\n", [results stringForColumn:@"PageNo"]];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\"\n", [results stringForColumn:@"col12"]];
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"]\n"];
    //page2 end
    
    content = [content stringByAppendingString:@"},\n"];
    //UL_Temp_Trad_Rider end
    
	//UL_Temp_ECAR55 start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from UL_Temp_ECAR55 where DataType = 'DATA'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT col0_1,col0_2,col1,col2,col3,col4,col5,col6,col7 FROM UL_Temp_ECAR55 where DataType = 'DATA'"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_ECAR55\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\"\n", [results stringForColumn:@"col7"]];

		
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_ECAR55 end

	//UL_Temp_ECAR1 start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from UL_Temp_ECAR where DataType = 'DATA'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }
    
    results = Nil;
    query = [NSString stringWithFormat:@"SELECT col0_1,col0_2,col1,col2,col3,col4,col5,col6,col7,col8 FROM UL_Temp_ECAR where DataType = 'DATA'"];
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_ECAR\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
		content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\"\n", [results stringForColumn:@"col8"]];
		
		
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_ECAR1 end

	//UL_Temp_Summary start
    totalRecords = 0;
    currentRecord = 0;
    results = [database executeQuery:@"select count(*) as cnt from UL_Temp_Summary where DataType = 'DATA'"];
    if ([results next]) {
        totalRecords = [results intForColumn:@"cnt"];
    }

    results = Nil;
    query = [NSString stringWithFormat:@"SELECT col0_1,col0_2,col1,col2,col3,col4,col5,col6,col7,col8,col9,col10 "
			 ",col11,col12,col13,col14,col15,col16,col17,col18,col19,col20,col21,col22, "
			 "col23,col24,col25,col26,col27,col28,col29,col30,col31 FROM UL_Temp_Summary where DataType = 'DATA'"];
	
    results = [database executeQuery:query];
    if (results != Nil){
        content = [content stringByAppendingString:@"\"UL_Temp_Summary\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
    }
    while([results next]) {
        currentRecord++;
        content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"col0_1\":\"%@\",\n", [results stringForColumn:@"col0_1"]];
        content = [content stringByAppendingFormat:@"\"col0_2\":\"%@\",\n", [results stringForColumn:@"col0_2"]];
        content = [content stringByAppendingFormat:@"\"col1\":\"%@\",\n", [results stringForColumn:@"col1"]];
        content = [content stringByAppendingFormat:@"\"col2\":\"%@\",\n", [results stringForColumn:@"col2"]];
        content = [content stringByAppendingFormat:@"\"col3\":\"%@\",\n", [results stringForColumn:@"col3"]];
        content = [content stringByAppendingFormat:@"\"col4\":\"%@\",\n", [results stringForColumn:@"col4"]];
        content = [content stringByAppendingFormat:@"\"col5\":\"%@\",\n", [results stringForColumn:@"col5"]];
        content = [content stringByAppendingFormat:@"\"col6\":\"%@\",\n", [results stringForColumn:@"col6"]];
        content = [content stringByAppendingFormat:@"\"col7\":\"%@\",\n", [results stringForColumn:@"col7"]];
        content = [content stringByAppendingFormat:@"\"col8\":\"%@\",\n", [results stringForColumn:@"col8"]];
        content = [content stringByAppendingFormat:@"\"col9\":\"%@\",\n", [results stringForColumn:@"col9"]];
        content = [content stringByAppendingFormat:@"\"col10\":\"%@\",\n", [results stringForColumn:@"col10"]];
        content = [content stringByAppendingFormat:@"\"col11\":\"%@\",\n", [results stringForColumn:@"col11"]];
        content = [content stringByAppendingFormat:@"\"col12\":\"%@\",\n", [results stringForColumn:@"col12"]];
        content = [content stringByAppendingFormat:@"\"col13\":\"%@\",\n", [results stringForColumn:@"col13"]];
        content = [content stringByAppendingFormat:@"\"col14\":\"%@\",\n", [results stringForColumn:@"col14"]];
        content = [content stringByAppendingFormat:@"\"col15\":\"%@\",\n", [results stringForColumn:@"col15"]];
        content = [content stringByAppendingFormat:@"\"col16\":\"%@\",\n", [results stringForColumn:@"col16"]];
        content = [content stringByAppendingFormat:@"\"col17\":\"%@\",\n", [results stringForColumn:@"col17"]];
        content = [content stringByAppendingFormat:@"\"col18\":\"%@\",\n", [results stringForColumn:@"col18"]];
        content = [content stringByAppendingFormat:@"\"col19\":\"%@\",\n", [results stringForColumn:@"col19"]];
        content = [content stringByAppendingFormat:@"\"col20\":\"%@\",\n", [results stringForColumn:@"col20"]];
        content = [content stringByAppendingFormat:@"\"col21\":\"%@\",\n", [results stringForColumn:@"col21"]];
        content = [content stringByAppendingFormat:@"\"col22\":\"%@\",\n", [results stringForColumn:@"col22"]];
        content = [content stringByAppendingFormat:@"\"col23\":\"%@\",\n", [results stringForColumn:@"col23"]];
		content = [content stringByAppendingFormat:@"\"col24\":\"%@\",\n", [results stringForColumn:@"col24"]];
        content = [content stringByAppendingFormat:@"\"col25\":\"%@\",\n", [results stringForColumn:@"col25"]];
        content = [content stringByAppendingFormat:@"\"col26\":\"%@\",\n", [results stringForColumn:@"col26"]];
        content = [content stringByAppendingFormat:@"\"col27\":\"%@\",\n", [results stringForColumn:@"col27"]];
        content = [content stringByAppendingFormat:@"\"col28\":\"%@\",\n", [results stringForColumn:@"col28"]];
        content = [content stringByAppendingFormat:@"\"col29\":\"%@\",\n", [results stringForColumn:@"col29"]];
        content = [content stringByAppendingFormat:@"\"col30\":\"%@\",\n", [results stringForColumn:@"col30"]];
        content = [content stringByAppendingFormat:@"\"col31\":\"%@\"\n", [results stringForColumn:@"col31"]];
		
        if (currentRecord == totalRecords){ //last record
            content = [content stringByAppendingString:@"}\n"];
        }
        else{
            content = [content stringByAppendingString:@"},\n"];
        }
    }
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"},\n"];
    //SI_Temp_Summary end
    
	
	//page3 start
    totalRecords = 0;
    currentRecord = 0;
    
	NSDateFormatter* df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd/MM/yyyy"];
	NSDate* now =  [NSDate date];
	NSString* ccc = [df stringFromDate:now];
	NSDate* d = [df dateFromString:ccc];
	NSDate* d2 = [df dateFromString:@"26/12/2023"];
	NSDate* d3 = [df dateFromString:@"26/12/2025"];
	NSDate* d4 = [df dateFromString:@"26/12/2028"];
	NSDate* d5 = [df dateFromString:@"26/12/2030"];
	NSDate* d6 = [df dateFromString:@"26/12/2035"];
	NSDate *fromDate;
	NSDate *toDate2;
	NSDate *toDate3;
	NSDate *toDate4;
	NSDate *toDate5;
	NSDate *toDate6;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
				 interval:NULL forDate:d];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate2
				 interval:NULL forDate:d2];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate3
				 interval:NULL forDate:d3];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate4
				 interval:NULL forDate:d4];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate5
				 interval:NULL forDate:d5];
	[calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate6
				 interval:NULL forDate:d6];
	
	NSDateComponents *difference2 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate2 options:0];
	NSDateComponents *difference3 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate3 options:0];
	NSDateComponents *difference4 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate4 options:0];
	NSDateComponents *difference5 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate5 options:0];
	NSDateComponents *difference6 = [calendar components:NSDayCalendarUnit
												fromDate:fromDate toDate:toDate6 options:0];
	
	
	NSString *round2 = [NSString stringWithFormat:@"%.2f", [difference2 day]/365.25];
	NSString *round3 = [NSString stringWithFormat:@"%.2f", [difference3 day]/365.25];
	NSString *round4 = [NSString stringWithFormat:@"%.2f", [difference4 day]/365.25];
	NSString *round5 = [NSString stringWithFormat:@"%.2f", [difference5 day]/365.25];
	NSString *round6 = [NSString stringWithFormat:@"%.2f", [difference6 day]/365.25];
	
	
	double YearDiff2023 = [round2 doubleValue];
	double YearDiff2025 = [round3 doubleValue];
	double YearDiff2028 = [round4 doubleValue];
	double YearDiff2030 = [round5 doubleValue];
	double YearDiff2035 = [round6 doubleValue];
	
	query = [NSString stringWithFormat:@"Select VU2023,VU2025,VU2028,VU2030,VU2035,VUCash,VURet,VURetOpt, VUCashOpt From UL_Details "
				" WHERE sino = '%@'", getSINo];
	
    results = [database executeQuery:query];
    if (results != Nil){
		[results next];
        content = [content stringByAppendingString:@"\"UL_Page3\":{\n"];
        content = [content stringByAppendingString:@"\"data\":[\n"];
		content = [content stringByAppendingString:@"{\n"];
        content = [content stringByAppendingFormat:@"\"VU2023\":\"%@\",\n", [results stringForColumn:@"VU2023"]];
        content = [content stringByAppendingFormat:@"\"VU2025\":\"%@\",\n", [results stringForColumn:@"VU2025"]];
        content = [content stringByAppendingFormat:@"\"VU2028\":\"%@\",\n", [results stringForColumn:@"VU2028"]];
        content = [content stringByAppendingFormat:@"\"VU2030\":\"%@\",\n", [results stringForColumn:@"VU2030"]];
        content = [content stringByAppendingFormat:@"\"VU2035\":\"%@\",\n", [results stringForColumn:@"VU2035"]];
        content = [content stringByAppendingFormat:@"\"VURet\":\"%@\",\n", [results stringForColumn:@"VURet"]];
		content = [content stringByAppendingFormat:@"\"VUCash\":\"%@\",\n", [results stringForColumn:@"VUCash"]];
		content = [content stringByAppendingFormat:@"\"YearDiff2023\":\"%f\",\n", YearDiff2023 ];
		content = [content stringByAppendingFormat:@"\"YearDiff2025\":\"%f\",\n", YearDiff2025 ];
		content = [content stringByAppendingFormat:@"\"YearDiff2028\":\"%f\",\n", YearDiff2028 ];
		content = [content stringByAppendingFormat:@"\"YearDiff2030\":\"%f\",\n", YearDiff2030 ];
		content = [content stringByAppendingFormat:@"\"YearDiff2035\":\"%f\"\n", YearDiff2035 ];
		content = [content stringByAppendingString:@"}\n"];
    }
	
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}\n"];
    //page3 end


	
	content = [content stringByAppendingString:@"}\n"];
    content = [content stringByAppendingString:@"]\n"];
    content = [content stringByAppendingString:@"}"];
	
	[content writeToFile:jsonFile atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    [database close];

	
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
