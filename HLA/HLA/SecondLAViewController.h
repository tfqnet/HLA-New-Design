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
#import "DateViewController.h"
#import "JobListTbViewController.h"
#import "SIHandler.h"

@interface SecondLAViewController : UIViewController <ListingTbViewControllerDelegate,UIPopoverControllerDelegate,DateViewControllerDelegate,JobListTbViewControllerDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *popOverController;
    BOOL useExist;
}

@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) SIHandler *la2ndH;

@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (retain, nonatomic) IBOutlet UISegmentedControl *smokerSegment;
@property (retain, nonatomic) IBOutlet UIButton *DOBBtn;
@property (retain, nonatomic) IBOutlet UITextField *ageField;
@property (retain, nonatomic) IBOutlet UIButton *OccpBtn;
@property (retain, nonatomic) IBOutlet UITextField *OccpLoadField;
@property (retain, nonatomic) IBOutlet UITextField *CPAField;
@property (retain, nonatomic) IBOutlet UITextField *PAField;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *smoker;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *jobDesc;
@property (nonatomic, assign,readwrite) int age;
@property (nonatomic, assign,readwrite) int ANB;
@property(nonatomic , retain) NSString *OccpCode;
@property(nonatomic , assign,readwrite) int occLoading;
@property(nonatomic , retain) NSString *occCPA;
@property(nonatomic , retain) NSString *occPA;
@property(nonatomic , retain) NSString *SINo;
@property (nonatomic, assign,readwrite) int CustLastNo;
@property (nonatomic, copy) NSString *CustDate;
@property (nonatomic, copy) NSString *CustCode;
@property (nonatomic, copy) NSString *clientName;
@property (nonatomic, assign,readwrite) int clientID;
@property (nonatomic, copy) NSString *OccpDesc;

- (IBAction)doSelectProspect:(id)sender;
- (IBAction)sexSegmentChange:(id)sender;
- (IBAction)smokerSegmentChange:(id)sender;
- (IBAction)DOBBtnPressed:(id)sender;
- (IBAction)OccpBtnPressed:(id)sender;
- (IBAction)doCloseView:(id)sender;
- (IBAction)doSave:(id)sender;

@end
