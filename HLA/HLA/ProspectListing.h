//
//  ProspectListing.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ProspectListing : UITableViewController
{
    NSString *databasePath;
    sqlite3 *contactDB;
}

@property (strong, nonatomic) NSMutableArray* ProspectTableData;
@property (strong, nonatomic) NSMutableArray* FilteredProspectTableData;
@property (nonatomic, assign) bool isFiltered;
- (IBAction)btnAddNew:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btnRefresh:(id)sender;

@end
