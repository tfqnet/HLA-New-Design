//
//  Login.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "Reachability.h"

@protocol LoginDelegate
- (void)Dismiss: (NSString *)ViewToBePresented;
@end


@interface Login : UIViewController
{
    NSString *databasePath;
    NSString *RatesDatabasePath;
	    NSString *CommDatabasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
	id<LoginDelegate> _delegate;
	Reachability *internetReachableFoo;
	
}

@property (nonatomic, strong) id<LoginDelegate> delegate;

@property (nonatomic, assign) int statusLogin;
@property (nonatomic, assign) int indexNo;
@property (nonatomic, copy) NSString *agentID;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewLogin;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblForgotPwd;
@property (strong, nonatomic) IBOutlet UILabel *labelVersion;
@property (strong, nonatomic) IBOutlet UILabel *labelUpdated;

- (IBAction)btnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletLogin;

-(void)keyboardDidShow:(NSNotificationCenter *)notification;
-(void)keyboardDidHide:(NSNotificationCenter *)notification;
- (IBAction)btnReset:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *outletReset;

@end
