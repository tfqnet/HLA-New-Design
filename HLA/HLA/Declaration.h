//
//  Declaration.h
//  iMobile Planner
//
//  Created by Erza on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Declaration : UITableViewController {
    BOOL agreed;
    BOOL disagreed;
}

@property (strong, nonatomic) IBOutlet UIButton *btnAgree;
@property (strong, nonatomic) IBOutlet UIButton *btnDisagree;

- (IBAction)isAgree:(id)sender;

@end
