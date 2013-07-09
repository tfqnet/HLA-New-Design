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
#import "ColorHexCode.h"
#import "IDTypeViewController.h"

@interface EditProspect ()

@end

@implementation EditProspect
@synthesize lblOfficeAddr;
@synthesize lblPostCode;
@synthesize txtPrefix1,strChanges;
@synthesize txtPrefix2;
@synthesize txtPrefix3;
@synthesize txtPrefix4;
@synthesize outletDelete,txtClass;
@synthesize txtContact2;
@synthesize txtContact3;
@synthesize txtContact4;
@synthesize txtRemark;
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
@synthesize txtOfficePostCode;
@synthesize txtOfficeTown;
@synthesize txtOfficeState;
@synthesize txtOfficeCountry;
@synthesize txtExactDuties;
@synthesize txtrFullName,segSmoker,txtBussinessType,txtAnnIncome;
@synthesize segGender,txtIDType,txtOtherIDType,OccupCodeSelected;
@synthesize outletDOB,outletGroup,outletTitle,OtherIDType;
@synthesize txtContact1, gender;
@synthesize txtEmail, pp, DOB, SelectedStateCode,SelectedOfficeStateCode;
@synthesize OccupationList = _OccupationList;
@synthesize OccupationListPopover = _OccupationListPopover;
@synthesize myScrollView,ClientSmoker;
@synthesize outletOccup,btnForeignHome,btnForeignOffice;
@synthesize delegate = _delegate;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;
@synthesize IDTypePicker = _IDTypePicker;
@synthesize IDTypePickerPopover = _IDTypePickerPopover;
@synthesize TitlePicker = _TitlePicker;
@synthesize TitlePickerPopover = _TitlePickerPopover;
@synthesize GroupList = _GroupList;
@synthesize GroupPopover = _GroupPopover;

bool IsContinue = TRUE;

