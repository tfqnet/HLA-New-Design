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
#import "JobListTbViewController.h"
#import "SIHandler.h"
#import "BasicPlanHandler.h"

@interface NewLAViewController : UIViewController<UITextFieldDelegate,UIPopoverControllerDelegate,ListingTbViewControllerDelegate,DateViewControllerDelegate,JobListTbViewControllerDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    UIPopoverController *popOverController;
    ListingTbViewController *_ProspectList;
    BOOL Saved;
    BOOL useExist;
    BOOL date1;
    BOOL date2;
}

@property (strong, nonatomic) NSMutableArray *dataInsert;
@property (nonatomic,strong) SIHandler *laH;
@property (nonatomic,strong) BasicPlanHandler *laBH;
//request from previous
@property (nonatomic,strong) id requestSINo;

@property (nonatomic, retain) ListingTbViewController *ProspectList;

//LA Field
@property (retain, nonatomic) IBOutlet UITextField *LANameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UITextField *LAAgeField;
@property (retain, nonatomic) IBOutlet UITextField *LAOccLoadingField;
@property (retain, nonatomic) IBOutlet UITextField *LACPAField;
@property (retain, nonatomic) IBOutlet UITextField *LAPAField;
@property (retain, nonatomic) IBOutlet UIButton *btnDOB;
@property (retain, nonatomic) IBOutlet UIButton *btnOccp;
@property (strong, nonatomic) IBOutlet UIButton *btnCommDate;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, copy) NSString *occuCode;
@property (nonatomic, copy) NSString *occuDesc;
@property (nonatomic, copy) NSString *commencementDate;
@property (nonatomic, assign,readwrite) int occuClass;
@property (nonatomic, assign,readwrite) int IndexNo;

//declare for store in DB
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *commDate;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, copy) NSString *SINo;
@property (nonatomic, copy) NSString *SIDate;
@property (nonatomic, assign,readwrite) int SILastNo;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic, copy) NSString *CustDate;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property (nonatomic, assign,readwrite) int clientID;
@property (nonatomic, assign,readwrite) int clientID2;
@property (nonatomic, copy) NSString *CustCode2;
@property (nonatomic, copy) NSString *payorSINo;
@property (nonatomic, copy) NSString *payorCustCode;

//for occupation
@property(nonatomic , retain) NSMutableArray *occDesc;
@property(nonatomic , retain) NSMutableArray *occCode;
@property(nonatomic , assign,readwrite) int occLoading;
@property(nonatomic , assign,readwrite) int occCPA_PA;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, retain) UIPopoverController *popOverController;

@property(nonatomic , retain) NSString *NamePP;
@property(nonatomic , retain) NSString *DOBPP;
@property(nonatomic , retain) NSString *GenderPP;
@property(nonatomic , retain) NSString *OccpCodePP;

- (IBAction)sexSegmentPressed:(id)sender;
- (IBAction)smokerSegmentPressed:(id)sender;
- (IBAction)btnDOBPressed:(id)sender;
- (IBAction)btnOccPressed:(id)sender;
- (IBAction)doSaveLA:(id)sender;
- (IBAction)selectProspect:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)btnCommDatePressed:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;

@end
