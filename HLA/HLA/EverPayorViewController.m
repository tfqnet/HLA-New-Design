//
//  EverPayorViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverPayorViewController.h"
#import "AppDelegate.h"


@interface EverPayorViewController ()

@end

NSString *gEverName = @"";

@implementation EverPayorViewController
@synthesize age, ANB, Change, CheckRiderCode, clientID, clientName, CustCode,CustDate,CustLastNo;
@synthesize dataInsert,DOB,DOBPP,requestCommDate,requestLAAge,requestLAIndexNo,requestSINo,RiderToBeDeleted;
@synthesize GenderPP,getCommDate,getLAAge,getLAIndexNo,getSINo,title,txtALB,txtCPA,txtOccpLoad,txtName;
@synthesize txtOccpDesc,txtPA,NamePP,jobDesc,LAView,IndexNo,occCPA_PA,occLoading,OccpDesc,outletSmoker;
@synthesize outletGender,outletDelete,occPA,occuClass,outletDOB,OccpCode,OccpCodePP,popOverController;
@synthesize sex,smoker,SINo;
@synthesize delegate = _delegate;
@synthesize ProspectList = _ProspectList;

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
    
    getLAIndexNo = requestLAIndexNo;
    getLAAge = requestLAAge;
    getCommDate = [self.requestCommDate description];
    getSINo = [self.requestSINo description];
    NSLog(@"Payor-SINo:%@, CommDate:%@",getSINo,getCommDate);
    
	
    self.outletDelete.hidden = YES;
    useExist = NO;
    inserted = NO;
    
    [outletDelete setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f] forState:UIControlStateNormal];
    [outletDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	outletDelete.titleLabel.shadowColor = [UIColor lightGrayColor];
	outletDelete.titleLabel.shadowOffset = CGSizeMake(0, -1);
	
    if (self.requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getProspectData];
            [self getSavedField];
            self.outletDelete.hidden = NO;
        }
    }
	// Do any additional setup after loading the view.
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
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

