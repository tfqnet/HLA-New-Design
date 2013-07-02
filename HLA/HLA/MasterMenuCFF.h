//
//  MasterMenuCFF.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/28/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisclosureStatus.h"
#import "CustomerChoice.h"
#import "CustomerPersonalData.h"
#import "PotentialArea.h"
#import "Preference.h"
#import "FinancialAnalysis.h"
#import "Retirement.h"
#import "RecordAdvice.h"
#import "Declare.h"
#import "ConfirmationCFF.h"

@interface MasterMenuCFF : UIViewController <FinancialAnalysisDelegate> {
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    DisclosureStatus *_DisclosureVC;
    CustomerChoice *_CustomerVC;
    CustomerPersonalData *_CustomerDataVC;
    PotentialArea *_PotentialVC;
    Preference *_PreferenceVC;
    FinancialAnalysis *_FinancialVC;
    Retirement *_RetirementVC;
    RecordAdvice *_RecordVC;
    Declare *_DeclareCFFVC;
    ConfirmationCFF *_ConfirmCFFVC;
}

@property (strong, nonatomic) IBOutlet UIView *RightView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic, retain) DisclosureStatus *DisclosureVC;
@property (nonatomic, retain) CustomerChoice *CustomerVC;
@property (nonatomic, retain) CustomerPersonalData *CustomerDataVC;
@property (nonatomic, retain) PotentialArea *PotentialVC;
@property (nonatomic, retain) Preference *PreferenceVC;
@property (nonatomic, retain) FinancialAnalysis *FinancialVC;
@property (nonatomic, retain) Retirement *RetirementVC;
@property (nonatomic, retain) RecordAdvice *RecordVC;
@property (nonatomic, retain) Declare *DeclareCFFVC;
@property (nonatomic, retain) ConfirmationCFF *ConfirmCFFVC;

@end
