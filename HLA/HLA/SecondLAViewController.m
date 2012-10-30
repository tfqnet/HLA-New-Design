//
//  SecondLAViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/31/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SecondLAViewController.h"
#import "MainScreen.h"

@interface SecondLAViewController ()

@end

@implementation SecondLAViewController
@synthesize nameField;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize DOBBtn;
@synthesize ageField;
@synthesize OccpBtn;
@synthesize OccpLoadField;
@synthesize CPAField;
@synthesize PAField;
@synthesize sex,smoker,DOB,jobDesc,age,ANB,OccpCode,occLoading,SINo,CustLastNo,CustDate,CustCode,clientName,clientID,OccpDesc,occCPA_PA;
@synthesize popOverController,requestSINo,la2ndH;
@synthesize ProspectList = _ProspectList;
@synthesize CheckRiderCode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    nameField.enabled = NO;
    sexSegment.enabled = NO;
    DOBBtn.enabled = NO;
    ageField.enabled = NO;
    OccpBtn.enabled = NO;
    OccpLoadField.enabled = NO;
    CPAField.enabled = NO;
    PAField.enabled = NO;
    
    useExist = NO;
    
    requestSINo = la2ndH.storedSINo;
    NSLog(@"2ndLA-SINo:%@",requestSINo);
    
    if (requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getSavedField];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

-(void)getSavedField
{
    nameField.text = clientName;
    [self.DOBBtn setTitle:DOB forState:UIControlStateNormal];
    ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
    
    if ([sex isEqualToString:@"M"]) {
        sexSegment.selectedSegmentIndex = 0;
    } else if ([sex isEqualToString:@"F"]) {
        sexSegment.selectedSegmentIndex = 1;
    }
    
    if ([smoker isEqualToString:@"Y"]) {
        smokerSegment.selectedSegmentIndex = 0;
    } else if ([smoker isEqualToString:@"N"]) {
        smokerSegment.selectedSegmentIndex = 1;
    }
    
    [self getOccLoadExist];
    [self.OccpBtn setTitle:OccpDesc forState:UIControlStateNormal];
    if (occLoading == 0) {
        OccpLoadField.text = @"STD";
    } else {
        OccpLoadField.text = [NSString stringWithFormat:@"%d",occLoading];
    }
    
    if (occCPA_PA > 4) {
        CPAField.text = @"D";
        PAField.text = @"D";
    } else {
        CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        PAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
    }
    
    useExist = YES;
}

#pragma mark - action
- (IBAction)doSelectProspect:(id)sender
{
    if (_ProspectList == nil) {
        self.ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        _ProspectList.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    [popOverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)sexSegmentChange:(id)sender
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"M";
    }
    else if (sexSegment.selectedSegmentIndex == 1){
        sex = @"F";
    }
}

- (IBAction)smokerSegmentChange:(id)sender
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    }
    else if (smokerSegment.selectedSegmentIndex == 1){
        smoker = @"N";
    }
}

