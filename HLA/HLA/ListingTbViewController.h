//
//  ListingTbViewController.h
//  HLA
//
//  Created by shawal sapuan on 8/7/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class ListingTbViewController;
@protocol ListingTbViewControllerDelegate
-(void)listing:(ListingTbViewController *)inController didSelectIndex:(NSString *)aaIndex andName:(NSString *)aaName andDOB:(NSString *)aaDOB andGender:(NSString *)aaGender andOccpCode:(NSString *)aaCode;
@end

@interface ListingTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <ListingTbViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) id <ListingTbViewControllerDelegate> delegate;
@property(nonatomic , retain) NSMutableArray *indexNo;
@property(nonatomic , retain) NSMutableArray *NameList;
@property(nonatomic , retain) NSMutableArray *DOBList;
@property(nonatomic , retain) NSMutableArray *GenderList;
@property(nonatomic , retain) NSMutableArray *OccpCodeList;
@end
