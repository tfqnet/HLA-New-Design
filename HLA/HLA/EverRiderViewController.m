//
//  EverRiderViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverRiderViewController.h"
#import "ColorHexCode.h"
#import "AppDelegate.h"

@interface EverRiderViewController ()

@end

@implementation EverRiderViewController
@synthesize requestAge,requestBasicHL,requestBasicHLPct,requestBasicSA,requestCoverTerm,requestOccpClass;
@synthesize requestOccpCode,requestPlanCode,requestSex,requestSINo, getAge,getPlanCode,getBasicHL;
@synthesize getSINo,getBasicHLPct,getBasicSA,getOccpClass,getOccpCode,getSex,getTerm;
@synthesize pTypeAge,pTypeCode,pTypeDesc,pTypeOccp, PTypeSeq, riderCode, riderDesc;
@synthesize outletDeductible,outletPersonType,outletRider,outletRiderPlan;
@synthesize lbl1,lbl2,lbl3,lbl4,lbl5,lbl6,lbl7,lbl8,lblRegular1,lblRegular2,lblRegularTerm,lblRegularTerm2;
@synthesize lblTable1,lblTable2,lblTable3,lblTable4,lblTable5,lblTable6,lblTable7;
@synthesize lblTable8,lblTable9, myScrollView, myTableView, outletDelete, outletEdit;
@synthesize LTempRidHL1K,LAge,LDeduct,LOccpCode,LPlanOpt,LRiderCode,LRidHL100,LRidHL100Term,LRidHL1K,LRidHLP;
@synthesize LRidHLPTerm,LRidHLTerm,LSex,LSmoker,LSumAssured,LTempRidHLTerm,LTerm,LTypeAge,LTypeDeduct,LTypeOccpCode;
@synthesize LTypePlanOpt,LTypeRiderCode,LTypeRidHL100,LTypeRidHL100Term,LTypeRidHL1K,LTypeRidHLP,LTypeRidHLPTerm;
@synthesize LTypeRidHLTerm,LTypeSex,LTypeSmoker,LTypeSumAssured,LTypeTempRidHL1K,LTypeTempRidHLTerm,LTypeTerm;
@synthesize LTypeUnits, occClass, occLoadType;
@synthesize delegate = _delegate;
@synthesize RiderList = _RiderList;
@synthesize RiderListPopover = _RiderListPopover;
@synthesize planPopover = _planPopover;
@synthesize deducPopover = _deducPopover;
@synthesize planList = _planList;
@synthesize deductList = _deductList;
@synthesize PTypeList = _PTypeList;
@synthesize pTypePopOver = _pTypePopOver;



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
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"HLA_Rates.sqlite"]];
    
    //--------- edited by heng
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.MhiMessage = @"";
    //-----------
	
	getSINo = [self.requestSINo description];
    getPlanCode = [self.requestPlanCode description];
    getAge = self.requestAge;
    getSex = [self.requestSex description];
    getTerm = self.requestCoverTerm;
    getBasicSA = [[self.requestBasicSA description] doubleValue];
    getBasicHL = [[self.requestBasicHL description] doubleValue];
    getBasicHLPct = [[self.requestBasicHLPct description] doubleValue];
    getOccpClass = self.requestOccpClass;
    getOccpCode = [self.requestOccpCode description];
	
	outletDeductible.hidden = YES;
	outletRiderPlan.hidden =YES;
	PtypeChange = NO;
	
	if (requestSINo) {
        self.PTypeList = [[RiderPTypeTbViewController alloc]initWithString:getSINo];
        _PTypeList.delegate = self;
        pTypeCode = [[NSString alloc] initWithFormat:@"%@",self.PTypeList.selectedCode];
        PTypeSeq = [self.PTypeList.selectedSeqNo intValue];
        pTypeDesc = [[NSString alloc] initWithFormat:@"%@",self.PTypeList.selectedDesc];
        pTypeAge = [self.PTypeList.selectedAge intValue];
        pTypeOccp = [[NSString alloc] initWithFormat:@"%@",self.PTypeList.selectedOccp];
        [self.outletPersonType setTitle:pTypeDesc forState:UIControlStateNormal];
    }
    _PTypeList = nil;
	
	ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
	
	CGRect frame=CGRectMake(53,454, 80, 50);
	lblTable1.text = @"Rider";
	lblTable1.frame = frame;
	lblTable1.textAlignment = UITextAlignmentCenter;
	lblTable1.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable1.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	lblTable1.numberOfLines = 2;
	
	CGRect frame2=CGRectMake(133,454, 105, 50);
	lblTable2.frame = frame2;
	lblTable2.textAlignment = UITextAlignmentCenter;
	lblTable2.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable2.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(238,454, 62, 50);
	lblTable3.frame = frame3;
	lblTable3.textAlignment = UITextAlignmentCenter;
	lblTable3.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable3.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(300,454, 62, 50);
	lblTable4.frame = frame4;
	lblTable4.textAlignment = UITextAlignmentCenter;
	lblTable4.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable4.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(362,454, 62, 50);
	lblTable5.text = @"Occ \nClass";
	lblTable5.frame = frame5;
	lblTable5.textAlignment = UITextAlignmentCenter;
	lblTable5.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable5.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	lblTable5.numberOfLines = 2;
	
    CGRect frame6=CGRectMake(424,454, 62, 50);
	lblTable6.text = @"Occp \nLoading";
	lblTable6.frame = frame6;
	lblTable6.textAlignment = UITextAlignmentCenter;
	lblTable6.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable6.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	lblTable6.numberOfLines = 2;
    
    CGRect frame7=CGRectMake(486,454, 63, 50);
	lblTable7.text = @"HL 1";
	lblTable7.frame = frame7;
	lblTable7.textAlignment = UITextAlignmentCenter;
	lblTable7.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable7.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame8=CGRectMake(549,454, 63, 50);
	lblTable8.text = @"HL 1\nTerm";
	lblTable8.frame = frame8;
	lblTable8.textAlignment = UITextAlignmentCenter;
	lblTable8.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable8.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	lblTable8.numberOfLines = 2;
    
    CGRect frame9=CGRectMake(612,454, 63, 50);
	lblTable9.text = @"HL 2";
	lblTable9.frame = frame9;
	lblTable9.textAlignment = UITextAlignmentCenter;
	lblTable9.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
	lblTable9.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
	myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.separatorColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
	myTableView.delegate = self;
	myTableView.dataSource = self;
    [self.view addSubview:myTableView];
	
	[outletEdit setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [outletEdit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outletEdit.titleLabel.shadowColor = [UIColor lightGrayColor];
    outletEdit.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    [outletDelete setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [outletDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	outletDelete.titleLabel.shadowColor = [UIColor lightGrayColor];
    outletDelete.titleLabel.shadowOffset = CGSizeMake(0, -1);
	
	ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
	 self.headerTitle.frame = CGRectMake(320, -20, 128, 44);
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

#pragma mark - keyboard display

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
	Edit = TRUE;
    self.myScrollView.frame = CGRectMake(0, 44, 768, 453-100);
    self.myScrollView.contentSize = CGSizeMake(768, 413);
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    //minDisplayLabel.text = @"";
    //maxDisplayLabel.text = @"";
    
    self.myScrollView.frame = CGRectMake(0, 44, 768, 453);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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
	return  YES;
}

#pragma mark - logic cycle

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setOutletPersonType:nil];
	[self setOutletRider:nil];
	[self setTxtRiderTerm:nil];
	[self setOutletRiderPlan:nil];
	[self setActionRiderPlan:nil];
	[self setTxtPaymentTerm:nil];
	[self setOutletDeductible:nil];
	[self setTxtReinvestment:nil];
	[self setTxtRRTUP:nil];
	[self setTxtRRTUPTerm:nil];
	[self setTxtSumAssured:nil];
	[self setTxtGYIFrom:nil];
	[self setTxtOccpLoad:nil];
	[self setTxtHL:nil];
	[self setTxtHLTerm:nil];
	[self setTxtRiderPremium:nil];
	[self setLbl1:nil];
	[self setLbl2:nil];
	[self setLbl3:nil];
	[self setLbl4:nil];
	[self setLbl5:nil];
	[self setLbl6:nil];
	[self setLbl7:nil];
	[self setLbl8:nil];
	[self setLblRegular1:nil];
	[self setLblRegular2:nil];
	[self setLblRegularTerm:nil];
	[self setLblRegularTerm2:nil];
	[self setMyScrollView:nil];
	[self setMyTableView:nil];
	[self setLblTable1:nil];
	[self setLblTable2:nil];
	[self setLblTable3:nil];
	[self setLblTable4:nil];
	[self setLblTable5:nil];
	[self setLblTable6:nil];
	[self setLblTable7:nil];
	[self setLblTable8:nil];
	[self setLblTable9:nil];
	[self setOutletDelete:nil];
	[self setOutletEdit:nil];
	[self setOutletDelete:nil];
	[self setOutletEdit:nil];
	[super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section
{
    //return [LTypeRiderCode count];
	return  1;
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencySymbol:@""];
    

	cell.detailTextLabel.text = @"dasdasdas";

    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	
}

#pragma mark - delegate



-(void)deductView:(RiderDeducTb *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc{
	
}

-(void)PlanView:(RiderPlanTb *)inController didSelectItem:(NSString *)item desc:(NSString *)itemdesc{
	
}

-(void)PTypeController:(RiderPTypeTbViewController *)inController didSelectCode:(NSString *)code seqNo:(NSString *)seq desc:(NSString *)desc andAge:(NSString *)aage andOccp:(NSString *)aaOccp{
	
}

-(void)RiderListController:(RiderListTbViewController *)inController didSelectCode:(NSString *)code desc:(NSString *)desc{
	
}

#pragma mark- Button Action
- (IBAction)ActionPersonType:(id)sender {
	if(_PTypeList == nil){
        
		self.PTypeList = [[RiderPTypeTbViewController alloc] initWithString:getSINo];
        _PTypeList.delegate = self;
        self.pTypePopOver = [[UIPopoverController alloc] initWithContentViewController:_PTypeList];
	}
    [self.pTypePopOver setPopoverContentSize:CGSizeMake(350.0f, 400.0f)];
    [self.pTypePopOver presentPopoverFromRect:[sender frame] inView:self.view
					 permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (IBAction)ActionRider:(id)sender {
}
- (IBAction)ActionDeductible:(id)sender {
}
- (IBAction)ActionDelete:(id)sender {
}

- (IBAction)ActionEdit:(id)sender {
}

- (IBAction)ActionSave:(id)sender {
}

@end
