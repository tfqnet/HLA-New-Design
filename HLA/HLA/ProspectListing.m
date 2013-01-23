//
//  ProspectListing.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ProspectListing.h"
#import <sqlite3.h>
#import "ProspectProfile.h"
#import "ProspectViewController.h"
#import "EditProspect.h"
#import "AppDelegate.h"
#import "MainScreen.h"
#import "ColorHexCode.h"

@interface ProspectListing ()

@end

@implementation ProspectListing
@synthesize searchBar, ProspectTableData, FilteredProspectTableData, isFiltered;
@synthesize EditProspect = _EditProspect;
@synthesize ProspectViewController = _ProspectViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    searchBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"Prospect Listing";
    self.navigationItem.titleView = label;
    
    searchBar.delegate = (id)self;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        //NSString *querySQL = [NSString stringWithFormat: @"SELECT * from tbl_prospect_profile"];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM prospect_profile order by ProspectName ASC"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            ProspectTableData = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                // [occCode addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)]];
                //[occDesc addObject:[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)]];
                NSString *ProspectID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *NickName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *ProspectName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *ProspectDOB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *ProspectGender = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *ResidenceAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *ResidenceAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                NSString *ResidenceAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                NSString *ResidenceAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                NSString *ResidenceAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                NSString *ResidenceAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                NSString *ResidenceAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                NSString *OfficeAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                NSString *OfficeAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                NSString *OfficeAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                NSString *OfficeAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                NSString *OfficeAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                NSString *OfficeAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                NSString *OfficeAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                NSString *ProspectEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                NSString *ProspectOccupationCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                NSString *ExactDuties = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 21)];
                NSString *ProspectRemark = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 22)];
                
                //NSString *ProspectContactType = @"2";
                //NSString *ProspectContactNo = @"0128765462";
                
                // NSLog(@"%@", ProspectRemark);
                
                [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName 
                                                                  AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                              AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3  
                                                           AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                                       AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry 
                                                                 AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown 
                                                             AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                           AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark 
                                                         AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB AndExactDuties:ExactDuties ]];
            }
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(contactDB);
    }
}

