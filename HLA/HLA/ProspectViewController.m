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
#import "ColorHexCode.h"
#import "IDTypeViewController.h"
#import "TitleViewController.h"

@interface ProspectViewController ()

@end

@implementation ProspectViewController
@synthesize txtPrefix1;
@synthesize txtPrefix2;
@synthesize txtPrefix3;
@synthesize txtPrefix4;
@synthesize lblOfficeAddr;
@synthesize lblPostCode;
@synthesize txtRemark;
@synthesize txtEmail;
@synthesize txtContact1;
@synthesize txtContact2;
@synthesize txtContact3;
@synthesize txtContact4;
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
@synthesize txtOfficeCountry,btnForeignHome,btnForeignOffice;
@synthesize txtExactDuties,txtBussinessType,txtAnnIncome,txtClass;
@synthesize outletOccup,ClientSmoker,btnOfficeCountry;
@synthesize myScrollView,outletGroup,OtherIDType,txtIDType,txtOtherIDType;
@synthesize txtFullName, ContactTypeTracker,segSmoker,outletTitle;
@synthesize segGender, ContactType, DOB, gender, SelectedStateCode, SelectedOfficeStateCode, OccupCodeSelected;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;
@synthesize delegate = _delegate;
@synthesize IDTypePicker = _IDTypePicker;
@synthesize TitlePicker = _TitlePicker;
@synthesize TitlePickerPopover = _TitlePickerPopover;
@synthesize nationalityList = _nationalityList;
@synthesize nationalityPopover = _nationalityPopover;

bool PostcodeContinue = TRUE;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    txtRemark.layer.borderWidth = 1.0f;
    txtRemark.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [txtHomePostCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [txtOfficePostcode addTarget:self action:@selector(OfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [txtHomePostCode addTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [txtOfficePostcode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc] init ];
    
    txtHomeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtHomeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtHomeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtClass.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    btnOfficeCountry.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSave:)];
    checked = NO;
    checked2 = NO;
    
    CustomColor = Nil;
    
}
/*
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
*/

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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}


#pragma mark - keyboard

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, -44, 1024, 748-352);
    self.myScrollView.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 15;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    txtRemark.hidden = FALSE;
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, -44, 1024, 748);
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)textFieldDidChange:(id) sender
{
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    txtHomePostCode.text = [txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([txtHomePostCode.text isEqualToString:@""]) {
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Home postcode is required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        rrr.tag = 2001;
        [rrr show];
        return;
    }
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Home post code must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        rrr.tag = 2001;
        [rrr show];
        
        
        txtHomePostCode.text = @"";
        txtHomeState.text = @"";
        txtHomeTown.text = @"";
        txtHomeCountry.text = @"";
        SelectedStateCode = @"";
        PostcodeContinue = FALSE;
        
    }
    else {
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
                    txtHomeCountry.text = @"MALAYSIA";
                    SelectedStateCode = Statecode;
                    gotRow = true;
                    PostcodeContinue = TRUE;
                    self.navigationItem.rightBarButtonItem.enabled = TRUE;
                }
                sqlite3_finalize(statement);
            }
            
            if (gotRow == false) {
                
                rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found for Home Address"
                                                delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                
                rrr.tag = 2000;
                [rrr show];
                
                txtHomePostCode.text = @"";
                txtHomeState.text = @"";
                txtHomeTown.text = @"";
                txtHomeCountry.text = @"";
                SelectedStateCode = @"";
                
                PostcodeContinue = FALSE;
            }
            
            sqlite3_close(contactDB);
        }
        
    }
}

-(void)OfficePostcodeDidChange:(id) sender
{
    
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    txtOfficePostcode.text = [txtOfficePostcode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([txtOfficePostcode.text isEqualToString:@""]) {

        rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Office postcode is required"
                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        rrr.tag = 3001;
        [rrr show];
        return;
    }
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[txtOfficePostcode.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Office post code must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        rrr.tag = 3001;
        [rrr show];
        
        txtOfficePostcode.text = @"";
        txtOfficeState.text = @"";
        txtOfficeTown.text = @"";
        txtOfficeCountry.text = @"";
        SelectedOfficeStateCode = @"";
        PostcodeContinue = FALSE;
    }
    else {
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
                    txtOfficeCountry.text = @"MALAYSIA";
                    SelectedOfficeStateCode = Statecode;
                    gotRow = true;
                    PostcodeContinue = TRUE;
                    self.navigationItem.rightBarButtonItem.enabled = TRUE;
                }
                sqlite3_finalize(statement);
                
                if (gotRow == false) {
                    /*UIAlertView *NoPostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found for office"
                     delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     
                     NoPostcode.tag = 3000;
                     [NoPostcode show];*/
                    rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found for office"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    rrr.tag = 3000;
                    [rrr show];
                    
                    txtOfficePostcode.text = @"";
                    txtOfficeState.text = @"";
                    txtOfficeTown.text = @"";
                    txtOfficeCountry.text = @"";
                    SelectedOfficeStateCode = @"";
                    
                    PostcodeContinue = FALSE;
                }
                
                sqlite3_close(contactDB);
            }
        }
    }
    
    
}

