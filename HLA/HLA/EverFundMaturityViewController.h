//
//  EverFundMaturityViewController.h
//  iMobile Planner
//
//  Created by infoconnect on 7/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class EverFundMaturity;
@protocol EverFundMaturity

@end

@interface EverFundMaturityViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
	NSString *databasePath;
	sqlite3 *contactDB;
 	UITextField *activeField;
 	id <EverFundMaturity> _delegate;
}

@property (nonatomic,strong) id <EverFundMaturity> delegate;

- (IBAction)ACtionDone:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletFund;
@property (weak, nonatomic) IBOutlet UISegmentedControl *outletOptions;
- (IBAction)ActionOptions:(id)sender;
- (IBAction)ACtionFund:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtPercentageReinvest;
@property (weak, nonatomic) IBOutlet UITextField *txt2025;
@property (weak, nonatomic) IBOutlet UITextField *txt2030;
@property (weak, nonatomic) IBOutlet UITextField *txtSecureFund;
@property (weak, nonatomic) IBOutlet UITextField *txt2028;
@property (weak, nonatomic) IBOutlet UITextField *txt2035;
@property (weak, nonatomic) IBOutlet UITextField *txtCashFund;
@property (weak, nonatomic) IBOutlet UIButton *outletDelete;
@property (weak, nonatomic) IBOutlet UIButton *ACtionDelete;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *outletTableLabel;

@end
