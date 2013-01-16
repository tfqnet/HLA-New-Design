//
//  Login.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Login.h"
#import "MainScreen.h"
#import "setting.h"
#import "ForgotPwd.h"
#import "FirstTimeViewController.h"
#import "AppDelegate.h"
#import "CarouselViewController.h"
#import "SecurityQuestion.h"

@interface Login ()

@end

@implementation Login
@synthesize outletReset;
@synthesize scrollViewLogin;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize lblForgotPwd;
@synthesize statusLogin,indexNo,agentID;
@synthesize labelUpdated,labelVersion;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    RatesDatabasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"HLA_Rates.sqlite"]];
    [self makeDBCopy];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword:)];
    tapGesture.numberOfTapsRequired = 1;
    [lblForgotPwd addGestureRecognizer:tapGesture];
    
    [self isFirstTimeLogin];

    //NSString *path = [[NSBundle mainBundle] pathForResource:@"HLA Ipad-Info"  ofType:@"plist"];
    //NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    
    NSString *version = [NSString stringWithFormat:
                         @"Version %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    labelVersion.text = version;
    labelUpdated.text = @"Last Updated: 16 January 2013";
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation==UIInterfaceOrientationLandscapeLeft){
        return YES;
    }
    else {
        return NO;
    }
     
    //return (interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
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

#pragma mark - handle db

- (void)makeDBCopy 
{	
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
    
    success = [fileManager fileExistsAtPath:databasePath];
    //if (success) return;
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    else {
        
        if([fileManager fileExistsAtPath:RatesDatabasePath] == FALSE ){
            NSString *RatesDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"HLA_Rates.sqlite"];
            success = [fileManager copyItemAtPath:RatesDBPath toPath:RatesDatabasePath error:&error];
            if (!success) {
                NSAssert1(0, @"Failed to create writable Rates database file with message '%@'.", [error localizedDescription]);
            }
        }
        else {
            return;
        }
         
        
    }
    
	
    
    
}

- (void)forgotPassword:(id)sender
{
    sqlite3_stmt *statement;
    
    if (txtUsername.text.length <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"User ID is required" delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
        [alert show];
    }
    else {
        if (sqlite3_open([databasePath UTF8String ], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM User_Profile WHERE AgentLoginID=\"%@\" ", txtUsername.text];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
                if (sqlite3_step(statement) == SQLITE_ROW){
                    ForgotPwd *forgotView = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPwd"];
                    forgotView.modalPresentationStyle = UIModalPresentationFormSheet;
                    forgotView.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                    forgotView.LoginID = txtUsername.text;
                    [self presentModalViewController:forgotView animated:NO];
                    forgotView.view.superview.bounds = CGRectMake(0, 0, 550, 600);
                    
                    
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Username does not exist. Unable to retrieve password." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil ];
                    [alert show];
                }
                sqlite3_finalize(statement);
            }
           
            sqlite3_close(contactDB);
        }    
        
        
    }
        
}

