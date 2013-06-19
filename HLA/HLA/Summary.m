//
//  Summary.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Summary.h"

@interface Summary ()

@end

@implementation Summary
@synthesize btnSummary;

- (void)viewDidLoad
{
    [super viewDidLoad];
      checked = NO;
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
  
    
	btnSummary.highlighted = TRUE;
    btnSummary.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  
    [self setBtnSummary:nil];
    [super viewDidUnload];
}

@end
