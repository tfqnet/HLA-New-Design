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

#import "AppDelegate.h"
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
@synthesize btnCommDate;
@synthesize statusLabel;
@synthesize sex,smoker,age,ANB,DOB,jobDesc,SINo,CustCode;
@synthesize occDesc,occCode,occLoading,payorSINo,occCPA_PA;
@synthesize popOverController,requestSINo,clientName,occuCode,occuDesc,CustCode2,payorCustCode;
@synthesize dataInsert,laH,commDate,occuClass,IndexNo,laBH;
@synthesize ProspectList=_ProspectList;
@synthesize NamePP,DOBPP,GenderPP,OccpCodePP;
@synthesize LADOBField,LAOccpField,getSINo,dataInsert2;
@synthesize getHL,getHLTerm,getPolicyTerm,getSumAssured,getTempHL,getTempHLTerm,MOP,cashDividend,advanceYearlyIncome,yearlyIncome;
@synthesize termCover,planCode,arrExistRiderCode;
@synthesize prospectPopover = _prospectPopover;
@synthesize idPayor,idProfile,idProfile2,lastIdPayor,lastIdProfile;
@synthesize delegate = _delegate;
@synthesize basicSINo,requestCommDate,requestIndexNo,requestLastIDPay,requestLastIDProf,requestSex,requestSmoker;
@synthesize LADate = _LADate;
@synthesize datePopover = _datePopover;

