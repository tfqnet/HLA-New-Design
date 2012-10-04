//
//  EditProspect.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EditProspect.h"
#import "ProspectListing.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProspect ()

@end

@implementation EditProspect
@synthesize outletDelete;
@synthesize outletType2;
@synthesize outletType3;
@synthesize outletType4;
@synthesize outletType5;
@synthesize txtContact2;
@synthesize txtContact3;
@synthesize txtContact4;
@synthesize txtContact5;
@synthesize ContactTypePicker;
@synthesize DobPicker;
@synthesize txtRemark;
@synthesize pickerToolbar;
@synthesize txtHomeAddr1;
@synthesize txtHomeAddr2;
@synthesize txtHomeAddr3;
@synthesize txtHomePostCode;
@synthesize txtHomeTown;
@synthesize txtHomeState;
@synthesize txtHomeCountry;
@synthesize txtOfiiceAddr1;
@synthesize txtOfficeAddr2;
@synthesize txtOfficeAddr3;
@synthesize txtOfficePostCode;
@synthesize txtOfficeTown;
@synthesize txtOfficeState;
@synthesize txtOfficeCountry;
@synthesize txtExactDuties;
@synthesize txtPreferredName;
@synthesize txtrFullName;
@synthesize segGender;
@synthesize outletDOB;
@synthesize outletType1;
@synthesize txtContact1, gender, ContactType, ContactTypeTracker;
@synthesize txtEmail, pp, DOB, SelectedStateCode,SelectedOfficeStateCode, OccupCodeSelected;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
@synthesize myScrollView;
@synthesize outletOccup;
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
    [txtOfficePostCode addTarget:self action:@selector(OfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    txtHomeTown.backgroundColor = [UIColor grayColor];
    txtHomeState.backgroundColor = [UIColor grayColor];
    txtHomeCountry.backgroundColor = [UIColor grayColor];
    txtOfficeTown.backgroundColor = [UIColor grayColor];
    txtOfficeState.backgroundColor = [UIColor grayColor];
    txtOfficeCountry.backgroundColor = [UIColor grayColor];
    
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
    
    NSString *zzz = [ContactType objectAtIndex:row];
    
        
     if (ContactTypeTracker == @"2") {
     txtContact2.enabled = true;
     [outletType2 setTitle:zzz forState:UIControlStateNormal];   
     
     }
     else if (ContactTypeTracker == @"1") {
     txtContact1.enabled = true;
     [outletType1 setTitle:zzz forState:UIControlStateNormal]; 
     
     }
     else if (ContactTypeTracker == @"3") {
     [outletType3 setTitle:zzz forState:UIControlStateNormal]; 
     
     }
     else if (ContactTypeTracker == @"4") {
     [outletType4 setTitle:zzz forState:UIControlStateNormal]; 
     }
     else if (ContactTypeTracker == @"5") {
     [outletType5 setTitle:zzz forState:UIControlStateNormal]; 
     }
     
}

- (void)viewDidUnload
{
    [self setTxtPreferredName:nil];
    [self setTxtrFullName:nil];
    [self setSegGender:nil];
    [self setOutletDOB:nil];
    [self setOutletType1:nil];
    [self setTxtContact1:nil];
    [self setTxtEmail:nil];
    [self setTxtHomeAddr1:nil];
    [self setTxtHomeAddr2:nil];
    [self setTxtHomeAddr3:nil];
    [self setTxtHomePostCode:nil];
    [self setTxtHomeTown:nil];
    [self setTxtHomeState:nil];
    [self setTxtHomeCountry:nil];
    [self setTxtOfiiceAddr1:nil];
    [self setTxtOfficeAddr2:nil];
    [self setTxtOfficeAddr3:nil];
    [self setTxtOfficePostCode:nil];
    [self setTxtOfficeTown:nil];
    [self setTxtOfficeState:nil];
    [self setTxtOfficeCountry:nil];
    [self setTxtExactDuties:nil];
    [self setTxtRemark:nil];
    [self setPickerToolbar:nil];
    [self setContactTypePicker:nil];
    [self setDobPicker:nil];
    [self setMyScrollView:nil];
    [self setOutletOccup:nil];
    [self setTxtContact1:nil];
    [self setTxtContact1:nil];
    [self setOutletDelete:nil];
    [self setOutletType2:nil];
    [self setOutletType3:nil];
    [self setOutletType4:nil];
    [self setOutletType5:nil];
    [self setTxtContact2:nil];
    [self setTxtContact3:nil];
    [self setTxtContact4:nil];
    [self setTxtContact5:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    txtPreferredName.text = pp.NickName;
    txtrFullName.text = pp.ProspectName;
    txtHomeAddr1.text = pp.ResidenceAddress1;
    txtHomeCountry.text = pp.ResidenceAddressCountry;
    txtHomePostCode.text = pp.ResidenceAddressPostCode;
    txtHomeTown.text = pp.ResidenceAddressTown;
    txtOfiiceAddr1.text = pp.OfficeAddress1;
    txtOfficePostCode.text = pp.OfficeAddressPostCode;
    txtOfficeCountry.text = pp.OfficeAddressCountry;
    txtOfficeTown.text = pp.OfficeAddressTown;
    txtRemark.text = pp.ProspectRemark;
    txtEmail.text = pp.ProspectEmail;
    txtHomeAddr3.text = pp.ResidenceAddress3;
    txtHomeAddr2.text = pp.ResidenceAddress2;
    txtOfficeAddr2.text = pp.OfficeAddress2;
    txtOfficeAddr3.text = pp.OfficeAddress3;
    txtExactDuties.text = pp.ExactDuties;
    
    if ([pp.ProspectGender isEqualToString:@"M"]) {
        segGender.selectedSegmentIndex = 0;
    }
    else { 
        segGender.selectedSegmentIndex = 1;
    }
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ContactCode, ContactNo FROM contact_input where indexNo = %@ ", pp.ProspectID];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            int a = 0;
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                NSString *ContactCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *ContactNo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                if (a==0) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        [outletType1 setTitle:@"Mobile" forState:UIControlStateNormal];
                        txtContact1.text  = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        [outletType1 setTitle:@"Home" forState:UIControlStateNormal];
                        txtContact1.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        [outletType1 setTitle:@"Fax" forState:UIControlStateNormal];
                        txtContact1.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        [outletType1 setTitle:@"Office" forState:UIControlStateNormal];
                        txtContact1.text = ContactNo;
                    }
                }
                else if (a==1) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        [outletType2 setTitle:@"Mobile" forState:UIControlStateNormal];
                        txtContact2.text  = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        [outletType2 setTitle:@"Home" forState:UIControlStateNormal];
                        txtContact2.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        [outletType2 setTitle:@"Fax" forState:UIControlStateNormal];
                        txtContact2.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        [outletType2 setTitle:@"Office" forState:UIControlStateNormal];
                        txtContact2.text = ContactNo;
                    }
                }
                else if (a==2) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        [outletType3 setTitle:@"Mobile" forState:UIControlStateNormal];
                        txtContact3.text  = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        [outletType3 setTitle:@"Home" forState:UIControlStateNormal];
                        txtContact3.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        [outletType3 setTitle:@"Fax" forState:UIControlStateNormal];
                        txtContact3.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        [outletType3 setTitle:@"Office" forState:UIControlStateNormal];
                        txtContact3.text = ContactNo;
                    }
                }
                else if (a==3) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        [outletType4 setTitle:@"Mobile" forState:UIControlStateNormal];
                        txtContact4.text  = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        [outletType4 setTitle:@"Home" forState:UIControlStateNormal];
                        txtContact4.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        [outletType4 setTitle:@"Fax" forState:UIControlStateNormal];
                        txtContact4.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        [outletType4 setTitle:@"Office" forState:UIControlStateNormal];
                        txtContact4.text = ContactNo;
                    }
                }
                else if (a==4) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        [outletType5 setTitle:@"Mobile" forState:UIControlStateNormal];
                        txtContact5.text  = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        [outletType5 setTitle:@"Home" forState:UIControlStateNormal];
                        txtContact5.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        [outletType5 setTitle:@"Fax" forState:UIControlStateNormal];
                        txtContact5.text = ContactNo;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        [outletType5 setTitle:@"Office" forState:UIControlStateNormal];
                        txtContact5.text = ContactNo;
                    }
                }
                a = a + 1;
            }
            sqlite3_finalize(statement);
            [self PopulateOccupCode];
            [self PopulateState];
            [self PopulateOfficeState];
            
        }
        sqlite3_close(contactDB);
        
    }
    else {
        NSLog(@"Error opening database");
    }
    
    
    [self.outletDOB setTitle:pp.ProspectDOB forState:UIControlStateNormal];
    
    [super viewWillAppear:animated];
}

