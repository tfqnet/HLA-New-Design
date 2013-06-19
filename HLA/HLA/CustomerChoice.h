//
//  CustomerChoice.h
//  iMobile Planner
//
//  Created by Erza on 6/15/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerChoice : UIViewController {
    BOOL checked;
}
@property (strong, nonatomic) IBOutlet UIButton *checkButton2;

- (IBAction)checkboxButton2:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkButton3;
- (IBAction)checkboxButton3:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *checkButton4;
- (IBAction)checkboxButton4:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *btnCusChoice;


@end
