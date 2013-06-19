//
//  DisclosureStatus.m
//  iMobile Planner
//
//  Created by Erza on 6/14/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "DisclosureStatus.h"

@interface DisclosureStatus ()

@end

@implementation DisclosureStatus
@synthesize checkButton;
@synthesize checkButton1,btnDisclose;

- (void)viewDidLoad
{
    [super viewDidLoad];
    checked = NO;

    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    self.navigationItem.title = @"Disclosure";
    
    btnDisclose.highlighted = TRUE;
    btnDisclose.enabled = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCheckButton:nil];
    [self setCheckButton1:nil];
    [self setBtnDisclose:nil];
    [super viewDidUnload];
}
- (IBAction)checkboxButton:(id)sender {
    if (!checked) {
        [checkButton setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkButton setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }

}
- (IBAction)checkboxButton1:(id)sender {
    if (!checked) {
        [checkButton1 setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkButton1 setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }
}
@end