-(void) PopulateOccupCode{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT OccpDesc FROM Adm_Occp where status = 1 and OccpCode = \"%@\"", pp.ProspectOccupationCode];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                //txtOccup.text = OccpDesc;
                OccupCodeSelected = pp.ProspectOccupationCode;
                [outletOccup setTitle:OccpDesc forState:UIControlStateNormal];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);   
    }
}

-(void) PopulateState{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT StateDesc FROM eProposal_state where status = \"A\" and StateCode = \"%@\"", pp.ResidenceAddressState];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *StateName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                txtHomeState.text = StateName;
                SelectedStateCode = pp.ResidenceAddressState;
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);   
    }
}


-(void) PopulateOfficeState{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT StateDesc FROM eProposal_state where status = \"A\" and StateCode = \"%@\"", pp.OfficeAddressState];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *StateName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                txtOfficeState.text = StateName;
                SelectedOfficeStateCode = pp.OfficeAddressState;
                
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }
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


- (IBAction)btnDOB:(id)sender {
    DobPicker.hidden = NO;
    pickerToolbar.hidden = NO;
    [self.view endEditing:TRUE];
    txtRemark.hidden = TRUE;
    ContactTypePicker.hidden = true;
    outletDelete.hidden = true;
}

- (IBAction)btnContactType1:(id)sender {
    ContactTypePicker.hidden = false;
    DobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"1";
    outletDelete.hidden = true;
    [self.view endEditing:TRUE];
    if ([outletType1.titleLabel.text isEqualToString:@""]) {
        [outletType1 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
}
- (IBAction)btnOccup:(id)sender {
    if (_OccupationList == nil) {
        self.OccupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        _OccupationList.delegate = self;
        self.OccupationListPopover = [[UIPopoverController alloc] initWithContentViewController:_OccupationList];               
    }
    
    [self.OccupationListPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}
- (IBAction)btnDone:(id)sender {
    if (DobPicker.hidden == FALSE) { //DOB picker
        pickerToolbar.hidden = YES;
        DobPicker.hidden = YES;
        txtRemark.hidden = FALSE;
        outletDelete.hidden = false;
    }
    else { // Contact type picker
        pickerToolbar.hidden = true;
        ContactTypePicker.hidden = true;
        txtRemark.hidden = FALSE;
        outletDelete.hidden = false;
    }

}
- (IBAction)ActionGender:(id)sender {
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"M";
    } 
    else {
        gender = @"F";
    }    
}

- (IBAction)btnDelete:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: NSLocalizedString(@"Delete prospect",nil)
                          message: NSLocalizedString(@"Are you sure you want to delete this prospect profile?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"Cancel",nil)
                          otherButtonTitles: NSLocalizedString(@"Delete",nil), nil];
    alert.tag = 1;
    [alert show];
}

- (IBAction)ActionDobPicker:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *pickerDate = [dateFormatter stringFromDate:[DobPicker date]];
    
    NSString *msg = [NSString stringWithFormat:@"%@",pickerDate];
    [self.outletDOB setTitle:msg forState:UIControlStateNormal];
}

