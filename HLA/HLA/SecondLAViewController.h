//
//  SecondLAViewController.h
//  HLA
//
//  Created by shawal sapuan on 7/31/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "ListingTbViewController.h"
#import "SIHandler.h"
#import "BasicPlanHandler.h"
#import "SecondLAHandler.h"

@class SecondLAViewController;
@protocol SecondLAViewControllerDelegate
-(void) LA2ndIndexNo:(int)aaIndexNo andSmoker:(NSString *)aaSmoker andSex:(NSString *)aaSex andDOB:(NSString *)aaDOB andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode;
-(void)secondLADelete;
-(void)saved:(BOOL)aaTrue;
@end

@interface SecondLAViewController : UIViewController <ListingTbViewControllerDelegate,UIPopoverControllerDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *popOverController;
    ListingTbViewController *_ProspectList;
    BOOL useExist;
    BOOL inserted;
    BOOL saved;
    id <SecondLAViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) SIHandler *laHand;
@property (nonatomic,strong) BasicPlanHandler *basicHand;
@property (nonatomic,strong) SecondLAHandler *la2ndHand;
@property (strong, nonatomic) NSMutableArray *dataInsert;

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) ListingTbViewController *ProspectList;
@property (nonatomic,strong) id <SecondLAViewControllerDelegate> delegate;

//--request
@property (nonatomic, assign,readwrite) int requestLAIndexNo;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) id requestCommDate;
@property (nonatomic, assign,readwrite) int getLAIndexNo;
@property(nonatomic , retain) NSString *getSINo;
@property (nonatomic, copy) NSString *getCommDate;
//--

@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *ageField;
@property (retain, nonatomic) IBOutlet UITextField *OccpLoadField;
@property (retain, nonatomic) IBOutlet UITextField *CPAField;
@property (retain, nonatomic) IBOutlet UITextField *PAField;
@property (strong, nonatomic) IBOutlet UITextField *DOBField;
@property (strong, nonatomic) IBOutlet UITextField *OccpField;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, assign,readwrite) int IndexNo;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property(nonatomic , retain) NSString *OccpCode;
@property(nonatomic , assign,readwrite) int occLoading;
@property(nonatomic , assign,readwrite) int occCPA_PA;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property(nonatomic , retain) NSString *SINo;
@property (nonatomic, copy) NSString *CustDate;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, assign,readwrite) int clientID;
@property (nonatomic, copy) NSString *OccpDesc;
@property (nonatomic, copy) NSString *CheckRiderCode;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

- (IBAction)doSelectProspect:(id)sender;
- (IBAction)sexSegmentChange:(id)sender;
- (IBAction)smokerSegmentChange:(id)sender;
- (IBAction)doSave:(id)sender;
- (IBAction)doDelete:(id)sender;

@end
