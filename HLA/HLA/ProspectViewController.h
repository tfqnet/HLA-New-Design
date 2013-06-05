//
//  ProspectViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/30/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "OccupationList.h"
#import "ContactTypeClass.h"
#import "SIDate.h"
#import "IDTypeViewController.h"

@protocol ProspectViewControllerDelegate
- (void)FinishInsert;
@end

@interface ProspectViewController : UIViewController<ContactTypeClassDelegate,IDTypeDelegate, SIDateDelegate,IDTypeDelegate, OccupationListDelegate>{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
    OccupationList *_OccupationList;
    ContactTypeClass *_ContactTypeClass;
    SIDate *_SIDate;
    
    UIPopoverController *_OccupationListPopover;
    UIPopoverController *_ContactTypePopover;
    UIPopoverController *_SIDatePopover;
    id<ProspectViewControllerDelegate> _delegate;

    UIAlertView *rrr;
}
@property (weak, nonatomic) IBOutlet UIButton *IDType;
- (IBAction)IdType:(id)sender;
@property (nonatomic, strong) IDTypeViewController *IDTypePicker;
@property (nonatomic, strong) UIPopoverController *IDTypePickerPopover;


@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *DOB;
@property (nonatomic, copy) NSString *OccupCodeSelected;
@property (nonatomic, copy) NSString *SelectedStateCode;
@property (nonatomic, copy) NSString *SelectedOfficeStateCode;
@property (nonatomic, strong) id<ProspectViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *txtPreferredName;
@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segGender;
- (IBAction)ActionGender:(id)sender;
- (IBAction)btnDOB:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletDOB;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeAddr1;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeAddr2;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeAddr3;
@property (weak, nonatomic) IBOutlet UITextField *txtHomePostCode;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeTown;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeState;
@property (weak, nonatomic) IBOutlet UITextField *txtHomeCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeAddr1;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeAddr2;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeAddr3;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficePostcode;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeTown;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeState;
@property (weak, nonatomic) IBOutlet UITextField *txtOfficeCountry;
@property (weak, nonatomic) IBOutlet UITextField *txtExactDuties;
@property (weak, nonatomic) IBOutlet UIButton *outletOccup;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
- (IBAction)btnOccup:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtRemark;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtContact1;
@property (weak, nonatomic) IBOutlet UITextField *txtContact2;
@property (weak, nonatomic) IBOutlet UITextField *txtContact3;
@property (weak, nonatomic) IBOutlet UITextField *txtContact4;
@property (weak, nonatomic) IBOutlet UITextField *txtContact5;
@property (weak, nonatomic) IBOutlet UIButton *outletType2;
@property (weak, nonatomic) IBOutlet UIButton *outletType3;
@property (weak, nonatomic) IBOutlet UIButton *outletType4;
@property (weak, nonatomic) IBOutlet UIButton *outletType5;
- (IBAction)btnContact2:(id)sender;
- (IBAction)btnContact3:(id)sender;
- (IBAction)btnContact4:(id)sender;
- (IBAction)btnContact5:(id)sender;



- (IBAction)btnSave:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletType1;
- (IBAction)btnContact1:(id)sender;

@property (strong, nonatomic) NSArray* ContactType;
@property (nonatomic, copy) NSString *ContactTypeTracker;
@property (nonatomic, retain) SIDate *SIDate;
@property (nonatomic, retain) UIPopoverController *SIDatePopover;
@property (nonatomic, retain) OccupationList *OccupationList;
@property (nonatomic, retain) UIPopoverController *OccupationListPopover;
@property (nonatomic, retain) ContactTypeClass  *ContactTypeClass;
@property (nonatomic, retain) UIPopoverController *ContactTypePopover;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCancel;
- (IBAction)ActionCancel:(id)sender;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;
@property (weak, nonatomic) IBOutlet UITextField *txtPrefix1;
@property (weak, nonatomic) IBOutlet UITextField *txtPrefix2;
@property (weak, nonatomic) IBOutlet UITextField *txtPrefix3;
@property (weak, nonatomic) IBOutlet UITextField *txtPrefix4;
@property (weak, nonatomic) IBOutlet UITextField *txtPrefix5;
@property (weak, nonatomic) IBOutlet UILabel *lblOfficeAddr;
@property (weak, nonatomic) IBOutlet UILabel *lblPostCode;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *outletDone;


@end
