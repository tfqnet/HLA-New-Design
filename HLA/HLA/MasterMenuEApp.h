//
//  MasterMenuEApp.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Summary.h"
#import "PolicyDetails.h"
#import "NomineesTrustees.h"
#import "HealthQuestionnaire.h"
#import "AdditionalQuestions.h"
#import "Declaration.h"
#import "CustomerPersonalData.h"
#import "eAppPersonalDetails.h"

@interface MasterMenuEApp : UIViewController {
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    Summary *_SummaryVC;
    PolicyDetails *_PolicyVC;
    NomineesTrustees *_NomineesVC;
    HealthQuestionnaire *_HealthVC;
    AdditionalQuestions *_AddQuestVC;
    Declaration *_DeclareVC;
    CustomerPersonalData *_CustomerDataVC;
     eAppPersonalDetails *_eAppPersonalDataVC;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic, retain) Summary *SummaryVC;
@property (nonatomic, retain) PolicyDetails *PolicyVC;
@property (nonatomic, retain) NomineesTrustees *NomineesVC;
@property (nonatomic, retain) HealthQuestionnaire *HealthVC;
@property (nonatomic, retain) AdditionalQuestions *AddQuestVC;
@property (nonatomic, retain) Declaration *DeclareVC;
@property (nonatomic, retain) CustomerPersonalData *CustomerDataVC;
@property (nonatomic, retain) eAppPersonalDetails *eAppPersonalDataVC;

@end
