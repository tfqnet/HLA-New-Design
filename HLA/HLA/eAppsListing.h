//
//  eAppsListing.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface eAppsListing : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (strong, nonatomic) IBOutlet UILabel *SILabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *idNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *planLabel;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)ActionClose:(id)sender;



@property (retain, nonatomic) NSMutableArray *SINO;
@property (retain, nonatomic) NSMutableArray *DateCreated;
@property (retain, nonatomic) NSMutableArray *Name;
@property (retain, nonatomic) NSMutableArray *PlanName;
@property (retain, nonatomic) NSMutableArray *BasicSA;
@property (retain, nonatomic) NSMutableArray *SIStatus;
@property (retain, nonatomic) NSMutableArray *CustomerCode;
@end