-(void)EditTextFieldBegin:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = FALSE;
}

-(void)OfficeEditTextFieldBegin:(id)sender
{
    
    if ([self OptionalOccp] == FALSE) {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    }
}


#pragma mark - action

- (IBAction)ActionGender:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"M";
    }
    else {
        gender = @"F";
    }
}

- (IBAction)ActionSmoker:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if ([segSmoker selectedSegmentIndex]==0) {
        ClientSmoker = @"Y";
    }
    else {
        ClientSmoker = @"N";
    }
}

- (IBAction)btnDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletDOB setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", dateString] forState:UIControlStateNormal];
    
    if (_SIDate == Nil) {
         
         self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
         _SIDate.delegate = self;
         self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
     }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.SIDatePopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    dateFormatter = Nil;
    dateString = Nil;
    
}

- (IBAction)btnOccup:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_OccupationList == nil) {
        self.OccupationList = [[OccupationList alloc] initWithStyle:UITableViewStylePlain];
        _OccupationList.delegate = self;
        self.OccupationListPopover = [[UIPopoverController alloc] initWithContentViewController:_OccupationList];               
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.OccupationListPopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)isForeign:(id)sender
{
    UIButton *btnPressed = (UIButton*)sender;
    ColorHexCode *CustomColor = [[ColorHexCode alloc] init ];
    
    if (btnPressed.tag == 0) {
        
        if (checked) {
            [btnForeignHome setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            checked = NO;
        }
        else {
            [btnForeignHome setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            checked = YES;
        }
        
    }
    
    else if (btnPressed.tag == 1) {
        
        if (checked2) {
            [btnForeignOffice setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            checked2 = NO;
            
            txtOfficeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeTown.enabled = NO;
            txtOfficeState.enabled = NO;
            txtOfficeCountry.hidden = NO;
            btnOfficeCountry.hidden = YES;
            
            [txtOfficePostcode addTarget:self action:@selector(OfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtOfficePostcode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
        else {
            [btnForeignOffice setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            checked2 = YES;
            
            txtOfficeTown.backgroundColor = [UIColor whiteColor];
            txtOfficeState.backgroundColor = [UIColor whiteColor];
            txtOfficeCountry.backgroundColor = [UIColor whiteColor];
            txtOfficeTown.enabled = YES;
            txtOfficeState.enabled = YES;
            txtOfficeCountry.hidden = YES;
            btnOfficeCountry.hidden = NO;
            
            [txtOfficePostcode removeTarget:self action:@selector(OfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtOfficePostcode removeTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
        
    }
}

- (void)btnSave:(id)sender
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    _OccupationList = Nil;
    
    if ([self Validation] == TRUE) {
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            txtFullName.text = [txtFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *OffCountry = nil;
            if (checked2) {
                OffCountry = btnOfficeCountry.titleLabel.text;
                SelectedOfficeStateCode = txtOfficeState.text;
            }
            else {
                OffCountry = txtOfficeCountry.text;
            }
            
            NSString *insertSQL = [NSString stringWithFormat:
            @"INSERT INTO prospect_profile(\"ProspectName\", \"ProspectDOB\", \"ProspectGender\", \"ResidenceAddress1\", \"ResidenceAddress2\", \"ResidenceAddress3\", \"ResidenceAddressTown\", \"ResidenceAddressState\",\"ResidenceAddressPostCode\", \"ResidenceAddressCountry\", \"OfficeAddress1\", \"OfficeAddress2\", \"OfficeAddress3\",\"OfficeAddressTown\", \"OfficeAddressState\", \"OfficeAddressPostCode\", \"OfficeAddressCountry\", \"ProspectEmail\",\"ProspectOccupationCode\", \"ExactDuties\", \"ProspectRemark\", \"DateCreated\", \"CreatedBy\", \"DateModified\",\"ModifiedBy\", \"ProspectGroup\", \"ProspectTitle\", \"IDTypeNo\", \"OtherIDType\", \"OtherIDTypeNo\", \"Smoker\", \"AnnualIncome\", \"BussinessType\") "
                "VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", %@, \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", txtFullName.text, outletDOB.titleLabel.text, gender, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text, txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, txtHomeCountry.text, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text, SelectedOfficeStateCode, txtOfficePostcode.text, OffCountry, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text,
                                   @"datetime(\"now\", \"+8 hour\")", @"1", @"", @"1", outletGroup.titleLabel.text, outletTitle.titleLabel.text , txtIDType.text, OtherIDType.titleLabel.text, txtOtherIDType.text, ClientSmoker, txtAnnIncome.text, txtBussinessType.text];
            
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
            
            insertSQL = Nil, insert_stmt = Nil;
        }
        else {
            NSLog(@"Error Open");
        }
        
        statement = Nil;
        dbpath = Nil;
        
        
    }
    
PostcodeContinue = TRUE;

}

- (IBAction)addNewGroup:(id)sender
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Group Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    [dialog setTag:1001];
    [dialog show];
}

- (IBAction)actionOfficeCountry:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_nationalityList == nil) {
        self.nationalityList = [[Nationality alloc] initWithStyle:UITableViewStylePlain];
        _nationalityList.delegate = self;
        self.nationalityPopover = [[UIPopoverController alloc] initWithContentViewController:_nationalityList];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.nationalityPopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnGroup:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_GroupList == nil) {
        
        self.GroupList = [[GroupClass alloc] initWithStyle:UITableViewStylePlain];
        _GroupList.delegate = self;
        self.GroupPopover = [[UIPopoverController alloc] initWithContentViewController:_GroupList];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.GroupPopover presentPopoverFromRect:butt inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)btnTitle:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_TitlePicker == nil) {
        _TitlePicker = [[TitleViewController alloc] initWithStyle:UITableViewStylePlain];
        _TitlePicker.delegate = self;
        self.TitlePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_TitlePicker];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.TitlePickerPopover presentPopoverFromRect:butt inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (_delegate != Nil) {
            [_delegate FinishInsert ];
        }
        
        [self resignFirstResponder];
        [self.view endEditing:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ((alertView.tag == 2000 || alertView.tag == 2001) && buttonIndex == 0) {
        [txtHomePostCode becomeFirstResponder];
    }
    else if ((alertView.tag == 3000 || alertView.tag == 3001) && buttonIndex == 0) {
        [txtOfficePostcode becomeFirstResponder];
    }
    else if (alertView.tag == 1001 && buttonIndex == 1) {
        
        NSString *str = [NSString stringWithFormat:@"%@",[[alertView textFieldAtIndex:0]text] ];
        if (str.length != 0) {
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:str];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsPath = [paths objectAtIndex:0];
            NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"dataGroup.plist"];
            
            [array addObjectsFromArray:[NSArray arrayWithContentsOfFile:plistPath]];
            [array writeToFile:plistPath atomically: TRUE];
        
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            [alert show];
        }
    }

}

- (IBAction)btnOtherIDType:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_IDTypePicker == nil) {
        
        self.IDTypePicker = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        _IDTypePicker.delegate = self;
        self.IDTypePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_IDTypePicker];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.IDTypePickerPopover presentPopoverFromRect:butt inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}


#pragma mark - validation

- (bool) Validation
{
    if([[txtFullName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Full Name is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtFullName becomeFirstResponder];
        //[self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    else {
        BOOL valid;
        NSString *strToBeTest = [txtFullName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] ;
        
        for (int i=0; i<strToBeTest.length; i++) {
            int str1=(int)[strToBeTest characterAtIndex:i];
            
            if((str1 >96 && str1 <123)  || (str1 >64 && str1 <91) || str1 == 39 || str1 == 64 || str1 == 47 || str1 == 45 || str1 == 46){
                valid = TRUE;
                
            }else {
                valid = FALSE;
                break;
            }
        }
        if (!valid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid input format. Input must be alphabet A to Z, space, apostrotrophe ('), alias(@),slash(/),dash(-) or dot(.)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtFullName becomeFirstResponder];
            
            [alert show];
            return false;
        }
    }
    
    if(segGender.selectedSegmentIndex == -1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Gender is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self resignFirstResponder];
        [self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    
    if(outletDOB.titleLabel.text == NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Date of Birth is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self resignFirstResponder];
        [self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    
    
    if(![txtPrefix1.text isEqualToString:@""]) {
        
        if ([txtContact1.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Number for contact no 1 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtContact1 becomeFirstResponder];
            [alert show];
            return false;
        }
        else {
            if (txtPrefix1.text.length > 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Prefix length cannot be more than 4 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtPrefix1 becomeFirstResponder];
                
                [alert show];
                return false;
            }
            else {
                
                if (txtContact1.text.length > 8) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be less than 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact1 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (txtContact1.text.length < 6) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be more than 6 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact1 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                BOOL valid;
                BOOL valid2;
                NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtContact1.text];
                NSCharacterSet *inStringSet2 = [NSCharacterSet characterSetWithCharactersInString:txtPrefix1.text];
                
                valid = [alphaNums isSupersetOfSet:inStringSet];
                valid2 = [alphaNums isSupersetOfSet:inStringSet2];
                if (!valid) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact1 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (!valid2) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Prefix for contact no 1 must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtPrefix1 becomeFirstResponder];
                    
                    [alert show];
                    return false;
                }
            }
        }
    }
    else {
        
        if (![[txtContact1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Prefix for contact no 1 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtPrefix1 becomeFirstResponder];
            [alert show];
            return FALSE;
        }
    }
    
    
    if(![txtPrefix2.text isEqualToString:@""]) {
        
        if ([txtContact2.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Number for contact no 2 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtContact2 becomeFirstResponder];
            [alert show];
            return false;
        }
        else {
            if (txtPrefix2.text.length > 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Prefix length cannot be more than 4 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtPrefix2 becomeFirstResponder];
                
                [alert show];
                return false;
            }
            else {
                
                if (txtContact2.text.length > 8) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be less than 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact2 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (txtContact2.text.length < 6) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be more than 6 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact2 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                BOOL valid;
                BOOL valid2;
                NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtContact2.text];
                NSCharacterSet *inStringSet2 = [NSCharacterSet characterSetWithCharactersInString:txtPrefix2.text];
                
                valid = [alphaNums isSupersetOfSet:inStringSet];
                valid2 = [alphaNums isSupersetOfSet:inStringSet2];
                if (!valid) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact2 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (!valid2) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Prefix for contact no 2 must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtPrefix2 becomeFirstResponder];
                    
                    [alert show];
                    return false;
                }
            }
        }
    }
    else {
        
        if (![[txtContact2.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Prefix for contact no 2 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtPrefix2 becomeFirstResponder];
            [alert show];
            return FALSE;
        }
    }
    
    
    if(![txtPrefix3.text isEqualToString:@""]) {
        
        if ([txtContact3.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Number for contact no 3 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtContact3 becomeFirstResponder];
            [alert show];
            return false;
        }
        else {
            if (txtPrefix3.text.length > 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Prefix length cannot be more than 4 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtPrefix3 becomeFirstResponder];
                
                [alert show];
                return false;
            }
            else {
                
                if (txtContact3.text.length > 8) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Contact number length must be less than 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                    [txtContact3 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                    
                if (txtContact3.text.length < 6) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Contact number length must be more than 6 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                    [txtContact3 becomeFirstResponder];
                    [alert show];
                    return false;
                }
					
                BOOL valid;
                BOOL valid2;
                NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtContact3.text];
                NSCharacterSet *inStringSet2 = [NSCharacterSet characterSetWithCharactersInString:txtPrefix3.text];
                    
                valid = [alphaNums isSupersetOfSet:inStringSet];
                valid2 = [alphaNums isSupersetOfSet:inStringSet2];
                if (!valid) {
                        
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Contact number must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                    [txtContact3 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                    
                if (!valid2) {
                        
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:@"Prefix for contact no 3 must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        
                    [txtPrefix3 becomeFirstResponder];
                        
                    [alert show];
                    return false;
                }
            }
        }
    }
    else {
        
        if (![[txtContact3.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Prefix for contact no 3 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtPrefix3 becomeFirstResponder];
            [alert show];
            return FALSE;
        }
    }
    
    
    if(![txtPrefix4.text isEqualToString:@""]) {
        
        if ([txtContact4.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Number for contact no 4 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtContact4 becomeFirstResponder];
            [alert show];
            return false;
        }
        else {
            if (txtPrefix4.text.length > 4) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Prefix length cannot be more than 4 characters" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtPrefix4 becomeFirstResponder];
                
                [alert show];
                return false;
            }
            else {
                
                if (txtContact4.text.length > 8) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be less than 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact4 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (txtContact4.text.length < 6) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number length must be more than 6 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact4 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                BOOL valid;
                BOOL valid2;
                NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
                NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtContact4.text];
                NSCharacterSet *inStringSet2 = [NSCharacterSet characterSetWithCharactersInString:txtPrefix4.text];
                
                valid = [alphaNums isSupersetOfSet:inStringSet];
                valid2 = [alphaNums isSupersetOfSet:inStringSet2];
                if (!valid) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Contact number must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtContact4 becomeFirstResponder];
                    [alert show];
                    return false;
                }
                
                if (!valid2) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Prefix for contact no 4 must be in numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [txtPrefix4 becomeFirstResponder];
                    
                    [alert show];
                    return false;
                }
            }
        }
    }
    else {
        
        if (![[txtContact4.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Prefix for contact no 4 is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtPrefix4 becomeFirstResponder];
            [alert show];
            return FALSE;
        }
    }
    
    
    if(OccupCodeSelected == NULL){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Occupation is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self resignFirstResponder];
        [self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    
    if(![txtEmail.text isEqualToString:@""]){
        if( [self NSStringIsValidEmail:txtEmail.text] == FALSE){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You have entered an invalid email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtEmail becomeFirstResponder];
            
            [alert show];
            return FALSE;
        }
    }
    
    if([[txtHomeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        if(![[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Home Address is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtHomeAddr1 becomeFirstResponder];
            [alert show];
            return false;
        }
    }

    if (PostcodeContinue == TRUE) {
        if(![[txtHomeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
            if([txtHomePostCode.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Home Address PostCode is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtHomePostCode becomeFirstResponder];
                
                [alert show];
                return false;
            }
        }
    }
    else {
        return FALSE;
    }

    if([[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        if(![[txtOfficePostcode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
            if ([self OptionalOccp] == FALSE) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Office Address is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtOfficeAddr1 becomeFirstResponder];
                
                [alert show];
                return false;
            }
            else {
                
            }
        }
    }
    
    if (PostcodeContinue == TRUE) {
        
        if(![[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
            if([txtOfficePostcode.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Office Address PostCode is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtOfficePostcode becomeFirstResponder];
                
                [alert show];
                return false;
            }
        }
    }
    else {
        return  FALSE;
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


#pragma mark - db handling

-(void) GetLastID
{
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
    
    for (int a = 0; a<4; a++) {
        
        switch (a) {
            case 0:
                
                contactCode = @"CONT006";
                break;
                
            case 1:
                contactCode = @"CONT008";
                break;
                
            case 2:
                contactCode = @"CONT007";
                break;
                
            case 3:
                contactCode = @"CONT009";
                break;
                
            default:
                break;
        }
        
        if (![contactCode isEqualToString:@""]) {
    
            NSString *insertContactSQL = @"";
            if (a==0) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact1.text, @"N", txtPrefix1.text];
            }
            else if (a==1) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact2.text, @"N", txtPrefix2.text];
            }
            else if (a==2) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact3.text, @"N", txtPrefix3.text];
            }
            else if (a==3) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact4.text, @"N", txtPrefix4.text];
            }
            
            const char *insert_contactStmt = [insertContactSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, insert_contactStmt, -1, &statement3, NULL) == SQLITE_OK) {
                if (sqlite3_step(statement3) == SQLITE_DONE){
                    sqlite3_finalize(statement3);
                    
                }
                else {
                    NSLog(@"Error - 4");
                }
            }
            else {
                NSLog(@"Error - 3");
            }
            
            insert_contactStmt = Nil, insertContactSQL = Nil;
            
        }
        
    }
    
    UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Client Profile"
                                                           message:@"A new client record successfully inserted." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    SuccessAlert.tag = 1;
    [SuccessAlert show];
    
    statement2 = Nil;
    statement3 = Nil;
    lastID = Nil;
    contactCode = Nil;
    dbpath = Nil;
    
}

-(BOOL)OptionalOccp
{
    sqlite3_stmt *statement;
    BOOL valid = FALSE;
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT \"OccpCatCode\" from Adm_OccpCat_Occp WHERE OccpCode = \"%@\" ", OccupCodeSelected];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String ], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW){
                NSString *cat = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                if ([[cat stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@"EMP"]) {
                    valid = FALSE;
                }
                else {
                    valid = TRUE;
                }
                
            }
            sqlite3_finalize(statement);
        }
        else {
            valid = FALSE;
        }
        
        sqlite3_close(contactDB);
    }
    /*
     if ([OccupCodeSelected isEqualToString:@"OCC02317"] || [OccupCodeSelected isEqualToString:@"OCC02229"]
     || [OccupCodeSelected isEqualToString:@"OCC01109"] || [OccupCodeSelected isEqualToString:@"OCC01179"]
     || [OccupCodeSelected isEqualToString:@"OCC01865"] || [OccupCodeSelected isEqualToString:@"OCC02229"]
     || [OccupCodeSelected isEqualToString:@"OCC00570"] || [OccupCodeSelected isEqualToString:@"OCC01596"]
     || [OccupCodeSelected isEqualToString:@"OCC02147"] || [OccupCodeSelected isEqualToString:@"OCC02148"]
     || [OccupCodeSelected isEqualToString:@"OCC02149"] || [OccupCodeSelected isEqualToString:@"OCC02321"]) {
     return TRUE;
     }
     else {
     return FALSE;
     }
     */
    return valid;
    
}


