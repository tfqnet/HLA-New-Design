//
//  PDSPagesController.m
//  iMobile Planner
//
//  Created by shawal sapuan on 4/24/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PagesController.h"

@interface PagesController ()

@end

@implementation PagesController
@synthesize pageDesc,htmlName;
@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    [self getPages];
}

-(void)getPages
{
    pageDesc = [[NSMutableArray alloc] init];
    htmlName = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT htmlName, PageNum, PageDesc FROM SI_Temp_Pages_PDS"];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                [htmlName addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]];
                [pageDesc addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]];
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
    return [pageDesc count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [pageDesc objectAtIndex:indexPath.row];
    
    /*
    if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}*/
    
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [_delegate getPages:[pageDesc objectAtIndex:selectedIndex]];
    [tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewDidUnload
{
    [self setDelegate:nil];
    [self setHtmlName:nil];
    [self setPageDesc:nil];
    [super viewDidUnload];
}

@end
