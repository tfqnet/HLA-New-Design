//
//  SettingSecurityQuestion.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 11/21/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SettingSecurityQuestion.h"

@interface SettingSecurityQuestion ()

@end

@implementation SettingSecurityQuestion
@synthesize btnClose,questOneCode;
@synthesize outletQues1,questTwoCode;
@synthesize outletQues3,questThreeCode;
@synthesize outletQues2;
@synthesize txtAnswer1;
@synthesize txtAnswer2;
@synthesize txtAnswer3;
@synthesize ScrollView;
@synthesize popOverConroller;

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
	// Do any additional setup after loading the view.
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
}

- (void)viewDidUnload
{
    [self setBtnClose:nil];
    [self setScrollView:nil];
    [self setOutletQues1:nil];
    [self setOutletQues3:nil];
    [self setTxtAnswer1:nil];
    [self setTxtAnswer2:nil];
    [self setTxtAnswer3:nil];
    [self setOutletQues2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        [self loadExisting];
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



















-(void) loadExisting{
    
    sqlite3_stmt *statement;
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"select SecurityQuestionDesc, securityquestionans from "
                              "securityQuestion_input as A, securityQuestion as B where A.securityQuestionCode = B.securityQuestionCode "];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK){
            
            int a = 1;
            while (sqlite3_step(statement) == SQLITE_ROW){
                if ( a == 1) {
                    [outletQues1 setTitle:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] forState:UIControlStateNormal];
                    txtAnswer1.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                }
                else if (a == 2) {
                    [outletQues2 setTitle:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] forState:UIControlStateNormal];
                    txtAnswer2.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                }
                else if (a == 3) {
                    [outletQues3 setTitle:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)] forState:UIControlStateNormal];
                    txtAnswer3.text = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                }
                
                a = a + 1;
            } 
            sqlite3_finalize(statement);       
        }
            
        sqlite3_close(contactDB);
    }
        
}

-(void)securityQuest:(SecurityQuesTbViewController *)inController didSelectQuest:(NSString *)code desc:(NSString *)desc{
    if (selectOne) {
        questOneCode = [[NSString alloc] initWithFormat:@"%@",code];
        [outletQues1 setTitle:[[NSString alloc] initWithFormat:@"%@",desc] forState:UIControlStateNormal ];
    }
    else if (selectTwo) {
        questTwoCode = [[NSString alloc] initWithFormat:@"%@",code];
        [outletQues2 setTitle:[[NSString alloc] initWithFormat:@"%@",desc] forState:UIControlStateNormal ];
    }
    else if (selectThree) {
        questThreeCode = [[NSString alloc] initWithFormat:@"%@",code];
        [outletQues3 setTitle:[[NSString alloc] initWithFormat:@"%@",desc] forState:UIControlStateNormal ];
    }
    [popOverConroller dismissPopoverAnimated:YES];
    
    selectOne = NO;
    selectTwo = NO;
    selectThree = NO;
    
}


- (IBAction)btnQues1:(id)sender {
    
}

- (IBAction)btnQues2:(id)sender {
}


- (IBAction)btnQues3:(id)sender {
}

- (IBAction)btnSave:(id)sender {
}

- (IBAction)ActionClose:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
