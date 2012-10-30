//
//  NewLAViewController.m
//  HLA
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "NewLAViewController.h"
#import "PayorViewController.h"
#import "SecondLAViewController.h"
#import "BasicPlanViewController.h"
#import "RiderViewController.h"

#import "SIMenuViewController.h"
#import "SIHandler.h"
#import "MainScreen.h"

@interface NewLAViewController ()

@end

@implementation NewLAViewController
@synthesize myScrollView;
@synthesize LANameField;
@synthesize sexSegment;
@synthesize smokerSegment;
@synthesize LAAgeField;
@synthesize LAOccLoadingField;
@synthesize LACPAField;
@synthesize LAPAField;
@synthesize btnDOB;
@synthesize btnOccp;
@synthesize btnCommDate;
@synthesize statusLabel;
@synthesize sex,smoker,age,SINo,SIDate,SILastNo,CustCode,ANB,CustDate,CustLastNo,DOB,jobDesc;
@synthesize occDesc,occCode,occLoading,payorSINo,occCPA_PA;
@synthesize popOverController,requestSINo,clientName,occuCode,commencementDate,occuDesc,clientID,clientID2,CustCode2,payorCustCode;
@synthesize dataInsert,laH,commDate,occuClass,IndexNo,laBH;
@synthesize ProspectList=_ProspectList;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self resignFirstResponder];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"%@",databasePath);
    
    LANameField.enabled = NO;
    sexSegment.enabled = NO;
    btnDOB.enabled = NO;
    LAAgeField.enabled = NO;
    btnOccp.enabled = NO;
    LAOccLoadingField.enabled = NO;
    LACPAField.enabled = NO;
    LAPAField.enabled = NO;
    useExist = NO;
    date1 = NO;
    date2 = NO;
    
    if (requestSINo) {
        self.laH = [[SIHandler alloc] init];
    } else {
        requestSINo = laH.storedSINo;
    }
    NSLog(@"%@",[self.requestSINo description]);
    
    NSLog(@"LA-SINo: %@",requestSINo);
    if (requestSINo) {
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getProspectData];
            [self getSavedField];
            
            NSLog(@"will use existing data");
            useExist = YES;
        }
    } else {
        NSLog(@"SINo not exist!");
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
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

#pragma mark - Handle KeyboardShow

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 704-264);
    self.myScrollView.contentSize = CGSizeMake(1024, 704);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 704);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
    Saved = NO;
}


#pragma mark - ToogleView

