//
//  eAppsListing.m
//  iMobile Planner
//
//  Created by shawal sapuan on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppsListing.h"
#import "ColorHexCode.h"

@interface eAppsListing ()

@end

@implementation eAppsListing
@synthesize SILabel,dateLabel,idTypeLabel,idNoLabel,nameLabel,planLabel;
@synthesize myTableView,dataItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    SILabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    SILabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    dateLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    dateLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    idTypeLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idTypeLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    idNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    nameLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    nameLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    planLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    planLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    dataItems = [[NSMutableArray alloc]initWithObjects:@"one",@"two",@"three", nil];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [dataItems objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"next!");
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [self setSILabel:nil];
    [self setDateLabel:nil];
    [self setIdTypeLabel:nil];
    [self setIdNoLabel:nil];
    [self setNameLabel:nil];
    [self setPlanLabel:nil];
    [self setMyTableView:nil];
    [super viewDidUnload];
}
@end
