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
#import "IDTypeViewController.h"

@interface ProspectListing ()

@end

@implementation ProspectListing
@synthesize ProspectTableData, FilteredProspectTableData, isFiltered;
@synthesize EditProspect = _EditProspect;
@synthesize ProspectViewController = _ProspectViewController;
@synthesize idNoLabel,idTypeLabel,clientNameLabel,editBtn,deleteBtn,nametxt;
@synthesize IDTypePicker = _IDTypePicker;


- (void)viewDidLoad
{
    [super viewDidLoad];

	AppDelegate *appDel= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
	appDel.MhiMessage = Nil;
	appDel = Nil;
	
    [self.view endEditing:YES];
    [self resignFirstResponder];
    
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
//    searchBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"Client Profile Listing";
    self.navigationItem.titleView = label;
    
//    searchBar.delegate = (id)self;
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    NSString *ProspectID = @"";
    NSString *NickName = @"";
    NSString *ProspectName = @"";
    NSString *ProspectDOB = @"" ;
    NSString *ProspectGender = @"";
    NSString *ResidenceAddress1 = @"";
    NSString *ResidenceAddress2 = @"";
    NSString *ResidenceAddress3 = @"";
    NSString *ResidenceAddressTown = @"";
    NSString *ResidenceAddressState = @"";
    NSString *ResidenceAddressPostCode = @"";
    NSString *ResidenceAddressCountry = @"";
    NSString *OfficeAddress1 = @"";
    NSString *OfficeAddress2 = @"";
    NSString *OfficeAddress3 = @"";
    NSString *OfficeAddressTown = @"";
    NSString *OfficeAddressState = @"";
    NSString *OfficeAddressPostCode = @"";
    NSString *OfficeAddressCountry = @"";
    NSString *ProspectEmail = @"";
    NSString *ProspectOccupationCode = @"";
    NSString *ExactDuties = @"";
    NSString *ProspectRemark = @"";
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM prospect_profile order by ProspectName ASC"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            ProspectTableData = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                ProspectID = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
//                NickName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                const char *name = (const char*)sqlite3_column_text(statement, 1);
                NickName = name == NULL ? nil : [[NSString alloc] initWithUTF8String:name];
                
                ProspectName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                ProspectDOB = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                ProspectGender = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                ResidenceAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                ResidenceAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                ResidenceAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                ResidenceAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                ResidenceAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 9)];
                ResidenceAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 10)];
                ResidenceAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 11)];
                OfficeAddress1 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 12)];
                OfficeAddress2 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 13)];
                OfficeAddress3 = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 14)];
                OfficeAddressTown = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 15)];
                OfficeAddressState = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 16)];
                OfficeAddressPostCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 17)];
                OfficeAddressCountry = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 18)];
                ProspectEmail = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 19)];
                ProspectOccupationCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 20)];
                ExactDuties = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 21)];
                ProspectRemark = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 22)];
                
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
        query_stmt = Nil, query_stmt = Nil;
    }
    
    label = Nil, dirPaths = Nil, docsDir = Nil, dbpath = Nil, statement = Nil, statement = Nil;
    ProspectID = Nil;
    NickName = Nil;
    ProspectName = Nil ;
    ProspectDOB = Nil  ;
    ProspectGender = Nil;
    ResidenceAddress1 = Nil;
    ResidenceAddress2 = Nil;
    ResidenceAddress3 = Nil;
    ResidenceAddressTown = Nil;
    ResidenceAddressState = Nil;
    ResidenceAddressPostCode = Nil;
    ResidenceAddressCountry = Nil;
    OfficeAddress1 = Nil;
    OfficeAddress2 = Nil;
    OfficeAddress3 = Nil;
    OfficeAddressTown = Nil;
    OfficeAddressState = Nil;
    OfficeAddressPostCode = Nil;
    OfficeAddressCountry = Nil;
    ProspectEmail = Nil;
    ProspectOccupationCode = Nil;
    ExactDuties = Nil;
    ProspectRemark = Nil;
    
    self.myTableView.rowHeight = 50;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    deleteBtn.hidden = TRUE;
    deleteBtn.enabled = FALSE;
    ItemToBeDeleted = [[NSMutableArray alloc] init];
    indexPaths = [[NSMutableArray alloc] init];
    
    CGRect frame1=CGRectMake(0,233, 200, 50);
    idTypeLabel.frame = frame1;
    idTypeLabel.textAlignment = UITextAlignmentCenter;
    idTypeLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idTypeLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame2=CGRectMake(200,233, 200, 50);
    idNoLabel.frame = frame2;
    idNoLabel.textAlignment = UITextAlignmentCenter;
    idNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(400,233, 624, 50);
    clientNameLabel.frame = frame3;
    clientNameLabel.textAlignment = UITextAlignmentCenter;
    clientNameLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    clientNameLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CustomColor = Nil;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
        return YES;
    
    return NO;
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    int rowCount;
    if(self.isFiltered)
        rowCount = FilteredProspectTableData.count;
    else
        rowCount = ProspectTableData.count;
    return rowCount;*/
    return [ProspectTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    /*
    ProspectProfile* pp;
    if(isFiltered)
        pp = [FilteredProspectTableData objectAtIndex:indexPath.row];
    else
        
        pp = [ProspectTableData objectAtIndex:indexPath.row]; 
     
    cell.textLabel.text = pp.ProspectName;
    cell.detailTextLabel.text = pp.NickName;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
     */
    
    [[cell.contentView viewWithTag:2001] removeFromSuperview ];
    [[cell.contentView viewWithTag:2002] removeFromSuperview ];
    [[cell.contentView viewWithTag:2003] removeFromSuperview ];
    
    ProspectProfile *pp = [ProspectTableData objectAtIndex:indexPath.row];
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,0, 200, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= @"IC Number";
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(200,0, 200, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= @"8877665544";
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 2002;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(400,0, 600, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= pp.ProspectName;
    label3.textAlignment = UITextAlignmentCenter;
    label3.tag = 2003;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label3];
    
    if (indexPath.row % 2 == 0) {
        label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    else {
        label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
    pp = Nil;
}

/*
-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        FilteredProspectTableData = [[NSMutableArray alloc] init];
        
        ProspectProfile* pp;
        for (pp in ProspectTableData)
        {
            NSRange Fullname = [pp.ProspectName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange PreferredName = [pp.NickName rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange ResidenceAddressState = [pp.ResidenceAddressState rangeOfString:text options:NSCaseInsensitiveSearch];
            
            
            if (Fullname.location != NSNotFound || PreferredName.location != NSNotFound || ResidenceAddressState.location != NSNotFound) {
                [FilteredProspectTableData addObject:pp];
            }
        }
        pp = Nil;
    }
    
    [self.myTableView reloadData];
}*/


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [self.myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            deleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted addObject:zzz];
        [indexPaths addObject:indexPath];
    }
    else {
        [self showDetailsForIndexPath:indexPath];
    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [self.myTableView visibleCells])
        {
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
        }
        
        if (!gotRowSelected) {
            [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            deleteBtn.enabled = FALSE;
        }
        else {
            [deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            deleteBtn.enabled = TRUE;
        }
        
        NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
        [ItemToBeDeleted removeObject:zzz];
        [indexPaths removeObject:indexPath];
    }
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
//    [self.searchBar resignFirstResponder];
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
    _EditProspect.navigationItem.title = @"Edit Client Profile";
    _EditProspect.navigationItem.rightBarButtonItem = _EditProspect.outletDone;
    pp = Nil, zzz = Nil;

}


#pragma mark - action

- (IBAction)btnAddNew:(id)sender
{
    
    if (_ProspectViewController == Nil) {
        self.ProspectViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Prospect"];
        _ProspectViewController.delegate = self;
    }
    
    [self.navigationController pushViewController:_ProspectViewController animated:YES];
    _ProspectViewController.navigationItem.title = @"Add Client Profile";
//    _ProspectViewController.navigationItem.rightBarButtonItem = _ProspectViewController.outletDone;
    
}

-(void) ReloadTableData
{
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
            
//            NSString *NickName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
            const char *name = (const char*)sqlite3_column_text(statement, 1);
            NSString *NickName = name == NULL ? nil : [[NSString alloc] initWithUTF8String:name];
            
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
                
                ProspectID = Nil;
                NickName = Nil;
                ProspectName = Nil ;
                ProspectDOB = Nil  ;
                ProspectGender = Nil;
                ResidenceAddress1 = Nil;
                ResidenceAddress2 = Nil;
                ResidenceAddress3 = Nil;
                ResidenceAddressTown = Nil;
                ResidenceAddressState = Nil;
                ResidenceAddressPostCode = Nil;
                ResidenceAddressCountry = Nil;
                OfficeAddress1 = Nil;
                OfficeAddress2 = Nil;
                OfficeAddress3 = Nil;
                OfficeAddressTown = Nil;
                OfficeAddressState = Nil;
                OfficeAddressPostCode = Nil;
                OfficeAddressCountry = Nil;
                ProspectEmail = Nil;
                ProspectOccupationCode = Nil;
                ExactDuties = Nil;
                ProspectRemark = Nil;
            }
            sqlite3_finalize(statement);
        
        }
        sqlite3_close(contactDB);
        query_stmt = Nil, querySQL = Nil;
    }
    [self.myTableView reloadData];
    dirPaths = Nil;
    docsDir = Nil;
    dbpath = Nil;
    statement = Nil;
    
}

