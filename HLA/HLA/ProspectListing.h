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
#import "IDTypeViewController.h"

@interface ProspectListing : UIViewController<EditProspectDelegate, IDTypeDelegate, ProspectViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *databasePath;
    sqlite3 *contactDB;
    EditProspect *_EditProspect;
    ProspectViewController *_ProspectViewController;
    NSMutableArray *ItemToBeDeleted;
    NSMutableArray *indexPaths;
}

@property (weak, nonatomic) IBOutlet UIButton *IDType;
- (IBAction)IdType:(id)sender;
@property (nonatomic, strong) IDTypeViewController *IDTypePicker;
@property (nonatomic, strong) UIPopoverController *IDTypePickerPopover;

@property (nonatomic, retain) EditProspect *EditProspect;
@property (nonatomic, retain) ProspectViewController *ProspectViewController;
@property (strong, nonatomic) NSMutableArray* ProspectTableData;
@property (strong, nonatomic) NSMutableArray* FilteredProspectTableData;
@property (nonatomic, assign) bool isFiltered;
- (IBAction)btnAddNew:(id)sender;
//@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

-(void) ReloadTableData;
-(void) Clear;

//--add new bob
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) IBOutlet UILabel *idTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *idNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nametxt;
- (IBAction)searchPressed:(id)sender;
- (IBAction)resetPressed:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)editPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;


@end
