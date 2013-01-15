//
//  UserProfile.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "UserProfile.h"
#import "ChangePassword.h"
#import "SecurityQuestion.h"
#import "Login.h"
#import "AppDelegate.h"

@interface UserProfile ()

@end

@implementation UserProfile
@synthesize outletCancel;
@synthesize outletSave;
@synthesize lblAgentLoginID,FirstTimeLogin;
@synthesize lblStatus;
@synthesize ScrollView;
@synthesize txtAgentCode;
@synthesize txtAgentName;
@synthesize txtAgentContactNo;
@synthesize txtLeaderCode;
@synthesize txtLeaderName;
@synthesize txtBizRegNo;
@synthesize txtEmail, ChangePwdPassword, ChangePwdUsername;
@synthesize email,leaderCode,leaderName,contactNo,code, username, name, registerNo, idRequest, indexNo;

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
    
    outletSave.hidden = TRUE;
    if (FirstTimeLogin == 1) {
        //outletCancel.enabled = false;
    }
    else {
        AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
        
        self.indexNo = zzz.indexNo;
        self.idRequest = zzz.userRequest;
        
        //outletCancel.enabled = true;
    }
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    //NSLog(@"receive User:%@",[self.idRequest description]);
    //NSLog(@"receive Index:%d",self.indexNo);
    
    
    lblAgentLoginID.text = [NSString stringWithFormat:@"%@",[self.idRequest description]];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setTxtAgentCode:nil];
    [self setTxtAgentName:nil];
    [self setTxtAgentContactNo:nil];
    [self setTxtLeaderCode:nil];
    [self setTxtLeaderName:nil];
    [self setLblAgentLoginID:nil];
    [self setLblStatus:nil];
    [self setOutletCancel:nil];
    [self setTxtBizRegNo:nil];
    [self setTxtEmail:nil];
    [self setOutletSave:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft )
        return YES;
    
    return NO;
}







- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewExisting];
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

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{   
    if (FirstTimeLogin == 1) {
        if (alertView.tag == 1) {
            Login *LoginPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            LoginPage.modalPresentationStyle = UIModalPresentationFullScreen;
            LoginPage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:LoginPage animated:YES ];
            
            [self dismissModalViewControllerAnimated:YES];
            
        }
    }
    
    /*
    else {
        [self updateUserData];
    }
     */
    /*
    if (alertView.tag == 1) {
        NSLog(@"dsadasdasdas");
        [self dismissModalViewControllerAnimated:YES ];
    }
     */
}

