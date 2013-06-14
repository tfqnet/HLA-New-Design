//
//  EverLAViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverLAViewController.h"
#import "AppDelegate.h"

@interface EverLAViewController ()

@end

@implementation EverLAViewController
@synthesize txtName, segGender, segSmoker,segStatus;
@synthesize txtALB, txtCommDate, txtDOB;
@synthesize txtOccpLoad;
@synthesize txtCPA;
@synthesize txtPA;
@synthesize statusLabel;
@synthesize sex,smoker,age,ANB,DOB,jobDesc,SINo,CustCode;
@synthesize occDesc,occCode,occLoading,payorSINo,occCPA_PA;
@synthesize popOverController,requestSINo,clientName,occuCode,occuDesc,CustCode2,payorCustCode;
@synthesize commDate,occuClass,IndexNo;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP,occPA,headerTitle;
@synthesize getSINo,btnDOB, btnOccpDesc;
@synthesize getHL,getHLTerm,getPolicyTerm,getSumAssured,getTempHL,getTempHLTerm,MOP,yearlyIncome;
@synthesize termCover,planCode,arrExistRiderCode,arrExistPlanChoice;
@synthesize prospectPopover = _prospectPopover;
@synthesize idPayor,idProfile,idProfile2,lastIdPayor,lastIdProfile,planChoose,ridCode,atcRidCode,atcPlanChoice;
@synthesize basicSINo,requestCommDate,requestIndexNo,requestLastIDPay,requestLastIDProf,requestSex,requestSmoker, strPA_CPA,payorAge;
@synthesize LADate = _LADate;
@synthesize datePopover = _datePopover;
@synthesize dobPopover = _dobPopover;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
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
	// Do any additional setup after loading the view.
	
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - handle Data
-(void)getOccLoadExist
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.OccpDesc, b.OccLoading, b.CPA, b.PA, b.Class from Adm_Occp_Loading_Penta a LEFT JOIN Adm_Occp_Loading b ON a.OccpCode = b.OccpCode WHERE b.OccpCode = \"%@\"",occuCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occuDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                occLoading =  [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occCPA_PA  = sqlite3_column_int(statement, 2);
                occPA  = sqlite3_column_int(statement, 3);
                occuClass = sqlite3_column_int(statement, 4);
                strPA_CPA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
				
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

-(void)insertData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
							   @"INSERT INTO UL_LAPayor (PTypeCode,Seq,DateCreated,CreatedBy) VALUES (\"LA\",\"1\",\"%@\","
							   "\"hla\")",commDate];

        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done Ever LA");
            }
            else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *insertSQL2 = [NSString stringWithFormat:@"INSERT INTO Clt_Profile (Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, "
								"DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", "
								"\"%@\", \"hla\", \"%d\")",txtName.text, smoker, sex, DOB, age, ANB, occuCode, commDate,IndexNo];

        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done Ever LA2");
                [self getLastIDPayor];
                [self getLastIDProfile];
                
            } else {
                NSLog(@"Failed LA2");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
		
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
        Inserted = YES;
        AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        zzz.SICompleted = NO;
        
        sqlite3_close(contactDB);
    }
}

