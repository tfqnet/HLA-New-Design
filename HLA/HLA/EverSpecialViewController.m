//
//  EverSpecialViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverSpecialViewController.h"
#import <sqlite3.h>
#import "AppDelegate.h"

@interface EverSpecialViewController ()

@end

@implementation EverSpecialViewController
@synthesize SINo,txtAmount,txtInterval,txtReduceAt,txtReduceTo,txtStartFrom,txtStartTo;
@synthesize outletReduce,outletWithdrawal;

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
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	 NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docsDir = [dirPaths objectAtIndex:0];
	databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
	
	txtAmount.delegate = self;
	txtInterval.delegate = self;
	txtStartFrom.delegate = self;
	txtStartTo.delegate = self;
	txtReduceAt.delegate = self;
	txtReduceTo.delegate = self;
	
	txtAmount.tag = 1;
	[self getExisting];
	[self toggle];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
 {
	 	return YES;
	 }

- (void)viewWillAppear:(BOOL)animated
{
	    /*
		   + 	 self.headerTitle.frame = CGRectMake(309, -20, 151, 44);
		   + 	 self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
		   + 	 self.view.frame = CGRectMake(0, 20, 768, 1004); */
	
	     self.view.frame = CGRectMake(0, 0, 788, 1004);
	     [super viewWillAppear:animated];
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getExisting{
	 	sqlite3_stmt *statement;
	 	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
		 	{
			 		NSString *querySQL = [NSString stringWithFormat: @"Select FromAge, Toage, YearInt, Amount "
										   							  "FROM UL_RegWithdrawal where sino = '%@' ", SINo ];
			
			 		//NSLog(@"%@", querySQL);
			 		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				 		{
					 			if (sqlite3_step(statement) == SQLITE_ROW)
						 			{
							 				WithdrawExist = TRUE;
							 				txtStartFrom.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
							 				txtStartTo.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
							 				txtInterval.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
							 				txtAmount.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
							
							 			} else {
								 				WithdrawExist = FALSE;
								 				//NSLog(@"error check tbl_Adm_TrnTypeNo");
								 			}
					 			sqlite3_finalize(statement);
					 		}
			 		sqlite3_close(contactDB);
			 	}
	
	 	if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
		 	{
			 		NSString *querySQL = [NSString stringWithFormat: @"Select ReducedYear, Amount "
										   							  "FROM UL_ReducedPaidUp where sino = '%@' ", SINo ];
			
			 		//NSLog(@"%@", querySQL);
			 		if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
				 		{
					 			if (sqlite3_step(statement) == SQLITE_ROW)
						 			{
							 				ReduceExist = TRUE;
							 				txtReduceAt.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
							 				txtReduceTo.text = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
							 				
							 			} else {
								 				ReduceExist = FALSE;
								 				//NSLog(@"error check tbl_Adm_TrnTypeNo");
								 			}
					 			sqlite3_finalize(statement);
					 		}
					sqlite3_close(contactDB);
		}
}

-(void)toggle{
	 	if (![txtAmount.text isEqualToString:@""]) {
				outletWithdrawal.selectedSegmentIndex = 0;
		 		txtAmount.enabled = TRUE;
		 		txtInterval.enabled = TRUE;
		 		txtStartFrom.enabled = TRUE;
		 		txtStartTo.enabled = TRUE;
				txtAmount.backgroundColor = [UIColor whiteColor];
		 		txtInterval.backgroundColor = [UIColor whiteColor];
		 		txtStartTo.backgroundColor = [UIColor whiteColor];
		 		txtStartFrom.backgroundColor = [UIColor whiteColor];
		 	}
	 	else{
		 		outletWithdrawal.selectedSegmentIndex = 1;
		 		txtAmount.enabled = FALSE;
		 		txtInterval.enabled = FALSE;
		 		txtStartFrom.enabled = FALSE;
		 		txtStartTo.enabled = FALSE;
		 		txtAmount.backgroundColor = [UIColor lightGrayColor];
		 		txtInterval.backgroundColor = [UIColor lightGrayColor];
		 		txtStartTo.backgroundColor = [UIColor lightGrayColor];
		 		txtStartFrom.backgroundColor = [UIColor lightGrayColor];
		 	}
	
	 	if (![txtReduceAt.text isEqualToString:@""]) {
		 		outletReduce.selectedSegmentIndex = 0;
		 		txtReduceAt.enabled = TRUE;
		 		txtReduceTo.enabled = TRUE;
		 		txtReduceAt.backgroundColor = [UIColor whiteColor];
		 		txtReduceTo.backgroundColor = [UIColor whiteColor];
		 	}
	 	else{
		 		outletReduce.selectedSegmentIndex = 1;
		 		txtReduceAt.enabled = FALSE;
		 		txtReduceTo.enabled = FALSE;
		 		txtReduceAt.backgroundColor = [UIColor lightGrayColor];
		 		txtReduceTo.backgroundColor = [UIColor lightGrayColor];
		 	}
	}

 -(BOOL)Validation{
	
	 	if (outletReduce.selectedSegmentIndex == 1 && outletWithdrawal.selectedSegmentIndex == 1
			 		&& WithdrawExist == FALSE && ReduceExist == FALSE)   {
		 		return FALSE;
		 	}
	
	 	if (outletWithdrawal.selectedSegmentIndex == 0) {
		 		if ([txtStartFrom.text isEqualToString:@""] )
			 		{
				 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
													  																message:@"First Regular Withdrawal policy year is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				 			[failAlert show];
				 			[txtStartFrom becomeFirstResponder];
				 			return FALSE;
				 		}
		 		if ([txtStartTo.text isEqualToString:@""]){
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												   																message:@"Last regular Withdrawal policy year is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtStartTo becomeFirstResponder];
			 			return FALSE;
			 		}
		
		 		if ([txtStartFrom.text intValue] > [txtStartTo.text intValue]){
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												   																message:@"First Regular Withdrawal policy year must be less than the Last Regular Withdrawal policy year." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtStartFrom becomeFirstResponder];
			 			return FALSE;
			 		}
		
		
		 		if([txtInterval.text isEqualToString:@""]){
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												  																message:@"Interval (Years) for Regular Withdrawal is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtInterval becomeFirstResponder];
			 			return FALSE;
			 		}
		
		 		if([txtAmount.text isEqualToString:@""]){
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												   																message:@"Amount for Regular Withdrawal is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtAmount becomeFirstResponder];
			 			return FALSE;
			 		}
		 	}
	
	 	if (outletReduce.selectedSegmentIndex == 0) {
		 		if ([txtReduceAt.text isEqualToString:@""]) {
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												   																message:@"Reduce Paid Up Year is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtReduceAt becomeFirstResponder];
			
			 			return FALSE;
			 		}
		 		if ([txtReduceTo.text isEqualToString:@""]) {
			 			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
												  															message:@"Reduce Basic Sum Assured is required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
			 			[failAlert show];
			 			[txtReduceTo becomeFirstResponder];
			 			
			 			return FALSE;
			 		}
		 
		 	}
	 	
	 	return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
	
	 	if (textField.tag != 1) {
		 		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
		 		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			 			return NO;
			 		}
		 	}
	 	else{
		 		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
		 		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			 			return NO;
			 		}
		 	}
	
	
	     return YES;
	 }


