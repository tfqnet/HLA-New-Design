//
//  PDSSidebarViewController.h
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTable.h"
#import <sqlite3.h>

@class DataTable,DBController;
@protocol PDSSidebarViewControllerDelegate;

@interface PDSSidebarViewController : UITableViewController


@property (nonatomic, assign) id <PDSSidebarViewControllerDelegate> sidebarDelegate;
@property (strong, nonatomic) DBController* db;
@property (strong, nonatomic) DataTable * dataTable;
@property (strong,nonatomic) NSMutableArray *dataArray;


@end

@protocol PDSSidebarViewControllerDelegate <NSObject>

//- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

- (void)PDSsidebarViewController:(PDSSidebarViewController *)PDSsidebarViewController didSelectObject:(NSObject *)object objectHTML:(NSObject *) objectHTML atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)PDSlastSelectedIndexPathForSidebarViewController:(PDSSidebarViewController *)PDSsidebarViewController;

@end
