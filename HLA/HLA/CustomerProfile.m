//
//  CustomerProfile.m
//  iMobile Planner
//
//  Created by shawal sapuan on 5/10/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "CustomerProfile.h"
#import "ColorHexCode.h"

@interface CustomerProfile ()

@end

@implementation CustomerProfile
@synthesize idNoLabel,idTypeLabel,nameLabel,statusLabel,lastUpdateLabel,txtName,txtIdNo,txtIdType,myTableView;
@synthesize clientData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    
    CGRect frame=CGRectMake(0,239, 204, 50);
    idTypeLabel.frame = frame;
    idTypeLabel.textAlignment = UITextAlignmentCenter;
    idTypeLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idTypeLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];

    CGRect frame2=CGRectMake(204,239, 200, 50);
    idNoLabel.frame = frame2;
    idNoLabel.textAlignment = UITextAlignmentCenter;
    idNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	
    CGRect frame3=CGRectMake(404,239, 212, 50);
    nameLabel.frame = frame3;
    nameLabel.textAlignment = UITextAlignmentLeft;
    nameLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    nameLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(616,239, 167, 50);
    lastUpdateLabel.frame = frame4;
    lastUpdateLabel.textAlignment = UITextAlignmentCenter;
    lastUpdateLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lastUpdateLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(783,239, 173, 50);
    statusLabel.frame = frame5;
    statusLabel.textAlignment = UITextAlignmentCenter;
    statusLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    statusLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    clientData = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrIdType = [[NSMutableArray alloc] initWithObjects:@"New Identification Number",@"New Identification Number", nil];
    [clientData addObject:arrIdType];
    
    NSMutableArray *arrIdNo = [[NSMutableArray alloc] initWithObjects:@"99911",@"888770", nil];
    [clientData addObject:arrIdNo];
    
    NSMutableArray *arrName = [[NSMutableArray alloc] initWithObjects:@"Johny",@"Adam", nil];
    [clientData addObject:arrName];
    
    NSMutableArray *arrDate = [[NSMutableArray alloc]initWithObjects:@"22/05/2013",@"30/05/2013", nil];
    [clientData addObject:arrDate];
    
    NSMutableArray *arrStatus = [[NSMutableArray alloc]initWithObjects:@"Incomplete",@"Completed", nil];
    [clientData addObject:arrStatus];
    
    CustomColor = nil, arrIdType=nil, arrIdNo=nil, arrName=nil, arrDate=nil, arrStatus=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - action

- (IBAction)doSearch:(id)sender
{
    
}

- (IBAction)doReset:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[clientData objectAtIndex:0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    [[cell.contentView viewWithTag:2001] removeFromSuperview ];
    [[cell.contentView viewWithTag:2002] removeFromSuperview ];
    [[cell.contentView viewWithTag:2003] removeFromSuperview ];
    [[cell.contentView viewWithTag:2004] removeFromSuperview ];
    [[cell.contentView viewWithTag:2005] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,0, 204, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [[clientData objectAtIndex:0]objectAtIndex:indexPath.row];
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(204,0, 200, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= [[clientData objectAtIndex:1]objectAtIndex:indexPath.row];
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 2002;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(404,0, 212, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= [[clientData objectAtIndex:2]objectAtIndex:indexPath.row];
    label3.textAlignment = UITextAlignmentLeft;
    label3.tag = 2003;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label3];
    
    CGRect frame4=CGRectMake(616,0, 167, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= [[clientData objectAtIndex:3]objectAtIndex:indexPath.row];
    label4.textAlignment = UITextAlignmentCenter;
    label4.tag = 2004;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label4];
    
    CGRect frame5=CGRectMake(783,0, 173, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [[clientData objectAtIndex:4]objectAtIndex:indexPath.row];
    label5.textAlignment = UITextAlignmentCenter;
    label5.tag = 2005;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label5];
    
    if (indexPath.row % 2 == 0) {
        label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    else {
        label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    
    return cell;
}


#pragma mark - memory

- (void)viewDidUnload
{
    [self setIdTypeLabel:nil];
    [self setIdNoLabel:nil];
    [self setNameLabel:nil];
    [self setLastUpdateLabel:nil];
    [self setStatusLabel:nil];
    [self setMyTableView:nil];
    [self setTxtIdType:nil];
    [self setTxtIdNo:nil];
    [self setTxtName:nil];
    [self setClientData:nil];
    [super viewDidUnload];
}

@end
