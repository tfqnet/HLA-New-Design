//
//  ChangePassword.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 9/28/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "PasswordTips.h"

@interface ChangePassword : UIViewController{
    NSString *databasePath;
    sqlite3 *contactDB;
    UIPopoverController *_PasswordTipPopover;
    PasswordTips *_PasswordTips;
}

@property (nonatomic, assign,readwrite) int userID;

@property (weak, nonatomic) IBOutlet UITextField *txtOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmPwd;
- (IBAction)btnChange:(id)sender;
- (IBAction)btnCancel:(id)sender;


@property (nonatomic, copy) NSString *passwordDB;
@property (weak, nonatomic) IBOutlet UILabel *lblmsg;
@property (nonatomic, retain) UIPopoverController *PasswordTipPopover;
@property (nonatomic, retain) PasswordTips *PasswordTips;
- (IBAction)btnTips:(id)sender;

@end