#pragma mark - delegate

-(void)selectedGroup:(NSString *)aaGroup
{
    outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",aaGroup]forState:UIControlStateNormal];
    [self.GroupPopover dismissPopoverAnimated:YES];
}

-(void)selectedTitle:(NSString *)selectedTitle
{
    outletTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletTitle setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",selectedTitle]forState:UIControlStateNormal];
    [self.TitlePickerPopover dismissPopoverAnimated:YES];
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletDOB setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",strDate]forState:UIControlStateNormal];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:dbDate];
    
    if ([d compare:d2] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Entered date cannot be greater than today." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        [outletDOB setTitle:@"" forState:UIControlStateNormal ];
        alert = Nil;
    }
    
    df = Nil, d = Nil, d2 = Nil;
}

-(void)selectedIDType:(NSString *)selectedIDType
{
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [OtherIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",selectedIDType]forState:UIControlStateNormal];
    [self.IDTypePickerPopover dismissPopoverAnimated:YES];
    
}

- (void)OccupCodeSelected:(NSString *)OccupCode{
    
    OccupCodeSelected = OccupCode;
    
}

- (void)OccupDescSelected:(NSString *)color
{
    outletOccup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletOccup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color]forState:UIControlStateNormal];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
    
    [self.view endEditing:YES];
    [self resignFirstResponder];
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
}