-(void)Insertandupdate{
	 	sqlite3_stmt *statement;
	
	 	if (outletWithdrawal.selectedSegmentIndex == 0) {
		 		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			 		{
				 			NSString *querySQL;
				 			if (WithdrawExist == TRUE) {
					 				querySQL = [NSString stringWithFormat: @"UPDATE UL_RegWithdrawal SET FromAge = '%@', ToAge = '%@', YearInt = '%@', "
												 							"Amount = '%@' WHERE sino = '%@' ",
												 							txtStartFrom.text, txtStartTo.text, txtInterval.text, txtAmount.text, SINo ];
					 			}
				 			else{
					 				querySQL = [NSString stringWithFormat: @"INSERT INTO UL_RegWithdrawal(Sino, FromAge, ToAge, YearInt, Amount ) VALUES "
												 							"('%@', '%@', '%@', '%@', '%@')", SINo, txtStartFrom.text, txtStartTo.text, txtInterval.text, txtAmount.text];
					 			}
				
				 			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
					 			{
						 				if (sqlite3_step(statement) == SQLITE_DONE)
							 				{
								
								 				} else {
									 					//NSLog(@"error check tbl_Adm_TrnTypeNo");
									 				}
						 				sqlite3_finalize(statement);
						 			}
				 			sqlite3_close(contactDB);
				 		}
		 	}
	 	else{
		 		if (WithdrawExist == TRUE) {
			 			if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
				 			{
					 				NSString *querySQL;
					 				querySQL = [NSString stringWithFormat: @"Delete from UL_RegWithdrawal WHERE sino = '%@'", SINo ];
					
					 				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
						 				{
							 					if (sqlite3_step(statement) == SQLITE_OK)
								 					{
									
									 					} else {
										 						//NSLog(@"error check tbl_Adm_TrnTypeNo");
										 					}
							 					sqlite3_finalize(statement);
							 				}
					 				sqlite3_close(contactDB);
					 			}
			
			
			 		}
		 	}
	
	 	if (outletReduce.selectedSegmentIndex == 0) {
		 		if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
			 		{
				 			NSString *querySQL;
				 			if (ReduceExist == TRUE) {
					 				querySQL = [NSString stringWithFormat: @"UPDATE UL_ReducedPaidUp SET ReducedYear = '%@', Amount = '%@' "
												 							" WHERE sino = '%@' ",
												 							txtReduceAt.text, txtReduceTo.text, SINo ];
					 			}
				 			else{
					 				querySQL = [NSString stringWithFormat: @"INSERT INTO UL_ReducedPaidUp(SiNo, ReducedYear, Amount) VALUES "
												 							"('%@', '%@', '%@')", SINo, txtReduceAt.text, txtReduceTo.text];
					 			}
				
				 			//NSLog(@"%@", querySQL);
				 			if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
					 			{
						 				if (sqlite3_step(statement) == SQLITE_DONE)
							 				{
								
								 				} else {
									 					//NSLog(@"error check tbl_Adm_TrnTypeNo");
									 				}
						 				sqlite3_finalize(statement);
						 			}
				 			sqlite3_close(contactDB);
				 		}
		 	}
	 	else{
		 		if (ReduceExist == TRUE) {
			 			if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
				 			{
					 				NSString *querySQL;
					 				querySQL = [NSString stringWithFormat: @"Delete FROM UL_ReducedPaidUp WHERE \"SINO\" = \"%@\" ", SINo ];
					 			
					 				if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
						 				{
							 					if (sqlite3_step(statement) == SQLITE_DONE)
								 					{
									 						NSLog(@"dasdasdsa");
									 					}
							 					else{
								 						NSLog(@"trere");
								 					}
							 					sqlite3_finalize(statement);
							 				}
					 				sqlite3_close(contactDB);
					 			}
			 		}
		 	}
	 }


