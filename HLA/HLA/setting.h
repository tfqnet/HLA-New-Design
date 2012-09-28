//
//  setting.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setting : UIViewController

@property (nonatomic, assign,readwrite) int indexNo;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *RightView;

@end
