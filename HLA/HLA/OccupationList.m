//
//  OccupationList.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/1/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "OccupationList.h"

NSString *SelectedString;
@interface OccupationList ()

@end

@implementation OccupationList
@synthesize OccupCode = _OccupCode;
@synthesize OccupDesc = _OccupDesc;
@synthesize isFiltered;
@synthesize FilteredData, FilteredCode;
@synthesize lastIndexPath;
@synthesize delegate = _delegate;

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
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(500.0, 400.0);
    self.OccupDesc = [NSMutableArray array];
    self.OccupCode = [NSMutableArray array];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *querySQL = [NSString stringWithFormat:@"SELECT OccpCode, OccpDesc FROM Adm_Occp where status = 1"];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *OccpCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *OccpDesc = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                
                [_OccupDesc addObject:OccpDesc];
                [_OccupCode addObject:OccpCode];
            }
        }
        
    }
    
    UISearchBar *zzz = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 200, 50) ];
    
    zzz.opaque = false;
    zzz.delegate = (id) self;
    self.tableView.tableHeaderView = zzz;
    CGRect searchbarFrame = zzz.frame;
    [self.tableView scrollRectToVisible:searchbarFrame animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (isFiltered == false) {
        return  [_OccupDesc count ];
    } 
    else {
        return [FilteredData count ];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (isFiltered == false) {
        NSString *OccuDesc = [_OccupDesc objectAtIndex:indexPath.row];
        cell.textLabel.text = OccuDesc;
        
        if (OccuDesc == SelectedString) {
            cell.accessoryType= UITableViewCellAccessoryCheckmark;
        } 
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else {
        
        cell.textLabel.text = [FilteredData objectAtIndex:indexPath.row];
        
        if ([FilteredData objectAtIndex:indexPath.row] == SelectedString) {
            cell.accessoryType= UITableViewCellAccessoryCheckmark;
        } 
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        
    }    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    return cell;

}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text{ 
    if (text.length == 0) {
        isFiltered = false;
        
    }
    else {
        isFiltered = true;
        FilteredData = [[NSMutableArray alloc] init ];
        FilteredCode = [[NSMutableArray alloc] init ];
        
        for (int a =0; a<_OccupDesc.count; a++ ) {
            NSRange Occu = [[_OccupDesc objectAtIndex:a ] rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if (Occu.location != NSNotFound) {
                [FilteredData addObject:[_OccupDesc objectAtIndex:a ] ];
                [FilteredCode addObject:[_OccupCode objectAtIndex:a]];
            }
        }
    }
    
    [self.tableView reloadData];
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (_delegate != nil) {
        
        if (isFiltered == false) {
            [self resignFirstResponder];
            [self.view endEditing:TRUE];
            
            NSString *OccuDesc = [_OccupDesc objectAtIndex:indexPath.row];
            [_delegate OccupDescSelected:OccuDesc];
            
            NSString *occupCode = [_OccupCode objectAtIndex:indexPath.row];
            [_delegate OccupCodeSelected:occupCode];
            
            //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            
            /*
             NSArray *visibleCells = [tableView visibleCells];
             for (UITableViewCell *cell in visibleCells) {
             //   [cell setAccessoryType:UITableViewCellAccessoryNone];
             }
             */    
            
            SelectedString = [_OccupDesc objectAtIndex:indexPath.row ];
            //cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } 
        else {
            [self resignFirstResponder];
            [self.view endEditing:TRUE];
            
            NSString *OccuDesc = [FilteredData objectAtIndex:indexPath.row];
            [_delegate OccupDescSelected:OccuDesc];
            
            NSString *occupCode = [FilteredCode objectAtIndex:indexPath.row];
            [_delegate OccupCodeSelected:occupCode];
            SelectedString = [FilteredData objectAtIndex:indexPath.row];
            
        }
        
        
    }
    
    [tableView reloadData];
}

@end
