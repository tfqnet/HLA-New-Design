//
//  FinancialAnalysis.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "FinancialAnalysis.h"

@interface FinancialAnalysis ()

@end

@implementation FinancialAnalysis
@synthesize btnFinancial;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
    btnFinancial.highlighted = TRUE;
    btnFinancial.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnFinancial:nil];
    [super viewDidUnload];
}
@end