- (bool) Validation{
    
    if([txtPreferredName.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Preferred Name cannot be empty" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return false;
    }
    
    if([txtrFullName.text isEqualToString:@""]){
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
    return true;
}

-(void) GetLastID{
    
    sqlite3_stmt *statement3;
    NSString *lastID;
    NSString *contactCode;
    
    //delete record first 
    [self DeleteRecord];
    
    
    
    for (int a=0; a<5; a++) {
        
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
            
        }
        
        
        if (![contactCode isEqualToString:@""]) {
        
            lastID = pp.ProspectID;
            NSString *insertContactSQL;
            
            if (a == 0) {
                insertContactSQL = [NSString stringWithFormat:
                                              @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                              " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact1.text, @"N"];
                
            }
            else if (a == 1) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact2.text, @"N"];
                
            }
            else if (a == 2) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact3.text, @"N"];
                
            }
            else if (a == 3) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact4.text, @"N"];
                
            }
            else if (a == 4) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact5.text, @"N"];
                
            }
            
            if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK) {
                
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
                    NSLog(@"%@", insertContactSQL);
                }
                
                sqlite3_close(contactDB);

            }
            
                       
                        
            
        }
        
        
    }
    UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Saved Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [SuccessAlert show];
    
    if (_delegate != nil) {
        [_delegate FinishEdit];
    }
    else {
         NSLog( @"dsadasdada");
    }
    
    ProspectListing *ListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Listing"];
    [ListingPage ReloadTableData];
    [ListingPage.tableView reloadData];
    
}


