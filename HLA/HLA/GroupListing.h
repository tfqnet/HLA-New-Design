//
//  GroupListing.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/5/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupListing : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *groupLabel;
@property (strong, nonatomic) IBOutlet UILabel *memberLabel;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

- (IBAction)addNew:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)editPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;

@property (strong, nonatomic) NSMutableArray *itemInArray;

@end
