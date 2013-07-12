//
//  eAppPersonalDetails.m
//  iMobile Planner
//
//  Created by shawal sapuan on 7/3/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppPersonalDetails.h"
#import "ColorHexCode.h"
#import "SubDetails.h"

@interface eAppPersonalDetails ()

@end

@implementation eAppPersonalDetails
@synthesize titleLbl,OtherIDLbl,DOBLbl,RelationshipLbl;
@synthesize IDTypePopover = _IDTypePopover;
@synthesize IDTypeVC = _IDTypeVC;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;
@synthesize TitlePicker = _TitlePicker;
@synthesize TitlePickerPopover = _TitlePickerPopover;
@synthesize RelationshipVC = _RelationshipVC;
@synthesize RelationshipPopover = _RelationshipPopover;
@synthesize checkAddress;
@synthesize checkForeign;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    checked = NO;
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"e-Application";
    self.navigationItem.titleView = label;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDone:)];

}

- (void)viewWillAppear:(BOOL)animated
{
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


#pragma mark - action

- (void)btnDone:(id)sender
{
    
}

- (IBAction)btnLA1:(id)sender
{
    SubDetails *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"subDataScreen"];
    zzz.modalPresentationStyle = UIModalPresentationPageSheet;
    zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:zzz animated:NO];
}

- (IBAction)btnLA2:(id)sender
{
    SubDetails *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"subDataScreen"];
    zzz.modalPresentationStyle = UIModalPresentationPageSheet;
    zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:zzz animated:NO];
}

- (IBAction)ActionTitle:(id)sender
{
    if (_TitlePicker == nil) {
        _TitlePicker = [[TitleViewController alloc] initWithStyle:UITableViewStylePlain];
        _TitlePicker.delegate = self;
        self.TitlePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_TitlePicker];
    }
    
    [self.TitlePickerPopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionOtherID:(id)sender
{
    if (_IDTypeVC == nil) {
        
        self.IDTypeVC = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        _IDTypeVC.delegate = self;
        self.IDTypePopover = [[UIPopoverController alloc] initWithContentViewController:_IDTypeVC];
    }
    
    [self.IDTypePopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionDOB:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    DOBLbl.text = dateString;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil];
    
    if (_SIDate == Nil) {
        
        self.SIDate = [mainStoryboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender bounds ]  inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    dateFormatter = Nil;
    dateString = Nil, mainStoryboard = nil;
}

- (IBAction)ActionRelationship:(id)sender
{
    if (_RelationshipVC == nil) {
        
        self.RelationshipVC = [[Relationship alloc] initWithStyle:UITableViewStylePlain];
        _RelationshipVC.delegate = self;
        _RelationshipVC.requestType = @"LA";
        self.RelationshipPopover = [[UIPopoverController alloc] initWithContentViewController:_RelationshipVC];
    }
    
    [self.RelationshipPopover presentPopoverFromRect:[sender bounds] inView:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)checkAdd:(id)sender {
    if (!checked) {
        [checkAddress setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkAddress setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}

- (IBAction)ActionForeign:(id)sender {
    if (!checked) {
        [checkForeign setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkForeign setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}


#pragma mark - delegate

-(void)selectedIDType:(NSString *)selectedIDType
{
    OtherIDLbl.text = selectedIDType;
    [self.IDTypePopover dismissPopoverAnimated:YES];
}

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    DOBLbl.text = strDate;
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [self.SIDatePopover dismissPopoverAnimated:YES];
}

-(void)selectedTitle:(NSString *)selectedTitle
{
    titleLbl.text = selectedTitle;
    [self.TitlePickerPopover dismissPopoverAnimated:YES];
}

-(void)selectedRelationship:(NSString *)theRelation
{
    RelationshipLbl.text = theRelation;
    [self.RelationshipPopover dismissPopoverAnimated:YES];
}


#pragma mark - memory management


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleLbl:nil];
    [self setOtherIDLbl:nil];
    [self setDOBLbl:nil];
    [self setRelationshipLbl:nil];
    [self setCheckAddress:nil];
    [self setCheckForeign:nil];
    [super viewDidUnload];
}
@end
