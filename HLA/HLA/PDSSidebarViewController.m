//
//  PDSSidebarViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PDSSidebarViewController.h"
#import "DataTable.h"
#import "pages.h"

@interface PDSSidebarViewController ()

@end

@implementation PDSSidebarViewController
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
        const char *sql ="Select PageNum, PageDesc, htmlName from SI_Temp_Pages_PDS";
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
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate PDSlastSelectedIndexPathForSidebarViewController:self];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (self.sidebarDelegate) {
        
        pages *pg = [_dataArray objectAtIndex:indexPath.row];
        //cell.textLabel.text = pg.PageDesc;
        
        NSObject *object = [NSString stringWithFormat:@"%@", pg.PageDesc];
        NSObject *objectHTML = [NSString stringWithFormat:@"%@", pg.htmlName];
        [self.sidebarDelegate PDSsidebarViewController:self didSelectObject:object objectHTML:objectHTML atIndexPath:indexPath];
        
        
        
        
        
    }
}

@end