-(void)updateData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"UPDATE Clt_Profile SET Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\",indexNo=\"%d\", DateCreated = \"%@\"  WHERE id=\"%d\"",
                              txtName.text,smoker,sex,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,idProfile];
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                if (DiffClient) {
                    NSLog(@"diffClient!");
                    
                    if (age < 10) {
                        [self checkingPayor];
                        if (payorSINo.length == 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert show];
                            
                            AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                            zzz.ExistPayor = NO;
                        }
                    }
                    [self checkExistRider];
                    if (arrExistRiderCode.count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider(s) has been deleted due to business rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                    if (age > 18) {
                        [self checkingPayor];
                        if (payorSINo.length != 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor's details will be deleted due to life Assured age is greater or equal to 18." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1003];
                            [alert show];
                        }
                    }
                    if (age < 16) {
                        [self checking2ndLA];
                        if (CustCode2.length != 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured's details will be deleted due to life Assured age is less than 16." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1002];
                            [alert show];
                        }
                    }
                }
                
                else {
                    if (age < 10) {
                        [self checkingPayor];
                        if (payorSINo.length == 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert show];
                            
                            AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
                            zzz.ExistPayor = NO;
                        }
                    }
                    if (age >= 18) {
                        [self checkingPayor];
                        if (payorSINo.length != 0) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor's details will be deleted due to life Assured age is greater or equal to 18" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1003];
                            [alert show];
                        }
                    }
                    if (age < 16) {
                        [self checking2ndLA];
                        if (CustCode2.length != 0) {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured's details will be deleted due to life Assured age is less than 16" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                            [alert setTag:1002];
                            [alert show];
                        }
                    }
                }
            }
            else {
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            
            //[_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateData2
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"UPDATE Clt_Profile SET Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\",indexNo=\"%d\", DateCreated = \"%@\"  WHERE id=\"%d\"",
                              txtName.text,smoker,sex,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,lastIdProfile];
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                if (age < 10) {
                    [self checkingPayor];
                    if (payorSINo.length == 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please attach Payor as Life Assured is below 10 years old." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert show];
                    }
                }
            }
            else {
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            
            //[_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
            
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingExisting
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, "
							  "b.id, b.IndexNo, a.rowid FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode "
							  "WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",getSINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
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
                occuCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                commDate = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 8)];
                idProfile = sqlite3_column_int(statement, 9);
                IndexNo = sqlite3_column_int(statement, 10);
                idPayor = sqlite3_column_int(statement, 11);
                NSLog(@"age:%d, indexNo:%d, idPayor:%d, idProfile:%d",age,IndexNo,idPayor,idProfile);
				
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
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
    sqlite3_stmt *statement;
    NSString *tempSINo;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",getSINo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                tempSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                idProfile = sqlite3_column_int(statement, 1);
				//                NSLog(@"tempSINo:%@, length:%d",tempSINo, tempSINo.length);
                
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
                useExist = NO;
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (tempSINo.length != 0 && ![tempSINo isEqualToString:@"(null)"]) {
        useExist = YES;
    } else {
        useExist = NO;
    }
}

-(void)checkingExistingSI
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM UL_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getProspectData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile "
							  "WHERE IndexNo= \"%d\"",IndexNo];
        
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