-(void)getSavedField
{
    BOOL valid = TRUE;
    
    if (![NamePP isEqualToString:clientName]) {
        valid = FALSE;
    }
    
    if (![GenderPP isEqualToString:sex]) {
        valid = FALSE;
    }
    
    if (![DOB isEqualToString:DOBPP]) {
        valid = FALSE;
    }
    
    if (![OccpCode isEqualToString:OccpCodePP]) {
        valid = FALSE;
    }
    
	//    NSLog(@"nameSI:%@, genderSI:%@, dobSI:%@, occpSI:%@",clientName,sex,DOB,OccpCode);
	//    NSLog(@"namepp:%@, genderpp:%@, dobPP:%@, occpPP:%@",NamePP,GenderPP,DOBPP,OccpCodePP);
    
    if (valid) {
		
		txtName.text = clientName;
		gEverName = clientName;
		outletDOB.text = [[NSString alloc] initWithFormat:@"%@",DOB];
		txtALB.text = [[NSString alloc] initWithFormat:@"%d",age];
		
        if ([sex isEqualToString:@"M"]) {
			outletGender.selectedSegmentIndex = 0;
        } else {
			outletGender.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
		
        
        if ([smoker isEqualToString:@"Y"]) {
			outletSmoker.selectedSegmentIndex = 0;
        } else {
			outletSmoker.selectedSegmentIndex = 1;
        }
        NSLog(@"smoker:%@",smoker);
        
        [self getOccLoadExist];
		txtOccpDesc.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
		txtOccpLoad.text = [NSString stringWithFormat:@"%@",occLoading];
		
        if (occCPA_PA == 0) {
			txtCPA.text = @"D";
        } else {
			txtCPA.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
			txtPA.text = @"D";
        } else {
			txtPA.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
        [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:sex andDOB:DOB andAge:age andOccpCode:OccpCode];
        AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        zzz.SICompleted = YES;
        Change = @"no";
    }
    else {
		
		txtName.text = NamePP;
		gEverName = NamePP;
        sex = GenderPP;
        
        if ([sex isEqualToString:@"M"]) {
			outletGender.selectedSegmentIndex = 0;
        } else {
			outletGender.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
        if ([smoker isEqualToString:@"Y"]) {
			outletSmoker.selectedSegmentIndex = 0;
        } else {
			outletSmoker.selectedSegmentIndex = 1;
        }
        NSLog(@"smoker:%@",smoker);
        
		outletDOB.text = [[NSString alloc] initWithFormat:@"%@",DOBPP];
        DOB = DOBPP;
        [self calculateAge];
		txtALB.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        OccpCode = OccpCodePP;
        [self getOccLoadExist];
		txtOccpDesc.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
		txtOccpLoad.text = [NSString stringWithFormat:@"%@",occLoading];
		
        if (occCPA_PA == 0) {
			txtCPA.text = @"D";
        } else {
			txtCPA.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occCPA_PA == 0) {
			txtPA.text = @"D";
        } else {
			txtPA.text = [NSString stringWithFormat:@"%d",occPA];
        }
        
		if ([LAView isEqualToString:@"1"] ) {
			[self updatePayor];
			[self CheckValidRider];
			Change = @"yes";
			[_delegate RiderAdded];
			
		}
		else{
			
			//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There are changes in Prospect's information. Are you sure want to apply changes to this SI?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Prospect's information will synchronize to this SI." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
			[alert setTag:2003];
			[alert show];
		}
    }
}

#pragma mark - action


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2001 && buttonIndex == 0) //save
    {
        if (self.requestSINo) {
            if (useExist) {
				NSLog(@"rrrr");
				[self updatePayor];
				[self CheckValidRider];
				
            } else {
				NSLog(@"wwww");
				[self savePayor];
            }
        }
        else {
			NSLog(@"qqqq");
            [self savePayorHandler];
        }
    }
    else if (alertView.tag == 2002 && buttonIndex == 0) //delete
    {
        NSLog(@"delete 1");
        if (self.requestSINo) {
            [self checkingRider];
            [self deletePayor];
            if (CheckRiderCode.length != 0) {
                [self deleteRider];
                [_delegate RiderAdded];
            }
			txtName.text = @"";
			gEverName = @"";
            [outletGender setSelectedSegmentIndex:UISegmentedControlNoSegment];
			outletDOB.text = @"";
			txtALB.text = @"";
			txtOccpDesc.text= @"";
			txtOccpLoad.text = @"";
			txtCPA.text = @"";
			txtPA.text = @"";
        }
        else {
            NSLog(@"delete 2");
			txtName.text = @"";
			gEverName = @"";
            [outletGender setSelectedSegmentIndex:UISegmentedControlNoSegment];
			outletDOB.text = @"";
			txtALB.text = @"";
			txtOccpDesc.text= @"";
			txtOccpLoad.text = @"";
			txtCPA.text = @"";
			txtPA.text = @"";
            
            [_delegate PayorDeleted];
			
            self.outletDelete.hidden = YES;
        }
    }
    else if (alertView.tag==2003 && buttonIndex == 0) {
        
        if (smoker.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            [self updatePayor];
        }
    }
    else if (alertView.tag==2004 && buttonIndex == 0) {
		//        [self closeScreen];
    }
}

-(void)calculateAge
{
    /*
	 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	 [dateFormatter setDateFormat:@"yyyy"];
	 NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
	 [dateFormatter setDateFormat:@"MM"];
	 NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
	 [dateFormatter setDateFormat:@"dd"];
	 NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]]; */
    
    NSArray *curr = [getCommDate componentsSeparatedByString: @"/"];
    NSString *currentDay = [curr objectAtIndex:0];
    NSString *currentMonth = [curr objectAtIndex:1];
    NSString *currentYear = [curr objectAtIndex:2];
    
    NSArray *foo = [DOB componentsSeparatedByString: @"/"];
    NSString *birthDay = [foo objectAtIndex: 0];
    NSString *birthMonth = [foo objectAtIndex: 1];
    NSString *birthYear = [foo objectAtIndex: 2];
    
    int yearN = [currentYear intValue];
    int yearB = [birthYear intValue];
    int monthN = [currentMonth intValue];
    int monthB = [birthMonth intValue];
    int dayN = [currentDay intValue];
    int dayB = [birthDay intValue];
    
    int ALB = yearN - yearB;
    int newALB;
    int newANB;
    
    NSString *msgAge;
    if (yearN > yearB)
    {
        if (monthN < monthB) {
            newALB = ALB - 1;
        } else if (monthN == monthB && dayN < dayB) {
            newALB = ALB - 1;
        } else {
            newALB = ALB;
        }
        
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN >= dayB) {
            newANB = ALB + 1;
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        age = newALB;
        ANB = newANB;
        
        if (age < 16) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
    }
    else if (yearN == yearB)
    {
        age = 0;
        ANB = 1;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        
    }
    
    NSLog(@"msgAge:%@",msgAge);
}

#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode
{
    if (sex != NULL) {
        sex = nil;
        smoker = nil;
    }
    IndexNo = [aaIndex intValue];
    smoker = @"N";
    
    if (getLAIndexNo == [aaIndex intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"This Payor has already been attached to the plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        [_delegate payorSaved:NO];
		txtName.text = aaName;
		gEverName = aaName;
        sex = aaGender;
        
        if ([sex isEqualToString:@"M"]) {
			outletGender.selectedSegmentIndex = 0;
        } else {
			outletGender.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
		//        [smokerSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
		outletDOB.text = [[NSString alloc] initWithFormat:@"%@",aaDOB];
        DOB = aaDOB;
        [self calculateAge];
		txtALB.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        OccpCode = aaCode;
        [self getOccLoadExist];
		txtOccpDesc.text = [[NSString alloc] initWithFormat:@"%@",OccpDesc];
		txtOccpLoad.text = [NSString stringWithFormat:@"%@",occLoading];
        
        if (occCPA_PA == 0) {
			txtCPA.text = @"D";
        } else {
			txtCPA.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
			txtPA.text = @"D";
        } else {
			txtPA.text = [NSString stringWithFormat:@"%d",occPA];
        }
    }
    
    [popOverController dismissPopoverAnimated:YES];
}


#pragma mark - db handle

-(void)getRunningCustCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"CL\""];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustLastNo = sqlite3_column_int(statement, 0);
                CustDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                NSLog(@"LastCustNo:%d CustDate:%@",CustLastNo,CustDate);
                
            } else {
                NSLog(@"error check tbl_Adm_TrnTypeNo");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)savePayor
{
    [self getRunningCustCode];
    
    //generate CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    NSString *fooCust = [NSString stringWithFormat:@"%04d", runningNoCust];
    CustCode = [[NSString alloc] initWithFormat:@"CL%@-%@",currentdate,fooCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO UL_LAPayor (SINo, CustCode,PTypeCode,Seq,DateCreated,CreatedBy) "
							   "VALUES (\"%@\",\"%@\",\"PY\",\"1\",\"%@\",\"hla\")",getSINo, CustCode,dateStr];
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            } else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *insertSQL2 = [NSString stringWithFormat:
                                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, "
								"CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", "
								"\"%@\", \"hla\", \"%d\")", CustCode, txtName.text, smoker, sex, DOB, age, ANB, OccpCode,
								dateStr,IndexNo];
		//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                [self updateRunCustCode];
                [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:sex andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate payorSaved:YES];
                self.outletDelete.hidden = NO;
                
                AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                zzz.ExistPayor = YES;
            }
            else {
                NSLog(@"Failed LA2");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)savePayorHandler
{
    [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:sex andDOB:DOB andAge:age andOccpCode:OccpCode];
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.SICompleted = NO;
    self.outletDelete.hidden = NO;
    inserted = YES;
    [_delegate payorSaved:YES];
}

