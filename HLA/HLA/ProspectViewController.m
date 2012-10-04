//
//  ProspectViewController.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProspectViewController.h"
#import "ProspectListing.h"
#import <QuartzCore/QuartzCore.h>

@interface ProspectViewController ()

@end

@implementation ProspectViewController
@synthesize outletType1;
@synthesize pickerToolbar;
@synthesize outletContactType;
@synthesize txtRemark;
@synthesize txtEmail;
@synthesize txtContact1;
@synthesize txtContact2;
@synthesize txtContact3;
@synthesize txtContact4;
@synthesize txtContact5;
@synthesize outletType2;
@synthesize outletType3;
@synthesize outletType4;
@synthesize outletType5;
@synthesize outletDobPicker;
@synthesize outletDOB;
@synthesize txtHomeAddr1;
@synthesize txtHomeAddr2;
@synthesize txtHomeAddr3;
@synthesize txtHomePostCode;
@synthesize txtHomeTown;
@synthesize txtHomeState;
@synthesize txtHomeCountry;
@synthesize txtOfficeAddr1;
@synthesize txtOfficeAddr2;
@synthesize txtOfficeAddr3;
@synthesize txtOfficePostcode;
@synthesize txtOfficeTown;
@synthesize txtOfficeState;
@synthesize txtOfficeCountry;
@synthesize txtExactDuties;
@synthesize outletOccup;
@synthesize myScrollView;
@synthesize txtPreferredName;
@synthesize txtFullName, ContactTypeTracker;
@synthesize segGender, ContactType, DOB, gender, SelectedStateCode, SelectedOfficeStateCode, OccupCodeSelected;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
@synthesize btnCancel;
@synthesize ContactTypeClass = _ContactTypeClass;
@synthesize ContactTypePopover = _ContactTypePopover;
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
	
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    txtRemark.layer.borderWidth = 3.0f;
    txtRemark.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [txtHomePostCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [txtOfficePostcode addTarget:self action:@selector(OfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    txtHomeTown.backgroundColor = [UIColor grayColor];
    txtHomeState.backgroundColor = [UIColor grayColor];
    txtHomeCountry.backgroundColor = [UIColor grayColor];
    txtOfficeTown.backgroundColor = [UIColor grayColor];
    txtOfficeState.backgroundColor = [UIColor grayColor];
    txtOfficeCountry.backgroundColor = [UIColor grayColor];
    //ContactType = [[NSArray alloc] init];
    ContactType = [[NSArray alloc] initWithObjects:@"Mobile", @"Home", @"Fax", @"Office", nil];
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [ContactType count];
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [ContactType objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSString *SelectedContactType = [ContactType objectAtIndex:row];
    
    if (ContactTypeTracker == @"2") {
        txtContact2.enabled = true;
        [outletType2 setTitle:SelectedContactType forState:UIControlStateNormal];   
        
    }
    else if (ContactTypeTracker == @"1") {
        txtContact1.enabled = true;
        [outletType1 setTitle:SelectedContactType forState:UIControlStateNormal]; 
        
    }
    else if (ContactTypeTracker == @"3") {
        txtContact3.enabled = true;
        [outletType3 setTitle:SelectedContactType forState:UIControlStateNormal]; 
        
    }
    else if (ContactTypeTracker == @"4") {
        txtContact4.enabled = true;
        [outletType4 setTitle:SelectedContactType forState:UIControlStateNormal]; 
    }
    else if (ContactTypeTracker == @"5") {
        txtContact5.enabled = TRUE;
        [outletType5 setTitle:SelectedContactType forState:UIControlStateNormal]; 
    }
    
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
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
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


- (void)viewDidUnload
{
    [self setTxtPreferredName:nil];
    [self setTxtFullName:nil];
    [self setSegGender:nil];
    [self setOutletDOB:nil];
    [self setTxtHomeAddr1:nil];
    [self setTxtHomeAddr2:nil];
    [self setTxtHomeAddr3:nil];
    [self setTxtHomePostCode:nil];
    [self setTxtHomeTown:nil];
    [self setTxtHomeState:nil];
    [self setTxtHomeCountry:nil];
    [self setTxtOfficeAddr1:nil];
    [self setTxtOfficeAddr2:nil];
    [self setTxtOfficeAddr3:nil];
    [self setTxtOfficePostcode:nil];
    [self setTxtOfficeTown:nil];
    [self setTxtOfficeState:nil];
    [self setTxtOfficeCountry:nil];
    [self setTxtExactDuties:nil];
    [self setOutletOccup:nil];
    [self setOutletDobPicker:nil];
    [self setOutletContactType:nil];
    [self setPickerToolbar:nil];
    [self setTxtRemark:nil];
    [self setMyScrollView:nil];
    [self setTxtEmail:nil];
    [self setTxtContact1:nil];
    [self setOutletType1:nil];
    [self setBtnCancel:nil];
    [self setTxtContact2:nil];
    [self setTxtContact3:nil];
    [self setTxtContact4:nil];
    [self setTxtContact5:nil];
    [self setOutletType2:nil];
    [self setOutletType3:nil];
    [self setOutletType4:nil];
    [self setOutletType5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)ActionGender:(id)sender {
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"M";
    } 
    else {
        gender = @"F";
    }
}

- (IBAction)btnDOB:(id)sender {
    [self resignFirstResponder];
    outletDobPicker.hidden = NO;
    pickerToolbar.hidden = NO;
    [self.view endEditing:TRUE];
    txtRemark.hidden = TRUE;
    //ContactTypePicker.hidden = true;
    outletContactType.hidden = true;
}
- (IBAction)btnOccup:(id)sender {
    if (_OccupationList == nil) {
        self.OccupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        _OccupationList.delegate = self;
        self.OccupationListPopover = [[UIPopoverController alloc] initWithContentViewController:_OccupationList];               
    }
    
    [self.OccupationListPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionDobDate:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *pickerDate = [dateFormatter stringFromDate:[outletDobPicker date]];
    
    NSString *msg = [NSString stringWithFormat:@"%@",pickerDate];
    [self.outletDOB setTitle:msg forState:UIControlStateNormal];
}
- (IBAction)btnDone:(id)sender {
    if (outletDobPicker.hidden == FALSE) { //DOB picker
        pickerToolbar.hidden = YES;
        outletDobPicker.hidden = YES;
        txtRemark.hidden = FALSE;
    }
    else { // Contact type picker
        pickerToolbar.hidden = true;
        //ContactTypePicker.hidden = true;
        outletContactType.hidden = true;
        txtRemark.hidden = FALSE;
    }

}
- (IBAction)btnSave:(id)sender {
    if ([self Validation] == TRUE) {
        
        sqlite3_stmt *statement;
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"INSERT INTO prospect_profile(\"PreferredName\",\"ProspectName\", \"ProspectDOB\", "
                                   "\"ProspectGender\", \"ResidenceAddress1\", \"ResidenceAddress2\", \"ResidenceAddress3\",\"ResidenceAddressTown\",\"ResidenceAddressState\",\"ResidenceAddressPostCode\", "
                                   "\"ResidenceAddressCountry\", \"OfficeAddress1\",\"OfficeAddress2\",\"OfficeAddress3\",\"OfficeAddressTown\",\"OfficeAddressState\",\"OfficeAddressPostCode\", "
                                   "\"OfficeAddressCountry\", \"ProspectEmail\",\"ProspectOccupationCode\", \"ExactDuties\",\"ProspectRemark\",\"DateCreated\","
                                   "\"CreatedBy\",\"DateModified\",\"ModifiedBy\") "
                                   "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",
                                   txtPreferredName.text, txtFullName.text, outletDOB.titleLabel.text, gender, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text, 
                                   txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, txtHomeCountry.text, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text,
                                   SelectedOfficeStateCode, txtOfficePostcode.text, txtOfficeCountry.text, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text, 
                                   @"27-7-1988", @"1", @"28-5-1987", @"1"];
            
            const char *insert_stmt = [insertSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    [self GetLastID];
                    
                } else {
                    
                    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Fail in inserting into profile table" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [failAlert show];
                }
                sqlite3_finalize(statement);
            }
            else {
                NSLog(@"Error Statement");
            }
            sqlite3_close(contactDB);        
        }
        else {
            NSLog(@"Error Open");
        }
        
    }

}

- (bool) Validation{
    /*
     if (![txtNickName.text isEqualToString:@""]) {
     
     
     } 
     else {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:@"Preferred Name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
     [alert show];
     return false;    
     }
     */
    
    if([txtPreferredName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Preferred Name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if([txtFullName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Full Name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if(segGender.selectedSegmentIndex == -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Gender field cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if([outletDOB.titleLabel.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Date of Birth (DOB) cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if([txtHomeAddr1.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Home Address cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if(![txtContact1.text isEqualToString:@"" ]){
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtContact1.text];
        valid = [alphaNums isSupersetOfSet:inStringSet]; 
        if (!valid) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Contact number must be in numeric form" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return false;
        }
        
    }
    
    if(![txtEmail.text isEqualToString:@""]){
        if( [self NSStringIsValidEmail:txtEmail.text] == FALSE){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Email Address is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            return FALSE;
        }
    }
    
    return true;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) GetLastID{
    
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *lastID;
    NSString *contactCode;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select indexno  from prospect_profile order by \"indexNo\" desc limit 1"];
        const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK) 
        {
            if (sqlite3_step(statement2) == SQLITE_ROW)
            {
                lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                sqlite3_finalize(statement2);
                
            }
                
        }
    }
    
    for (int a = 0; a<5; a++) {
        
        switch (a) {
            case 0:
                
                if (outletType1.titleLabel.text == @"Mobile") {
                    contactCode = @"CONT008";    
                }
                else if (outletType1.titleLabel.text == @"Home") {
                    contactCode = @"CONT006";
                }
                else if (outletType1.titleLabel.text == @"Fax") {
                    contactCode = @"CONT009";
                }
                else if (outletType1.titleLabel.text == @"Office") {
                    contactCode = @"CONT007";
                }
                else {
                    contactCode = @"";
                }
                                
                break;
            
            case 1:
                if (outletType2.titleLabel.text == @"Mobile") {
                    contactCode = @"CONT008";    
                }
                else if (outletType2.titleLabel.text == @"Home") {
                    contactCode = @"CONT006";
                }
                else if (outletType2.titleLabel.text == @"Fax") {
                    contactCode = @"CONT009";
                }
                else if (outletType2.titleLabel.text == @"Office") {
                    contactCode = @"CONT007";
                }
                else {
                    contactCode = @"";
                }
                break;
            
            case 2:
                if (outletType3.titleLabel.text == @"Mobile") {
                    contactCode = @"CONT008";    
                }
                else if (outletType3.titleLabel.text == @"Home") {
                    contactCode = @"CONT006";
                }
                else if (outletType3.titleLabel.text == @"Fax") {
                    contactCode = @"CONT009";
                }
                else if (outletType3.titleLabel.text == @"Office") {
                    contactCode = @"CONT007";
                }
                else {
                    contactCode = @"";
                }
                break;
            
            case 3:
                if (outletType4.titleLabel.text == @"Mobile") {
                    contactCode = @"CONT008";    
                }
                else if (outletType4.titleLabel.text == @"Home") {
                    contactCode = @"CONT006";
                }
                else if (outletType4.titleLabel.text == @"Fax") {
                    contactCode = @"CONT009";
                }
                else if (outletType4.titleLabel.text == @"Office") {
                    contactCode = @"CONT007";
                }
                else {
                    contactCode = @"";
                }
                break;
            
            case 4:
                if (outletType5.titleLabel.text == @"Mobile") {
                    contactCode = @"CONT008";    
                }
                else if (outletType5.titleLabel.text == @"Home") {
                    contactCode = @"CONT006";
                }
                else if (outletType5.titleLabel.text == @"Fax") {
                    contactCode = @"CONT009";
                }
                else if (outletType5.titleLabel.text == @"Office") {
                    contactCode = @"CONT007";
                }
                else {
                    contactCode = @"";
                }
                break;
                
            default:
                break;
        }
        
        if (![contactCode isEqualToString:@""]) {
            /*
            NSString *GetLastIdSQL = [NSString stringWithFormat:@"Select last_insert_rowid() from prospect_profile"];
            const char *SelectLastId_stmt = [GetLastIdSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, SelectLastId_stmt, -1, &statement2, NULL) == SQLITE_OK) 
            {
                if (sqlite3_step(statement2) == SQLITE_ROW)
                {
                    lastID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2, 0)];
                    
                    sqlite3_finalize(statement2);
                    NSString *insertContactSQL = [NSString stringWithFormat:
                                                  @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                                  " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact1.text, @"N"];
                    const char *insert_contactStmt = [insertContactSQL UTF8String];
                    if(sqlite3_prepare_v2(contactDB, insert_contactStmt, -1, &statement3, NULL) == SQLITE_OK) {
                        if (sqlite3_step(statement3) == SQLITE_DONE){
                            sqlite3_finalize(statement3);
                            //UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Saved Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            //[SuccessAlert show];
                            
                        }
                        else {
                            NSLog(@"Error - 4");
                        }
                    }
                    else {
                        NSLog(@"Error - 3");
                    }
                }
                else {
                    NSLog(@"Error - 2 ");
                }
                sqlite3_close(contactDB);
            }
            else {
                
                NSLog(@"Error get last ID statement");
            }
             */
            NSString *insertContactSQL;
            if (a==0) {
                 insertContactSQL = [NSString stringWithFormat:
                                              @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                              " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact1.text, @"N"];
            }
            else if (a==1) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact2.text, @"N"];   
            }
            else if (a==2) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact3.text, @"N"];   
            }
            else if (a==3) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact4.text, @"N"];   
            }
            else if (a==4) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact5.text, @"N"];   
            }
            
            const char *insert_contactStmt = [insertContactSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, insert_contactStmt, -1, &statement3, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement3) == SQLITE_DONE){
                    sqlite3_finalize(statement3);
                    //UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Saved Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    //[SuccessAlert show];
                    
                }
                else {
                    NSLog(@"Error - 4");
                }
            }
            else {
                NSLog(@"Error - 3");
            }

        }
         
        
    }
    
    UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile"
                                                           message:@"Saved Successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    SuccessAlert.tag = 1;
    [SuccessAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        if (_delegate != Nil) {
            [_delegate FinishInsert ];
        }
        [self dismissModalViewControllerAnimated:YES];
    }

}