-(void)getExistingBasic
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT SINo, PlanCode, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, "
							  "AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM UL_Details "
							  "WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                getPolicyTerm = sqlite3_column_int(statement, 2);
                getSumAssured = sqlite3_column_double(statement, 3);
                MOP = sqlite3_column_int(statement, 4);
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 8);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 9);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 10);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 11);
                
            } else {
                NSLog(@"error access Trad_Details");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM"
							  "UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND"
							  "a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				payorAge = sqlite3_column_int(statement, 6);
                
            } else {
                NSLog(@"error access checkingPayor");
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
							  @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM"
							  "UL_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\""
							  "AND a.Sequence=2",getSINo];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                idProfile2 = sqlite3_column_int(statement, 9);
            } else {
                NSLog(@"error access Trad_LAPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)delete2ndLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM UL_LAPayor WHERE CustCode=\"%@\"",CustCode2];
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
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",CustCode2];
        if (sqlite3_prepare_v2(contactDB, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Clt_Profile delete!");
                //[_delegate secondLADelete];
                
            } else {
                NSLog(@"Clt_Profile delete Failed!");
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM UL_LAPayor WHERE CustCode=\"%@\"",payorCustCode];
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
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM Clt_Profile WHERE CustCode=\"%@\"",payorCustCode];
        if (sqlite3_prepare_v2(contactDB, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Clt_Profile delete!");
                //[_delegate PayorDeleted];
                
            } else {
                NSLog(@"Clt_Profile delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkExistRider
{
    arrExistRiderCode = [[NSMutableArray alloc] init];
    arrExistPlanChoice = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT RiderCode, PlanOption FROM UL_Rider_Details WHERE SINo=\"%@\"",getSINo];
		
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [arrExistRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [arrExistPlanChoice addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getActualRider
{
    ridCode = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    NSString *querySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        if (self.occuClass == 4 && ![strPA_CPA isEqualToString:@"D" ]) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN UL_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"MG_IV\")j "
                        "LEFT JOIN UL_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"", planChoose, age, age];
        }
        else if (self.occuClass > 4) {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN UL_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"CPA\" AND a.RiderCode != \"PA\" AND a.RiderCode != \"HMM\" AND a.RiderCode != \"HB\" AND a.RiderCode != \"MG_II\" AND a.RiderCode != \"MG_IV\" AND a.RiderCode != \"HSP_II\")j "
                        "LEFT JOIN UL_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"",planChoose, age, age];
        }
		else if ([strPA_CPA isEqualToString:@"D"]){
			querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN UL_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\" AND a.RiderCode != \"MG_IV\" AND a.RiderCode != \"CPA\")j "
                        "LEFT JOIN UL_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"", planChoose, age, age];
		}
        else {
            querySQL = [NSString stringWithFormat:
                        @"SELECT j.*, k.MinAge, k.MaxAge FROM"
                        "(SELECT a.RiderCode,b.RiderDesc FROM Trad_Sys_RiderComb a LEFT JOIN UL_Rider_Profile b ON a.RiderCode=b.RiderCode WHERE a.PlanCode=\"%@\")j "
                        "LEFT JOIN UL_Rider_Mtn k ON j.RiderCode=k.RiderCode WHERE k.MinAge <= \"%d\" AND k.MaxAge >= \"%d\"",planChoose, age, age];
        }
		
        if (age > 60) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode != \"I20R\""];
        }
        if (age > 65) {
            querySQL = [querySQL stringByAppendingFormat:@" AND j.RiderCode != \"IE20R\""];
        }
        
        querySQL = [querySQL stringByAppendingFormat:@" order by j.RiderCode asc"];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [ridCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM UL_Rider_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"All rider delete!");
                //[_delegate RiderAdded];
                
            } else {
                NSLog(@"rider delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteRider:(NSString *)aaCode
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND RiderCode=\"%@\"",getSINo,aaCode];
        
		//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"rider %@ delete!",aaCode);
                //[_delegate RiderAdded];
                
            } else {
                NSLog(@"rider delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getLastIDPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT rowid FROM UL_LAPayor ORDER by rowid desc limit 1"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                lastIdPayor  =  sqlite3_column_int(statement, 0);
                NSLog(@"lastPayorID:%d",lastIdPayor);
            }
            else {
                NSLog(@"error access Trad_LAPayor");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getLastIDProfile
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT id FROM Clt_Profile ORDER by id desc limit 1"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                lastIdProfile  =  sqlite3_column_int(statement, 0);
                NSLog(@"lastProfileID:%d",lastIdProfile);
            }
            else {
                NSLog(@"error access Clt_Profile");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)calculateAge
{
    AgeLess = NO;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    /*
	 [dateFormatter setDateFormat:@"yyyy"];
	 NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
	 [dateFormatter setDateFormat:@"MM"];
	 NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
	 [dateFormatter setDateFormat:@"dd"];
	 NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
     */
    
	//    NSString *birthYear = [DOB substringFromIndex:[DOB length]-4];
	//    NSString *birthMonth = [DOB substringWithRange:NSMakeRange(3, 2)];
	//    NSString *birthDay = [DOB substringWithRange:NSMakeRange(0, 2)];
    //12/12/2012
    
    NSArray *curr = [commDate componentsSeparatedByString: @"/"];
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
        } else if (monthN == monthB && dayN == dayB) { //edited by heng
            newALB = ALB ;  //edited by heng
        } else {
            newALB = ALB;
            
        }
		
        if (monthN > monthB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN > dayB) {
            newANB = ALB + 1;
        } else if (monthN == monthB && dayN == dayB) { // edited by heng
            newANB = ALB; //edited by heng
        } else {
            newANB = ALB;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d",newALB];
        age = newALB;
        ANB = newANB;
    }
    else if (yearN == yearB)
    {
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectDate = DOB;
        NSDate *startDate = [dateFormatter dateFromString:selectDate];
        
        NSString *todayDate = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *endDate = [dateFormatter dateFromString:todayDate];
        
        unsigned flags = NSDayCalendarUnit;
        NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:startDate toDate:endDate options:0];
        int diffDays = [difference day];
        if (diffDays < 30) {
            AgeLess = YES;
        }
        msgAge = [[NSString alloc] initWithFormat:@"%d days",diffDays];
		//        NSLog(@"birthday:%@, today:%@, diff:%d",selectDate,todayDate,diffDays);
        
        age = 0;
        ANB = 1;
    }
	//    NSLog(@"msgAge:%@",msgAge);
}


#pragma mark - Delegate
-(void) LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker
{
	
}
-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered
		andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL
		andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan
{
	
}
-(void) RiderAdded
{
	
}

-(void)secondLADelete
{
	
}

-(void)PayorDeleted{
	
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB{
	
}

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode{
	if ([NSString stringWithFormat:@"%d",IndexNo] != NULL) {
        smoker = @"N";
        DiffClient = YES;
    }
	IndexNo = [aaIndex intValue];
	
	AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.ExistPayor = YES;

	NSLog(@"new client");
    if (commDate.length == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        commDate = [dateFormatter stringFromDate:[NSDate date]];
    }
	
	DOB = aaDOB;
	
	[self calculateAge];
	if (age > 100) {
	
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Age Last Birthday must be less than or equal to 100 for this product."
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
	else {
		txtName.text = aaName;
		sex = aaGender;
		
		if ([sex isEqualToString:@"M"]) {
            segGender.selectedSegmentIndex = 0;
        } else {
            segGender.selectedSegmentIndex = 1;
        }
		
		//[btnDOB setTitle:DOB forState:UIControlStateNormal];
		txtDOB.text = DOB;
		txtALB.text = [[NSString alloc] initWithFormat:@"%d",age];
		//[self.btnComDate setTitle:commDate forState:UIControlStateNormal];
		txtCommDate.text = commDate;
		
		occuCode = aaCode;
		[self getOccLoadExist];
		[btnOccpDesc setTitle:occuDesc forState:UIControlStateNormal];
		self.btnOccpDesc.titleLabel.textColor = [UIColor darkGrayColor];
		txtOccpLoad.text = [NSString stringWithFormat:@"%@",occLoading];
		
		if (occCPA_PA == 0) {
			txtCPA.text = @"D";
        }
        else {
			txtCPA.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        if (occPA == 0) {
			txtPA.text = @"D";
        }
        else {
			txtPA.text = [NSString stringWithFormat:@"%d",occPA];
        }
	}
	
	[self.prospectPopover dismissPopoverAnimated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (alertView.tag==1001 && buttonIndex == 0) {
        
        if (useExist) {
            NSLog(@"will update");
            [self updateData];
        }
        else if (Inserted) {
            NSLog(@"will update2");
            [self updateData2];
        }
        else {
            NSLog(@"will insert new");
            [self insertData];
        }
        Saved = YES;
    }
    else if (alertView.tag==1002 && buttonIndex == 0) {
        [self delete2ndLA];
    }
    else if (alertView.tag==1003 && buttonIndex == 0) {
        [self deletePayor];
    }
}

#pragma mark - memory management

- (void)viewDidUnload {
	[self setSegGender:nil];
	[self setSegSmoker:nil];
	[self setSegStatus:nil];
	[self setBtnDOB:nil];
	[self setTxtALB:nil];
	[self setBtnOccpDesc:nil];
	[self setTxtOccpLoad:nil];
	[self setTxtCPA:nil];
	[self setTxtPA:nil];
	[self setMyScrollView:nil];
	[self setTxtName:nil];
	[self setTxtDOB:nil];
	[self setTxtCommDate:nil];
	[super viewDidUnload];
}

#pragma mark - Button Action

- (IBAction)ActionDOB:(id)sender {
}

- (IBAction)ActionProspect:(id)sender {
	if (_ProspectList == nil) {
        self.ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        _ProspectList.delegate = self;
        self.prospectPopover = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    [self.prospectPopover presentPopoverFromRect:[sender frame] inView:self.view
						permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}
- (IBAction)ActionRefresh:(id)sender {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"dd/MM/yyyy"];
	commDate = [dateFormatter stringFromDate:[NSDate date]];
	
	txtCommDate.text = commDate;
}
- (IBAction)ActionDone:(id)sender {
	NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789'@/-. "] invertedSet];
	if (txtName.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        //[Field becomeFirstResponder];
    }
    else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
	else if (AgeLess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1005];
        [alert show];
    }else if (age > 100) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 100 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
	else if (occuCode.length == 0 || btnOccpDesc.titleLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
	else if ([txtName.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe('), alias(@), slash(/), dash(-) or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([occuCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }else {
        //prompt save
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
            if (Inserted) {
                msg = @"Confirm changes?";
            } else {
                msg = @"Save?";
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self
											  cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:1001];
        [alert show];
    }
	
}
@end
