//
//  MasterMenuEApp.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/25/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PolicyDetails.h"

@interface MasterMenuEApp : UIViewController {
    NSIndexPath *selectedPath;
    NSIndexPath *previousPath;
    PolicyDetails *_PolicyVC;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UIView *rightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic, retain) PolicyDetails *PolicyVC;


@end
