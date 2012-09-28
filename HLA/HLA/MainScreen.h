//
//  MainScreen.h
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSVerticalTabBarController.h"

@interface MainScreen : FSVerticalTabBarController<FSTabBarControllerDelegate>

@property (nonatomic, assign,readwrite) int indexNo;

@end
