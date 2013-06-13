//
//  EverLAViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 6/12/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DateViewController.h"
#import "BasicPlanHandler.h"
#import "OccupationList.h"
#import "ListingTbViewController.h"

@class EverLAViewController;
@protocol EverLAViewControllerDelegate
-(void) LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
		andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate
		andSmoker:(NSString *)aaSmoker;
-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered
		andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL
		andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan;
-(void)RiderAdded;
-(void)secondLADelete;
-(void)PayorDeleted;
@end

@interface EverLAViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate,DateViewControllerDelegate,
													ListingTbViewControllerDelegate>{

	NSString *databasePath;
	sqlite3 *contactDB;
	UITextField *activeField;
	BOOL Saved;
    BOOL Inserted;
    BOOL useExist;
    BOOL AgeLess;
    BOOL DiffClient;
    BOOL AgeChanged;
    BOOL JobChanged;
    BOOL date1;
    BOOL date2;
	id <EverLAViewControllerDelegate> _delegate;
	ListingTbViewController *_ProspectList;
}

@property (nonatomic,strong) id <EverLAViewControllerDelegate> delegate;

@property (nonatomic, retain) ListingTbViewController *ProspectList;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segGender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segSmoker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segStatus;
@property (weak, nonatomic) IBOutlet UITextField *txtALB;
- (IBAction)ActionDOB:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnComDate;
- (IBAction)ActionCommDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ActionRefresh;
@property (weak, nonatomic) IBOutlet UIButton *btnOccpDesc;
@property (weak, nonatomic) IBOutlet UITextField *txtOccpLoad;
@property (weak, nonatomic) IBOutlet UITextField *txtCPA;
@property (weak, nonatomic) IBOutlet UITextField *txtPA;
- (IBAction)ActionProspect:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UITextField *txtName;


//--request
@property (nonatomic,strong) id requestSINo;
@property (nonatomic, assign,readwrite) int requestIndexNo;
@property (nonatomic, assign,readwrite) int requestLastIDPay;
@property (nonatomic, assign,readwrite) int requestLastIDProf;
@property (nonatomic,strong) id requestCommDate;
@property (nonatomic,strong) id requestSex;
@property (nonatomic,strong) id requestSmoker;

@property (nonatomic, copy) NSString *getSINo;
//--

@property (nonatomic, retain) OccupationList *OccupationList;
@property (nonatomic, retain) DateViewController *LADate;
@property (nonatomic, retain) UIPopoverController *prospectPopover;
@property (nonatomic, retain) UIPopoverController *datePopover;
@property (nonatomic, retain) UIPopoverController *dobPopover;
@property (nonatomic, retain) UIPopoverController *OccupationListPopover;
@property (nonatomic, retain) UIPopoverController *popOverController;
//LA Field

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnDOB;

@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic,strong) NSString *planChoose;

@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *occuCode;
@property (nonatomic, copy) NSString *occuDesc;
@property (nonatomic, copy) NSString *occLoading;
@property (nonatomic, copy) NSString *strPA_CPA;
@property (nonatomic, assign,readwrite) int occuClass;
@property(nonatomic , assign,readwrite) int occCPA_PA;
@property(nonatomic , assign,readwrite) int occPA;
@property (nonatomic, assign,readwrite) int IndexNo;
@property (nonatomic, assign,readwrite) int idPayor;
@property (nonatomic, assign,readwrite) int idProfile;
@property (nonatomic, assign,readwrite) int idProfile2;
@property (nonatomic, assign,readwrite) int lastIdPayor;
@property (nonatomic, assign,readwrite) int lastIdProfile;

@property (nonatomic,strong) NSString *basicSINo;
@property (nonatomic,assign,readwrite) int getPolicyTerm;
@property (nonatomic,assign,readwrite) double getSumAssured;
@property (nonatomic,copy) NSString *getHL;
@property (nonatomic,copy) NSString *getTempHL;
@property (nonatomic,assign,readwrite) int getTempHLTerm;
@property (nonatomic,assign,readwrite) int getHLTerm;
@property (nonatomic, assign,readwrite) int MOP;
@property (nonatomic, copy) NSString *yearlyIncome;
@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic,strong) NSString *planCode;

//declare for store in DB
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *commDate;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property (nonatomic, copy) NSString *CustCode2;
@property (nonatomic, copy) NSString *payorSINo;
@property (nonatomic, copy) NSString *payorCustCode;
@property (nonatomic, assign,readwrite) int payorAge;

//for occupation
@property(nonatomic , retain) NSMutableArray *occDesc;
@property(nonatomic , retain) NSMutableArray *occCode;


@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

@property (retain, nonatomic) NSMutableArray *arrExistRiderCode;
@property (retain, nonatomic) NSMutableArray *arrExistPlanChoice;
@property (nonatomic, retain) NSMutableArray *ridCode;
@property(nonatomic , retain) NSMutableArray *atcRidCode;
@property(nonatomic , retain) NSMutableArray *atcPlanChoice;

@end