- (void)OccupCodeSelected:(NSString *)OccupCode{
    OccupCodeSelected = OccupCode;
}

- (IBAction)ActionCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES ];
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748-350);
    self.myScrollView.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 15;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    pickerToolbar.hidden = true;
    outletDobPicker.hidden = TRUE;
    txtRemark.hidden = FALSE;
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748);
    //ContactTypePicker.hidden = true;
    outletContactType.hidden = true;
}

-(void)textFieldDidChange:(id) sender
{
    //txtState.text = @"Selangor";
    //txtTown.text = @"Petaling Jaya";
    
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT \"Town\", \"Statedesc\", b.Statecode FROM adm_postcode as A, eproposal_state as B where trim(a.Statecode) = b.statecode and Postcode = %@ ", txtHomePostCode.text];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *Town = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *State = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *Statecode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)]; 
                
                txtHomeState.text = State;
                txtHomeTown.text = Town;
                txtHomeCountry.text = @"Malaysia";
                SelectedStateCode = Statecode;
                gotRow = true;
            }
            
        }
        
        if (gotRow == false) {
            UIAlertView *NoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            txtHomeState.text = @"";
            txtHomeTown.text = @"";
            txtHomeCountry.text = @"";
            SelectedStateCode = @"";
            [NoPostcode show];   
        }
    }
    
}