-(void) FinishEdit
{
    isFiltered = FALSE;
    [self ReloadTableData];
//    searchBar.text = @"";
    _EditProspect = Nil;
    
}

-(void) FinishInsert
{
    isFiltered = FALSE;
    [self ReloadTableData];
//    searchBar.text = @"";
    _ProspectViewController = nil;
}

- (IBAction)searchPressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    if(nametxt.text.length != 0)
    {
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM prospect_profile WHERE ProspectName like \"%%%@%%\" order by ProspectName ASC",nametxt.text];
            
            if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
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
                    
                    [ProspectTableData addObject:[[ProspectProfile alloc] initWithName:NickName AndProspectID:ProspectID AndProspectName:ProspectName
                                                                      AndProspecGender:ProspectGender AndResidenceAddress1:ResidenceAddress1
                                                                  AndResidenceAddress2:ResidenceAddress2 AndResidenceAddress3:ResidenceAddress3
                                                               AndResidenceAddressTown:ResidenceAddressTown AndResidenceAddressState:ResidenceAddressState
                                                           AndResidenceAddressPostCode:ResidenceAddressPostCode AndResidenceAddressCountry:ResidenceAddressCountry
                                                                     AndOfficeAddress1:OfficeAddress1 AndOfficeAddress2:OfficeAddress2 AndOfficeAddress3:OfficeAddress3 AndOfficeAddressTown:OfficeAddressTown
                                                                 AndOfficeAddressState:OfficeAddressState AndOfficeAddressPostCode:OfficeAddressPostCode
                                                               AndOfficeAddressCountry:OfficeAddressCountry AndProspectEmail:ProspectEmail AndProspectRemark:ProspectRemark
                                                             AndProspectOccupationCode:ProspectOccupationCode AndProspectDOB:ProspectDOB AndExactDuties:ExactDuties ]];
                    
                    ProspectID = Nil;
                    NickName = Nil;
                    ProspectName = Nil ;
                    ProspectDOB = Nil  ;
                    ProspectGender = Nil;
                    ResidenceAddress1 = Nil;
                    ResidenceAddress2 = Nil;
                    ResidenceAddress3 = Nil;
                    ResidenceAddressTown = Nil;
                    ResidenceAddressState = Nil;
                    ResidenceAddressPostCode = Nil;
                    ResidenceAddressCountry = Nil;
                    OfficeAddress1 = Nil;
                    OfficeAddress2 = Nil;
                    OfficeAddress3 = Nil;
                    OfficeAddressTown = Nil;
                    OfficeAddressState = Nil;
                    OfficeAddressPostCode = Nil;
                    OfficeAddressCountry = Nil;
                    ProspectEmail = Nil;
                    ProspectOccupationCode = Nil;
                    ExactDuties = Nil;
                    ProspectRemark = Nil;
                }
                sqlite3_finalize(statement);
                
            }
            sqlite3_close(contactDB);
            querySQL = Nil;
        }
        [self.myTableView reloadData];
        statement = Nil;
    }
}

