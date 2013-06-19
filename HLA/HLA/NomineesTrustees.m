//
//  NomineesTrustees.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "NomineesTrustees.h"

@interface NomineesTrustees ()

@end

@implementation NomineesTrustees
@synthesize btnNominees;

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
    btnNominees.highlighted = TRUE;
    btnNominees.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnNominees:nil];
    [super viewDidUnload];
}
@end
