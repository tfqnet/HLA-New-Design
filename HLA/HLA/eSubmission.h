//
//  eSubmission.h
//  iMobile Planner
//
//  Created by shawal sapuan on 5/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIDate.h"
#import "eAppsListing.h"
#import "eAppStatusList.h"


@interface eSubmission : UIViewController <UITableViewDelegate,UITableViewDataSource,SIDateDelegate>{
    SIDate *_SIDate;
    eAppStatusList *_statusVC;
    UIPopoverController *_SIDatePopover;
    UIPopoverController *_statusPopover;
    eAppsListing *_eAppsVC;
}

@property (strong, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *idNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *policyNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIButton *btnDate;

@property (strong, nonatomic) NSMutableArray *clientData;
@property (nonatomic, retain) SIDate *SIDate;
@property (nonatomic, retain) eAppStatusList *statusVC;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, retain) UIPopoverController *statusPopover;
@property (nonatomic, retain) eAppsListing *eAppsVC;

- (IBAction)btnDatePressed:(id)sender;
- (IBAction)addNew:(id)sender;

@end
