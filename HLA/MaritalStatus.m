//
//  MaritalStatus.m
//  iMobile Planner
//
//  Created by Administrator on 9/3/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "MaritalStatus.h"


NSString *SelectedString;
@interface MaritalStatus ()



@end

@implementation MaritalStatus


@synthesize items = _items;
@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        NSString *file = [[NSBundle mainBundle] pathForResource:@"MaritalStatus" ofType:@"plist"];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:file];
        _items = [dict objectForKey:@"MaritalStatus"];
        
        self.clearsSelectionOnViewWillAppear = NO;
        
        NSInteger rowsCount = [_items count];
        NSInteger singleRowHeight = [self.tableView.delegate tableView:self.tableView
                                               heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        NSInteger totalRowsHeight = rowsCount * singleRowHeight;
        
        
        CGFloat largestLabelWidth = 0;
        for (NSString *Title in _items) {
            CGSize labelSize = [Title sizeWithFont:[UIFont boldSystemFontOfSize:20.0f]];
            if (labelSize.width > largestLabelWidth) {
                largestLabelWidth = labelSize.width;
            }
        }
        
        CGFloat popoverWidth = largestLabelWidth + 100;
        
        self.contentSizeForViewInPopover = CGSizeMake(popoverWidth, totalRowsHeight);
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

   
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
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *ms = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = ms;
    
    
    if (ms == SelectedString) {
        cell.accessoryType= UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *theMS = [_items objectAtIndex:indexPath.row];
    SelectedString = theMS;
    
    [_delegate selectedMaritalStatus:theMS];
    
    [tableView reloadData];

}

@end
