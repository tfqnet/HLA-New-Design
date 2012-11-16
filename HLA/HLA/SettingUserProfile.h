//
//  SettingUserProfile.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 11/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface SettingUserProfile : UIViewController{
    NSString *databasePath;
    sqlite3 *contactDB;
    UITextField *activeField;
}

@property (nonatomic,strong) id idRequest;
@property (nonatomic, assign) int indexNo;

@property (weak, nonatomic) IBOutlet UILabel *lblAgentLoginID;
@property (weak, nonatomic) IBOutlet UITextField *txtAgentCode;
@property (weak, nonatomic) IBOutlet UITextField *txtAgentName;
@property (weak, nonatomic) IBOutlet UITextField *txtAgentContactNo;
@property (weak, nonatomic) IBOutlet UITextField *txtLeaderCode;
@property (weak, nonatomic) IBOutlet UITextField *txtLeaderName;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtBixRegNo;


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *contactNo;
@property (nonatomic, copy) NSString *leaderCode;
@property (nonatomic, copy) NSString *leaderName;
@property (nonatomic, copy) NSString *registerNo;
@property (nonatomic, copy) NSString *email;

- (IBAction)btnClose:(id)sender;
- (IBAction)btnSave:(id)sender;



@end
