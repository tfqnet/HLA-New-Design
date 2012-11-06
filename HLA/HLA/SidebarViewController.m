//
//  LeftSidebarViewController.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SidebarViewController.h"
#import "DataTable.h"
#import "pages.h"

@implementation SidebarViewController
@synthesize sidebarDelegate, dataTable, db;
@synthesize dataArray = _dataArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *databaseName = @"hladb.sqlite";
    //self.db = [DBController sharedDatabaseController:databaseName];
    
    
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *databasePathFromDoc = [documents stringByAppendingPathComponent:databaseName];
    //NSLog(@"%@",databasePathFromDoc);
    
    sqlite3 *db2;
    _dataArray=[[NSMutableArray alloc]init];
    if(sqlite3_open([databasePathFromDoc UTF8String], &db2) == SQLITE_OK){
        //char *errMsg;
        const char *sql ="Select PageNum, PageDesc, htmlName from SI_Temp_Pages";
        sqlite3_stmt *sqlStmt;
        if(sqlite3_prepare_v2(db2, sql, -1, &sqlStmt, NULL) == SQLITE_OK){
            while (sqlite3_step(sqlStmt)==SQLITE_ROW) {
                NSString *pageNum = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStmt, 0)];
                NSString *pageDesc = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStmt, 1)];
                NSString *htmlName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(sqlStmt, 2)];
                pages *pg = [[pages alloc] initPages:pageNum withPageDesc:pageDesc withHTMLName:htmlName];
                [_dataArray addObject:pg];
            }
        }
        sqlite3_finalize(sqlStmt);
    }
    sqlite3_close(db2);
    
    //pages *a = [_dataArray objectAtIndex:0];
    //NSLog(@"%@", a.htmlName);
    
    //NSLog(@"%d",_dataArray.count);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    //NSString *databaseName = @"0000000000000001.sqlite";
    //NSString *masterName = @"Databases.db";
    
    //self.db = [DBController sharedDatabaseController:databaseName];
    //self.db = [DBController sharedDatabaseController:@"Database.sql"];
    //NSString *sqlStmt = [NSString stringWithFormat:@"SELECT * from SI_temp_Pages"];
    //self.dataTable = [_db  ExecuteQuery:sqlStmt];

    //self.db = [DBController s]

    //NSString *docsDir;
    //NSArray *dirPaths;
    
    //dirPaths = NSSearchPathForDirectoriesInDomains(
    //                                               NSDocumentDirectory, NSUserDomainMask, YES);
    
    //docsDir = [dirPaths objectAtIndex:0];
    
    
    //NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *databasePathFromDoc = [documents stringByAppendingPathComponent:databaseName];
    //NSLog(@"%@",databasePathFromDoc);
    
    // Build the path to the database file
    //databasePath = [[NSString alloc]
    //                initWithString: [docsDir stringByAppendingPathComponent:
    //                                 @"contacts.db"]];
    
    
  
    //sqlite3 *db;
    //_dataArray=[[NSMutableArray alloc]init];
    //if(sqlite3_open([databasePath UTF8String], &db) == SQLITE_OK){
    //}

    
    
    
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    pages *pg = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = pg.PageDesc;
    return cell;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return self.title;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sidebarDelegate) {
        
        pages *pg = [_dataArray objectAtIndex:indexPath.row];
        //cell.textLabel.text = pg.PageDesc;
        
        NSObject *object = [NSString stringWithFormat:@"%@", pg.PageDesc];
        NSObject *objectHTML = [NSString stringWithFormat:@"%@", pg.htmlName];
        [self.sidebarDelegate sidebarViewController:self didSelectObject:object objectHTML:objectHTML atIndexPath:indexPath];
        
        
        
        
    }
}

@end
