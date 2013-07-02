//
//  CustomerChoice.m
//  iMobile Planner
//
//  Created by Erza on 6/15/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CustomerChoice.h"

@interface CustomerChoice ()

@end

@implementation CustomerChoice
@synthesize checkButton2;
@synthesize checkButton3;
@synthesize checkButton4;

- (void)viewDidLoad
{
    [super viewDidLoad];
    checked = NO;
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.frame = CGRectMake(0, 0, 788, 1004);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setCheckButton2:nil];
    [self setCheckButton3:nil];
    [self setCheckButton4:nil];
    [super viewDidUnload];
}
- (IBAction)checkboxButton2:(id)sender {
    if (!checked) {
        [checkButton2 setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkButton2 setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }

}
- (IBAction)checkboxButton3:(id)sender {
    if (!checked) {
        [checkButton3 setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkButton3 setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }

}
- (IBAction)checkboxButton4:(id)sender {
    if (!checked) {
        [checkButton4 setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else if (checked) {
        [checkButton4 setImage:[UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        checked = NO;
    }

}
@end
