//
//  HealthQuestionnaire.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HealthQuestionnaire.h"

@interface HealthQuestionnaire ()

@end

@implementation HealthQuestionnaire
@synthesize btnHealth;

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
    btnHealth.highlighted = TRUE;
    btnHealth.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnHealth:nil];
    [super viewDidUnload];
}
@end
