//
//  PlanList.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/16/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PlanList.h"

@interface PlanList ()

@end

@implementation PlanList
@synthesize ListOfPlan,ListOfCode,selectedCode,selectedDesc, TradOrEver;
@synthesize delegate;

-(id)init {
    self = [super init];
    if (self != nil) {
        /*
        ListOfPlan = [[NSMutableArray alloc] initWithObjects:@"HLA Income Builder", @"HLA Cash Promise", nil ];
        ListOfCode = [[NSMutableArray alloc] initWithObjects:@"HLAIB", @"HLACP", nil ];
		 
		ListOfPlan = [[NSMutableArray alloc] initWithObjects:@"HLA Cash Promise", nil ];
        ListOfCode = [[NSMutableArray alloc] initWithObjects:@"HLACP", nil ];
		 */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	if([TradOrEver isEqualToString:@"TRAD"]){
		ListOfPlan = [[NSMutableArray alloc] initWithObjects:@"HLA Cash Promise", nil ];
		ListOfCode = [[NSMutableArray alloc] initWithObjects:@"HLACP", nil ];
	}
	else{
		ListOfPlan = [[NSMutableArray alloc] initWithObjects:@"HLA EverLife", nil ];
		ListOfCode = [[NSMutableArray alloc] initWithObjects:@"HLAEL", nil ];
	}
    NSLog(@"viewPlan!");
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
    return [ListOfPlan count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	cell.textLabel.text = [ListOfPlan objectAtIndex:indexPath.row];
    
	if (indexPath.row == selectedIndex) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16 ];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndex = indexPath.row;
    [delegate Planlisting:self didSelectCode:self.selectedCode andDesc:self.selectedDesc];
    
    [tableView reloadData];
}

-(NSString *)selectedCode
{
    return [ListOfCode objectAtIndex:selectedIndex];
}

-(NSString *)selectedDesc
{
    return [ListOfPlan objectAtIndex:selectedIndex];
}

- (void)viewDidUnload
{
    [self setDelegate:nil];
    [super viewDidUnload];
}

@end