- (void) DeleteRecord{
    sqlite3_stmt *statement;
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *DeleteSQL = [NSString stringWithFormat:@"Delete from contact_input where indexNo = \"%@\"", pp.ProspectID];
        const char *Delete_stmt = [DeleteSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, Delete_stmt, -1, &statement, NULL) == SQLITE_OK) 
        {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
            
        }
        else {
            
            NSLog(@"Error in Delete Statement");
        }
        sqlite3_close(contactDB);
    }
}

- (void)OccupCodeSelected:(NSString *)OccupCode{
    OccupCodeSelected = OccupCode;
}

- (void)OccupDescSelected:(NSString *)color {
    [outletOccup setTitle:color forState:UIControlStateNormal];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
    
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748-350);
    self.myScrollView.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 15;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    pickerToolbar.hidden = true;
    DobPicker.hidden = TRUE;
    txtRemark.hidden = FALSE;
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, 0, 1024, 748);
    ContactTypePicker.hidden = true;
}

- (IBAction)btnCancel:(id)sender {
    
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    if ([self Validation] == TRUE) {
        
        sqlite3_stmt *statement;
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            NSString *insertSQL = [NSString stringWithFormat:
                                   @"update prospect_profile set \"PreferredName\" = \"%@\" ,\"ProspectName\" = \"%@\", \"ProspectDOB\" = \"%@\", "
                                   "\"ProspectGender\" = \"%@\", \"ResidenceAddress1\" = \"%@\", \"ResidenceAddress2\" = \"%@\", \"ResidenceAddress3\" = \"%@\", "
                                   "\"ResidenceAddressTown\" = \"%@\",\"ResidenceAddressState\" = \"%@\",\"ResidenceAddressPostCode\" = \"%@\", "
                                   "\"ResidenceAddressCountry\"= \"%@\", \"OfficeAddress1\"= \"%@\", \"OfficeAddress2\"= \"%@\", \"OfficeAddress3\"= \"%@\", "
                                   "\"OfficeAddressTown\"= \"%@\",\"OfficeAddressState\"= \"%@\",\"OfficeAddressPostCode\"= \"%@\", "
                                   "\"OfficeAddressCountry\"= \"%@\", \"ProspectEmail\"= \"%@\",\"ProspectOccupationCode\"= \"%@\", \"ExactDuties\"= \"%@\", \"ProspectRemark\"= \"%@\","
                                   "\"DateModified\"= \"%@\",\"ModifiedBy\"= \"%@\" where indexNo = \"%@\" "
                                   "", txtPreferredName.text, txtrFullName.text, outletDOB.titleLabel.text, gender, txtHomeAddr1.text, txtHomeAddr2.text, 
                                   txtHomeAddr3.text, txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, txtHomeCountry.text, txtOfiiceAddr1.text, 
                                   txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text, SelectedOfficeStateCode, txtOfficePostCode.text, 
                                   txtOfficeCountry.text, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text, @"28-5-1987", @"1", pp.ProspectID];
            
            
            const char *Update_stmt = [insertSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, Update_stmt, -1, &statement, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    [self GetLastID];
                    
                } else {
                    
                    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Fail in update" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
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
    /*
    ProspectListing *ListingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Listing"];
    [ListingPage ReloadTableData];
    [ListingPage.tableView reloadData];
    */
    
}

-(void)textFieldDidChange:(id) sender
{

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
        NSString *querySQL = [NSString stringWithFormat:@"SELECT \"Town\", \"Statedesc\", b.Statecode FROM adm_postcode as A, eproposal_state as B where trim(a.Statecode) = b.statecode and Postcode = %@ ", txtOfficePostCode.text];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    
    switch (buttonIndex) {
        case 0: 
        {       
            
        }
            break;
            
        case 1: 
        {
            
            if (alertView.tag == 1) {
                
                const char *dbpath = [databasePath UTF8String];
                
                if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                    NSString *DeleteProspectSQL = [NSString stringWithFormat:
                                                   @"Delete from prospect_profile where \"indexNo\" = \"%@\" ", pp.ProspectID];
                    
                    const char *Delete_prospectStmt = [DeleteProspectSQL UTF8String];
                    if(sqlite3_prepare_v2(contactDB, Delete_prospectStmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        int zzz = sqlite3_step(statement);
                        
                        if (zzz == SQLITE_DONE){
                            
                            /*
                             UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Delete Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                             [SuccessAlert show];    
                             
                             EditTableViewController *Listing = [self.storyboard instantiateViewControllerWithIdentifier:@"Listing"];
                             Listing.modalPresentationStyle = UIModalPresentationFullScreen;
                             Listing.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                             [self presentModalViewController:Listing animated:YES];
                             */
                        }
                        
                        sqlite3_finalize(statement);
                    }
                    
                    NSString *DeleteContactSQL = [NSString stringWithFormat:
                                                  @"Delete from contact_input where \"indexNo\" = %@ ", pp.ProspectID];
                    
                    const char *Delete_ContactStmt = [DeleteContactSQL UTF8String];
                    if(sqlite3_prepare_v2(contactDB, Delete_ContactStmt, -1, &statement2, NULL) == SQLITE_OK)
                    {
                        int delCount = sqlite3_step(statement2);
                        
                        if (delCount == SQLITE_DONE){
                            
                            sqlite3_finalize(statement);
                            sqlite3_close(contactDB);
                            UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile" message:@"Delete Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [SuccessAlert show];    
                            
                            
                            
                        }
                        
                    }
                    
                }

            }
                       
        }
            break;
    }
} 

- (IBAction)btnContact2:(id)sender {
    ContactTypePicker.hidden = false;
    DobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"2";
    outletDelete.hidden = true;
    [self.view endEditing:TRUE];
    if ([outletType2.titleLabel.text isEqualToString:@""]) {
        [outletType2 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
}

- (IBAction)btnContact3:(id)sender {
    ContactTypePicker.hidden = false;
    DobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"3";
    outletDelete.hidden = true;
    [self.view endEditing:TRUE];
    if ([outletType3.titleLabel.text isEqualToString:@""]) {
        [outletType3 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
}

- (IBAction)btnContact4:(id)sender {
    ContactTypePicker.hidden = false;
    DobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"4";
    outletDelete.hidden = true;
    [self.view endEditing:TRUE];
    if ([outletType4.titleLabel.text isEqualToString:@""]) {
        [outletType4 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
}

- (IBAction)btnContact5:(id)sender {
    ContactTypePicker.hidden = false;
    DobPicker.hidden = true;
    pickerToolbar.hidden = FALSE;
    txtRemark.hidden = true;
    ContactTypeTracker = @"5";
    outletDelete.hidden = true;
    [self.view endEditing:TRUE];
    if ([outletType5.titleLabel.text isEqualToString:@""]) {
        [outletType5 setTitle:@"Mobile" forState:UIControlStateNormal];
    }
}
@end
