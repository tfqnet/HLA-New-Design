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
@synthesize checkButton1;

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
    checked = NO;
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    self.navigationItem.title = @"Disclosure";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCheckButton:nil];
    [self setCheckButton1:nil];
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
