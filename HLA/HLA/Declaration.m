//
//  Declaration.m
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "Declaration.h"
#import "ColorHexCode.h"

@interface Declaration ()

@end

@implementation Declaration
@synthesize btnAgree,btnDisagree;

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
    
    agreed = NO;
    disagreed = NO;
}

- (void)btnDone:(id)sender
{
    
    
}

- (IBAction)isAgree:(id)sender
{
    UIButton *btnPressed = (UIButton*)sender;
    
    if (btnPressed.tag == 0) {
        
        if (agreed) {
            [btnAgree setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            agreed = NO;
            
            [btnDisagree setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            disagreed = YES;
            
        }
        else {
            [btnAgree setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            agreed = YES;
            
            [btnDisagree setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            disagreed = NO;
        }
    }
    
    else if (btnPressed.tag == 1) {
        
        if (disagreed) {
            [btnDisagree setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            disagreed = NO;
            
            [btnAgree setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            agreed = YES;
        }
        else {
            [btnDisagree setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
            disagreed = YES;
            
            [btnAgree setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
            agreed = NO;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