- (void)viewDidLoad
{
    [super viewDidLoad];
    outletDelete.hidden = true;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    txtRemark.layer.borderWidth = 1.0f;
    txtRemark.layer.borderColor = [[UIColor grayColor] CGColor];
    
    [txtHomePostCode addTarget:self action:@selector(EditTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    
    [txtOfficePostCode addTarget:self action:@selector(EditOfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
    [txtEmail addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtHomeAddr1 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtHomeAddr2 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtHomeAddr3 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtOfficeAddr1 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtOfficeAddr2 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtOfficeAddr3 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtrFullName addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtPrefix1 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtContact1 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtContact2 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtContact3 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtContact4 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtPrefix2 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtPrefix3 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [txtPrefix4 addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventEditingDidEnd];
    [segGender addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventValueChanged];
    [outletDOB addTarget:self action:@selector(detectChanges:) forControlEvents:UIControlEventAllTouchEvents];
    [txtHomePostCode addTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [txtOfficePostCode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
    txtRemark.delegate = self;
    txtExactDuties.delegate = self;
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    txtHomeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtHomeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtHomeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtOfficeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    txtClass.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    
    [outletDelete setBackgroundImage:[[UIImage imageNamed:@"iphone_delete_button.png"] stretchableImageWithLeftCapWidth:8.0f topCapHeight:0.0f]
                            forState:UIControlStateNormal];
    [outletDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    outletDelete.titleLabel.shadowColor = [UIColor lightGrayColor];
    outletDelete.titleLabel.shadowOffset = CGSizeMake(0, -1);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnSave:)];
    
    outletTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    outletOccup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    checked = NO;
    checked2 = NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    strChanges = @"Yes";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
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

- (void)viewWillAppear:(BOOL)animated
{
    strChanges = @"No";
    
    [outletGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.ProspectGroup]forState:UIControlStateNormal];
    [outletTitle setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.ProspectTitle]forState:UIControlStateNormal];
    [outletDOB setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.ProspectDOB]forState:UIControlStateNormal];
    
    if (![pp.OtherIDType isEqualToString:@"(null)"]) {
        [OtherIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.OtherIDType]forState:UIControlStateNormal];
        txtOtherIDType.text = pp.OtherIDTypeNo;
    }
    else {
        [self.OtherIDType setTitle:@"- Select -" forState:UIControlStateNormal];
        txtOtherIDType.text = @"";
    }
    
    txtIDType.text = pp.IDTypeNo;
    txtrFullName.text = pp.ProspectName;
    txtHomeAddr1.text = pp.ResidenceAddress1;
    txtHomeCountry.text = pp.ResidenceAddressCountry;
    txtHomePostCode.text = pp.ResidenceAddressPostCode;
    txtHomeTown.text = pp.ResidenceAddressTown;
    txtOfficeAddr1.text = pp.OfficeAddress1;
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
    
    if (![pp.AnnualIncome isEqualToString:@"(null)"]) {
        txtAnnIncome.text = pp.AnnualIncome;
    }
    else {
        txtAnnIncome.text = @"";
    }
    
    if (![pp.BussinessType isEqualToString:@"(null)"]) {
        txtBussinessType.text = pp.BussinessType;
    }
    else {
        txtBussinessType.text = @"";
    }
    
    if ([pp.Smoker isEqualToString:@"Y"]) {
        ClientSmoker = @"Y";
        segSmoker.selectedSegmentIndex = 0;
    }
    else {
        ClientSmoker = @"N";
        segSmoker.selectedSegmentIndex = 1;
    }
    
    if ([pp.ProspectGender isEqualToString:@"M"]) {
        gender = @"M";
        segGender.selectedSegmentIndex = 0;
    }
    else { 
        gender = @"F";
        segGender.selectedSegmentIndex = 1;
    }
    
    txtContact1.text = @"";
    txtContact2.text = @"";
    txtContact3.text = @"";
    txtContact4.text = @"";
    
    txtPrefix1.text = @"";
    txtPrefix2.text = @"";
    txtPrefix3.text = @"";
    txtPrefix4.text = @"";
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ContactCode, ContactNo, Prefix FROM contact_input where indexNo = %@ ", pp.ProspectID];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            int a = 0;
            while (sqlite3_step(statement) == SQLITE_ROW){
                
                NSString *ContactCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *ContactNo = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *Prefix = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];

                if (a==0) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        txtContact2.text  = ContactNo;
                        txtPrefix2.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        txtContact1.text = ContactNo;
                        txtPrefix1.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        txtContact4.text = ContactNo;
                        txtPrefix4.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        txtContact3.text = ContactNo;
                        txtPrefix3.text = Prefix;
                    }
                }
                else if (a==1) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        txtContact2.text  = ContactNo;
                        txtPrefix2.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        txtContact1.text = ContactNo;
                        txtPrefix1.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        txtContact4.text = ContactNo;
                        txtPrefix4.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        txtContact3.text = ContactNo;
                        txtPrefix3.text = Prefix;
                    }
                }
                else if (a==2) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        txtContact2.text  = ContactNo;
                        txtPrefix2.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        txtContact1.text = ContactNo;
                        txtPrefix1.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        txtContact4.text = ContactNo;
                        txtPrefix4.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        txtContact3.text = ContactNo;
                        txtPrefix3.text = Prefix;
                    }
                }
                else if (a==3) {
                    if ([ContactCode isEqualToString:@"CONT008"]) { //mobile
                        txtContact2.text  = ContactNo;
                        txtPrefix2.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT006"]) { //home
                        txtContact1.text = ContactNo;
                        txtPrefix1.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT009"]) { //fax
                        txtContact4.text = ContactNo;
                        txtPrefix4.text = Prefix;
                    }
                    else if ([ContactCode isEqualToString:@"CONT007"]) { //office
                        txtContact3.text = ContactNo;
                        txtPrefix3.text = Prefix;
                    }
                }
                a = a + 1;
            }
            sqlite3_finalize(statement);
            [self PopulateOccupCode];
            
            txtHomeState.text = @"";
            if (![[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ]) {
                
                [self PopulateState];
            }
            
            if (![[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ]) {
                
                [self PopulateOfficeState];
            }
            else{
                txtOfficeState.text = @"";
            }
        }
        sqlite3_close(contactDB);
        
    }
    else {
        NSLog(@"Error opening database");
    }
    
	dbpath = Nil;
	statement = Nil;
    
    [super viewWillAppear:animated];
}

