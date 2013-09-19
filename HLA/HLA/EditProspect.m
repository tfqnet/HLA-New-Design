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
@synthesize txtOfficeCountry,txtDOB;
@synthesize txtExactDuties,btnOfficeCountry;
@synthesize txtrFullName,segSmoker,txtBussinessType,txtAnnIncome;
@synthesize segGender,txtIDType,txtOtherIDType,OccupCodeSelected;
@synthesize outletDOB,outletGroup,outletTitle,OtherIDType,outletNationality;
@synthesize txtContact1, gender,btnHomeCountry;
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
@synthesize nationalityPopover = _nationalityPopover;
@synthesize nationalityList = _nationalityList;
@synthesize nationalityPopover2 = _nationalityPopover2;
@synthesize nationalityList2 = _nationalityList2;


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
    
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    checked = NO;
    checked2 = NO;
    isHomeCountry = NO;
    isOffCountry = NO;
    
    outletDOB.hidden = YES;
    txtDOB.enabled = NO;
    segGender.enabled = NO;
    txtDOB.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
    
    CustomColor = nil;
    
    [myScrollView setScrollEnabled:YES];
    [myScrollView setContentSize:CGSizeMake(1024, 819)];
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
    
    outletTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    outletDOB.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    outletOccup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [_delegate FinishEdit];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    strChanges = @"No";
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];

    if (!(pp.ProspectGroup == NULL || [pp.ProspectGroup isEqualToString:@"- Select -"])) {
        
        [outletGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.ProspectGroup]forState:UIControlStateNormal];
        outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else {
        [outletGroup setTitle:@"- Select -" forState:UIControlStateNormal];
    }
    
    if (!(pp.ProspectTitle == NULL || [pp.ProspectTitle isEqualToString:@"- Select -"])) {
        [outletTitle setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.ProspectTitle]forState:UIControlStateNormal];
        outletTitle.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    else {
        [outletTitle setTitle:@"- Select -" forState:UIControlStateNormal];
    }
    
    if (!(pp.OtherIDType == NULL || [pp.OtherIDType isEqualToString:@"- Select -"])) {
        
        [OtherIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", pp.OtherIDType]forState:UIControlStateNormal];
        txtOtherIDType.text = pp.OtherIDTypeNo;
        OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        //for company case
        if ([[pp.OtherIDType stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"CompanyRegistrationNumber"]) {
            companyCase = YES;
            outletOccup.enabled = NO;
            segSmoker.enabled = NO;
        }
        else {
            companyCase = NO;
            outletOccup.enabled = YES;
        }
    }
    else {
        [self.OtherIDType setTitle:@"- Select -" forState:UIControlStateNormal];
        txtOtherIDType.text = @"";
    }
    
    
    if ([pp.IDTypeNo isEqualToString:@""] || pp.IDTypeNo == NULL) {
        txtIDType.enabled = YES;
        [txtIDType addTarget:self action:@selector(NewICDidChange:) forControlEvents:UIControlEventEditingDidEnd];
        [txtIDType addTarget:self action:@selector(NewICTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        
        [outletDOB setTitle:[[NSString stringWithFormat:@" "]stringByAppendingFormat:@"%@",pp.ProspectDOB] forState:UIControlStateNormal];
        outletDOB.hidden = NO;
        segGender.enabled = YES;
        txtDOB.hidden = YES;
    }
    else {
        txtIDType.text = pp.IDTypeNo;
        txtIDType.enabled = NO;
        txtIDType.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
        
        txtDOB.text = pp.ProspectDOB;
    }
    
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
    
    if (!([pp.ResidenceAddressCountry isEqualToString:@""]||pp.ResidenceAddressCountry == NULL) && ![pp.ResidenceAddressCountry isEqualToString:@"MALAYSIA"]) {
        
        checked = YES;
        txtHomeTown.backgroundColor = [UIColor whiteColor];
        txtHomeState.backgroundColor = [UIColor whiteColor];
        txtHomeTown.enabled = YES;
        txtHomeState.enabled = YES;
        txtHomeCountry.hidden = YES;
        btnHomeCountry.hidden = NO;
        [btnForeignHome setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        
        btnHomeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnHomeCountry setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",pp.ResidenceAddressCountry] forState:UIControlStateNormal];
    }
    else {
        
        btnHomeCountry.hidden = YES;
        txtHomeCountry.text = pp.ResidenceAddressCountry;
    }
    
    
    if (!([pp.OfficeAddressCountry isEqualToString:@""]||pp.OfficeAddressCountry == NULL) && ![pp.OfficeAddressCountry isEqualToString:@"MALAYSIA"]) {
        
        checked2 = YES;
        txtOfficeTown.backgroundColor = [UIColor whiteColor];
        txtOfficeState.backgroundColor = [UIColor whiteColor];
        txtOfficeTown.enabled = YES;
        txtOfficeState.enabled = YES;
        txtOfficeCountry.hidden = YES;
        btnOfficeCountry.hidden = NO;
        [btnForeignOffice setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        
        btnOfficeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnOfficeCountry setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",pp.OfficeAddressCountry] forState:UIControlStateNormal];
    }
    else {
        
        btnOfficeCountry.hidden = YES;
        txtOfficeCountry.text = pp.OfficeAddressCountry;
    }
    
    
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
            if (![[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ] && [txtHomeCountry.text isEqualToString:@"MALAYSIA"]) {
                
                [self PopulateState];
                [txtHomePostCode addTarget:self action:@selector(EditTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
                [txtHomePostCode addTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
            }
            else if (![[txtHomePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ] && ![txtHomeCountry.text isEqualToString:@"MALAYSIA"]) {
                
                txtHomeState.text = pp.ResidenceAddressState;
            }
            else{
                
                txtHomeState.text = @"";
                [txtHomePostCode addTarget:self action:@selector(EditTextFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
                [txtHomePostCode addTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
            }
            
            
            if (![[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ] && [txtOfficeCountry.text isEqualToString:@"MALAYSIA"]) {
                
                [self PopulateOfficeState];
                [txtOfficePostCode addTarget:self action:@selector(EditOfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
                [txtOfficePostCode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
            }
            else if (![[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"" ] && ![txtOfficeCountry.text isEqualToString:@"MALAYSIA"]) {
                
                txtOfficeState.text = pp.OfficeAddressState;
            }
            else{
                
                txtOfficeState.text = @"";
                [txtOfficePostCode addTarget:self action:@selector(EditOfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
                [txtOfficePostCode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
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
    self.myScrollView.contentSize = CGSizeMake(1024, 819);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 15;
    [self.myScrollView scrollRectToVisible:textFieldRect animated:YES];
    
    txtRemark.hidden = FALSE;
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.myScrollView.frame = CGRectMake(0, -44, 1024, 748);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *myString = nil;
    
    if (textField == txtrFullName) {
        myString = [txtrFullName.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 2) {
            NSString *last = [myString substringFromIndex:[myString length] -1];
            NSString *secLast = [myString substringWithRange:NSMakeRange([myString length] -2, 1)];
            NSString *thirdLast = [myString substringWithRange:NSMakeRange([myString length] -3, 1)];
            
            if ([last isEqualToString:secLast] &&  [secLast isEqualToString:thirdLast]) {
                return NO;
            }
        }
    }
    
    if (textField == txtAnnIncome) {
        myString = [txtAnnIncome.text stringByReplacingCharactersInRange:range withString:string];
        NSArray  *arrayOfString = [myString componentsSeparatedByString:@"."];
        if ([arrayOfString count] > 2 )
        {
            return NO;
        }
    }
    
    if (textField == txtPrefix1) {
        myString = [txtPrefix1.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 4) {
            return NO;
        }
    }
    
    if (textField == txtPrefix2) {
        myString = [txtPrefix2.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 4) {
            return NO;
        }
    }
    
    if (textField == txtPrefix3) {
        myString = [txtPrefix3.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 4) {
            return NO;
        }
    }
    
    if (textField == txtPrefix4) {
        myString = [txtPrefix4.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 4) {
            return NO;
        }
    }
    
    if (textField == txtContact1) {
        myString = [txtContact1.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 10) {
            return NO;
        }
    }
    
    if (textField == txtContact2) {
        myString = [txtContact2.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 10) {
            return NO;
        }
    }
    
    if (textField == txtContact3) {
        myString = [txtContact3.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 10) {
            return NO;
        }
    }
    
    if (textField == txtContact4) {
        myString = [txtContact4.text stringByReplacingCharactersInRange:range withString:string];
        if (myString.length > 10) {
            return NO;
        }
    }

    
    return YES;
}

-(void)NewICDidChange:(id) sender
{
    txtIDType.text = [txtIDType.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([txtIDType.text isEqualToString:@""]) {
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No is required" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        rrr.tag = 1002;
        [rrr show];
        txtIDType.text = @"";
        txtDOB.text = @"";
        segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        return;
    }
    
    if (txtIDType.text.length != 12) {
        rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid New IC No length. IC No length should be 12 characters long" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        rrr.tag = 1002;
        [rrr show];
        txtIDType.text = @"";
        txtDOB.text = @"";
        segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        
        return;
    }
    
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:[txtIDType.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    if (!valid) {
        
        rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No must be in numeric" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        rrr.tag = 1002;
        [rrr show];
        txtIDType.text = @"";
        txtDOB.text = @"";
        segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
    }
    else {
        
        NSString *last = [txtIDType.text substringFromIndex:[txtIDType.text length] -1];
        NSCharacterSet *oddSet = [NSCharacterSet characterSetWithCharactersInString:@"13579"];
        
        if ([last rangeOfCharacterFromSet:oddSet].location != NSNotFound) {
            NSLog(@"MALE");
            segGender.selectedSegmentIndex = 0;
        } else {
            NSLog(@"FEMALE");
            segGender.selectedSegmentIndex = 1;
        }
        
        //get the DOB value from ic entered
        NSString *strDate = [txtIDType.text substringWithRange:NSMakeRange(4, 2)];
        NSString *strMonth = [txtIDType.text substringWithRange:NSMakeRange(2, 2)];
        NSString *strYear = [txtIDType.text substringWithRange:NSMakeRange(0, 2)];
        
        //get value for year whether 20XX or 19XX
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *currentYear = [dateFormatter stringFromDate:[NSDate date]];
        NSString *strCurrentYear = [currentYear substringWithRange:NSMakeRange(2, 2)];
        if ([strYear intValue] > [strCurrentYear intValue] && !([strYear intValue] < 30)) {
            strYear = [NSString stringWithFormat:@"19%@",strYear];
        }
        else {
            strYear = [NSString stringWithFormat:@"20%@",strYear];
        }
        
        NSString *strDOB = [NSString stringWithFormat:@"%@/%@/%@",strDate,strMonth,strYear];
        NSString *strDOB2 = [NSString stringWithFormat:@"%@-%@-%@",strYear,strMonth,strDate];
        NSLog(@"DOB:%@",strDOB);
        
        //determine day of february
        NSString *febStatus = nil;
        float devideYear = [strYear floatValue]/4;
        int devideYear2 = devideYear;
        float minus = devideYear - devideYear2;
        if (minus > 0) {
            febStatus = @"Normal";
        }
        else {
            febStatus = @"Jump";
        }
        
        //compare year is valid or not
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *d = [NSDate date];
        NSDate *d2 = [dateFormatter dateFromString:strDOB2];
        
        if ([d compare:d2] == NSOrderedAscending) {
            rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            rrr.tag = 1002;
            [rrr show];
            
            txtIDType.text = @"";
            txtDOB.text = @"";
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        else if ([strMonth intValue] > 12) {
            
            rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            rrr.tag = 1002;
            [rrr show];
            
            txtIDType.text = @"";
            txtDOB.text = @"";
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        else if (([strMonth isEqualToString:@"01"] || [strMonth isEqualToString:@"03"] || [strMonth isEqualToString:@"05"] || [strMonth isEqualToString:@"07"] || [strMonth isEqualToString:@"08"] || [strMonth isEqualToString:@"10"] || [strMonth isEqualToString:@"12"]) && [strDate intValue] > 31) {
            
            rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            rrr.tag = 1002;
            [rrr show];
            
            txtIDType.text = @"";
            txtDOB.text = @"";
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        
        else if (([strMonth isEqualToString:@"04"] || [strMonth isEqualToString:@"06"] || [strMonth isEqualToString:@"09"] || [strMonth isEqualToString:@"11"]) && [strDate intValue] > 30) {
            
            rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            rrr.tag = 1002;
            [rrr show];
            
            txtIDType.text = @"";
            txtDOB.text = @"";
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        else if (([febStatus isEqualToString:@"Normal"] && [strDate intValue] > 28 && [strMonth isEqualToString:@"02"]) || ([febStatus isEqualToString:@"Jump"] && [strDate intValue] > 29 && [strMonth isEqualToString:@"02"]) ) {
            
            rrr = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New IC No not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
            rrr.tag = 1002;
            [rrr show];
            
            txtIDType.text = @"";
            txtDOB.text = @"";
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
        }
        else {
            txtDOB.text = strDOB;
        }
        
        last = nil, oddSet = nil;
        strDate = nil, strMonth = nil, strYear = nil, currentYear = nil, strCurrentYear = nil;
        dateFormatter = Nil, strDOB = nil, strDOB2 = nil, d = Nil, d2 = Nil;
    }
    
    alphaNums = nil, inStringSet = nil;
    
}

-(void)NewICTextFieldBegin:(id)sender {
    
    outletDOB.hidden = YES;
    txtDOB.hidden = NO;
    segGender.enabled = NO;
}


#pragma mark - action

- (IBAction)ActionHomeCountry:(id)sender
{
    isHomeCountry = YES;
    isOffCountry = NO;
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

- (IBAction)addNewGroup:(id)sender
{
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Group Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [[dialog textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDefault];
    [dialog setTag:1001];
    [dialog show];
}

- (IBAction)ActionOfficeCountry:(id)sender
{
    isOffCountry = YES;
    isHomeCountry = NO;
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    if (_nationalityList2 == nil) {
        self.nationalityList2 = [[Nationality alloc] initWithStyle:UITableViewStylePlain];
        _nationalityList2.delegate = self;
        self.nationalityPopover2 = [[UIPopoverController alloc] initWithContentViewController:_nationalityList2];
    }
    
    CGRect butt = [sender frame];
    int y = butt.origin.y - 44;
    butt.origin.y = y;
    [self.nationalityPopover2 presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)isForeign:(id)sender
{
    UIButton *btnPressed = (UIButton*)sender;
    ColorHexCode *CustomColor = [[ColorHexCode alloc] init ];
    
    if (btnPressed.tag == 0) {
        
        if (checked) {
            [btnForeignHome setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            checked = NO;
            
            txtHomePostCode.text = @"";
            txtHomeTown.text = @"";
            txtHomeState.text = @"";
            txtHomeCountry.text = @"MALAYSIA";
            txtHomeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtHomeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtHomeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtHomeTown.enabled = NO;
            txtHomeState.enabled = NO;
            txtHomeCountry.hidden = NO;
            btnHomeCountry.hidden = YES;
            
            [txtHomePostCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtHomePostCode addTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
        else {
            [btnForeignHome setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            checked = YES;
            
            txtHomePostCode.text = @"";
            txtHomeTown.text = @"";
            txtHomeState.text = @"";
            [btnHomeCountry setTitle:@"- Select -" forState:UIControlStateNormal];
            btnHomeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            txtHomeTown.backgroundColor = [UIColor whiteColor];
            txtHomeState.backgroundColor = [UIColor whiteColor];
            txtHomeCountry.backgroundColor = [UIColor whiteColor];
            txtHomeTown.enabled = YES;
            txtHomeState.enabled = YES;
            txtHomeCountry.hidden = YES;
            btnHomeCountry.hidden = NO;
            
            [txtHomePostCode removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtHomePostCode removeTarget:self action:@selector(EditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
    }
    
    else if (btnPressed.tag == 1) {
        
        if (checked2) {
            [btnForeignOffice setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            checked2 = NO;
            
            txtOfficePostCode.text = @"";
            txtOfficeTown.text = @"";
            txtOfficeState.text = @"";
            txtOfficeCountry.text = @"MALAYSIA";
            txtOfficeTown.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeState.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeCountry.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
            txtOfficeTown.enabled = NO;
            txtOfficeState.enabled = NO;
            txtOfficeCountry.hidden = NO;
            btnOfficeCountry.hidden = YES;
            
            [txtOfficePostCode addTarget:self action:@selector(EditOfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtOfficePostCode addTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
        }
        else {
            [btnForeignOffice setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            checked2 = YES;
            
            txtOfficePostCode.text = @"";
            txtOfficeTown.text = @"";
            txtOfficeState.text = @"";
            [btnOfficeCountry setTitle:@"- Select -" forState:UIControlStateNormal];
            btnOfficeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            txtOfficeTown.backgroundColor = [UIColor whiteColor];
            txtOfficeState.backgroundColor = [UIColor whiteColor];
            txtOfficeCountry.backgroundColor = [UIColor whiteColor];
            txtOfficeTown.enabled = YES;
            txtOfficeState.enabled = YES;
            txtOfficeCountry.hidden = YES;
            btnOfficeCountry.hidden = NO;
            
            [txtOfficePostCode removeTarget:self action:@selector(EditOfficePostcodeDidChange:) forControlEvents:UIControlEventEditingDidEnd];
            [txtOfficePostCode removeTarget:self action:@selector(OfficeEditTextFieldBegin:) forControlEvents:UIControlEventEditingDidBegin];
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
    [self.GroupPopover presentPopoverFromRect:butt inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (IBAction)btnTitle:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
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
    [self.SIDatePopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
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
    [self.OccupationListPopover presentPopoverFromRect:butt  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    
}

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
            
            else if (alertView.tag == 1002) {
                [txtIDType becomeFirstResponder];
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
            else if (alertView.tag == 1001) {
                
                NSString *str = [NSString stringWithFormat:@"%@",[[alertView textFieldAtIndex:0]text] ];
                if (str.length != 0) {
                    
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    
                    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsPath = [paths objectAtIndex:0];
                    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"dataGroup.plist"];
                    [array addObjectsFromArray:[NSArray arrayWithContentsOfFile:plistPath]];
                    
                    BOOL Found = NO;
                    
                    for (NSString *existing in array) {
                        
                        if ([str isEqualToString:existing]) {
                            
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Group already exist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                            [alert show];
                            
                            Found = YES;
                            break;
                        }
                    }
                    
                    if (!Found) {
                        
                        [array addObject:str];
                        [array writeToFile:plistPath atomically: TRUE];
                        
                        outletGroup.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [outletGroup setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",str]forState:UIControlStateNormal];
                    }
                    
                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
                    [alert show];
                }

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
        NSLog(@"%@",querySQL);
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
            NSString *group = nil;
            NSString *title = nil;
            NSString *otherID = nil;
            NSString *OffCountry = nil;
            NSString *HomeCountry = nil;
            NSString *strDOB = nil;
            
            txtrFullName.text = [txtrFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            if (txtDOB.text.length == 0) {
                strDOB = [outletDOB.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            }
            else {
                strDOB = txtDOB.text;
            }
            
            if (![outletGroup.titleLabel.text isEqualToString:@"- Select -"]) {
                group = [outletGroup.titleLabel.text substringWithRange:NSMakeRange(1,outletGroup.titleLabel.text.length - 1)];
            }
            else {
                group = outletGroup.titleLabel.text;
            }
            
            
            if (![outletTitle.titleLabel.text isEqualToString:@"- Select -"]) {
                title = [outletTitle.titleLabel.text substringWithRange:NSMakeRange(1,outletTitle.titleLabel.text.length - 1)];
            }
            else {
                title = outletTitle.titleLabel.text;
            }
            
            
            if (![OtherIDType.titleLabel.text isEqualToString:@"- Select -"]) {
                otherID = [OtherIDType.titleLabel.text substringWithRange:NSMakeRange(1,OtherIDType.titleLabel.text.length - 1)];
            }
            else {
                otherID = OtherIDType.titleLabel.text;
            }
            
            
            if (checked) {
                HomeCountry = [btnHomeCountry.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                SelectedStateCode = txtHomeState.text;
            }
            else {
                HomeCountry = txtHomeCountry.text;
            }
            
            if (checked2) {
                OffCountry = [btnOfficeCountry.titleLabel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
                SelectedOfficeStateCode = txtOfficeState.text;
            }
            else {
                OffCountry = txtOfficeCountry.text;
            }
            
            NSString *insertSQL = [NSString stringWithFormat:
                @"update prospect_profile set \"ProspectName\"=\"%@\", \"ProspectDOB\"=\"%@\", \"ProspectGender\"=\"%@\", \"ResidenceAddress1\"=\"%@\", \"ResidenceAddress2\"=\"%@\", \"ResidenceAddress3\"=\"%@\", \"ResidenceAddressTown\"=\"%@\", \"ResidenceAddressState\"=\"%@\", \"ResidenceAddressPostCode\"=\"%@\", \"ResidenceAddressCountry\"=\"%@\", \"OfficeAddress1\"=\"%@\", \"OfficeAddress2\"=\"%@\", \"OfficeAddress3\"=\"%@\", \"OfficeAddressTown\"=\"%@\",\"OfficeAddressState\"=\"%@\", \"OfficeAddressPostCode\"=\"%@\", \"OfficeAddressCountry\"=\"%@\", \"ProspectEmail\"= \"%@\", \"ProspectOccupationCode\"=\"%@\", \"ExactDuties\"=\"%@\", \"ProspectRemark\"=\"%@\", \"DateModified\"=%@,\"ModifiedBy\"=\"%@\", \"ProspectGroup\"=\"%@\", \"ProspectTitle\"=\"%@\", \"IDTypeNo\"=\"%@\", \"OtherIDType\"=\"%@\", \"OtherIDTypeNo\"=\"%@\", \"Smoker\"=\"%@\", \"AnnualIncome\"=\"%@\", \"BussinessType\"=\"%@\"  where indexNo = \"%@\" "
                    "", txtrFullName.text, strDOB, gender, txtHomeAddr1.text, txtHomeAddr2.text, txtHomeAddr3.text, txtHomeTown.text, SelectedStateCode, txtHomePostCode.text, HomeCountry, txtOfficeAddr1.text, txtOfficeAddr2.text, txtOfficeAddr3.text, txtOfficeTown.text, SelectedOfficeStateCode, txtOfficePostCode.text, OffCountry, txtEmail.text, OccupCodeSelected, txtExactDuties.text, txtRemark.text, @"datetime(\"now\", \"+8 hour\")", @"1", group, title, txtIDType.text, otherID, txtOtherIDType.text, ClientSmoker, txtAnnIncome.text, txtBussinessType.text, pp.ProspectID];
            
            
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
    
    if(([[txtDOB.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) && ([outletDOB.titleLabel.text isEqualToString:@"- Select -"])){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Date of Birth is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self resignFirstResponder];
        [self.view endEditing:TRUE];
        
        [alert show];
        return false;
    }
    
    if (![[txtIDType.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtIDType.text];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (!valid) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"New IC No must be numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtIDType becomeFirstResponder];
            return false;
        }
        
        if (txtIDType.text.length != 12) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid New IC No length. IC No length should be 12 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtIDType becomeFirstResponder];
            return false;
        }
    }
    
    
    if (![OtherIDType.titleLabel.text isEqualToString:@"- Select -"]) {
        
        if ([[txtOtherIDType.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Other ID is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtOtherIDType becomeFirstResponder];
            [alert show];
            return false;
        }
        
        if (txtOtherIDType.text.length > 30) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid Other ID length. Other ID length should be not more 30 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtOtherIDType becomeFirstResponder];
            return false;
        }
    }
    
    if (txtExactDuties.text.length > 40) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Exact Duties length. Only 40 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtExactDuties becomeFirstResponder];
        [alert show];
        return false;
    }
    
    if (![[txtAnnIncome.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtAnnIncome.text];
        valid = [alphaNums isSupersetOfSet:inStringSet];
        if (!valid) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Annual Income must be numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtAnnIncome becomeFirstResponder];
            return false;
        }
        
        if (txtAnnIncome.text.length > 13) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid Annual Income length. Annual Income length should be not more than 13 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtAnnIncome becomeFirstResponder];
            return false;
        }
    }
    
    if (companyCase) {
        
        if ([[txtOtherIDType.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Other ID is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtOtherIDType becomeFirstResponder];
            [alert show];
            return false;
        }
        
        if ([[txtBussinessType.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Type of Bussiness is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtBussinessType becomeFirstResponder];
            [alert show];
            return false;
        }
        
        if ([[txtAnnIncome.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Annual Income is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtAnnIncome becomeFirstResponder];
            [alert show];
            return false;
        }
        
        if ([[txtOfficeAddr1.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[txtOfficePostCode.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Office Address is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [txtOfficeAddr1 becomeFirstResponder];
            [alert show];
            return false;
        }
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
    
    if(OccupCodeSelected == NULL && !companyCase) {
        
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
    
    if(txtHomeAddr1.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Home Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtHomeAddr1 becomeFirstResponder];
        [alert show];
        return false;
    }
    
    if(txtHomeAddr2.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Home Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtHomeAddr2 becomeFirstResponder];
        [alert show];
        return false;
    }
    
    if(txtHomeAddr3.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Home Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtHomeAddr3 becomeFirstResponder];
        [alert show];
        return false;
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
    
    if(txtOfficeAddr1.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Office Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtOfficeAddr1 becomeFirstResponder];
        [alert show];
        return false;
    }
    
    if(txtOfficeAddr2.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Office Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtOfficeAddr2 becomeFirstResponder];
        [alert show];
        return false;
    }
    
    if(txtOfficeAddr3.text.length > 30){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Invalid Office Address length. Only 30 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [txtOfficeAddr3 becomeFirstResponder];
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
        
        if (txtEmail.text.length > 40) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid Email length. Only 40 characters allowed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [txtExactDuties becomeFirstResponder];
            [alert show];
            return false;
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

-(void)selectedCountry:(NSString *)theCountry
{
    if (isOffCountry) {
        btnOfficeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnOfficeCountry setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",theCountry] forState:UIControlStateNormal];
        
        [self.nationalityPopover2 dismissPopoverAnimated:YES];
    }
    else if (isHomeCountry) {
        btnHomeCountry.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btnHomeCountry setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",theCountry] forState:UIControlStateNormal];
        
        [self.nationalityPopover dismissPopoverAnimated:YES];
    }
    
    isOffCountry = NO;
    isHomeCountry = NO;
}

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
    ColorHexCode *CustomColor = [[ColorHexCode alloc] init ];
    
    OtherIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [OtherIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",selectedIDType]forState:UIControlStateNormal];
    
    if (![selectedIDType isEqualToString:@"New Identification Number"]) {
        txtOtherIDType.backgroundColor = [UIColor whiteColor];
        txtOtherIDType.enabled = YES;
        
        //for company case
        if ([selectedIDType isEqualToString:@"Company Registration Number"]) {
            
            outletTitle.enabled = NO;
            outletOccup.enabled = NO;
            segGender.enabled = NO;
            segSmoker.enabled = NO;
            segGender.selectedSegmentIndex = UISegmentedControlNoSegment;
            segSmoker.selectedSegmentIndex = UISegmentedControlNoSegment;
            companyCase = YES;
            txtDOB.hidden = NO;
            outletDOB.hidden = YES;
        }
        else if (([selectedIDType isEqualToString:@"Foreigner Birth Certificate"] || [selectedIDType isEqualToString:@"Foreigner Identification Number"] || [selectedIDType isEqualToString:@"Passport"] || [selectedIDType isEqualToString:@"Singapore Identification Number"] ) && [txtIDType.text isEqualToString:@""]) {
            
            outletTitle.enabled = YES;
            outletOccup.enabled = YES;
            segGender.enabled = YES;
            segSmoker.enabled = YES;
            companyCase = NO;
            txtDOB.hidden = YES;
            outletDOB.hidden = NO;
            
        }
        else {
            outletTitle.enabled = YES;
            outletOccup.enabled = YES;
            segGender.enabled = NO;
            segSmoker.enabled = YES;
            companyCase = NO;
            txtDOB.hidden = NO;
            outletDOB.hidden = YES;
        }
        
    }
    else {
        txtOtherIDType.backgroundColor = [CustomColor colorWithHexString:@"EEEEEE"];
        txtOtherIDType.enabled = NO;
    }
    [self.IDTypePickerPopover dismissPopoverAnimated:YES];
    
}

-(void)selectedNationality:(NSString *)selectedNationality
{
    
    outletNationality.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [outletNationality setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@",selectedNationality]forState:UIControlStateNormal];
    [self.nationalityPopover dismissPopoverAnimated:YES];
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
    [self setBtnOfficeCountry:nil];
    [self setBtnHomeCountry:nil];
    [self setTxtDOB:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

@end
