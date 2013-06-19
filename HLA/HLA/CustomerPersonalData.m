//
//  CustomerPersonalData.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CustomerPersonalData.h"

@interface CustomerPersonalData ()

@end

@implementation CustomerPersonalData
@synthesize btnCusData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
    btnCusData.highlighted = TRUE;
    btnCusData.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnCusData:nil];
    [super viewDidUnload];
}
@end