-(void)EditTextFieldBegin:(id)sender{
    
    self.navigationItem.rightBarButtonItem.enabled = FALSE;
}

-(void)OfficeEditTextFieldBegin:(id)sender{
    
    if ([self OptionalOccp:OccupCodeSelected] == FALSE) {
        self.navigationItem.rightBarButtonItem.enabled = FALSE;
    }
}

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


#pragma mark - action

- (IBAction)isForeign:(id)sender
{
    UIButton *btnPressed = (UIButton*)sender;
    
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
        }
        else {
            [btnForeignOffice setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            checked2 = YES;
        }
        
    }
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
    if (_TitlePicker == nil) {
        self.TitlePicker = [[TitleViewController alloc] initWithStyle:UITableViewStylePlain];
        _TitlePicker.delegate = self;
        self.TitlePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_TitlePicker];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.TitlePickerPopover presentPopoverFromRect:butt inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnDOB:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    
    if (_SIDate == Nil) {
        
        self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        _SIDate.ProspectDOB = pp.ProspectDOB;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.SIDatePopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (IBAction)btnOccup:(id)sender
{
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

- (IBAction)ActionGender:(id)sender
{
    if ([segGender selectedSegmentIndex]==0) {
        gender = @"M";
    }
    else {
        gender = @"F";
    }
}

- (IBAction)ActionSmoker:(id)sender
{
    if ([segSmoker selectedSegmentIndex]==0) {
        ClientSmoker = @"Y";
    }
    else {
        ClientSmoker = @"N";
    }
}

- (IBAction)btnDelete:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: NSLocalizedString(@"Delete prospect",nil)
                          message: NSLocalizedString(@"Are you sure you want to delete this prospect profile?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"Yes",nil)
                          otherButtonTitles: NSLocalizedString(@"No",nil), nil];
    alert.tag = 1;
    [alert show];
}

- (void)btnSave:(id)sender
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    self.myScrollView.frame = CGRectMake(0, 20, 1024, 748);
    
    _OccupationList = Nil;
    _SIDate = Nil;
    
    if ([strChanges isEqualToString:@"Yes"]) {
        [self SaveChanges];
    }
    else {
        [self SaveChanges];
    }
    
    IsContinue = TRUE;
}

-(void)EditOfficePostcodeDidChange:(id) sender
{
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    txtOfficePostCode.text = [txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([txtOfficePostCode.text isEqualToString:@""]) {
        
        /*
         if ([self OptionalOccp:OccupCodeSelected] == FALSE) {
         
         rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Office postcode is required"
         delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
         rrr.tag = 3001;
         [rrr show];
         return;
         }
         else {
         txtOfficePostCode.text = @"";
         txtOfficeState.text = @"";
         txtOfficeTown.text = @"";
         txtOfficeCountry.text = @"";
         SelectedOfficeStateCode = @"";
         txtOfiiceAddr1.text = @"";
         txtOfficeAddr2.text = @"";
         txtOfficeAddr3.text = @"";
         }
         */
        txtOfficePostCode.text = @"";
        txtOfficeState.text = @"";
        txtOfficeTown.text = @"";
        txtOfficeCountry.text = @"";
        SelectedOfficeStateCode = @"";
        //txtOfiiceAddr1.text = @"";
        //txtOfficeAddr2.text = @"";
        //txtOfficeAddr3.text = @"";
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
        
    }
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
         message:@"Office post code must be in numeric" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         
         alert.tag = 3001;
         [alert show];
         */
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Office post code must be in numeric" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        rrr.tag = 3001;
        [rrr show];
        txtOfficePostCode.text = @"";
        txtOfficeState.text = @"";
        txtOfficeTown.text = @"";
        txtOfficeCountry.text = @"";
        SelectedOfficeStateCode = @"";
        IsContinue = FALSE;
        
    }
    else {
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
            NSString *querySQL = [NSString stringWithFormat:@"SELECT \"Town\", \"Statedesc\", b.Statecode FROM adm_postcode as A, eproposal_state as B where trim(a.Statecode) = b.statecode and Postcode = %@ ", txtOfficePostCode.text];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *OfficeTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    NSString *OfficeState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *Statecode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    
                    txtOfficeState.text = OfficeState;
                    txtOfficeTown.text = OfficeTown;
                    txtOfficeCountry.text = @"MALAYSIA";
                    SelectedOfficeStateCode = Statecode;
                    gotRow = true;
                    IsContinue = TRUE;
                    self.navigationItem.rightBarButtonItem.enabled = TRUE;
                }
                sqlite3_finalize(statement);
                
                if (gotRow == false) {
                    /*
                     UIAlertView *NoOfficePostcode = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found for office"
                     delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     NoOfficePostcode.tag = 3000;
                     */
                    
                    rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No postcode found for office"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    rrr.tag = 3000;
                    [txtOfficePostCode becomeFirstResponder];
                    txtOfficePostCode.text = @"";
                    txtOfficeState.text = @"";
                    txtOfficeTown.text = @"";
                    txtOfficeCountry.text = @"";
                    SelectedOfficeStateCode = @"";
                    
                    //[NoOfficePostcode show];
                    [rrr show];
                    IsContinue = FALSE;
                    
                }
            }
            sqlite3_close(contactDB);
        }
        
    }
}

