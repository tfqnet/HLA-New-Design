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
-(void)listing:(ListingTbViewController *)inController didSelectItem:(NSString *)item;
@end

@interface ListingTbViewController : UITableViewController {
    NSString *databasePath;
    sqlite3 *contactDB;
    NSUInteger selectedIndex;
    id <ListingTbViewControllerDelegate> _delegate;
}

@property (nonatomic,strong) id <ListingTbViewControllerDelegate> delegate;
@property (readonly) NSString *selectedItem;
@property(nonatomic , retain) NSMutableArray *nameList;
@property(nonatomic , retain) NSMutableArray *SINoList;
@end