-(void)updateRunCustCode
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE "
							  "TrnTypeCode=\"CL\"",newLastNo,dateString];
        
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

-(void)checkingExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id, "
							  "b.IndexNo FROM UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode "
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Seq=1",getSINo];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                CustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientName = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                smoker = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                sex = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                DOB = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                age = sqlite3_column_int(statement, 6);
                OccpCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                clientID = sqlite3_column_int(statement, 8);
                IndexNo = sqlite3_column_int(statement, 9);
            } else {
                NSLog(@"error checkingExisting");
                useExist = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (SINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)checkingExisting2
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *tempSINo;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, b.id FROM UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode "
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Seq=1",[self.requestSINo description]];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                clientID = sqlite3_column_int(statement, 1);
                
            } else {
                NSLog(@"error access checkingExisting2");
                useExist = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (tempSINo.length != 0) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM "
							  "prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
		//        NSLog(@"%@",querySQL);
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

-(void)getOccLoadExist
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.OccpDesc, b.OccLoading, b.CPA, b.PA, b.Class from Adm_Occp_Loading_Penta "
							  "a LEFT JOIN Adm_Occp_Loading b ON a.OccpCode = b.OccpCode WHERE b.OccpCode = \"%@\"",OccpCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                occLoading =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occCPA_PA  = sqlite3_column_int(statement, 2);
                occPA  = sqlite3_column_int(statement, 3);
                occuClass = sqlite3_column_int(statement, 4);
                
                NSLog(@"OccpLoad:%@, cpa:%d, pa:%d, class:%d",occLoading, occCPA_PA,occPA,occuClass);
            }
            else {
                NSLog(@"Error getOccLoadExist!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updatePayor
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {

		NSString *querySQL = [NSString stringWithFormat:@"UPDATE Clt_Profile SET Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", "
							  "DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\", indexNo=\"%d\" WHERE id=\"%d\"",
							  gEverName ,smoker,sex,DOB,age,ANB,OccpCode,currentdate,IndexNo,clientID];
		
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"SI update!");
                [_delegate PayorIndexNo:IndexNo andSmoker:smoker andSex:sex andDOB:DOB andAge:age andOccpCode:OccpCode];
                [_delegate payorSaved:YES];
            }
            else {
                NSLog(@"SI update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deletePayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM UL_LAPayor WHERE CustCode=\"%@\"",CustCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"LAPayor delete!");
                
            } else {
                NSLog(@"LAPayor delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",CustCode];
        if (sqlite3_prepare_v2(contactDB, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Clt_Profile delete!");
                [_delegate PayorDeleted];
                
                if (getLAAge < 10) {
                    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                    zzz.ExistPayor = NO;
                }
            }
            else {
                NSLog(@"Clt_Profile delete Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in deleting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    self.outletDelete.hidden = YES;
    useExist = NO;
}

-(void)CheckValidRider
{
    RiderToBeDeleted = [[NSMutableArray alloc] init ];
	
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"Select RiderTerm From UL_Rider_Details where SINO = \"%@\" AND RiderCode in ('PTR') ", SINo];
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {	int SQLTerm = 0;
				SQLTerm	= [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue ];
				
				if(SQLTerm + age > 60){
					
					[RiderToBeDeleted addObject:@"PTR" ];
				}
            }
            else {
				
            }
            sqlite3_finalize(statement);
        }
		
		querySQL = [NSString stringWithFormat:@"Select RiderTerm From UL_Rider_Details where SINO = \"%@\" AND "
					"RiderCode in ('PLCP') ", SINo];
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {	int SQLTerm = 0;
				SQLTerm	= [[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)] intValue ];
				
				if(SQLTerm + age > 60){
					[RiderToBeDeleted addObject:@"PLCP" ];
				}
            }
            else {
                
            }
            sqlite3_finalize(statement);
        }
		
		NSString *temp;
		
		if ([OccpCode isEqualToString:@"OCC01975"]) {
			NSString *querySQL = [NSString stringWithFormat:@"Select Ridercode From UL_Rider_Details where SINO = \"%@\" AND RiderCode in ('LCWP', 'PR', 'PTR', 'PLCP') ", SINo];
			//        NSLog(@"%@",querySQL);
			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
			{
				while (sqlite3_step(statement) == SQLITE_ROW)
				{
					temp =[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
					[RiderToBeDeleted addObject:temp];
				}
				
				sqlite3_finalize(statement);
			}
			
		}
		
		temp = Nil;
		
		if (RiderToBeDeleted.count > 0) {
			
			for (int i=0; i < RiderToBeDeleted.count; i++) {
				querySQL = [NSString stringWithFormat:@"DELETE From UL_Rider_Details where SINO = \"%@\" AND RiderCode = \"%@\" ", SINo, [RiderToBeDeleted objectAtIndex:i]];
				//        NSLog(@"%@",querySQL);
				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				{
					if (sqlite3_step(statement) == SQLITE_DONE)
					{
						
					}
					
					sqlite3_finalize(statement);
				}
			}
			
			[_delegate RiderAdded];
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider(s) has been deleted due to business rule."
														   delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
			[alert show];
			
		}
		
        sqlite3_close(contactDB);
    }
}


