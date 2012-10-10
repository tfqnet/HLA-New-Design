//
//  ListingTbViewController.m
//  HLA
//
//  Created by shawal sapuan on 8/7/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "ListingTbViewController.h"

@interface ListingTbViewController ()

@end

@implementation ListingTbViewController
@synthesize NameList,indexNo,DOBList,GenderList,OccpCodeList;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self getListing];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - handle db
-(void)getListing
{
    indexNo = [[NSMutableArray alloc] init];
    NameList = [[NSMutableArray alloc] init];
    DOBList = [[NSMutableArray alloc] init];
    GenderList = [[NSMutableArray alloc] init];
    OccpCodeList = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
//        [NSString stringWithFormat:@"SELECT a.SINo, b.Name, b.DateCreated FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.PTypeCode=\"LA\" AND a.Sequence=1"];
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT IndexNo, ProspectName, ProspectDOB, ProspectGender, ProspectOccupationCode FROM prospect_profile"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int index = sqlite3_column_int(statement, 0);
                [indexNo addObject:[[NSString alloc] initWithFormat:@"%d",index]];
                [NameList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
                [DOBList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
                [GenderList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]];
                [OccpCodeList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [indexNo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [NameList objectAtIndex:indexPath.row];
    
	if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [_delegate listing:self didSelectIndex:[indexNo objectAtIndex:selectedIndex] andName:[NameList objectAtIndex:selectedIndex] andDOB:[DOBList objectAtIndex:selectedIndex] andGender:[GenderList objectAtIndex:selectedIndex] andOccpCode:[OccpCodeList objectAtIndex:selectedIndex]];
    
    [tableView reloadData];
}


#pragma mark - Memory Management
- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setNameList:nil];
    [self setDOBList:nil];
    [self setGenderList:nil];
    [self setOccpCodeList:nil];
    [super viewDidUnload];
}

@end