- (void)viewDidUnload
{
    [self setSearchBar:nil];
    [super viewDidUnload];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self ReloadTableData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount;
    if(self.isFiltered)
        //rowCount = filteredTableData.count;
        rowCount = FilteredProspectTableData.count;
    else
        //rowCount = allTableData.count;
        rowCount = ProspectTableData.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    //Food* food;
    ProspectProfile* pp;
    if(isFiltered)
        //food = [filteredTableData objectAtIndex:indexPath.row];
        pp = [FilteredProspectTableData objectAtIndex:indexPath.row];
    else
        //food = [allTableData objectAtIndex:indexPath.row];
        pp = [ProspectTableData objectAtIndex:indexPath.row];
    //cell.textLabel.text = food.name;
    //cell.detailTextLabel.text = food.description;
    cell.textLabel.text = pp.ProspectName;
    cell.detailTextLabel.text = pp.NickName;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    return cell;
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        //  filteredTableData = [[NSMutableArray alloc] init];
        FilteredProspectTableData = [[NSMutableArray alloc] init];
        /*
         for (Food* food in allTableData)
         {
         NSRange nameRange = [food.name rangeOfString:text options:NSCaseInsensitiveSearch];
         NSRange descriptionRange = [food.description rangeOfString:text options:NSCaseInsensitiveSearch];
         if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
         {
         [filteredTableData addObject:food];
         }	
         }
         */
        for (ProspectProfile* pp in ProspectTableData)
        {
            NSRange Fullname = [pp.ProspectName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange PreferredName = [pp.NickName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange ResidenceAddressState = [pp.ResidenceAddressState rangeOfString:text options:NSCaseInsensitiveSearch];
            
            
            if (Fullname.location != NSNotFound || PreferredName.location != NSNotFound || ResidenceAddressState.location != NSNotFound) {
                [FilteredProspectTableData addObject:pp];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [self.searchBar resignFirstResponder];
    EditProspect* zzz = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
    ProspectProfile* pp;
    
    if(isFiltered)
    {
    
        pp = [FilteredProspectTableData objectAtIndex:indexPath.row];
    }
    else
    {
    
        pp = [ProspectTableData objectAtIndex:indexPath.row];
    }
    
    zzz.pp = pp;
    
    //[self.navigationController pushViewController:zzz animated:true];    
    
    if (_EditProspect == Nil) {
        //self.EditProspect = [[EditProspect alloc] init ];
        self.EditProspect = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProspect"];
        _EditProspect.delegate = self;
    }
    
    _EditProspect.pp = pp;
        
    /*
    _EditProspect.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _EditProspect.modalPresentationStyle = UIModalPresentationPageSheet; 
    [self presentModalViewController:_EditProspect animated:YES];
    _EditProspect.view.superview.frame = CGRectMake(50, 0, 970, 768);
    */
    
    [self.navigationController pushViewController:_EditProspect animated:YES];
    _EditProspect.navigationItem.title = @"Edit Prospect Profile";
    _EditProspect.navigationItem.rightBarButtonItem = _EditProspect.outletDone;

}

- (IBAction)btnAddNew:(id)sender {
    /*
    ProspectViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
    pvc.modalPresentationStyle = UIModalPresentationPageSheet;
    pvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:pvc animated:YES];
    pvc.view.superview.frame = CGRectMake(20, 0, 1000, 768);
    //[self.navigationController pushViewController:pvc animated:YES ];
     */
    
    /*
    if (_ProspectViewController == Nil) {
        self.ProspectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
        _ProspectViewController.delegate = self;
    }
    _ProspectViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    _ProspectViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:_ProspectViewController animated:YES];
    _ProspectViewController.view.superview.frame = CGRectMake(50, 0, 970, 768);
    */
    
    ProspectViewController *pvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
    [self.navigationController pushViewController:pvc animated:YES];
    pvc.navigationItem.title = @"Prospect Profile";
    pvc.navigationItem.rightBarButtonItem = pvc.outletDone;
    
}
/*
- (IBAction)btnRefresh:(id)sender {
    //[self.tableView reloadData];
    [self ReloadTableData];
}
*/
-(void) ReloadTableData{
    
    
NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *docsDir = [dirPaths objectAtIndex:0];

databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];


const char *dbpath = [databasePath UTF8String];
sqlite3_stmt *statement;
if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
{
    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM prospect_profile order by ProspectName ASC"];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        
        ProspectTableData = [[NSMutableArray alloc] init];
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *ProspectID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            NSString *NickName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            NSString *ProspectName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
            NSString *ProspectDOB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
            NSString *ProspectGender = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
            NSString *ResidenceAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
            NSString *ResidenceAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
            NSString *ResidenceAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
            NSString *ResidenceAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
            NSString *ResidenceAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
            NSString *ResidenceAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
            NSString *ResidenceAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
            NSString *OfficeAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
            NSString *OfficeAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
            NSString *OfficeAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
            NSString *OfficeAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
            NSString *OfficeAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
            NSString *OfficeAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
            NSString *OfficeAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
            NSString *ProspectEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
            NSString *ProspectOccupationCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
            NSString *ExactDuties = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 21)];
            NSString *ProspectRemark = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 22)];
            
            //NSString *ProspectContactType = @"2";
            //NSString *ProspectContactNo = @"0128765462";
            
            // NSLog(@"%@", ProspectRemark);
            [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName 
                                                              AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                          AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3  
                                                       AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                                   AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry 
                                                             AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown 
                                                         AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                       AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark 
                                                     AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB AndExactDuties:ExactDuties ]];
        }
        sqlite3_finalize(statement);
        
    }
    sqlite3_close(contactDB);
}
    [self.tableView reloadData];
    
}

-(void) FinishEdit{
    isFiltered = FALSE;
    [self ReloadTableData];
    searchBar.text = @"";
    _EditProspect = Nil;
    
}

-(void) FinishInsert{
    isFiltered = FALSE;
    [self ReloadTableData];
    searchBar.text = @"";
    _ProspectViewController = nil;
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

@end