-(void)EditTextFieldDidChange:(id) sender
{
    
    BOOL gotRow = false;
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    txtHomePostCode.text =[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] ;
    
    if ([txtHomePostCode.text isEqualToString:@""]) {
        /*
         rrr = [[UIAlertView alloc] initWithTitle:@"Error"
         message:@"Home PostCode is required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         rrr.tag = 2001;
         [rrr show];
         return;
         */
        
        txtHomePostCode.text = @"";
        txtHomeState.text = @"";
        txtHomeTown.text = @"";
        txtHomeCountry.text = @"";
        SelectedStateCode = @"";
        //txtHomeAddr1.text = @"";
        //txtHomeAddr2.text = @"";
        //txtHomeAddr3.text = @"";
        self.navigationItem.rightBarButtonItem.enabled = TRUE;
    }
    else{
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (!valid) {
            
            rrr = [[UIAlertView alloc] initWithTitle:@"Error"
                                             message:@"Home PostCode must be in numeric" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            rrr.tag = 2001;
            [rrr show];
            txtHomePostCode.text = @"";
            txtHomeState.text = @"";
            txtHomeTown.text = @"";
            txtHomeCountry.text = @"";
            SelectedStateCode = @"";
            IsContinue = FALSE;
            
        }
        else {
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                NSString *querySQL = [NSString stringWithFormat:@"SELECT \"Town\", \"Statedesc\", b.Statecode FROM adm_postcode as A, eproposal_state as B where trim(a.Statecode) = b.statecode and Postcode = %@ ", txtHomePostCode.text];
                const char *query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    
                    if (sqlite3_step(statement) == SQLITE_ROW){
                        NSString *Town = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                        NSString *State = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                        NSString *Statecode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                        
                        txtHomeState.text = State;
                        txtHomeTown.text = Town;
                        txtHomeCountry.text = @"MALAYSIA";
                        SelectedStateCode = Statecode;
                        gotRow = true;
                        IsContinue = TRUE;
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }
                    sqlite3_finalize(statement);
                    
                }
                
                if (gotRow == false) {
                    
                    rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No PostCode found for Home Address"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    rrr.tag = 2000;
                    txtHomePostCode.text = @"";
                    txtHomeState.text = @"";
                    txtHomeTown.text = @"";
                    txtHomeCountry.text = @"";
                    SelectedStateCode = @"";
                    //[NoPostcode show];
                    [rrr show];
                    IsContinue = FALSE;
                    
                    
                }
                sqlite3_close(contactDB);
            }
            
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

-(void)detectChanges:(id) sender
{
    strChanges = @"Yes";
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    
    switch (buttonIndex) {
        case 0:
        {
            if (alertView.tag == 1) { //delete mode
                
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
                            
                            if (_delegate != nil) {
                                [_delegate FinishEdit];
                            }
                            
                            UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile"
                                                                                   message:@"Prospect record successfully been deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            SuccessAlert.tag = 2;
                            [SuccessAlert show];
                            
                        }
                        sqlite3_finalize(statement2);
                        
                    }
                    
                    sqlite3_close(contactDB);
                }
                
            }
            
            else if (alertView.tag == 2) {
                [self resignFirstResponder];
                [self.view endEditing:YES];
                //[self dismissModalViewControllerAnimated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else if (alertView.tag == 1003) {
                [self resignFirstResponder];
                [self.view endEditing:YES];
                [self dismissModalViewControllerAnimated:YES];
            }
            
            
            else if ((alertView.tag == 3000)  || (alertView.tag == 3001)) {
                
                [txtOfficePostCode becomeFirstResponder];
            }
            else if ((alertView.tag == 2000) || (alertView.tag == 2001) ) {
                
                [txtHomePostCode becomeFirstResponder];
            }
        }
            break;
            
        case 1:
        {
            
            if (alertView.tag == 1) { //delete mode
                /*
                 const char *dbpath = [databasePath UTF8String];
                 
                 if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                 NSString *DeleteProspectSQL = [NSString stringWithFormat:
                 @"Delete from prospect_profile where \"indexNo\" = \"%@\" ", pp.ProspectID];
                 
                 const char *Delete_prospectStmt = [DeleteProspectSQL UTF8String];
                 if(sqlite3_prepare_v2(contactDB, Delete_prospectStmt, -1, &statement, NULL) == SQLITE_OK)
                 {
                 int zzz = sqlite3_step(statement);
                 
                 if (zzz == SQLITE_DONE){
                 
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
                 
                 if (_delegate != nil) {
                 [_delegate FinishEdit];
                 }
                 
                 UIAlertView *SuccessAlert = [[UIAlertView alloc] initWithTitle:@"Prospect Profile"
                 message:@"Prospect record successfully been deleted" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 SuccessAlert.tag = 2;
                 [SuccessAlert show];
                 
                 }
                 sqlite3_finalize(statement2);
                 
                 }
                 
                 sqlite3_close(contactDB);
                 }
                 */
                
            }
            else if (alertView.tag == 1003) { //save changes
                //[self SaveChanges];
            }
            
        }
            break;
    }
}


