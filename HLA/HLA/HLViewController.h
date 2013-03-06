//
//  HLViewController.h
//  iMobile Planner
//
//  Created by shawal sapuan on 3/6/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class HLViewController;
@protocol HLViewControllerDelegate
-(void) HLInsert:(NSString *)aaBasicHL andBasicTempHL:(NSString *)aaBasicTempHL;
@end

@interface HLViewController : UIViewController <UITextFieldDelegate> {
    NSString *databasePath;
    sqlite3 *contactDB;
    id <HLViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) id <HLViewControllerDelegate> delegate;

@property (strong, nonatomic) IBOutlet UITextField *HLField;
@property (strong, nonatomic) IBOutlet UITextField *HLTermField;
@property (strong, nonatomic) IBOutlet UITextField *TempHLField;
@property (strong, nonatomic) IBOutlet UITextField *TempHLTermField;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolBar;
- (IBAction)doSave:(id)sender;

//--request
@property (nonatomic, assign,readwrite) int ageClient;
@property (nonatomic,strong) NSString *planChoose;
@property (nonatomic, copy) NSString *SINo;
//--
@property (nonatomic, assign,readwrite) int termCover;
@property (nonatomic,copy) NSString *getHL;
@property (nonatomic,assign,readwrite) int getHLTerm;
@property (nonatomic,copy) NSString *getTempHL;
@property (nonatomic,assign,readwrite) int getTempHLTerm;


@end
