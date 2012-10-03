//
//  SIMenuViewController.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIHandler.h"

@interface SIMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *RightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (nonatomic,strong) SIHandler *handler;

@property (nonatomic, retain) NSString *getSINo;
@property (nonatomic ,assign ,readwrite) int getAge;
@property (nonatomic, retain) NSString *getOccpCode;

@end
