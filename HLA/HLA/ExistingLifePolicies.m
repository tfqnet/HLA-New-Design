//
//  ExistingLifePolicies.m
//  iMobile Planner
//
//  Created by Erza on 7/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ExistingLifePolicies.h"
#import "ExistingPolicies.h"
#import "ColorHexCode.h"

@interface ExistingLifePolicies ()

@end

@implementation ExistingLifePolicies

- (void)viewDidLoad
{
    [super viewDidLoad];

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

- (void)btnDone:(id)sender
{
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAddExisting:nil];
    [super viewDidUnload];
}
- (IBAction)actionExisting:(id)sender {
    ExistingPolicies *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"ExistingScreen"];
    zzz.modalPresentationStyle = UIModalPresentationPageSheet;
    zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:zzz animated:NO];
    zzz.view.superview.frame = CGRectMake(130, 370, 448, 534);

}
@end
