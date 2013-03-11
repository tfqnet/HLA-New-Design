//
//  NewLAViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ListingTbViewController.h"
#import "DateViewController.h"
#import "SIHandler.h"
#import "BasicPlanHandler.h"

@class NewLAViewController;
@protocol NewLAViewControllerDelegate
-(void) LAIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker;

-(void) BasicSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andCovered:(int)aaCovered andBasicSA:(NSString *)aaBasicSA andBasicHL:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL andMOP:(int)aaMOP andPlanCode:(NSString *)aaPlanCode andAdvance:(int)aaAdvance andBasicPlan:(NSString *)aabasicPlan;

-(void) RiderAdded;
-(void)secondLADelete;
-(void)PayorDeleted;
@end

@interface NewLAViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate,ListingTbViewControllerDelegate,DateViewControllerDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *popOverController;
    UIPopoverController *_prospectPopover;
    UIPopoverController *_datePopover;
    ListingTbViewController *_ProspectList;
    DateViewController *_LADate;
    id <NewLAViewControllerDelegate> _delegate;
    BOOL Saved;
    BOOL Inserted;
    BOOL useExist;
    BOOL AgeLess;
    BOOL DiffClient;
    BOOL AgeChanged;
    BOOL JobChanged;
}

@property (strong, nonatomic) NSMutableArray *dataInsert;
@property (strong, nonatomic) NSMutableArray *dataInsert2;
@property (nonatomic,strong) SIHandler *laH;
@property (nonatomic,strong) BasicPlanHandler *laBH;
@property (nonatomic,strong) id <NewLAViewControllerDelegate> delegate;

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

@property (nonatomic, retain) ListingTbViewController *ProspectList;
@property (nonatomic, retain) DateViewController *LADate;
@property (nonatomic, retain) UIPopoverController *prospectPopover;
@property (nonatomic, retain) UIPopoverController *datePopover;
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) UIPopoverController *popOverController;
//LA Field
@property (retain, nonatomic) IBOutlet UITextField *LANameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *LAAgeField;
@property (retain, nonatomic) IBOutlet UITextField *LAOccLoadingField;
@property (retain, nonatomic) IBOutlet UITextField *LACPAField;
@property (retain, nonatomic) IBOutlet UITextField *LAPAField;
@property (strong, nonatomic) IBOutlet UIButton *btnCommDate;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITextField *LADOBField;
@property (strong, nonatomic) IBOutlet UITextField *LAOccpField;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;

@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic,strong) NSString *planChoose;

@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *occuCode;
@property (nonatomic, copy) NSString *occuDesc;
@property (nonatomic, assign,readwrite) int occuClass;
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
@property (nonatomic, copy) NSString *cashDividend;
@property (nonatomic, assign,readwrite) int advanceYearlyIncome;
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

//for occupation
@property(nonatomic , retain) NSMutableArray *occDesc;
@property(nonatomic , retain) NSMutableArray *occCode;
@property(nonatomic , assign,readwrite) int occLoading;
@property(nonatomic , assign,readwrite) int occCPA_PA;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

@property (retain, nonatomic) NSMutableArray *arrExistRiderCode;
@property (retain, nonatomic) NSMutableArray *arrExistPlanChoice;
@property (nonatomic, retain) NSMutableArray *ridCode;
@property(nonatomic , retain) NSMutableArray *atcRidCode;
@property(nonatomic , retain) NSMutableArray *atcPlanChoice;

- (IBAction)sexSegmentPressed:(id)sender;
- (IBAction)smokerSegmentPressed:(id)sender;
- (IBAction)doSaveLA:(id)sender;
- (IBAction)selectProspect:(id)sender;
- (IBAction)btnCommDatePressed:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;



@end


