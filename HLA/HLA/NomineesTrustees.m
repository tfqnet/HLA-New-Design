//
//  NomineesTrustees.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "NomineesTrustees.h"
#import "Nominees.h"
#import "Trustees.h"

@interface NomineesTrustees ()

@end

@implementation NomineesTrustees

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
- (IBAction)addNominees:(id)sender
{
    Nominees *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"PopNomineesView"];
    zzz.modalPresentationStyle = UIModalPresentationPageSheet;
    zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:zzz animated:NO];
    zzz.view.superview.frame = CGRectMake(0, 50, 748, 974);
}

- (IBAction)addTrustee:(id)sender
{
    Trustees *zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"TrusteeView"];
    zzz.modalPresentationStyle = UIModalPresentationPageSheet;
    zzz.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:zzz animated:NO];
//    zzz.view.superview.frame = CGRectMake(0, 50, 748, 974);
    
}
@end
