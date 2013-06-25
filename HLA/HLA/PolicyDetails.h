//
//  PolicyDetails.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolicyDetails : UIViewController <UITextFieldDelegate> {
    UITextField *activeField;
}

@property (strong, nonatomic) IBOutlet UIScrollView *myScrollView;

@end
