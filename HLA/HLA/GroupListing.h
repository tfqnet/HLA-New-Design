//
//  GroupListing.h
//  iMobile Planner
//
//  Created by shawal sapuan on 6/5/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupListing : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)addNew:(id)sender;

@property (strong, nonatomic) NSMutableArray *itemInArray;

@end
