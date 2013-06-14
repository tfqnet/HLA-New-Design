//
//  BasicAccountViewController.m
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "BasicAccountViewController.h"
#import "AppDelegate.h"

@interface BasicAccountViewController ()

@end

@implementation BasicAccountViewController
@synthesize outletBasic, txtBasicPremium, txtBasicSA,txtBUMP,txtCommFrom,txtFor;
@synthesize txtGrayRTUP,txtPolicyTerm,txtPremiumPayable,txtRTUP,txtTotalBAPremium;
@synthesize myScrollView, Label1, label2, labelComm, labelFor, segPremium;
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
    
	self.planList = [[PlanList alloc] init];
    _planList.delegate = self;
	self.planList.TradOrEver = @"EVER";
	self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
}


#pragma delegate

-(void)Planlisting:(PlanList *)inController didSelectCode:(NSString *)aaCode andDesc:(NSString *)aaDesc{
	[outletBasic setTitle:aaDesc forState:UIControlStateNormal ];
	[self.planPopover dismissPopoverAnimated:YES];
	
}

#pragma memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
	[self setMyScrollView:nil];
	[self setOutletBasic:nil];
	[self setTxtPolicyTerm:nil];
	[self setSegPremium:nil];
	[self setTxtBasicPremium:nil];
	[self setTxtBasicSA:nil];
	[self setTxtGrayRTUP:nil];
	[self setTxtRTUP:nil];
	[self setTxtCommFrom:nil];
	[self setTxtFor:nil];
	[self setTxtBUMP:nil];
	[self setTxtTotalBAPremium:nil];
	[self setTxtPremiumPayable:nil];
	[self setLabel1:nil];
	[self setLabel2:nil];
	[self setLabelComm:nil];
	[self setLabelFor:nil];
	[super viewDidUnload];
}
#pragma button

- (IBAction)ACtionBasic:(id)sender {
	[self resignFirstResponder];
    
	Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
	
    if (_planList == nil) {
        self.planList = [[PlanList alloc] init];
        _planList.delegate = self;
		self.planList.TradOrEver = @"EVER";
        self.planPopover = [[UIPopoverController alloc] initWithContentViewController:_planList];
    }

	[self.planPopover setPopoverContentSize:CGSizeMake(350.0f, 200.0f)];
    [self.planPopover presentPopoverFromRect:[sender frame]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	
}
- (IBAction)ActionDone:(id)sender {
}
@end
