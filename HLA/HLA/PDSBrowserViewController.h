//
//  PDSBrowserViewController.h
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import <Cordova/CDVViewController.h>
#import "BasicPlanHandler.h"

#define EXPERIEMENTAL_ORIENTATION_SUPPORT 1
@class PDSSidebarViewController;
@protocol PDSBrowserDelegate
- (void)CloseWindow;
@end

@interface PDSBrowserViewController : UIViewController<JTRevealSidebarV2Delegate, UITableViewDelegate> {
    CDVViewController* browserController;
#if EXPERIEMENTAL_ORIENTATION_SUPPORT
    CGPoint _containerOrigin;
#endif
    UIBarButtonItem *next;
    UIBarButtonItem *prev;
    id<PDSBrowserDelegate> _delegate;
}

@property (nonatomic, strong) PDSSidebarViewController *leftSidebarViewController;
@property (nonatomic, strong) NSIndexPath *leftSelectedIndexPath;
//@property (nonatomic, strong) UITableView *rightSidebarView;
//@property (nonatomic, strong) UILabel     *label;
@property (nonatomic, strong) id<PDSBrowserDelegate> delegate;
@property (nonatomic, assign) int gPages;
@property (nonatomic,strong) id PDSLanguage;

@end
