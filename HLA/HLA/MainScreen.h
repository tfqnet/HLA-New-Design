//
//  MainScreen.h
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVerticalTabBarController.h"
#import "SIHandler.h"
#import "BasicPlanHandler.h"

@interface MainScreen : FSVerticalTabBarController<FSTabBarControllerDelegate>

@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id userRequest;

@property (nonatomic, assign,readwrite) int IndexTab;
@property (nonatomic,strong) SIHandler *mainH;
@property (nonatomic,strong) BasicPlanHandler *mainBH;

@end