- (IBAction)ActionDone:(id)sender {
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
	     id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
	     [activeInstance performSelector:@selector(dismissKeyboard)];
	
	 	if([self Validation] == TRUE){
		 		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
													message:@"Confirm changes?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
		         [alert setTag:1001];
		         [alert show];
		 		
		 	}
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
 {
	     if (alertView.tag == 1001 && buttonIndex == 0) {
		
		         [self Insertandupdate];
		     }
	 }

- (void)viewDidUnload {
	[self setOutletWithdrawal:nil];
	[self setTxtStartFrom:nil];
	[self setTxtStartTo:nil];
	[self setTxtInterval:nil];
	[self setTxtAmount:nil];
	[self setOutletReduce:nil];
	[self setTxtReduceAt:nil];
	[self setTxtReduceTo:nil];
	[super viewDidUnload];
}
- (IBAction)ActionWithdrawal:(id)sender {
	if (outletWithdrawal.selectedSegmentIndex == 0) {
		 		txtAmount.enabled = TRUE;
		 		txtInterval.enabled = TRUE;
				txtStartFrom.enabled = TRUE;
		 		txtStartTo.enabled = TRUE;
		 		txtAmount.backgroundColor = [UIColor whiteColor];
		 		txtInterval.backgroundColor = [UIColor whiteColor];
		 		txtStartTo.backgroundColor = [UIColor whiteColor];
		 		txtStartFrom.backgroundColor = [UIColor whiteColor];
		
		 	}
	 	else{
		 		txtAmount.text = @"";
		 				txtInterval.text = @"";
		 				txtStartFrom.text = @"";
		 				txtStartTo.text = @"";
		 		txtAmount.enabled = FALSE;
				txtInterval.enabled = FALSE;
		 		txtStartFrom.enabled = FALSE;
		 		txtStartTo.enabled = FALSE;
		 		txtAmount.backgroundColor = [UIColor lightGrayColor];
		 		txtInterval.backgroundColor = [UIColor lightGrayColor];
		 		txtStartTo.backgroundColor = [UIColor lightGrayColor];
		 		txtStartFrom.backgroundColor = [UIColor lightGrayColor];
		 
		 	}
}
- (IBAction)ActionReduce:(id)sender {
	if (outletReduce.selectedSegmentIndex == 0) {
		 		txtReduceAt.enabled = TRUE;
		 		txtReduceTo.enabled = TRUE;
				txtReduceAt.backgroundColor = [UIColor whiteColor];
		 		txtReduceTo.backgroundColor = [UIColor whiteColor];
		 	}
	 	else{
		 		txtReduceAt.text = @"";
		 		txtReduceTo.text = @"";
		 		txtReduceAt.enabled = FALSE;
		 		txtReduceTo.enabled = FALSE;
		 		txtReduceAt.backgroundColor = [UIColor lightGrayColor];
		 		txtReduceTo.backgroundColor = [UIColor lightGrayColor];
		 
		 	}
}
@end