#pragma mark - db

-(void) PopulateOccupCode
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT OccpDesc, Class FROM Adm_Occp_Loading_Penta where OccpCode = \"%@\"", pp.ProspectOccupationCode];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *OccpClass = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                OccupCodeSelected = pp.ProspectOccupationCode;
                [outletOccup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", OccpDesc]forState:UIControlStateNormal];
                txtClass.text = OccpClass;
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);   
    }
    /*
    if ([self OptionalOccp:pp.ProspectOccupationCode] == FALSE) {
        lblOfficeAddr.text = @"Office Address*";
        lblPostCode.text = @"Postcode*";
        
    }
    else {
        lblOfficeAddr.text = @"Office Address";
        lblPostCode.text = @"Postcode";
     
    }
     */
}

-(void) PopulateState
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT StateDesc FROM eProposal_state where status = \"A\" and StateCode = \"%@\"", pp.ResidenceAddressState];
        
//        NSLog(@"%@",querySQL);
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

-(void) PopulateOfficeState
{    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT StateDesc FROM eProposal_state where status = \"A\" and StateCode = \"%@\"", pp.OfficeAddressState];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW){
                
                NSString *StateName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                txtOfficeState.text = StateName;
                SelectedOfficeStateCode = pp.OfficeAddressState;
                
            }
            
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(contactDB);
    }
}

