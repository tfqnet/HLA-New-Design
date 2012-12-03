//
//  AppDelegate.h
//  HLA
//
//  Created by Md. Nazmus Saadat on 9/26/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign,readwrite) int indexNo;
@property (nonatomic,strong) id userRequest;
@property (nonatomic,strong) id MhiMessage;

@end