-(void)getSavedField
{
    BOOL valid;
    if (![NamePP isEqualToString:clientName]) {
        valid = FALSE;
    }
    
    if (![GenderPP isEqualToString:sex]) {
        valid = FALSE;
    }
    
    if (![DOB isEqualToString:DOBPP]) {
        valid = FALSE;
    }
    
    if (![occuCode isEqualToString:OccpCodePP]) {
        valid = FALSE;
    }
    
    NSLog(@"nameSI:%@, genderSI:%@, dobSI:%@, occpSI:%@",clientName,sex,DOB,occuCode);
    NSLog(@"namepp:%@, genderpp:%@, dobPP:%@, occpPP:%@",NamePP,GenderPP,DOBPP,OccpCodePP);
    
    if (valid) {
        
        LANameField.text = clientName;
        [self.btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        if ([sex isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else {
            smokerSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"smoker:%@",smoker);
        
        [self getOccLoadExist];
        [self.btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        
        if (occLoading == 0) {
            LAOccLoadingField.text = @"STD";
        } else {
            LAOccLoadingField.text = [NSString stringWithFormat:@"%d",occLoading];
        }
        
        if (occCPA_PA > 4) {
            LACPAField.text = @"D";
            LAPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            LAPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
        dataInsert = [[NSMutableArray alloc] init];
        SIHandler *ss = [[SIHandler alloc] init];
        [dataInsert addObject:[[SIHandler alloc] initWithSI:SINo andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo]];
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            ss = [dataInsert objectAtIndex:i];
            NSLog(@"stored SI:%@ sex:%@",ss.storedSINo,ss.storedSex);
        }
    }
    else {
        
        LANameField.text = NamePP;
        sex = GenderPP;
        
        if ([sex isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else if ([smoker isEqualToString:@"N"]) {
            smokerSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"smoker:%@",smoker);
        
        [btnDOB setTitle:DOBPP forState:UIControlStateNormal];
        DOB = DOBPP;
        [self calculateAge];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        
        [btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        occuCode = OccpCodePP;
        [self getOccLoadExist];
        [self.btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        if (occLoading == 0) {
            LAOccLoadingField.text = @"STD";
        } else {
            LAOccLoadingField.text = [NSString stringWithFormat:@"%d",occLoading];
        }
        
        if (occCPA_PA > 4) {
            LACPAField.text = @"D";
            LAPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            LAPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
        
//            statusLabel.text = @"Data changed. Please resave!";
//            statusLabel.textColor = [UIColor redColor];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Data changed. Please resave!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1004];
        [alert show];
    }
}

#pragma mark - Action
- (IBAction)sexSegmentPressed:(id)sender
{
    if ([sexSegment selectedSegmentIndex]==0) {
        sex = @"M";
    } 
    else if (sexSegment.selectedSegmentIndex == 1){
        sex = @"F";
    }
}

- (IBAction)smokerSegmentPressed:(id)sender 
{
    if ([smokerSegment selectedSegmentIndex]==0) {
        smoker = @"Y";
    }
    else if (smokerSegment.selectedSegmentIndex == 1){
        smoker = @"N";
    }
}

- (IBAction)btnDOBPressed:(id)sender
{
    if(![popOverController isPopoverVisible]) {
        date1 = YES;
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

- (IBAction)btnOccPressed:(id)sender 
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

- (IBAction)doSaveLA:(id)sender
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789'@/-. "] invertedSet];
    
    if (LANameField.text.length <= 0) {   
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (age <= 0) {         
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (occuCode.length == 0) {        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else if ([LANameField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe('), alias(@), slash(/), dash(-) or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        //prompt save
        NSString *msg;
        if (useExist) {
            msg = @"Confirm changes?";
        } else {
            msg = @"Save?";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:1001];
        [alert show];
    }
}

- (IBAction)selectProspect:(id)sender
{
    if (_ProspectList == nil) {
        self.ProspectList = [[ListingTbViewController alloc] initWithStyle:UITableViewStylePlain];
        _ProspectList.delegate = self;
        popOverController = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
    [popOverController presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)goBack:(id)sender
{
    if (dataInsert.count != 0) {
        
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            SIHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainH = ss;
            main.mainBH = laBH;
            main.IndexTab = 4;
//            [self presentModalViewController:main animated:YES];
            [self presentViewController:main animated:NO completion:nil];
        }
    }
    else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.IndexTab = 4;
//        [self presentModalViewController:main animated:YES];
        [self presentViewController:main animated:NO completion:nil];

    }
}

- (IBAction)btnCommDatePressed:(id)sender
{
    if(![popOverController isPopoverVisible]) {
        date2 = YES;
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) {
        
        if (useExist) {
            NSLog(@"will update");
            [self updateData];
        } else {
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
    else if (alertView.tag==1004 && buttonIndex == 0) {
        
        if (smoker.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        } else {
            [self updateData];
        }        
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
    
//    NSString *birthYear = [DOB substringFromIndex:[DOB length]-4];
//    NSString *birthMonth = [DOB substringWithRange:NSMakeRange(3, 2)];
//    NSString *birthDay = [DOB substringWithRange:NSMakeRange(0, 2)];
    
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
            newALB = ALB - 1;  //edited by heng
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
    
    if (yearN==yearB && monthN==monthB && dayN==dayB) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}



#pragma mark - Handle Data

-(void)getOccLoading
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                            @"SELECT Class,PA_CPA,OccLoading_TL from Adm_Occp_Loading_Penta where OccpCode = \"%@\"",occuCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occuClass = sqlite3_column_int(statement, 0);
                occCPA_PA  = sqlite3_column_int(statement, 1);
                occLoading = sqlite3_column_int(statement, 2);
            
                if (occLoading == 0) {
                    LAOccLoadingField.text = @"STD";
                } else {
                    LAOccLoadingField.text = [NSString stringWithFormat:@"%d",occLoading];
                }
                
                if (occCPA_PA > 4) {
                    LACPAField.text = @"D";
                    LAPAField.text = @"D";
                } else {
                    LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
                    LAPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
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

-(void)getRunningSI
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastNo,LastUpdated FROM Adm_TrnTypeNo WHERE TrnTypeCode=\"SI\""];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SILastNo = sqlite3_column_int(statement, 0);
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                SIDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastSINo:%d SIDate:%@",SILastNo,SIDate);
                
            } else {
                NSLog(@"error check logout");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    if (SILastNo == 0 && SIDate == NULL) {
        [self updateFirstRunSI];
    } else {
        [self updateFirstRunSI];
    }
}

-(void)updateFirstRunSI
{
    int newLastNo;
    newLastNo = SILastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                    @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"SI\"",newLastNo,dateString];

        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Run SI update!");
                
            } else {
                NSLog(@"Run SI update Failed!");
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
                
                const char *lastDate = (const char *)sqlite3_column_text(statement, 1);
                CustDate = lastDate == NULL ? nil : [[NSString alloc] initWithUTF8String:lastDate];
                
                NSLog(@"LastCustNo:%d CustDate:%@",CustLastNo,CustDate);
                
            } else {
                NSLog(@"error check tbl_Adm_TrnTypeNo");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    if (CustLastNo == 0 && CustDate == NULL) {
        [self updateFirstRunCust];
    } else {
        [self updateFirstRunCust];
    }
}

-(void)updateFirstRunCust
{
    int newLastNo;
    newLastNo = CustLastNo + 1;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                    @"UPDATE Adm_TrnTypeNo SET LastNo= \"%d\",LastUpdated= \"%@\" WHERE TrnTypeCode=\"CL\"",newLastNo,dateString];
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

-(void)getOccLoadExist
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                @"SELECT OccpCode,OccpDesc,Class,PA_CPA,OccLoading_TL from Adm_Occp_Loading_Penta where OccpCode = \"%@\"",occuCode];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                occuDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                occuClass = sqlite3_column_int(statement, 2);
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

-(void)insertData
{
    [self getRunningSI];
    [self getRunningCustCode];
    
    //generate SINo || CustCode
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *currentdate = [dateFormatter stringFromDate:[NSDate date]];
    
    int runningNoSI = SILastNo + 1;
    int runningNoCust = CustLastNo + 1;
    SINo = [[NSString alloc] initWithFormat:@"SI%@-000%d",currentdate,runningNoSI];
    CustCode = [[NSString alloc] initWithFormat:@"CL%@-000%d",currentdate,runningNoCust];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                        @"INSERT INTO Trad_LAPayor (SINo, CustCode,PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"%@\",\"%@\",\"LA\",\"1\",\"%@\",\"hla\")",SINo, CustCode,commDate];
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
                    @"INSERT INTO Clt_Profile (CustCode, Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")", CustCode, LANameField.text, smoker, sex, DOB, age, ANB, occuCode, commDate,IndexNo];
        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");

                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
            } else {
                NSLog(@"Failed LA2");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in inserting record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        
        dataInsert = [[NSMutableArray alloc] init];
        SIHandler *ss = [[SIHandler alloc] init];
        [dataInsert addObject:[[SIHandler alloc] initWithSI:SINo andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo]];
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            ss = [dataInsert objectAtIndex:i];
            NSLog(@"stored %@",ss.storedSINo);
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
        NSString *querySQL = [NSString stringWithFormat:
            @"UPDATE Clt_Profile SET Name=\"%@\", Smoker=\"%@\", Sex=\"%@\", DOB=\"%@\", ALB=\"%d\", ANB=\"%d\", OccpCode=\"%@\", DateModified=\"%@\", ModifiedBy=\"hla\" WHERE id=\"%d\"",LANameField.text,smoker,sex,DOB,age,ANB,occuCode,currentdate,clientID];
        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Record saved." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [SuccessAlert show];
                
                statusLabel.text = @"";
                
                if (age < 16) {
                    [self checking2ndLA];
                    if (CustCode2.length != 0) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"2nd Life Assured's details will be deleted due to life Assured age is less than 16" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1002];
                        [alert show];
                    }
                }
                else if (age >= 18) {
                    [self checkingPayor];
                    if (payorSINo.length != 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Payor's details will be deleted due to life Assured age is greater or equal to 18" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1003];
                        [alert show];
                    }
                }
            } else {
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            
            dataInsert = [[NSMutableArray alloc] init];
            SIHandler *ss = [[SIHandler alloc] init];
            [dataInsert addObject:[[SIHandler alloc] initWithSI:SINo andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo]];
            for (NSUInteger i=0; i< dataInsert.count; i++) {
                ss = [dataInsert objectAtIndex:i];
                NSLog(@"stored SI%@, sex:%@",ss.storedSINo,ss.storedSex);
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
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id, b.IndexNo FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",[self.requestSINo description]];
    
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
                clientID = sqlite3_column_int(statement, 9);
                IndexNo = sqlite3_column_int(statement, 10);
                
//                NSLog(@"sex:%@",sex);
            
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
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
            @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];

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

-(void)checkingPayor
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
        @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",[self.requestSINo description]];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
            } else {
                NSLog(@"error access tbl_SI_Trad_LAPayor");
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
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",[self.requestSINo description]];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                CustCode2 = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                clientID2 = sqlite3_column_int(statement, 9);
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",CustCode2];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_LAPayor WHERE CustCode=\"%@\"",payorCustCode];
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
                
            } else {
                NSLog(@"Clt_Profile delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}



#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode
{
    if ([NSString stringWithFormat:@"%d",IndexNo] != NULL) {
        smoker = nil;
    }
    useExist = NO;
    statusLabel.text = @"";
    NSLog(@"namedb:%@, gender:%@",aaName,aaGender);
    IndexNo = [aaIndex intValue];
    
    NSLog(@"view new client");
    DOB = aaDOB;
    [self calculateAge];
    if (age > 70) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured's age exceed HLA Income Builder maximum entry age (70 years old)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        LANameField.text = aaName;
        sex = aaGender;
        [smokerSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        if ([sex isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
        [btnDOB setTitle:DOB forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
                
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        commDate = [dateFormatter stringFromDate:[NSDate date]];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        occuCode = aaCode;
        [self getOccLoadExist];
        [self.btnOccp setTitle:occuDesc forState:UIControlStateNormal];
        
        if (occLoading == 0) {
            LAOccLoadingField.text = @"STD";
        } else {
            LAOccLoadingField.text = [NSString stringWithFormat:@"%d",occLoading];
        }
        
        if (occCPA_PA > 4) {
            LACPAField.text = @"D";
            LAPAField.text = @"D";
        } else {
            LACPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
            LAPAField.text = [NSString stringWithFormat:@"%d",occCPA_PA];
        }
    }
    
    [popOverController dismissPopoverAnimated:YES];
    
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    if (date1) {
        [self.btnDOB setTitle:aDate forState:UIControlStateNormal];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%@",aAge];
        DOB = aDate;
        age = bAge;
        ANB = aANB;
        [popOverController dismissPopoverAnimated:YES];
        date1 = NO;
    } else if (date2) {
        [self.btnCommDate setTitle:aDate forState:UIControlStateNormal];
        commDate = aDate;
        [popOverController dismissPopoverAnimated:YES];
        date2 = NO;
    }
    
}

-(void) joblist:(JobListTbViewController *)inController selectCode:(NSString *)aaCode selectDesc:(NSString *)aaDesc
{
    [self.btnOccp setTitle:aaDesc forState:UIControlStateNormal];
    occuCode = [[NSString alloc] initWithFormat:@"%@",aaCode];
    [self getOccLoading];
    [popOverController dismissPopoverAnimated:YES];
}

#pragma mark - Memory management
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setNamePP:nil];
    [self setGenderPP:nil];
    [self setDOBPP:nil];
    [self setOccpCodePP:nil];
    [self setLANameField:nil];
    [self setSexSegment:nil];
    [self setSmokerSegment:nil];
    [self setLAAgeField:nil];
    [self setLAOccLoadingField:nil];
    [self setLACPAField:nil];
    [self setLAPAField:nil];
    [self setMyScrollView:nil];
    [self setSmoker:nil];
    [self setSex:nil];
    [self setOccDesc:nil];
    [self setOccCode:nil];
    [self setSINo:nil];
    [self setCustCode:nil];
    [self setSIDate:nil];
    [self setCustDate:nil];
    [self setBtnDOB:nil];
    [self setBtnOccp:nil];
    [self setDOB:nil];
    [self setJobDesc:nil];
    [self setRequestSINo:nil];
    [self setClientName:nil];
    [self setOccuCode:nil];
    [self setCommencementDate:nil];
    [self setOccuDesc:nil];
    [self setPayorSINo:nil];
    [self setBtnCommDate:nil];
    [self setStatusLabel:nil];
    [super viewDidUnload];
}

@end
