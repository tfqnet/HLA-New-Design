//
//  EverHLoadingViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "EverHLoadingViewController.h"

@interface EverHLoadingViewController ()

@end

@implementation EverHLoadingViewController
@synthesize txtHLoad,termCover,title,txtHloadPct,txtHLoadPctTerm,txtHloadTerm;
@synthesize outletMedical,getHL,getHLPct,getHLTerm,getHLTermPct;
@synthesize SINo,ageClient,planChoose,getMed;
@synthesize delegate = _delegate;

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
    
	txtHLoad.tag = 1;
	txtHloadPct.tag = 2;
	txtHLoad.delegate = self;
	txtHloadPct.delegate = self;
	txtHLoadPctTerm.delegate = self;
	txtHloadTerm.delegate = self;
	
    [self getTermRule];
    [self getExistingData];
    if (getHLTerm > 0 || getHLTermPct > 0) {
        [self getExistingView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*
	 self.headerTitle.frame = CGRectMake(309, -20, 151, 44);
	 self.myToolBar.frame = CGRectMake(0, 0, 768, 44);
	 self.view.frame = CGRectMake(0, 20, 768, 1004); */
    
    self.view.frame = CGRectMake(0, 0, 788, 1004);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString     = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    if ([arrayOfString count] > 4 )
    {
        return NO;
    }
	
    if (textField.tag != 1  ) {
		NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
		if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound) {
			return NO;
		}
	}
	

	
    return YES;
}

- (void)getExistingView
{
    if (getHL.length != 0) {
        
        NSRange rangeofDot = [getHL rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getHL substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getHL substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getHL;
            }
        }
        else {
            valueToDisplay = getHL;
        }
		txtHLoad.text = valueToDisplay;
    }
    
    if (getHLTerm != 0) {
		txtHloadTerm.text = [NSString stringWithFormat:@"%d",getHLTerm];
    }
    
    if (getHLPct.length != 0) {
        NSRange rangeofDot = [getHLPct rangeOfString:@"."];
        NSString *valueToDisplay = @"";
        
        if (rangeofDot.location != NSNotFound) {
            NSString *substring = [getHLPct substringFromIndex:rangeofDot.location ];
            if (substring.length == 2 && [substring isEqualToString:@".0"]) {
                valueToDisplay = [getHLPct substringToIndex:rangeofDot.location ];
            }
            else {
                valueToDisplay = getHLPct;
            }
        }
        else {
            valueToDisplay = getHLPct;
        }
		txtHloadPct.text = valueToDisplay;
    }
    
    if (getHLTermPct != 0) {
		txtHLoadPctTerm.text = [NSString stringWithFormat:@"%d",getHLTermPct];
        
    }
	
	if (getMed == 1) {
		outletMedical.selectedSegmentIndex = 0;
	}
	else{
		outletMedical.selectedSegmentIndex = 1;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[self setTxtHLoad:nil];
	[self setTxtHloadTerm:nil];
	[self setTxtHloadPct:nil];
	[self setTxtHLoadPctTerm:nil];
	[self setOutletMedical:nil];
	[super viewDidUnload];
}
- (IBAction)ActionMedical:(id)sender {
	if (outletMedical.selectedSegmentIndex == 0) {
		getMed = 1; // yes
	}
	else{
		getMed = 0; //no
	}
}