-(void)OfficePostcodeDidChange:(id) sender
{
    
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT \"Town\", \"Statedesc\", b.Statecode FROM adm_postcode as A, eproposal_state as B where trim(a.Statecode) = b.statecode and Postcode = %@ ", txtOfficePostcode.text];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *OfficeTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *OfficeState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *Statecode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                
                txtOfficeState.text = OfficeState;
                txtOfficeTown.text = OfficeTown;
                txtOfficeCountry.text = @"Malaysia";
                SelectedOfficeStateCode = Statecode;
                gotRow = true;
            }
            
            if (gotRow == false) {
                UIAlertView *NoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                txtOfficeState.text = @"";
                txtOfficeTown.text = @"";
                txtOfficeCountry.text = @"";
                SelectedOfficeStateCode = @"";
                [NoPostcode show];   
            }
        }
        
        
    } 
}

- (IBAction)btnContact1:(id)sender {
    /*
    //ContactTypePicker.hidden = false;
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    
    outletContactType.hidden = false;
    outletDobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"1";
    //if ([outletType1.titleLabel.text isEqualToString:@""]) {
        [outletType1 setTitle:@"Mobile" forState:UIControlStateNormal];
    //}
    */
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    txtContact1.enabled = true;
    ContactTypeTracker = @"1";
    if (_ContactTypeClass == nil) {
        self.ContactTypeClass = [[ContactTypeClass alloc] initWithStyle:UITableViewStylePlain];
        _ContactTypeClass.ContactTypeDelegate = self;
        self.ContactTypePopover = [[UIPopoverController alloc] initWithContentViewController:_ContactTypeClass];               
    }
    [self.ContactTypePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    [self.ContactTypePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}

- (void)OccupDescSelected:(NSString *)color {
    [outletOccup setTitle:color forState:UIControlStateNormal];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
}


- (IBAction)btnContact2:(id)sender {
    /*outletContactType.hidden = false;
    outletDobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"2";
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    if ([outletType2.titleLabel.text isEqualToString:@""]) {
        [outletType2 setTitle:@"Mobile" forState:UIControlStateNormal];
    }*/
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    txtContact2.enabled = true;
    ContactTypeTracker = @"2";
    if (_ContactTypeClass == nil) {
        self.ContactTypeClass = [[ContactTypeClass alloc] initWithStyle:UITableViewStylePlain];
        _ContactTypeClass.ContactTypeDelegate = self;
        self.ContactTypePopover = [[UIPopoverController alloc] initWithContentViewController:_ContactTypeClass];               
    }
    [self.ContactTypePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    [self.ContactTypePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnContact3:(id)sender {
    /*outletContactType.hidden = false;
    outletDobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"3";
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    if ([outletType3.titleLabel.text isEqualToString:@""]) {
        [outletType3 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
     */
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    txtContact3.enabled = true;
    ContactTypeTracker = @"3";
    if (_ContactTypeClass == nil) {
        self.ContactTypeClass = [[ContactTypeClass alloc] initWithStyle:UITableViewStylePlain];
        _ContactTypeClass.ContactTypeDelegate = self;
        self.ContactTypePopover = [[UIPopoverController alloc] initWithContentViewController:_ContactTypeClass];               
    }
    [self.ContactTypePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    [self.ContactTypePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnContact4:(id)sender {
    /*outletContactType.hidden = false;
    outletDobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"4";
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    if ([outletType4.titleLabel.text isEqualToString:@""]) {
        [outletType4 setTitle:@"Mobile" forState:UIControlStateNormal];
    }*/
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    txtContact4.enabled = true;
    ContactTypeTracker = @"4";
    if (_ContactTypeClass == nil) {
        self.ContactTypeClass = [[ContactTypeClass alloc] initWithStyle:UITableViewStylePlain];
        _ContactTypeClass.ContactTypeDelegate = self;
        self.ContactTypePopover = [[UIPopoverController alloc] initWithContentViewController:_ContactTypeClass];               
    }
    [self.ContactTypePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    [self.ContactTypePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnContact5:(id)sender {
    /*outletContactType.hidden = false;
    outletDobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"5";
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    if ([outletType5.titleLabel.text isEqualToString:@""]) {
        [outletType5 setTitle:@"Mobile" forState:UIControlStateNormal];
    }*/
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    txtContact5.enabled = true;
    ContactTypeTracker = @"5";
    if (_ContactTypeClass == nil) {
        self.ContactTypeClass = [[ContactTypeClass alloc] initWithStyle:UITableViewStylePlain];
        _ContactTypeClass.ContactTypeDelegate = self;
        self.ContactTypePopover = [[UIPopoverController alloc] initWithContentViewController:_ContactTypeClass];               
    }
    [self.ContactTypePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    
    [self.ContactTypePopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)ContactTypeSelected:(NSString *)ContactTypeString{
    if ([ContactTypeTracker isEqualToString:@"1" ]) {
        [outletType1 setTitle:ContactTypeString forState:UIControlStateNormal ];
        [self.ContactTypePopover dismissPopoverAnimated:YES];
    }
    else if ([ContactTypeTracker isEqualToString:@"2" ]) {
        [outletType2 setTitle:ContactTypeString forState:UIControlStateNormal ];
        [self.ContactTypePopover dismissPopoverAnimated:YES];
    }
    else if ([ContactTypeTracker isEqualToString:@"3" ]) {
        [outletType3 setTitle:ContactTypeString forState:UIControlStateNormal ];
        [self.ContactTypePopover dismissPopoverAnimated:YES];
    }
    else if ([ContactTypeTracker isEqualToString:@"4" ]) {
        [outletType4 setTitle:ContactTypeString forState:UIControlStateNormal ];
        [self.ContactTypePopover dismissPopoverAnimated:YES];
    }
    else if ([ContactTypeTracker isEqualToString:@"5" ]) {
        [outletType5 setTitle:ContactTypeString forState:UIControlStateNormal ];
        [self.ContactTypePopover dismissPopoverAnimated:YES];
    }
}
@end
