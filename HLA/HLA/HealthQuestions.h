//
//  HealthQuestions.h
//  iMobile Planner
//
//  Created by shawal sapuan on 7/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthQuestions : UITableViewController {
    BOOL checked;
}

@property (strong, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ1B;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ3;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ4;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ5;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ6;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7A;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7B;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7C;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7D;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7E;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7F;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7G;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7H;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7I;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ7J;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ8A;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ8B;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ8C;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ8D;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ8E;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ9;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ10;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ11;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ12;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ13;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ14A;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ14B;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segQ15;

- (IBAction)isAllNo:(id)sender;
- (IBAction)btnQ2Press:(id)sender;
- (IBAction)btnQ3Press:(id)sender;




@end
