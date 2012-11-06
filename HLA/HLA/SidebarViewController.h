//
//  LeftSidebarViewController.h
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataTable.h"
#import <sqlite3.h>

@class DataTable,DBController;
@protocol SidebarViewControllerDelegate;

@interface SidebarViewController : UITableViewController

@property (nonatomic, assign) id <SidebarViewControllerDelegate> sidebarDelegate;
@property (strong, nonatomic) DBController* db;
@property (strong, nonatomic) DataTable * dataTable;
@property (strong,nonatomic) NSMutableArray *dataArray;

@end

@protocol SidebarViewControllerDelegate <NSObject>

//- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath;

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object objectHTML:(NSObject *) objectHTML atIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController;

@end