-(void) GetLastID
{
    
    sqlite3_stmt *statement3;
    NSString *lastID = @"";
    NSString *contactCode = @"";
    
    //delete record first
    [self DeleteRecord];
    
    for (int a=0; a<4; a++) {
        
        switch (a) {
                
            case 0:
                //home
                contactCode = @"CONT006";
                break;
                
            case 1:
                //mobile
                contactCode = @"CONT008";
                break;
                
            case 2:
                //office
                contactCode = @"CONT007";
                break;
                
            case 3:
                //fax
                contactCode = @"CONT009";
                break;
                
            default:
                break;
        }
        
        if (![contactCode isEqualToString:@""]) {
            
            lastID = pp.ProspectID;
            NSString *insertContactSQL;
            
            if (a == 0) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact1.text, @"N", txtPrefix1.text];
                
            }
            else if (a == 1) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact2.text, @"N", txtPrefix2.text];
                
            }
            else if (a == 2) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact3.text, @"N", txtPrefix3.text];
                
            }
            else if (a == 3) {
                insertContactSQL = [NSString stringWithFormat:
                                    @"INSERT INTO contact_input(\"IndexNo\",\"contactCode\", \"ContactNo\", \"Primary\", \"Prefix\") "
                                    " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", lastID, contactCode, txtContact4.text, @"N", txtPrefix4.text];
                
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
                    
                }
                
                sqlite3_close(contactDB);
            }
        }
    }
    
    if (_delegate != nil) {
        [_delegate FinishEdit];
    }
}

