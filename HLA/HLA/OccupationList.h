//
//  OccupationList.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@protocol OccupationListDelegate
- (void)OccupDescSelected:(NSString *) OccupDesc;
- (void)OccupCodeSelected:(NSString *) OccupCode;
@end
@interface OccupationList : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSMutableArray *_OccupDesc;
    NSMutableArray *_OccupCode;
    NSString *databasePath;
    sqlite3 *contactDB;
    id<OccupationListDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *OccupDesc;
@property (nonatomic, retain) NSMutableArray *OccupCode;
@property (nonatomic, strong) id<OccupationListDelegate> delegate;
@property(retain) NSIndexPath* lastIndexPath;
@property (strong, nonatomic) NSMutableArray* FilteredData;
@property (nonatomic, assign) bool isFiltered;


@end
