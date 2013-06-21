//
//  PersonalDetails.m
//  iMobile Planner
//
//  Created by shawal sapuan on 6/21/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PersonalDetails.h"

@interface PersonalDetails ()

@end

@implementation PersonalDetails
@synthesize btnPersonalDetails;

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
         self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    btnPersonalDetails.highlighted = TRUE;
    btnPersonalDetails.enabled = FALSE;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnPersonalDetails:nil];
    [super viewDidUnload];
}
@end
