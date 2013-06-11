//
//  CustomerProfile.h
//  iMobile Planner
//
//  Created by shawal sapuan on 5/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerProfile : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *idNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UITextField *txtIdType;
@property (strong, nonatomic) IBOutlet UITextField *txtIdNo;
@property (strong, nonatomic) IBOutlet UITextField *txtName;

@property (strong, nonatomic) NSMutableArray *clientData;

- (IBAction)doSearch:(id)sender;
- (IBAction)doReset:(id)sender;

@end
