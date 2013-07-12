//
//  HealthQuestions.m
//  iMobile Planner
//
//  Created by shawal sapuan on 7/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "HealthQuestions.h"
#import "ColorHexCode.h"

@interface HealthQuestions ()

@end

@implementation HealthQuestions
@synthesize btnCheck;
@synthesize segQ10,segQ11,segQ12,segQ13,segQ14A,segQ14B,segQ15,segQ1B,segQ2,segQ3,segQ4,segQ5,segQ6;
@synthesize segQ7A,segQ7B,segQ7C,segQ7D,segQ7E,segQ7F,segQ7G,segQ7H,segQ7I,segQ7J,segQ8A,segQ8B,segQ8C,segQ8D,segQ8E,segQ9;

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
    
    checked = NO;
}

- (void)btnDone:(id)sender
{
         
}

- (IBAction)isAllNo:(id)sender
{
    if (checked) {
        checked = NO;
        [btnCheck setImage: [UIImage imageNamed:@"emptyCheckBox.png"] forState:UIControlStateNormal];
    }
    else {
        //set all to no
        
        checked = YES;
        [btnCheck setImage: [UIImage imageNamed:@"tickCheckBox.png"] forState:UIControlStateNormal];
        segQ1B.selectedSegmentIndex = 1;
        segQ2.selectedSegmentIndex = 1;
        segQ3.selectedSegmentIndex = 1;
        segQ4.selectedSegmentIndex = 1;
        segQ5.selectedSegmentIndex = 1;
        segQ6.selectedSegmentIndex = 1;
        segQ7A.selectedSegmentIndex = 1;
        segQ7B.selectedSegmentIndex = 1;
        segQ7C.selectedSegmentIndex = 1;
        segQ7D.selectedSegmentIndex = 1;
        segQ7E.selectedSegmentIndex = 1;
        segQ7F.selectedSegmentIndex = 1;
        segQ7G.selectedSegmentIndex = 1;
        segQ7H.selectedSegmentIndex = 1;
        segQ7I.selectedSegmentIndex = 1;
        segQ7J.selectedSegmentIndex = 1;
        segQ8A.selectedSegmentIndex = 1;
        segQ8B.selectedSegmentIndex = 1;
        segQ8C.selectedSegmentIndex = 1;
        segQ8D.selectedSegmentIndex = 1;
        segQ8E.selectedSegmentIndex = 1;
        segQ9.selectedSegmentIndex = 1;
        segQ10.selectedSegmentIndex = 1;
        segQ11.selectedSegmentIndex = 1;
        segQ12.selectedSegmentIndex = 1;
        segQ13.selectedSegmentIndex = 1;
        segQ14A.selectedSegmentIndex = 1;
        segQ14B.selectedSegmentIndex = 1;
        segQ15.selectedSegmentIndex = 1;
    }
}


- (IBAction)btnQ1bPress:(id)sender {
    if (segQ1B.selectedSegmentIndex == 0) {
       HealthQuestions *aaa = [self.storyboard instantiateViewControllerWithIdentifier:@"HQ1"];
        aaa.modalPresentationStyle = UIModalPresentationPageSheet;
        aaa.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:aaa animated:NO];
        //aaa.view.superview.frame = CGRectMake(0, 50, 748, 974);
    }
}

- (IBAction)btnQ2Press:(id)sender {
    if (segQ2.selectedSegmentIndex == 0) {
        HealthQuestions *aaa = [self.storyboard instantiateViewControllerWithIdentifier:@"HQ2"];
        aaa.modalPresentationStyle = UIModalPresentationPageSheet;
        aaa.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:aaa animated:NO];
    
    }
}

- (IBAction)btnQ3Press:(id)sender {
    if (segQ3.selectedSegmentIndex == 0) {
        HealthQuestions *aaa = [self.storyboard instantiateViewControllerWithIdentifier:@"HQ3"];
        aaa.modalPresentationStyle = UIModalPresentationPageSheet;
        aaa.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentModalViewController:aaa animated:NO];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