- (IBAction)ActionDone:(id)sender {
	[self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSCharacterSet *setTerm = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    NSRange rangeofDotHL = [txtHLoad.text rangeOfString:@"."];
    NSString *substringHL = @"";
    NSRange rangeofDotTempHL = [txtHloadPct.text rangeOfString:@"."];
    NSString *substringTempHL = @"";
    
    if (rangeofDotHL.location != NSNotFound) {
        substringHL = [txtHLoad.text substringFromIndex:rangeofDotHL.location ];
    }
    if (rangeofDotTempHL.location != NSNotFound) {
        substringTempHL = [txtHloadPct.text substringFromIndex:rangeofDotTempHL.location ];
    }
    
    if ([txtHLoad.text rangeOfCharacterFromSet:set].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) or dot(.) into Health input for (per 1k SA)." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHLoad becomeFirstResponder];
    }
    else if (substringHL.length > 5) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (Per 1k SA) only allow 4 decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHLoad becomeFirstResponder];
    }
    else if ([txtHLoad.text intValue] > 0 && txtHloadTerm.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadTerm becomeFirstResponder];
    }
    else if ([txtHloadTerm.text intValue] > 0 && txtHLoad.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHLoad becomeFirstResponder];
    }
    else if ([txtHloadTerm.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) into Health input for (per 1k SA) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHloadTerm becomeFirstResponder];
    }
    else if ([txtHLoad.text intValue] == 0 && txtHLoad.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHLoad becomeFirstResponder];
    }
    else if ([txtHloadTerm.text intValue] == 0 && txtHloadTerm.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (per 1k SA) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadTerm becomeFirstResponder];
    }
	else if ([txtHloadTerm.text intValue] > termCover) {
		NSString *msg = [NSString stringWithFormat:@"Health Loading (per 1k SA) Term cannot be more than %d.", termCover];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadTerm becomeFirstResponder];
    }
    
    //--
    
    else if ([txtHloadPct.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner"
														message:@"Invalid input. Please enter numeric value (0-9) into Health Loading (%) input." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if (substringTempHL.length > 2) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) does not allow decimal places." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if ([txtHLoadPctTerm.text rangeOfCharacterFromSet:setTerm].location != NSNotFound) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Invalid input. Please enter numeric value (0-9) into  Health Loading (%) Term." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
        [alert show];
        [txtHLoadPctTerm becomeFirstResponder];
    }
    else if ([txtHloadPct.text intValue] > 999) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) cannot greater than 999" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if ([txtHloadPct.text intValue] > 0 && txtHLoadPctTerm.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if ([txtHLoadPctTerm.text intValue] > 0 && txtHloadPct.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if ([txtHloadPct.text intValue] == 0 && txtHloadPct.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHloadPct becomeFirstResponder];
    }
    else if ([txtHLoadPctTerm.text intValue] == 0 && txtHLoadPctTerm.text.length != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Health Loading (%) Term is required." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHLoadPctTerm becomeFirstResponder];
    }
	else if ([txtHLoadPctTerm.text intValue] > termCover) {
		NSString *msg = [NSString stringWithFormat:@"Health Loading (%%) Term cannot be more than %d.", termCover];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [txtHLoadPctTerm becomeFirstResponder];
    }
	else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Confirm changes?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL",nil];
        [alert setTag:1001];
        [alert show];
    }

}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 && buttonIndex == 0) {
        
        [self updateHL];
    }
}

#pragma mark - db

-(void) getTermRule
{
	int maxTerm  =  100;
    
	termCover = maxTerm - ageClient;
    
}

-(void)updateHL
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"UPDATE UL_Details SET HLoading=\"%@\", HLoadingTerm=\"%d\", "
							  "HLoadingPct=\"%@\", HloadingPctTerm=\"%d\", DateModified=%@, MedicalReq = '%d' WHERE SINo=\"%@\"",
							  txtHLoad.text, [txtHloadTerm.text intValue], txtHloadPct.text, [txtHLoadPctTerm.text intValue],
							  @"datetime(\"now\", \"+8 hour\")",getMed, SINo];
        
        //NSLog(@"%@",querySQL);
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"HL update!");
                
                [_delegate HLInsert:txtHLoad.text andBasicTempHL:txtHloadPct.text];
            }
            else {
                NSLog(@"HL update Failed!");
                
                UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:@"Fail in updating record." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [failAlert show];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

- (void)getExistingData
{
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT SINo, PlanCode, HLoading, HLoadingTerm, HLoadingPct, HLoadingPctTerm, MedicalReq FROM "
							  "UL_Details WHERE SINo=\"%@\"",SINo];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                SINo = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                planChoose = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
				
                const char *getHL2 = (const char*)sqlite3_column_text(statement, 2);
                getHL = getHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getHL2];
                getHLTerm = sqlite3_column_int(statement, 3);
                
                const char *getTempHL2 = (const char*)sqlite3_column_text(statement, 4);
                getHLPct = getTempHL2 == NULL ? nil : [[NSString alloc] initWithUTF8String:getTempHL2];
                getHLTermPct = sqlite3_column_int(statement, 5);
				getMed = sqlite3_column_int(statement, 6);
                
            } else {
                NSLog(@"error getExistingData");
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

@end