- (void) DeleteRecord
{
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

-(void)SaveChanges
{
    
    if ([self Validation] == TRUE) {
        
        sqlite3_stmt *statement;
        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            txtrFullName.text = [txtrFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            NSString *insertSQL = [NSString stringWithFormat:
                @"update prospect_profile set \"ProspectName\"=\"%@\", \"ProspectDOB\"=\"%@\", \"ProspectGender\"=\"%@\", \"ResidenceAddress1\"=\"%@\", \"ResidenceAddress2\"=\"%@\", \"ResidenceAddress3\"=\"%@\", \"ResidenceAddressTown\"=\"%@\", \"ResidenceAddressState\"=\"%@\", \"ResidenceAddressPostCode\"=\"%@\", \"ResidenceAddressCountry\"=\"%@\", \"OfficeAddress1\"=\"%@\", \"OfficeAddress2\"=\"%@\", \"OfficeAddress3\"=\"%@\", \"OfficeAddressTown\"=\"%@\",\"OfficeAddressState\"=\"%@\", \"OfficeAddressPostCode\"=\"%@\", \"OfficeAddressCountry\"=\"%@\", \"ProspectEmail\"= \"%@\", \"ProspectOccupationCode\"=\"%@\", \"ExactDuties\"=\"%@\", \"ProspectRemark\"=\"%@\", \"DateModified\"=%@,\"ModifiedBy\"=\"%@\", \"ProspectGroup\"=\"%@\", \"ProspectTitle\"=\"%@\", \"IDTypeNo\"=\"%@\", \"OtherIDType\"=\"%@\", \"OtherIDTypeNo\"=\"%@\", \"Smoker\"=\"%@\", \"AnnualIncome\"=\"%@\", \"BussinessType\"=\"%@\"  where indexNo = \"%@\" "
                    "", txtrFullName.text, outletDOB.titleLabel.text, gender, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text, txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, txtHomeCountry.text, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text, SelectedOfficeStateCode, txtOfficePostCode.text, txtOfficeCountry.text, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text, @"datetime(\"now\", \"+8 hour\")", @"1", outletGroup.titleLabel.text, outletTitle.titleLabel.text, txtIDType.text, OtherIDType.titleLabel.text, txtOtherIDType.text, ClientSmoker, txtAnnIncome.text, txtBussinessType.text, pp.ProspectID];
            
            
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - validation

- (bool) Validation
{    
    if([[txtrFullName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Full Name is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtrFullName becomeFirstResponder];
        [alert show];
        return false;
    }
    else {
        BOOL valid;
        NSString *strToBeTest = [txtrFullName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] ;
        
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
            [txtrFullName becomeFirstResponder];
            
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
    
    /*
    if([[txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Email address is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtEmail becomeFirstResponder];
        
        [alert show];
        return false;
    }
     */
    
    if(OccupCodeSelected == NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Occupation is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [self resignFirstResponder];
        [self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    
    if([[txtHomeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        if (![txtHomePostCode.text isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Home Address is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtHomeAddr1 becomeFirstResponder];
            
            [alert show];
            return false;
        }
        
    }
    
    
    if (IsContinue == TRUE) {
        if (![[txtHomeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
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
		if (![[txtHomeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            if([txtHomePostCode.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Home Address PostCode is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [txtHomePostCode becomeFirstResponder];
                
                [alert show];
                return false;
            }
        }
        
    }
    
    if([[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]){
        if (![[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            //if ([self OptionalOccp:OccupCodeSelected] == FALSE) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Office Address is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [txtOfficeAddr1 becomeFirstResponder];
                
                [alert show];
                return false;
            //}
        
        }
        
        
    }
    
    if (IsContinue == TRUE) {
        
        if (![[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            if([txtOfficePostCode.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Office Address PostCode is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [txtOfficePostCode becomeFirstResponder];
                
                [alert show];
                return false;
            }
        }
        
    }
    else {
        if (![[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
            if([txtOfficePostCode.text isEqualToString:@""]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Office Address PostCode is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [txtOfficePostCode becomeFirstResponder];
                
                [alert show];
                return false;
            }
        }
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


#pragma mark - delegate

-(void)selectedGroup:(NSString *)aaGroup
{
    outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", aaGroup] forState:UIControlStateNormal];
    [self.GroupPopover dismissPopoverAnimated:YES];
}

-(void)selectedTitle:(NSString *)selectedTitle
{
    outletTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletTitle setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", selectedTitle] forState:UIControlStateNormal];
    [self.TitlePickerPopover dismissPopoverAnimated:YES];
}

-(void)selectedIDType:(NSString *)selectedIDType
{
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [OtherIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", selectedIDType] forState:UIControlStateNormal];
    [self.IDTypePickerPopover dismissPopoverAnimated:YES];
}

- (void)OccupCodeSelected:(NSString *)OccupCode
{
    OccupCodeSelected = OccupCode;
    strChanges = @"Yes";
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
     
}

- (void)OccupDescSelected:(NSString *)color
{
    outletOccup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletOccup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", color] forState:UIControlStateNormal];
    
    [self resignFirstResponder];
    [self.view endEditing:TRUE];
    [self.OccupationListPopover dismissPopoverAnimated:YES];
    
}

-(void)OccupClassSelected:(NSString *)OccupClass
{
    txtClass.text = OccupClass;
}

-(BOOL)OptionalOccp:(NSString *)OccupationCode
{
    sqlite3_stmt *statement;
    BOOL valid = FALSE;
    
    if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT \"OccpCatCode\" from Adm_OccpCat_Occp WHERE OccpCode = \"%@\" ", OccupationCode];
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
    return valid;
}

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:dbDate];
    
    if ([d compare:d2] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Entered date cannot be greater than today." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        
    }
    else{
        outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [outletDOB setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
    }
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

-(void)dismiss:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}



- (void)viewDidUnload
{
    [self setTxtrFullName:nil];
    [self setSegGender:nil];
    [self setOutletDOB:nil];
    [self setTxtContact1:nil];
    [self setTxtEmail:nil];
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
    [self setTxtOfficePostCode:nil];
    [self setTxtOfficeTown:nil];
    [self setTxtOfficeState:nil];
    [self setTxtOfficeCountry:nil];
    [self setTxtExactDuties:nil];
    [self setTxtRemark:nil];
    [self setMyScrollView:nil];
    [self setOutletOccup:nil];
    [self setTxtContact1:nil];
    [self setTxtContact1:nil];
    [self setOutletDelete:nil];
    [self setTxtContact2:nil];
    [self setTxtContact3:nil];
    [self setTxtContact4:nil];
    [self setTxtPrefix1:nil];
    [self setTxtPrefix2:nil];
    [self setTxtPrefix3:nil];
    [self setTxtPrefix4:nil];
    [self setLblOfficeAddr:nil];
    [self setLblPostCode:nil];
    [self setOutletGroup:nil];
    [self setOutletTitle:nil];
    [self setTxtIDType:nil];
    [self setOtherIDType:nil];
    [self setTxtOtherIDType:nil];
    [self setSegSmoker:nil];
    [self setTxtAnnIncome:nil];
    [self setTxtBussinessType:nil];
    [self setPp:nil];
    [self setTxtExactDuties:nil];
    [self setTxtClass:nil];
    [self setBtnForeignHome:nil];
    [self setBtnForeignOffice:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