-(void)isFirstTimeLogin
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT firstLogin FROM User_Profile WHERE AgentLoginID=\"hla\" "];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                int FirstLogin = sqlite3_column_int(statement, 0);
                
                if (FirstLogin == 0) {
                    lblForgotPwd.hidden = FALSE;
                }
                else {
                    lblForgotPwd.hidden = TRUE;
                }
                
            } else {
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingFirstLogin
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT IndexNo,AgentLoginID,FirstLogin FROM User_Profile WHERE AgentLoginID=\"%@\" and AgentPassword=\"%@\"", txtUsername.text,txtPassword.text];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                indexNo = sqlite3_column_int(statement, 0);
                agentID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                statusLogin = sqlite3_column_int(statement, 2);
                
                txtPassword.text = @"";
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid Username or Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)updateDateLogin
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE User_Profile SET LastLogonDate= \"%@\" WHERE IndexNo=\"%d\"",dateString,indexNo];
        //        NSString *querySQL = [NSString stringWithFormat:@"UPDATE tbl_User_Profile SET LastLogonDate= datetime('now') WHERE IndexNo=\"%d\"",indexNo];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"date update!");
                
            } else {
                NSLog(@"date update Failed!");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)checkingLastLogout
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT LastLogoutDate FROM User_Profile WHERE IndexNo=\"%d\"",indexNo];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
                
                //                NSDate *logoutDate = [NSDate dateWithTimeIntervalSinceNow: sqlite3_column_double(statement, 0)];
                
                NSString *logoutDate = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                //                NSDate *logoutDate = [dateFormatter stringFromDate:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
                
                
                NSLog(@"%@",logoutDate);
                
            } else {
                NSLog(@"error check logout");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - keyboard display

-(void)keyboardDidShow:(NSNotificationCenter *)notification
{/*
    self.scrollViewLogin.frame = CGRectMake(0, 0, 1024, 748-352);
    self.scrollViewLogin.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.scrollViewLogin scrollRectToVisible:textFieldRect animated:YES];
  */
}

-(void)keyboardDidHide:(NSNotificationCenter *)notification
{
    self.scrollViewLogin.frame = CGRectMake(0, 0, 1024, 748);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    activeField = textField;
    return YES;
}

#pragma mark - action

- (IBAction)btnLogin:(id)sender {
    if (txtUsername.text.length <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Username is required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtUsername becomeFirstResponder];
        
    }
    else if (txtPassword.text.length <=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password is required" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        [txtPassword becomeFirstResponder];
    }
    else {
        
        [self checkingFirstLogin];
        NSLog(@"loginstatus:%d",statusLogin);
        NSLog(@"indexNo:%d",indexNo);
        NSLog(@"user:%@",agentID);
        
        if (statusLogin == 1 && indexNo != 0) {
            
            /*
             FirstTimeViewController *newProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"firstTimeLogin"];
             newProfile.userID = indexNo;
             //[self presentViewController:newProfile animated:YES completion:nil];
             newProfile.modalPresentationStyle = UIModalPresentationPageSheet;
             newProfile.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             [self presentModalViewController:newProfile animated:YES];
             */
            
            SecurityQuestion *securityPage = [self.storyboard instantiateViewControllerWithIdentifier:@"SecurityQuestion"];
            securityPage.userID = indexNo;
            securityPage.FirstTimeLogin = 1;
            securityPage.modalPresentationStyle = UIModalPresentationPageSheet;
            securityPage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentModalViewController:securityPage animated:NO];
            
            
            
        } else if (statusLogin == 0 && indexNo != 0) {
            
            txtUsername.text = @"";
            txtPassword.text = @"";
            
            AppDelegate *zzz= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
            zzz.indexNo = self.indexNo;
            zzz.userRequest = agentID;
            
            /*
             MainScreen *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
             mainMenu.userRequest = agentID;
             mainMenu.indexNo = indexNo;
             [self presentViewController:mainMenu animated:YES completion:nil];
             */
            
            CarouselViewController *carouselMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"carouselView"];
            [self presentViewController:carouselMenu animated:YES completion:Nil];
            
            [self updateDateLogin];
            //            [self checkingLastLogout];
        }
    }
    
}

- (IBAction)btnReset:(id)sender
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE User_Profile SET firstLogin = 1, agentPassword = \"password\" WHERE IndexNo=\"1\""];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSString *querySQL2 = [NSString stringWithFormat:@"DELETE from SecurityQuestion_Input "];
                if (sqlite3_prepare_v2(contactDB, [querySQL2 UTF8String], -1, &statement2, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement2) == SQLITE_DONE){
                        
                        NSString *querySQL3 = [NSString stringWithFormat:@"UPDATE Agent_Profile SET AgentCode = \"\", AgentName = \"\", "
                                               " AgentContactNo = \"\", ImmediateLeaderCode = \"\", ImmediateLeaderName = \"\", BusinessRegNumber = \"\", "
                                               " AgentEmail = \"\" "];
                        if (sqlite3_prepare_v2(contactDB, [querySQL3 UTF8String], -1, &statement3, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement3) == SQLITE_DONE){
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset"
                                                                                message:@"System has been restored to first time login mode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                [alert show];
                                
                            }
                            
                            sqlite3_finalize(statement3);
                        }
                        
                    }
                    sqlite3_finalize(statement2);
                    
                }
                
                
            } else {
                NSLog(@"reset error");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
    
}

#pragma mark - memory

- (void)viewDidUnload
{
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setLblForgotPwd:nil];
    [self setScrollViewLogin:nil];
    [self setOutletReset:nil];
    [self setLabelVersion:nil];
    [self setLabelUpdated:nil];
    [self setLabelUpdated:nil];
    [self setLabelVersion:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end
