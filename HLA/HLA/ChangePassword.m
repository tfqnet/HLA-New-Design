//
//  ChangePassword.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ChangePassword.h"
#import "Login.h"

@interface ChangePassword ()

@end

@implementation ChangePassword
@synthesize txtOldPwd;
@synthesize txtNewPwd;
@synthesize txtConfirmPwd;
@synthesize passwordDB;
@synthesize lblmsg;
@synthesize userID;


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
    NSLog(@"Receive userID:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
       
    
    [self validateExistingPwd];

}

- (void)viewDidUnload
{
    [self setTxtOldPwd:nil];
    [self setTxtNewPwd:nil];
    [self setTxtConfirmPwd:nil];
    [self setLblmsg:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}




-(void)validateExistingPwd
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT AgentPassword FROM User_Profile WHERE IndexNO=\"%d\"",self.userID];
        
        NSLog(@"%@", querySQL);
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                passwordDB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)validatePassword
{
    if ([txtOldPwd.text isEqualToString:passwordDB]){
        
        NSLog(@"Password enter match!");
        [self saveChanges];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        txtOldPwd.text = @"";
        txtNewPwd.text = @"";
        txtConfirmPwd.text = @"";
        
    }
}

-(void)saveChanges
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE User_Profile SET AgentPassword= \"%@\" WHERE IndexNo=\"%d\"",txtNewPwd.text,self.userID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                txtOldPwd.text = @"";
                txtNewPwd.text = @"";
                txtConfirmPwd.text = @"";
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Password save!\n You need to re-login." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert setTag:01];
                [alert show];
                
            } else {
                lblmsg.text = @"Failed to update!";
                lblmsg.textColor = [UIColor redColor];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}



- (IBAction)btnChange:(id)sender {
    
    //NSLog(@"Your existing:%@",passwordDB);

    if (txtOldPwd.text.length <= 0 || txtNewPwd.text.length <= 0 || txtConfirmPwd.text.length <= 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please fill up all field!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    } 
        
        
    else {
        
        if ([txtNewPwd.text isEqualToString:txtConfirmPwd.text]) {
           [self validatePassword]; 
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Password did not match!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            txtOldPwd.text = @"";
            txtNewPwd.text = @"";
            txtConfirmPwd.text = @"";
        }   
        
    }
     
}

- (IBAction)btnCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 01) {     
        if (buttonIndex == 0) {
            
            Login *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
            [self presentViewController:loginView animated:YES completion:nil];
        }
    }
}
@end
