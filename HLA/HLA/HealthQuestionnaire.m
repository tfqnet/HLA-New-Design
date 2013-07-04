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
@synthesize delegate = _delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
	
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
- (IBAction)swipeNext:(id)sender {
    [_delegate swipeToHQ2];
    
}
@end
