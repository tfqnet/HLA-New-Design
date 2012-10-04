//
//  ProspectListing.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "EditProspect.h"
#import "ProspectViewController.h"

@interface ProspectListing : UITableViewController<EditProspectDelegate,ProspectViewControllerDelegate>
{
    NSString *databasePath;
    sqlite3 *contactDB;
    EditProspect *_EditProspect;
    ProspectViewController *_ProspectViewController;
}

@property (nonatomic, retain) EditProspect *EditProspect;
@property (nonatomic, retain) ProspectViewController *ProspectViewController;
@property (strong, nonatomic) NSMutableArray* ProspectTableData;
@property (strong, nonatomic) NSMutableArray* FilteredProspectTableData;
@property (nonatomic, assign) bool isFiltered;
- (IBAction)btnAddNew:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btnRefresh:(id)sender;
-(void) ReloadTableData;
@end
