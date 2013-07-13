//
//  PolicyDetails.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIDate.h"
#import "IDTypeViewController.h"

@interface PolicyDetails : UITableViewController <SIDateDelegate,IDTypeDelegate> {
    SIDate *_SIDate;
    UIPopoverController *_SIDatePopover;
}


@property (nonatomic, retain) SIDate *SIDate;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, strong) IDTypeViewController *IDTypeVC;
@property (nonatomic, retain) UIPopoverController *IDTypePopover;

@property (strong, nonatomic) IBOutlet UILabel *DOBLbl;
@property (strong, nonatomic) IBOutlet UILabel *OtherIDLbl;


- (IBAction)ActionDOB:(id)sender;
- (IBAction)ActionOtherID:(id)sender;


@end