-(void)viewExisting
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT IndexNo,AgentLoginID,AgentCode,AgentName,AgentContactNo,ImmediateLeaderCode,ImmediateLeaderName,BusinessRegNumber,AgentEmail FROM Agent_Profile WHERE IndexNo=\"%d\"",self.indexNo];
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                username = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                const char *code2 = (const char*)sqlite3_column_text(statement, 2);
                code = code2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:code2];
                
                const char *name2 = (const char*)sqlite3_column_text(statement, 3);
                name = name2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:name2];
                
                const char *contactNo2 = (const char*)sqlite3_column_text(statement, 4);
                contactNo = contactNo2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:contactNo2];
                
                const char *leaderCode2 = (const char*)sqlite3_column_text(statement, 5);
                leaderCode = leaderCode2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:leaderCode2];
                
                const char *leaderName2 = (const char*)sqlite3_column_text(statement, 6);
                leaderName = leaderName2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:leaderName2];
                
                const char *register2 = (const char*)sqlite3_column_text(statement, 7);
                registerNo = register2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:register2];
                
                const char *email2 = (const char*)sqlite3_column_text(statement, 8);
                email = email2 == NULL ? @"" : [[NSString alloc] initWithUTF8String:email2];
                
                txtAgentCode.text = code;
                txtAgentName.text = name;
                txtAgentContactNo.text = contactNo;
                txtLeaderCode.text = leaderCode;
                txtLeaderName.text = leaderName;
                txtBizRegNo.text = registerNo;
                txtEmail.text = email;
                
                
            } else {
                NSLog(@"Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{/*
    self.ScrollView.frame = CGRectMake(0, 0, 1024, 748-352);
    self.ScrollView.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.ScrollView scrollRectToVisible:textFieldRect animated:YES];
  */
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{/*
    self.ScrollView.frame = CGRectMake(0, 0, 1024, 748);
  */
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
}

-(void)updateUserData
{
    if([self Validation] == TRUE){
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        sqlite3_stmt *statement2;
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
             NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentCode= \"%@\",AgentName= \"%@\",AgentContactNo= \"%@\",ImmediateLeaderCode= \"%@\",ImmediateLeaderName= \"%@\",BusinessRegNumber = \"%@\",AgentEmail= \"%@\" WHERE IndexNo=\"%d\"",
             txtAgentCode.text,txtAgentName.text,txtAgentContactNo.text,txtLeaderCode.text,txtLeaderName.text,txtBizRegNo.text,txtEmail.text,self.indexNo];
             
            
            
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    if (FirstTimeLogin == 1) {
                        NSString *FinalSQL = [NSString stringWithFormat:@"UPDATE User_Profile SET AgentPassword= \"%@\", FirstLogin = 0 WHERE IndexNo=\"%d\"", self.ChangePwdPassword ,self.indexNo];
                        
                        
                        if (sqlite3_prepare_v2(contactDB, [FinalSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK){
                            
                            if (sqlite3_step(statement2) == SQLITE_DONE)
                            {
                                UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                                  message:@"Registration successful! Please re-login with the new password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
                                success.tag = 1;
                                [success show];
                            }
                            
                            sqlite3_finalize(statement2);
                        }    
                    }
                    else {
                        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                          message:@"Record Saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
                        success.tag = 1;
                        [success show];
                    }
                    
                   
                    
                } else {
                    lblStatus.text = @"Failed to update!";
                    lblStatus.textColor = [UIColor redColor];
                    
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(contactDB);
        }
        
    }
    
    
    
    
}

-(BOOL) Validation{
    
    if ([txtAgentCode.text isEqualToString:@""] || [txtAgentCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Agent Code is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtAgentCode becomeFirstResponder];
        return FALSE;
        
    }else {
        if (txtAgentCode.text.length != 8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid Agent Code length. Agent Code length should be exact 8 characters long"
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtAgentCode becomeFirstResponder];
            return FALSE;
        }
    }
    
    if ([txtAgentName.text isEqualToString:@""] || [txtAgentName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ].length == 0 ) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Agent Name is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        [txtAgentName becomeFirstResponder];
            return FALSE;
        
        
    }
    else {
        
        BOOL valid;
        NSString *strToBeTest = [txtAgentName.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] ;
        
        for (int i=0; i<strToBeTest.length; i++) {
            int str1=(int)[strToBeTest characterAtIndex:i];
        
            if((str1 >96 && str1 <123)  || (str1 >64 && str1 <91)){
                valid = TRUE;
                
            }else {
                valid = FALSE;
                break;
            }
        }
        if (!valid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Agent name is not valid" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtAgentName becomeFirstResponder];
            return false;
        }
    }

    if(![[txtAgentContactNo.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@"" ]){
        if (txtAgentContactNo.text.length > 11) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Contact number length must be less than 11 digits" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtAgentContactNo becomeFirstResponder ];
            return false;
        }
        
        BOOL valid;
        NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
        NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:txtAgentContactNo.text];
        valid = [alphaNums isSupersetOfSet:inStringSet]; 
        if (!valid) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Contact number must be numeric" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtAgentContactNo becomeFirstResponder];
            return false;
        }
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Agent's Contact No is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtAgentContactNo becomeFirstResponder];
        return false;
    }
    
    if (![[txtLeaderCode.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        if (txtLeaderCode.text.length != 8) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Invalid Immediate Leader Code length. Immediate Leader Code length should be 8 characters long" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [txtAgentContactNo becomeFirstResponder];
            return false;
        }
    }    
    
    
    if (![[txtEmail.text stringByReplacingOccurrencesOfString:@" " withString:@"" ] isEqualToString:@""]) {
        if( [self NSStringIsValidEmail:txtEmail.text] == FALSE ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Email address is not in valid form" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            [txtEmail becomeFirstResponder];
            return FALSE;
        }
            
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Email is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtEmail becomeFirstResponder];
        return FALSE;
    }
    
    return TRUE;
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


- (IBAction)btnCancel:(id)sender {
    //[self dismissModalViewControllerAnimated:YES ];
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    [self updateUserData ];
}

- (IBAction)btnSave:(id)sender {
    [self.view endEditing:TRUE];
    [self resignFirstResponder];
    [self updateUserData ];
}


@end