- (IBAction)resetPressed:(id)sender
{
    nametxt.text = @"";
    [self ReloadTableData];
}

- (IBAction)editPressed:(id)sender
{
    [self resignFirstResponder];
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:TRUE];
        deleteBtn.hidden = true;
        deleteBtn.enabled = false;
        [editBtn setTitle:@"Delete" forState:UIControlStateNormal ];
        
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        indexPaths = [[NSMutableArray alloc] init];
    }
    else{
        [self.myTableView setEditing:YES animated:TRUE];
        deleteBtn.hidden = FALSE;
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [editBtn setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

- (IBAction)deletePressed:(id)sender
{
    NSString *clt;
    int RecCount = 0;
    for (UITableViewCell *cell in [self.myTableView visibleCells])
    {
        if (cell.selected == TRUE) {
            NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];
            if (RecCount == 0) {
                ProspectProfile *pp = [ProspectTableData objectAtIndex:selectedIndexPath.row];
                clt = pp.ProspectName;
            }
            
            RecCount = RecCount + 1;
            
            if (RecCount > 1) {
                break;
            }
        }
    }
    
    NSString *msg;
    if (RecCount == 1) {
        msg = [NSString stringWithFormat:@"Delete %@",clt];
    }
    else {
        msg = @"Are you sure want to delete these Client(s)?";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mobile Planner" message:msg delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert setTag:1001];
    [alert show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001 && buttonIndex == 0) //delete
    {
        NSLog(@"delete!");
        NSLog(@"itemToBeDeleted:%d", ItemToBeDeleted.count);
        
        if (ItemToBeDeleted.count < 1) {
            return;
        }
        else{
            NSLog(@"itemToBeDeleted:%d", ItemToBeDeleted.count);
        }
        
        NSArray *sorted = [[NSArray alloc] init ];
        sorted = [ItemToBeDeleted sortedArrayUsingComparator:^(id firstObject, id secondObject){
            return [((NSString *)firstObject) compare:((NSString *)secondObject) options:NSNumericSearch];
        }];
        
        sqlite3_stmt *statement;
        if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
        {
            for(int a=0; a<sorted.count; a++) {
                int value = [[sorted objectAtIndex:a] intValue];
                value = value - a;
                
                ProspectProfile *pp = [ProspectTableData objectAtIndex:value];
                NSString *DeleteSQL = [NSString stringWithFormat:@"Delete from prospect_profile where indexNo = \"%@\"", pp.ProspectID];
                NSLog(@"%@",DeleteSQL);
                
                const char *Delete_stmt = [DeleteSQL UTF8String];
                if(sqlite3_prepare_v2(contactDB, Delete_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                else {
                    
                    NSLog(@"Error in Delete Statement");
                }
                
                [ProspectTableData removeObjectAtIndex:value];
            }
            sqlite3_close(contactDB);
        }
        [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self ReloadTableData];
        
        ItemToBeDeleted = [[NSMutableArray alloc] init];
        indexPaths = [[NSMutableArray alloc] init];
        deleteBtn.enabled = FALSE;
        [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        
    }
}

- (IBAction)IdType:(id)sender
{
    //NSLog(@"aa");
    
    if (_IDTypePicker == nil) {
        //Create the ColorPickerViewController.
        _IDTypePicker = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        
        //Set this VC as the delegate.
        _IDTypePicker.delegate = self;
    }
    
    if (_IDTypePickerPopover == nil) {
        //NSLog(@"aa");
        //The color picker popover is not showing. Show it.
        _IDTypePickerPopover = [[UIPopoverController alloc] initWithContentViewController:_IDTypePicker];
        //[_IDTypePickerPopover presentPopoverFromRect:<#(CGRect)#> inView:<#(UIView *)#> permittedArrowDirections:<#(UIPopoverArrowDirection)#> animated:<#(BOOL)#>];
        
        
        [_IDTypePickerPopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        
        
        
        //[_IDTypePickerPopover presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
        //                             permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    } else {
        //The color picker popover is showing. Hide it.
        [_IDTypePickerPopover dismissPopoverAnimated:YES];
        _IDTypePickerPopover = nil;
    }
    
}

#pragma mark - memory management

- (void)viewDidUnload
{
    [self setIDType:nil];
    [self setMyTableView:nil];
    [self setIdTypeLabel:nil];
    [self setIdNoLabel:nil];
    [self setClientNameLabel:nil];
    [self setEditBtn:nil];
    [self setDeleteBtn:nil];
    [self setNametxt:nil];
    [self setIDType:nil];
    [super viewDidUnload];
    FilteredProspectTableData = Nil;
    ProspectTableData = Nil;
}

-(void)Clear
{
	ProspectTableData = Nil;
	FilteredProspectTableData = Nil;
	databasePath = Nil;
}

-(void)selectedIDType:(NSString *)selectedIDType
{
    //NSLog(@"%@",selectedIDType);
    [_IDType setTitle:selectedIDType forState:UIControlStateNormal];
    
    if (_IDTypePickerPopover) {
        [_IDTypePickerPopover dismissPopoverAnimated:YES];
        _IDTypePickerPopover = nil;
    }
}



@end
