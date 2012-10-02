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

@interface Login ()

@end

@implementation Login
@synthesize scrollViewLogin;
@synthesize txtUsername;
@synthesize txtPassword;
@synthesize lblForgotPwd;
@synthesize statusLogin,indexNo,agentID;

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
    [self makeDBCopy];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPassword:)];
    tapGesture.numberOfTapsRequired = 1;
    [lblForgotPwd addGestureRecognizer:tapGesture];
    
}

- (void)viewDidUnload
{
    [self setTxtUsername:nil];
    [self setTxtPassword:nil];
    [self setLblForgotPwd:nil];
    [self setScrollViewLogin:nil];
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

- (void)makeDBCopy 
{	
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
    
    success = [fileManager fileExistsAtPath:databasePath];
    if (success) return;
    
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (IBAction)btnLogin:(id)sender {
    if (txtUsername.text.length <= 0 || txtPassword.text.length <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please insert ID/Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } else {
        
        [self checkingFirstLogin];
        NSLog(@"loginstatus:%d",statusLogin);
        NSLog(@"indexNo:%d",indexNo);
        NSLog(@"user:%@",agentID);
        
        if (statusLogin == 1 && indexNo != 0) {
            
            FirstTimeViewController *newProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"firstTimeLogin"];
            newProfile.userID = indexNo;
            [self presentViewController:newProfile animated:YES completion:nil];
            
            /*
            setting *settingPage = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            settingPage.indexNo = indexNo;
            settingPage.userRequest = agentID;
            
            [self presentViewController:settingPage animated:YES completion:nil];
            */
            
        } else if (statusLogin == 0 && indexNo != 0) {
            
            txtUsername.text = @"";
            txtPassword.text = @"";
            
            MainScreen *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"Main"];
            mainMenu.userRequest = agentID;
            mainMenu.indexNo = indexNo;
            [self presentViewController:mainMenu animated:YES completion:nil];
            
            
            [self updateDateLogin];
            //            [self checkingLastLogout];
        }
    }

}

- (void)forgotPassword:(id)sender
{
    ForgotPwd *forgotView = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPwd"];
    forgotView.modalPresentationStyle = UIModalPresentationFormSheet;
    forgotView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:forgotView animated:YES];
    forgotView.view.superview.bounds = CGRectMake(0, 0, 550, 600);
     
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong Id/Password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
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
{
    self.scrollViewLogin.frame = CGRectMake(0, 0, 1024, 748-352);
    self.scrollViewLogin.contentSize = CGSizeMake(1024, 748);
    
    CGRect textFieldRect = [activeField frame];
    textFieldRect.origin.y += 10;
    [self.scrollViewLogin scrollRectToVisible:textFieldRect animated:YES];
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


@end
