//
//  EverSeriesMasterViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 6/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "EverLAViewController.h"

@interface EverSeriesMasterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, EverLAViewControllerDelegate>{
	NSString *databasePath;
    sqlite3 *contactDB;
	NSIndexPath *selectedPath;
	NSIndexPath *previousPath;
    BOOL blocked;
    BOOL saved;
    BOOL payorSaved;
    BOOL added;
	BOOL PlanEmpty;
	NSString *PDSorSI;
	EverLAViewController *_EverLAController;
}

@property (nonatomic, retain) EverLAViewController *EverLAController;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *RightView;

@property (retain, nonatomic) NSMutableArray *ListOfSubMenu;
@property (retain, nonatomic) NSMutableArray *SelectedRow;
@property (nonatomic,strong) id requestSINo;
@property (nonatomic,strong) id requestSINo2;

@property (nonatomic, strong) NSMutableDictionary *riderCode;

-(void)Reset;
-(void)copySIToDoc;
@end