id temp;
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
    LAAgeField.enabled = NO;
    LAOccLoadingField.enabled = NO;
    LACPAField.enabled = NO;
    LAPAField.enabled = NO;
    LADOBField.enabled = NO;
    LAOccpField.enabled = NO;
    useExist = NO;
    AgeChanged = NO;
    JobChanged = NO;
    
    getSINo = [self.requestSINo description];
    NSLog(@"LA-SINo: %@",getSINo);
    
    if (getSINo.length != 0) {
        
        [self checkingExisting];
        if (SINo.length != 0) {
            [self getProspectData];
            [self getSavedField];
            NSLog(@"will use existing data");
        }
        
        [self checkingExistingSI];
        if (basicSINo.length != 0) {
            [self getExistingBasic];
            [self getTerm];
            [self toogleExistingBasic];
        }
    }
    else {
        NSLog(@"SINo not exist!");
    }
    
    if (requestIndexNo != 0) {
        [self tempView];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
    [super viewWillAppear:animated];
//    self.view.superview.bounds = CGRectMake(-98, 0, 1000, 748);
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
    BOOL valid = TRUE;
    if (![NamePP isEqualToString:clientName]) {
        valid = FALSE;
    }
    
    if (![GenderPP isEqualToString:sex]) {
        valid = FALSE;
    }
    
    if (![DOB isEqualToString:DOBPP]) {
        valid = FALSE;
        AgeChanged = YES;
    }
    
    if (![occuCode isEqualToString:OccpCodePP]) {
        valid = FALSE;
        JobChanged = YES;
    }
    
    if (valid) {
        
        LANameField.text = clientName;
        LADOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
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
        LAOccpField.text = [[NSString alloc] initWithFormat:@"%@",occuDesc];
        
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
        
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
    }
    else {
        
        LANameField.text = NamePP;
        sex = GenderPP;
        
        if ([GenderPP isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",GenderPP);
        
        if ([smoker isEqualToString:@"Y"]) {
            smokerSegment.selectedSegmentIndex = 0;
        } else if ([smoker isEqualToString:@"N"]) {
            smokerSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"smoker:%@",smoker);
        
        DOB = DOBPP;
        [self calculateAge];
            
        LADOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        occuCode = OccpCodePP;
        [self getOccLoadExist];
        LAOccpField.text = [[NSString alloc] initWithFormat:@"%@",occuDesc];
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
    
        [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
        
        if (age > 70) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Prospect's information will synchronize to this SI." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert setTag:1004];
            [alert show];
        }
    }
    
    if (age < 10) {
        [self checkingPayor];
        if (payorSINo.length == 0) {
            
            AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
            zzz.ExistPayor = NO;
        }
    }
}

-(void)toogleExistingBasic
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    NSString *sumAss = [formatter stringFromNumber:[NSNumber numberWithDouble:getSumAssured]];
    sumAss = [sumAss stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    [self getPlanCodePenta];
    
    [_delegate BasicSI:getSINo andAge:age andOccpCode:occuCode andCovered:termCover andBasicSA:sumAss andBasicHL:getHL andBasicTempHL:getTempHL andMOP:MOP andPlanCode:planCode andAdvance:advanceYearlyIncome];
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.SICompleted = YES;
}

-(void)tempView
{
    IndexNo = requestIndexNo;
    lastIdPayor = requestLastIDPay;
    lastIdProfile = requestLastIDProf;
    [self getProspectData];
    
    LANameField.text = NamePP;
    DOB = DOBPP;
    commDate = [self.requestCommDate description];
    [self calculateAge];
    LADOBField.text = [[NSString alloc] initWithFormat:@"%@",DOBPP];
    LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
    [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
    
    sex = [self.requestSex description];
    if ([sex isEqualToString:@"M"]) {
        sexSegment.selectedSegmentIndex = 0;
    } else {
        sexSegment.selectedSegmentIndex = 1;
    }
    NSLog(@"sex:%@",sex);
    
    smoker = [self.requestSmoker description];
    if ([smoker isEqualToString:@"Y"]) {
        smokerSegment.selectedSegmentIndex = 0;
    } else {
        smokerSegment.selectedSegmentIndex = 1;
    }
    NSLog(@"smoker:%@",smoker);
    
    occuCode = OccpCodePP;
    [self getOccLoadExist];
    LAOccpField.text = [[NSString alloc] initWithFormat:@"%@",occuDesc];
    
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
    [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
    Inserted = YES;
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

- (IBAction)doSaveLA:(id)sender
{
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789'@/-. "] invertedSet];
           
    if (LANameField.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured Name is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [LANameField becomeFirstResponder];
    }
    else if (smoker.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    
    else if ([btnCommDate.titleLabel.text isEqualToString:@"(null)"] || btnCommDate.titleLabel.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Commencement date is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (AgeLess) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert setTag:1005];
        [alert show];
    }
    else if (age > 70) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if (occuCode.length == 0 || LAOccpField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Please select an Occupation Description." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    } else if ([LANameField.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe('), alias(@), slash(/), dash(-) or dot(.)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else if ([occuCode isEqualToString:@"OCC01975"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
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
        self.prospectPopover = [[UIPopoverController alloc] initWithContentViewController:_ProspectList];
    }
    
//    [self.prospectPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [self.prospectPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (IBAction)btnCommDatePressed:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [btnCommDate setTitle:dateString forState:UIControlStateNormal];
    temp = btnCommDate.titleLabel.text;

    if (_LADate == Nil) {
        
        self.LADate = [self.storyboard instantiateViewControllerWithIdentifier:@"showDate"];
        _LADate.delegate = self;
        _LADate.msgDate = temp;
        self.datePopover = [[UIPopoverController alloc] initWithContentViewController:_LADate];
    }
    
    [self.datePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.datePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    else if (alertView.tag==1004 && buttonIndex == 0) {
        
        if (smoker.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Smoker is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else if ([OccpCodePP isEqualToString:@"OCC01975"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"There is no existing plan which can be offered to this occupation." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
        }
        else {
            //---------
            sex = GenderPP;
            DOB = DOBPP;
            occuCode = OccpCodePP;
            [self calculateAge];
            [self getOccLoadExist];
            
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
            //-------------------
            
        
            [self calculateAge];
            if (AgeLess) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age must be at least 30 days." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                [alert setTag:1005];
                [alert show];
            }
            else {
                if (AgeChanged||JobChanged) {
                    [self checkExistRider];
                    if (arrExistRiderCode.count > 0) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Rider(s) has been deleted due to business rule." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
                        [alert setTag:1007];
                        [alert show];
                    }
                }
                
                [self updateData];
            }
        }
    }
    else if (alertView.tag==1004 && buttonIndex == 1) { // added by heng
        LANameField.text = clientName;
        LADOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
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
        LAOccpField.text = [[NSString alloc] initWithFormat:@"%@",occuDesc];
        
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
        /*
        dataInsert = [[NSMutableArray alloc] init];
        SIHandler *ss = [[SIHandler alloc] init];
        [dataInsert addObject:[[SIHandler alloc] initWithIDPayor:idPayor andIDProfile:idProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker]];
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            ss = [dataInsert objectAtIndex:i];
            NSLog(@"storedLA sex:%@",ss.storedSex);
        }
        */
    }    
    else if (alertView.tag==1005 && buttonIndex == 0) {
        
        LANameField.text = @"";
        [sexSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        LADOBField.text = @"";
        LAAgeField.text = @"";
        [self.btnCommDate setTitle:@"" forState:UIControlStateNormal];
        LAOccpField.text = @"";
        LAOccLoadingField.text = @"";
        LACPAField.text = @"";
        LAPAField.text = @"";
    }
    else if (alertView.tag==1006 && buttonIndex == 0) //record saved
    {
//        [self closeScreen];
    }
    else if (alertView.tag == 1007 && buttonIndex == 0) {
        [self deleteRider];
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

/*
-(void)closeScreen
{
    if (dataInsert.count != 0 && dataInsert2.count == 0) {
        
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            SIHandler *ss = [dataInsert objectAtIndex:i];
            MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            main.modalPresentationStyle = UIModalPresentationFullScreen;
            main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            main.mainLaH = ss;
            main.mainBH = laBH;
            main.IndexTab = 3;
            [self presentViewController:main animated:NO completion:nil];
        }
    }
    else if (dataInsert.count != 0 && dataInsert2.count != 0) {
        
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        for (NSUInteger i=0; i< dataInsert.count; i++) {
            SIHandler *ss = [dataInsert objectAtIndex:i];
            main.mainLaH = ss;
        }
        for (NSUInteger i=0; i< dataInsert2.count; i++) {
            BasicPlanHandler *pp = [dataInsert2 objectAtIndex:i];
            main.mainBH = pp;
        }
        
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.IndexTab = 3;
        [self presentViewController:main animated:NO completion:nil];
    }
    else {
        MainScreen *main = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
        main.modalPresentationStyle = UIModalPresentationFullScreen;
        main.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        main.IndexTab = 3;
        main.mainLaH = laH;
        [self presentViewController:main animated:NO completion:nil];
        
    }
} */


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
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:
                @"INSERT INTO Trad_LAPayor (PTypeCode,Sequence,DateCreated,CreatedBy) VALUES (\"LA\",\"1\",\"%@\",\"hla\")",commDate];
        
//        NSLog(@"%@",insertSQL);
        if(sqlite3_prepare_v2(contactDB, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA");
            }
            else {
                NSLog(@"Failed LA");
            }
            sqlite3_finalize(statement);
        }
        
        NSString *insertSQL2 = [NSString stringWithFormat:@"INSERT INTO Clt_Profile (Name, Smoker, Sex, DOB, ALB, ANB, OccpCode, DateCreated, CreatedBy,indexNo) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%d\", \"%d\", \"%@\", \"%@\", \"hla\", \"%d\")",LANameField.text, smoker, sex, DOB, age, ANB, occuCode, commDate,IndexNo];
        
//        NSLog(@"%@",insertSQL2);
        if(sqlite3_prepare_v2(contactDB, [insertSQL2 UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"Done LA2");
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
                              LANameField.text,smoker,sex,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,idProfile];
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
            
            [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
            
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
                              LANameField.text,smoker,sex,DOB,age,ANB,occuCode,currentdate,IndexNo, commDate,lastIdProfile];
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
            
            [_delegate LAIDPayor:lastIdPayor andIDProfile:lastIdProfile andAge:age andOccpCode:occuCode andOccpClass:occuClass andSex:sex andIndexNo:IndexNo andCommDate:commDate andSmoker:smoker];
            
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
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id, b.IndexNo, a.rowid FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=1",getSINo];
        
//        NSLog(@"%@",querySQL);
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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SINo FROM Trad_Details WHERE SINo=\"%@\"",getSINo];
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
            @"SELECT ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile WHERE IndexNo= \"%d\"",IndexNo];
        
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
                @"SELECT SINo, PolicyTerm, BasicSA, PremiumPaymentOption, CashDividend, YearlyIncome, AdvanceYearlyIncome, HL1KSA, HL1KSATerm, TempHL1KSA, TempHL1KSATerm FROM Trad_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                basicSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                getPolicyTerm = sqlite3_column_int(statement, 1);
                getSumAssured = sqlite3_column_double(statement, 2);
                MOP = sqlite3_column_int(statement, 3);
                cashDividend = [[NSString alloc ] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                yearlyIncome = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                advanceYearlyIncome = sqlite3_column_int(statement, 6);
                
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 7);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 8);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 9);
                getTempHL = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getTempHLTerm = sqlite3_column_int(statement, 10);
                
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
        @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"PY\" AND a.Sequence=1",getSINo];
        
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                payorSINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                payorCustCode = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
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
                @"SELECT a.SINo, a.CustCode, b.Name, b.Smoker, b.Sex, b.DOB, b.ALB, b.OccpCode, b.DateCreated, b.id FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.SINo=\"%@\" AND a.PTypeCode=\"LA\" AND a.Sequence=2",getSINo];
        
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
                [_delegate secondLADelete];
                
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
                [_delegate PayorDeleted];
                
            } else {
                NSLog(@"Clt_Profile delete Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void) getTerm
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                        @"SELECT MinTerm,MaxTerm,MinSA,MaxSA FROM Trad_Sys_Mtn WHERE PlanCode=\"HLAIB\""];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int maxTerm  =  sqlite3_column_int(statement, 1);
                termCover = maxTerm - age;
            }
            else {
                NSLog(@"error access Trad_Mtn");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)getPlanCodePenta
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT PentaPlanCode FROM Trad_Sys_Product_Mapping WHERE SIPlanCode=\"HLAIB\" AND PremPayOpt=\"%d\"",MOP];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                planCode =  [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
            } else {
                NSLog(@"error access PentaPlanCode");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkExistRider
{
    arrExistRiderCode = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT RiderCode FROM Trad_Rider_Details WHERE SINo=\"%@\"",getSINo];
//        NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [arrExistRiderCode addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
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
        NSString *querySQL = [NSString stringWithFormat:@"DELETE FROM Trad_Rider_Details WHERE SINo=\"%@\"",getSINo];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"All rider delete!");
                [_delegate RiderAdded];
                
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
        NSString *querySQL = [NSString stringWithFormat: @"SELECT rowid FROM Trad_LAPayor ORDER by rowid desc limit 1"];
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

#pragma mark - delegate

-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode
{
    if ([NSString stringWithFormat:@"%d",IndexNo] != NULL) {
        smoker = @"N";
        DiffClient = YES;
    }
    useExist = NO;
    statusLabel.text = @"";
    IndexNo = [aaIndex intValue];
    
    AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    zzz.ExistPayor = YES;
    
    NSLog(@"view new client");
    if (commDate.length == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        commDate = [dateFormatter stringFromDate:[NSDate date]];
    }
    
    DOB = aaDOB;
    [self calculateAge];
    if (age > 70) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Life Assured's age exceed HLA Income Builder maximum entry age (70 years old)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Age Last Birthday must be less than or equal to 70 for this product." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
    }
    else {
        LANameField.text = aaName;
        sex = aaGender;
//        [smokerSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        
        if ([sex isEqualToString:@"M"]) {
            sexSegment.selectedSegmentIndex = 0;
        } else {
            sexSegment.selectedSegmentIndex = 1;
        }
        NSLog(@"sex:%@",sex);
        
        LADOBField.text = [[NSString alloc] initWithFormat:@"%@",DOB];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
        [self.btnCommDate setTitle:commDate forState:UIControlStateNormal];
        
        occuCode = aaCode;
        [self getOccLoadExist];
        LAOccpField.text = [[NSString alloc] initWithFormat:@"%@",occuDesc];
        
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
    
    [self.prospectPopover dismissPopoverAnimated:YES];
    
}

-(void)datePick:(DateViewController *)inController strDate:(NSString *)aDate strAge:(NSString *)aAge intAge:(int)bAge intANB:(int)aANB
{
    if (aDate == NULL) {
        [btnCommDate setTitle:temp forState:UIControlStateNormal];
        commDate = temp;
    }
    else {
        [self.btnCommDate setTitle:aDate forState:UIControlStateNormal];
        commDate = aDate;
    }
    
    if (DOB.length != 0 || LADOBField.text.length != 0) {
        [self calculateAge];
        LAAgeField.text = [[NSString alloc] initWithFormat:@"%d",age];
    }
    
    [self.datePopover dismissPopoverAnimated:YES];
}


#pragma mark - Memory management
-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

- (void)viewDidUnload
{
    [self resignFirstResponder];
    [self setLADOBField:nil];
    [self setLAOccpField:nil];
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
    [self setDOB:nil];
    [self setJobDesc:nil];
    [self setRequestSINo:nil];
    [self setClientName:nil];
    [self setOccuCode:nil];
    [self setOccuDesc:nil];
    [self setPayorSINo:nil];
    [self setBtnCommDate:nil];
    [self setStatusLabel:nil];
    [self setLADOBField:nil];
    [self setLAOccpField:nil];
    [self setMyToolBar:nil];
    [super viewDidUnload];
}

@end
