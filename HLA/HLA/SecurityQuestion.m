//
//  SecurityQuestion.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/29/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SecurityQuestion.h"
#import "SecurityQuesTbViewController.h"

@interface SecurityQuestion ()

@end

@implementation SecurityQuestion
@synthesize lblQuesOne;
@synthesize lblQuesTwo;
@synthesize lblQuestThree;
@synthesize txtAnswerQ1;
@synthesize txtAnswerQ2;
@synthesize txtAnswerQ3;
@synthesize questOneCode,questTwoCode,questThreeCode,popOverConroller, userID;

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
    NSLog(@"Receive user:%d",self.userID);
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    UITapGestureRecognizer *gestureQOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestOne:)];
    gestureQOne.numberOfTapsRequired = 1;
    [lblQuesOne addGestureRecognizer:gestureQOne];
    
    UITapGestureRecognizer *gestureQTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestTwo:)];
    gestureQTwo.numberOfTapsRequired = 1;
    [lblQuesTwo addGestureRecognizer:gestureQTwo];
    
    UITapGestureRecognizer *gestureQThree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectQuestThree:)];
    gestureQThree.numberOfTapsRequired = 1;
    [lblQuestThree addGestureRecognizer:gestureQThree];
}

- (void)viewDidUnload
{
    [self setLblQuesOne:nil];
    [self setLblQuesTwo:nil];
    [self setLblQuestThree:nil];
    [self setTxtAnswerQ1:nil];
    [self setTxtAnswerQ2:nil];
    [self setTxtAnswerQ3:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)btnSave:(id)sender {
    [self saveData];
}

- (IBAction)btnCancel:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

- (void)selectQuestOne:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
        selectOne = YES;
		SecurityQuesTbViewController *popView = [[SecurityQuesTbViewController alloc] init];
		popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
        
		[popOverConroller setPopoverContentSize:CGSizeMake(530.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
        selectOne = NO;
	}
}

- (void)selectQuestTwo:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
        selectTwo = YES;
		SecurityQuesTbViewController *popView = [[SecurityQuesTbViewController alloc] init];
		popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
        
		[popOverConroller setPopoverContentSize:CGSizeMake(530.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
        selectTwo = NO;
	}
}

- (void)selectQuestThree:(id)sender
{
    if(![popOverConroller isPopoverVisible]){
        
        selectThree = YES;
		SecurityQuesTbViewController *popView = [[SecurityQuesTbViewController alloc] init];
		popOverConroller = [[UIPopoverController alloc] initWithContentViewController:popView];
        popView.delegate = self;
        
		[popOverConroller setPopoverContentSize:CGSizeMake(530.0f, 400.0f)];
        [popOverConroller presentPopoverFromRect:CGRectMake(0, 0, 550, 600) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
    else{
		[popOverConroller dismissPopoverAnimated:YES];
        selectThree = NO;
	}
}

- (void) saveData
{
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO SecurityQuestion_Input (SecurityQuestionCode, SecurityQuestionAns) SELECT \"%@\", \"%@\" UNION ALL SELECT \"%@\", \"%@\" UNION ALL SELECT \"%@\", \"%@\"",questOneCode,txtAnswerQ1.text,questTwoCode,txtAnswerQ2.text,questThreeCode,txtAnswerQ3.text];
        
        const char *insert_stmt = [insertSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"save question success!");
                
            } else {
                NSLog(@"Failed save question");
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
}

#pragma mark - delegate

-(void)securityQuest:(SecurityQuesTbViewController *)inController didSelectQuest:(NSString *)code desc:(NSString *)desc
{
    if (selectOne) {
        questOneCode = [[NSString alloc] initWithFormat:@"%@",code];
        lblQuesOne.text = [[NSString alloc] initWithFormat:@"%@",desc];
    }
    else if (selectTwo) {
        questTwoCode = [[NSString alloc] initWithFormat:@"%@",code];
        lblQuesTwo.text = [[NSString alloc] initWithFormat:@"%@",desc];
    }
    else if (selectThree) {
        questThreeCode = [[NSString alloc] initWithFormat:@"%@",code];
        lblQuestThree.text = [[NSString alloc] initWithFormat:@"%@",desc];
    }
    [popOverConroller dismissPopoverAnimated:YES];
    selectOne = NO;
    selectTwo = NO;
    selectThree = NO;
}

@end