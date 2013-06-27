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

@interface MasterMenuEApp : UIViewController {
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    Summary *_SummaryVC;
    PolicyDetails *_PolicyVC;
    NomineesTrustees *_NomineesVC;
    HealthQuestionnaire *_HealthVC;
    AdditionalQuestions *_AddQuestVC;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic, retain) Summary *SummaryVC;
@property (nonatomic, retain) PolicyDetails *PolicyVC;
@property (nonatomic, retain) NomineesTrustees *NomineesVC;
@property (nonatomic, retain) HealthQuestionnaire *HealthVC;
@property (nonatomic, retain) AdditionalQuestions *AddQuestVC;

@end
