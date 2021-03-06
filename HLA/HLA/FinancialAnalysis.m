//
//  FinancialAnalysis.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FinancialAnalysis.h"
#import "Retirement.h"

@interface FinancialAnalysis ()

@end

@implementation FinancialAnalysis
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)swipeNext:(id)sender
{
    
    [_delegate swipeToRetirement];
    
//    Retirement *RetirementPage = [self.storyboard instantiateViewControllerWithIdentifier:@"RetirementView"];
//    RetirementPage.modalPresentationStyle = UIModalPresentationPageSheet;
//    RetirementPage.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:RetirementPage animated:YES completion:Nil];
}
@end