-(void)checkingRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,SumAssured,RiderTerm,Units FROM UL_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"PY\" AND Seq=\"1\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                CheckRiderCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM UL_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"PY\" AND Seq=\"1\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"rider delete!");
                
            } else {
                NSLog(@"rider delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - memory management
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

- (void)viewDidUnload {
	[self setTxtName:nil];
	[self setOutletGender:nil];
	[self setOutletSmoker:nil];
	[self setOutletDOB:nil];
	[self setTxtALB:nil];
	[self setTxtOccpDesc:nil];
	[self setTxtOccpLoad:nil];
	[self setTxtCPA:nil];
	[self setTxtPA:nil];
	[self setOutletDelete:nil];
	[super viewDidUnload];
}

#pragma mark - button action
- (IBAction)ActionDone:(id)sender {
	//    NSLog(@"smoker:%@",smoker);
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789'@/-. "] invertedSet];
    
    if (txtName.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([txtName.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe('), alias(@), slash(/), dash(-) or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (age < 16) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 16 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        NSString *msg;
        if (self.requestSINo) {
            [self checkingExisting2];
            if (useExist) {
                msg = @"Confirm changes?";
            } else {
                msg = @"Save?";
            }
        }
        else {
            if (inserted) {
                msg = @"Confirm changes?";
            }
            else {
                msg = @"Save?";
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:2001];
        [alert show];
    }
}

- (IBAction)ActionDelete:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
													message:[NSString stringWithFormat:@"Delete Payor:%@?",txtName.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
    [alert setTag:2002];
    [alert show];
}

- (IBAction)ActionProspect:(id)sender {
	if (_ProspectList == nil) {
        self.ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        _ProspectList.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    [popOverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionGender:(id)sender {
	if ([outletGender selectedSegmentIndex]==0) {
        sex = @"M";
    }
    else if (outletGender.selectedSegmentIndex == 1){
        sex = @"F";
    }
}

- (IBAction)ACtionSmoker:(id)sender {
	if ([outletSmoker selectedSegmentIndex]==0) {
        smoker = @"Y";
    }
    else if (outletSmoker.selectedSegmentIndex == 1){
        smoker = @"N";
    }
}
@end
