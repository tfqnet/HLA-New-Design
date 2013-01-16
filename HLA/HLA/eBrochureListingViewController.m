//
//  eBrochureListingViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/16/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eBrochureListingViewController.h"
#import "eBrochureViewController.h"

@interface eBrochureListingViewController ()

@end

@implementation eBrochureListingViewController
@synthesize arrNameFile,arrTitle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrTitle = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:
                                                      @"MedGlobalIVP",
                                                      @"PACare",
                                                      @"PremierLife",
                                                      @"HLAIncomeBuilder_Mand",
                                                      @"HSPII",
                                                      @"MajorMedi",
                                                      @"MajorMediPlus",
                                                      @"MedGlobalII_Chi",
                                                      @"MedGlobalII",
                                                      @"CSecure(Standalone)",
                                                      @"HLAIncomeBuilder_BM", nil]];
    
    arrNameFile = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:
                                                         @"Brochure_MedGlobalIVP",
                                                         @"Brochure_PACare",
                                                         @"Brochure_PremierLife",
                                                         @"Brochure_HLAIncomeBuilder_Mand",
                                                         @"Brochure_HSPII",
                                                         @"Brochure_MajorMedi",
                                                         @"Brochure_MajorMediPlus",
                                                         @"Brochure_MedGlobalII_Chi",
                                                         @"Brochure_MedGlobalII",
                                                         @"Brochure_CSecure(Standalone)",
                                                         @"Brochure_HLAIncomeBuilder_BM", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrNameFile.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [arrTitle objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [arrNameFile objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    eBrochureViewController *Brochure = [self.storyboard instantiateViewControllerWithIdentifier:@"eBrochure"];
    Brochure.fileName = [arrNameFile objectAtIndex:indexPath.row];
    Brochure.title = [arrTitle objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:Brochure animated:YES];
}

- (IBAction)btnClose:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
@end

