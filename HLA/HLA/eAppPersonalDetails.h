//
//  eAppPersonalDetails.h
//  iMobile Planner
//
//  Created by shawal sapuan on 7/3/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDTypeViewController.h"
#import "SIDate.h"
#import "TitleViewController.h"
#import "Relationship.h"

@interface eAppPersonalDetails : UITableViewController <IDTypeDelegate, SIDateDelegate,TitleDelegate,RelationshipDelegate> {
    IDTypeViewController *_IDTypeVC;
    SIDate *_SIDate;
    TitleViewController *_TitlePicker;
    Relationship *_RelationshipVC;
    UIPopoverController *_IDTypePopover;
    UIPopoverController *_SIDatePopover;
    UIPopoverController *_TitlePickerPopover;
    UIPopoverController *_RelationshipPopover;
    BOOL checked;
}

@property (nonatomic, strong) IDTypeViewController *IDTypeVC;
@property (nonatomic, retain) SIDate *SIDate;
@property (nonatomic, strong) TitleViewController *TitlePicker;
@property (nonatomic, strong) Relationship *RelationshipVC;
@property (nonatomic, strong) UIPopoverController *TitlePickerPopover;
@property (nonatomic, retain) UIPopoverController *IDTypePopover;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, retain) UIPopoverController *RelationshipPopover;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *OtherIDLbl;
@property (strong, nonatomic) IBOutlet UILabel *DOBLbl;
@property (strong, nonatomic) IBOutlet UILabel *RelationshipLbl;
@property (strong, nonatomic) IBOutlet UIButton *checkAddress;
@property (strong, nonatomic) IBOutlet UIButton *checkForeign;

- (IBAction)btnLA1:(id)sender;
- (IBAction)btnLA2:(id)sender;
- (IBAction)ActionTitle:(id)sender;
- (IBAction)ActionOtherID:(id)sender;
- (IBAction)ActionDOB:(id)sender;
- (IBAction)ActionRelationship:(id)sender;
- (IBAction)checkAdd:(id)sender;
- (IBAction)ActionForeign:(id)sender;


@end
