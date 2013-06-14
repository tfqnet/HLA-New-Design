//
//  BasicAccountViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanList.h"
#import <sqlite3.h>

@class EverBasicPlanViewController;
@protocol EverBasicPlanViewControllerDelegate
-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan;
-(void)RiderAdded;
-(void) BasicSARevised:(NSString *)aabasicSA;
@end


@interface BasicAccountViewController : UIViewController<UITextFieldDelegate,PlanListDelegate>{
	NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *_planPopover;
    PlanList *_planList;
	id <EverBasicPlanViewControllerDelegate> _delegate;
}

@property (nonatomic, retain) UIPopoverController *planPopover;
@property (nonatomic, retain) PlanList *planList;
@property (nonatomic,strong) id <EverBasicPlanViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIButton *outletBasic;
- (IBAction)ACtionBasic:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPolicyTerm;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segPremium;
@property (weak, nonatomic) IBOutlet UITextField *txtBasicPremium;
@property (weak, nonatomic) IBOutlet UITextField *txtBasicSA;
@property (weak, nonatomic) IBOutlet UITextField *txtGrayRTUP;
@property (weak, nonatomic) IBOutlet UITextField *txtRTUP;
@property (weak, nonatomic) IBOutlet UITextField *txtCommFrom;
@property (weak, nonatomic) IBOutlet UITextField *txtFor;
@property (weak, nonatomic) IBOutlet UITextField *txtBUMP;
@property (weak, nonatomic) IBOutlet UITextField *txtTotalBAPremium;
@property (weak, nonatomic) IBOutlet UITextField *txtPremiumPayable;
@property (weak, nonatomic) IBOutlet UILabel *Label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *labelComm;
@property (weak, nonatomic) IBOutlet UILabel *labelFor;
- (IBAction)ActionDone:(id)sender;


@end