-(void)OccupClassSelected:(NSString *)OccupClass
{
    txtClass.text = OccupClass;
}

-(void)selectedCountry:(NSString *)theCountry
{
    btnOfficeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnOfficeCountry setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",theCountry] forState:UIControlStateNormal];
    [self.nationalityPopover dismissPopoverAnimated:YES];
}

#pragma mark - memory management

- (void)viewDidUnload
{
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
    [self setTxtRemark:nil];
    [self setMyScrollView:nil];
    [self setTxtEmail:nil];
    [self setTxtContact1:nil];
    [self setTxtContact2:nil];
    [self setTxtContact3:nil];
    [self setTxtContact4:nil];
    [self setTxtPrefix1:nil];
    [self setTxtPrefix2:nil];
    [self setTxtPrefix3:nil];
    [self setTxtPrefix4:nil];
    [self setLblOfficeAddr:nil];
    [self setLblPostCode:nil];
    [self setOutletTitle:nil];
    [self setSegSmoker:nil];
    [self setOutletGroup:nil];
    [self setOtherIDType:nil];
    [self setTxtOtherIDType:nil];
    [self setTxtIDType:nil];
    [self setTxtAnnIncome:nil];
    [self setTxtBussinessType:nil];
    [self setTxtExactDuties:nil];
    [self setTxtClass:nil];
    [self setBtnForeignHome:nil];
    [self setBtnForeignOffice:nil];
    [self setBtnOfficeCountry:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
