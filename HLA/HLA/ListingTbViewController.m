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
@synthesize selectedItem,nameList,SINoList;
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
    nameList = [[NSMutableArray alloc] init];
    SINoList = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT a.SINo, b.Name, b.DateCreated FROM Trad_LAPayor a LEFT JOIN Clt_Profile b ON a.CustCode=b.CustCode WHERE a.PTypeCode=\"LA\" AND a.Sequence=1"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [SINoList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [nameList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]];
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
    return [SINoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [nameList objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"SINo: %@",[SINoList objectAtIndex:indexPath.row]];
    
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
    [_delegate listing:self didSelectItem:self.selectedItem];
    
    [tableView reloadData];
}

-(NSString *)selectedItem
{
    return [SINoList objectAtIndex:selectedIndex];
}

#pragma mark - Memory Management
- (void)viewDidUnload
{
    [self setDelegate:nil];
    [self setNameList:nil];
    [self setSINoList:nil];
    [super viewDidUnload];
}

@end