- (IBAction)DOBBtnPressed:(id)sender
{
    if(![popOverController isPopoverVisible]) {
        DateViewController *datePick = [self.storyboard instantiateViewControllerWithIdentifier:@"showDate"];
		popOverController = [[UIPopoverController alloc] initWithContentViewController:datePick];
        datePick.delegate = self;
		
		[popOverController setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
        [popOverController presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popOverController.delegate = self;
	}
    else {
		[popOverController dismissPopoverAnimated:YES];
	}
}

- (IBAction)OccpBtnPressed:(id)sender
{
    if(![popOverController isPopoverVisible]) {
        
		JobListTbViewController *jobList = [[JobListTbViewController alloc] init];
		popOverController = [[UIPopoverController alloc] initWithContentViewController:jobList];
        jobList.delegate = self;
		
		[popOverController setPopoverContentSize:CGSizeMake(500.0f, 400.0f)];
        [popOverController presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        popOverController.delegate = self;
	}
    else {
		[popOverController dismissPopoverAnimated:YES];
	}
}

- (IBAction)doCloseView:(id)sender
{
    MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
    main.modalPresentationStyle = UIModalPresentationFullScreen;
    main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    main.IndexTab = 4;
    main.mainH = la2ndH;
    [self presentModalViewController:main animated:YES];
}

- (IBAction)doSave:(id)sender
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789'@/-. "] invertedSet];
    
    if (nameField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Prospect Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (OccpCode.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([nameField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe('), alias(@), slash(/), dash(-) or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Save?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:1001];
        [alert show];
    }
}

- (IBAction)doDelete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:[NSString stringWithFormat:@"Delete 2nd Life Assured:%@?",nameField.text] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
    [alert setTag:1002];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) {
        if (useExist) {
            [self updateData];
        } else {
            [self saveData];
        }
    }
    else if (alertView.tag == 1002 && buttonIndex == 0) {
        [self checkingRider];
        [self deleteLA];
        if (CheckRiderCode.length != 0) {
            [self deleteRider];
        }
        nameField.text = @"";
        [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [smokerSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [DOBBtn setTitle:@"" forState:UIControlStateNormal];
        ageField.text = @"";
        [OccpBtn setTitle:@"" forState:UIControlStateNormal];
        OccpLoadField.text = @"";
        CPAField.text = @"";
        PAField.text = @"";
    }
}

-(void)calculateAge
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"MM"];
    NSString *currentMonth = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter setDateFormat:@"dd"];
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];
    
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
    }
    else if (yearN == yearB)
    {
        if (monthN > monthB) {
            newALB = monthN - monthB;
            msgAge = [[NSString alloc] initWithFormat:@"%d months",newALB];
            
        } else if (monthN == monthB && dayB<dayN) {
            newALB = dayN - dayB;
            msgAge = [[NSString alloc] initWithFormat:@"%d days",newALB];
            if (newALB < 30) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        age = 0;
        ANB = 1;
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
    
    if (la2ndH.storedIndexNo == [aaIndex intValue]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"This Life Assured has already been attached to the plan." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        nameField.text = aaName;
        sex = aaGender;
    
        if ([sex isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else if ([sex isEqualToString:@"F"]) {
            sexSegment.selectedSegmentIndex = 1;
        }
        
        [smokerSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        [DOBBtn setTitle:aaDOB forState:UIControlStateNormal];
        DOB = aaDOB;
        [self calculateAge];
        ageField.text = [[NSString alloc] initWithFormat:@"%d",age];
    
        OccpCode = aaCode;
        [self getOccLoadExist];
        [self.OccpBtn setTitle:OccpDesc forState:UIControlStateNormal];
        if (occLoading == 0) {
            OccpLoadField.text = @"STD";
        } else {
            OccpLoadField.text = [NSString stringWithFormat:@"%d",occLoading];
        }
        
        if (occCPA_PA > 4) {
            CPAField.text = @"D";
            PAField.text = @"D";
        } else {
            CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            PAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
    }
    
    [popOverController dismissPopoverAnimated:YES];
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    [self.DOBBtn setTitle:aDate forState:UIControlStateNormal];
    ageField.text = [[NSString alloc] initWithFormat:@"%@",aAge];
    DOB = aDate;
    age = bAge;
    ANB = aANB;
    [popOverController dismissPopoverAnimated:YES];
}

-(void) joblist:(JobListTbViewController *)inController selectCode:(NSString *)aaCode selectDesc:(NSString *)aaDesc
{
    [self.OccpBtn setTitle:aaDesc forState:UIControlStateNormal];
    OccpCode = [[NSString alloc] initWithFormat:@"%@",aaCode];
    [self getOccLoading];
    
    [popOverController dismissPopoverAnimated:YES];
}

#pragma mark - db handle

-(void)getOccLoading
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT Class,PA_CPA,OccLoading_TL from Adm_Occp_Loading_Penta where OccpCode = \"%@\"",OccpCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occCPA_PA  = sqlite3_column_int(statement, 1);
                occLoading = sqlite3_column_int(statement, 2);
                
                if (occLoading == 0) {
                    OccpLoadField.text = @"STD";
                } else {
                    OccpLoadField.text = [NSString stringWithFormat:@"%d",occLoading];
                }
                
                if (occCPA_PA > 4) {
                    CPAField.text = @"D";
                    PAField.text = @"D";
                } else {
                    CPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
                    PAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
                }
            }
            else {
                NSLog(@"Error retrieve loading!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

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

-(void)saveData
{
    [self getRunningCustCode];
    
    //generate CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoCust = CustLastNo + 1;
    SINo = [self.requestSINo description];
    CustCode = [[NSString alloc] initWithFormat:@"CL%@-000%d",currentdate,runningNoCust];
    
    sqlite3_stmt *statement;    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                    @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"2\",\"%@\",\"hla\")",SINo, CustCode,dateStr];
        NSLog(@"%@",insertSQL);
        
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
                @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\")", CustCode, nameField.text, smoker, sex, DOB, age, ANB, OccpCode, dateStr];
        NSLog(@"%@",insertSQL2);
        
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
                [self updateRunCustCode];
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
            } else {
                NSLog(@"Failed LA2");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
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
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
        
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
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",[self.requestSINo description]];
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
                OccpCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)];
                clientID = sqlite3_column_int(statement, 8);
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
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
                              @"SELECT OccpCode,OccpDesc,Class,PA_CPA,OccLoading_TL from Adm_Occp_Loading_Penta where OccpCode = \"%@\"",OccpCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occCPA_PA  = sqlite3_column_int(statement, 3);
                occLoading =  sqlite3_column_int(statement, 4);
            }
            else {
                NSLog(@"Error retrieve loading!");
            }
            sqlite3_finalize(statement);
        }
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
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Clt_Profile SET Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" WHERE id=\"%d\"",nameField.text,smoker,sex,DOB,age,ANB,OccpCode,currentdate,clientID];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"SI update!");
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
            } else {
                NSLog(@"SI update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)deleteLA
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",CustCode];
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
                
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record Deleted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
            } else {
                NSLog(@"Clt_Profile delete Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in deleting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingRider
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT RiderCode,SumAssured,RiderTerm,Units FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"LA\" AND Seq=\"2\"",requestSINo];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\" AND PTypeCode=\"LA\" AND Seq=\"2\"",requestSINo];
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

- (void)viewDidUnload
{
    [self setCheckRiderCode:nil];
    [self setNameField:nil];
    [self setSexSegment:nil];
    [self setSmokerSegment:nil];
    [self setDOBBtn:nil];
    [self setAgeField:nil];
    [self setOccpBtn:nil];
    [self setOccpLoadField:nil];
    [self setCPAField:nil];
    [self setPAField:nil];
    [self setPopOverController:nil];
    [self setRequestSINo:nil];
    [self setSex:nil];
    [self setSmoker:nil];
    [self setDOB:nil];
    [self setJobDesc:nil];
    [self setOccpCode:nil];
    [self setSINo:nil];
    [self setCustDate:nil];
    [self setCustCode:nil];
    [self setClientName:nil];
    [self setOccpDesc:nil];
    [super viewDidUnload];
}

@end
