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
#import "Preference.h"
#import "FinancialAnalysis.h"

@interface MasterMenuCFF : UIViewController {
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    DisclosureStatus *_DisclosureVC;
    CustomerChoice *_CustomerVC;
    CustomerPersonalData *_CustomerDataVC;
    Preference *_PreferenceVC;
    FinancialAnalysis *_FinancialVC;
}

@property (strong, nonatomic) IBOutlet UIView *RightView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic, retain) DisclosureStatus *DisclosureVC;
@property (nonatomic, retain) CustomerChoice *CustomerVC;
@property (nonatomic, retain) CustomerPersonalData *CustomerDataVC;
@property (nonatomic, retain) Preference *PreferenceVC;
@property (nonatomic, retain) FinancialAnalysis *FinancialVC;

@end
