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

@interface UserProfile ()

@end

@implementation UserProfile
@synthesize outletCancel;
@synthesize lblAgentLoginID,FirstTimeLogin;
@synthesize lblStatus;
@synthesize ScrollView;
@synthesize txtAgentCode;
@synthesize txtAgentName;
@synthesize txtAgentContactNo;
@synthesize txtLeaderCode;
@synthesize txtLeaderName;
@synthesize txtBizRegNo;
@synthesize txtEmailAddr;
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

    if (FirstTimeLogin == 1) {
        outletCancel.enabled = false;
    }
    else {
        outletCancel.enabled = true;
    }
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    NSLog(@"receive User:%@",[self.idRequest description]);
    NSLog(@"receive Index:%d",self.indexNo);
    
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
    [self setTxtBizRegNo:nil];
    [self setTxtEmailAddr:nil];
    [self setLblAgentLoginID:nil];
    [self setLblStatus:nil];
    [self setOutletCancel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
                code = code2 == NULL ? nil : [[NSString alloc] initWithUTF8String:code2];
                
                const char *name2 = (const char*)sqlite3_column_text(statement, 3);
                name = name2 == NULL ? nil : [[NSString alloc] initWithUTF8String:name2];
                
                const char *contactNo2 = (const char*)sqlite3_column_text(statement, 4);
                contactNo = contactNo2 == NULL ? nil : [[NSString alloc] initWithUTF8String:contactNo2];
                
                const char *leaderCode2 = (const char*)sqlite3_column_text(statement, 5);
                leaderCode = leaderCode2 == NULL ? nil : [[NSString alloc] initWithUTF8String:leaderCode2];
                
                const char *leaderName2 = (const char*)sqlite3_column_text(statement, 6);
                leaderName = leaderName2 == NULL ? nil : [[NSString alloc] initWithUTF8String:leaderName2];
                
                const char *register2 = (const char*)sqlite3_column_text(statement, 7);
                registerNo = register2 == NULL ? nil : [[NSString alloc] initWithUTF8String:register2];
                
                const char *email2 = (const char*)sqlite3_column_text(statement, 8);
                email = email2 == NULL ? nil : [[NSString alloc] initWithUTF8String:email2];
                
                txtAgentCode.text = code;
                txtAgentName.text = name;
                txtAgentContactNo.text = contactNo;
                txtLeaderCode.text = leaderCode;
                txtLeaderName.text = leaderName;
                txtBizRegNo.text = registerNo;
                txtEmailAddr.text = email;
                
                
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
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentCode= \"%@\",AgentName= \"%@\",AgentContactNo= \"%@\",ImmediateLeaderCode= \"%@\",ImmediateLeaderName= \"%@\",BusinessRegNumber = \"%@\",AgentEmail= \"%@\" WHERE IndexNo=\"%d\"",
                              txtAgentCode.text,txtAgentName.text,txtAgentContactNo.text,txtLeaderCode.text,txtLeaderName.text,txtBizRegNo.text,txtEmailAddr.text,self.indexNo];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                lblStatus.text = @"Data successfully update!";
                lblStatus.textColor = [UIColor blueColor];
                
                
                //NSLog(@"Done update!");
                
            } else {
                lblStatus.text = @"Failed to update!";
                lblStatus.textColor = [UIColor redColor];
                NSLog(@"Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success"
                                                      message:@"Data Updated" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil ];
    success.tag = 1;
    [success show];
    
}

- (IBAction)btnCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES ];
}

- (IBAction)btnSave:(id)sender {
    [self updateUserData ];
}


@end
