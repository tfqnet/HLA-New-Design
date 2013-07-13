//
//  eSubmission.m
//  iMobile Planner
//
//  Created by shawal sapuan on 5/9/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eSubmission.h"
#import "ColorHexCode.h"

@interface eSubmission ()

@end

@implementation eSubmission
@synthesize idNoLabel,idTypeLabel,nameLabel,policyNoLabel,statusLabel,myTableView,btnDate;
@synthesize clientData,dateLabel,btnIDType,btnStatus;
@synthesize eAppsVC = _eAppsVC;
@synthesize statusPopover = _statusPopover;
@synthesize statusVC = _statusVC;
@synthesize IDTypePopover = _IDTypePopover;
@synthesize IDTypeVC = _IDTypeVC;
@synthesize eAppMenu = _eAppMenu;

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg10.jpg"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    self.navigationController.navigationBar.tintColor = [CustomColor colorWithHexString:@"A9BCF5"];
    
    CGRect frame = CGRectMake(0, 0, 400, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"TreBuchet MS" size:20];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [CustomColor colorWithHexString:@"234A7D"];
    label.text = @"e-Application Listing";
    self.navigationItem.titleView = label;
    
    idTypeLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idTypeLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    idNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
	
    policyNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    policyNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    nameLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    nameLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    dateLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    dateLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    statusLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    statusLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    clientData = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrIdType = [[NSMutableArray alloc] initWithObjects:@"New Identification Number",@"New Identification Number", nil];
    [clientData addObject:arrIdType];
    
    NSMutableArray *arrIdNo = [[NSMutableArray alloc] initWithObjects:@"880101117865",@"890101234575", nil];
    [clientData addObject:arrIdNo];
    
    NSMutableArray *arrPolicy = [[NSMutableArray alloc]initWithObjects:@"SI20130523-0001",@"SI20130530-0007", nil];
    [clientData addObject:arrPolicy];
    
    NSMutableArray *arrName = [[NSMutableArray alloc] initWithObjects:@"Johny",@"Adam", nil];
    [clientData addObject:arrName];
    
    NSMutableArray *arrDate = [[NSMutableArray alloc] initWithObjects:@"2013-07-10",@"2013-07-11", nil];
    [clientData addObject:arrDate];
    
    NSMutableArray *arrStatus = [[NSMutableArray alloc]initWithObjects:@"Created",@"Submitted", nil];
    [clientData addObject:arrStatus];
    
    CustomColor = nil, arrIdType=nil, arrIdNo=nil, arrName=nil, arrPolicy=nil, arrStatus=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - action

- (IBAction)btnDatePressed:(id)sender
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    
    Class UIKeyboardImpl = NSClassFromString(@"UIKeyboardImpl");
    id activeInstance = [UIKeyboardImpl performSelector:@selector(activeInstance)];
    [activeInstance performSelector:@selector(dismissKeyboard)];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    [btnDate setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", dateString] forState:UIControlStateNormal];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil];
    
    if (_SIDate == Nil) {
        
        self.SIDate = [mainStoryboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover setPopoverContentSize:CGSizeMake(300.0f, 255.0f)];
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
    
    dateFormatter = Nil;
    dateString = Nil, mainStoryboard = nil;
}

- (IBAction)addNew:(id)sender
{
    UIStoryboard *nextStoryboard = [UIStoryboard storyboardWithName:@"LynnStoryboard" bundle:Nil];
    self.eAppMenu = [nextStoryboard instantiateViewControllerWithIdentifier:@"eAppMenuScreen"];
    self.eAppMenu.modalPresentationStyle = UIModalPresentationFullScreen;
    self.eAppMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:self.eAppMenu animated:NO];
//    [self.navigationController pushViewController:self.eAppMenu animated:YES];
    
    nextStoryboard = nil;
}

- (IBAction)ActionIDType:(id)sender
{
    if (_IDTypeVC == nil) {
        
        self.IDTypeVC = [[IDTypeViewController alloc] initWithStyle:UITableViewStylePlain];
        _IDTypeVC.delegate = self;
        self.IDTypePopover = [[UIPopoverController alloc] initWithContentViewController:_IDTypeVC];
    }
    
    [self.IDTypePopover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)ActionStatus:(id)sender
{
    if (_statusVC == Nil) {
        
        self.statusVC = [[eAppStatusList alloc] initWithStyle:UITableViewStylePlain];
        _statusVC.delegate = self;
        self.statusPopover = [[UIPopoverController alloc] initWithContentViewController:_statusVC];
    }
    
    [self.statusPopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}


#pragma mark - delegate

-(void)DateSelected:(NSString *)strDate :(NSString *)dbDate
{
    btnDate.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnDate setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", strDate] forState:UIControlStateNormal];
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *d = [NSDate date];
    NSDate* d2 = [df dateFromString:dbDate];
    
    if ([d compare:d2] == NSOrderedAscending) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Entered date cannot be greater than today." delegate:Nil cancelButtonTitle:@"OK" otherButtonTitles:Nil, nil];
        [alert show];
        [btnDate setTitle:@"" forState:UIControlStateNormal ];
        alert = Nil;
    }
    
    df = Nil, d = Nil, d2 = Nil;
}

-(void)CloseWindow
{
    [self resignFirstResponder];
    [self.view endEditing:YES];
    [_SIDatePopover dismissPopoverAnimated:YES];
}

-(void)selectedStatus:(NSString *)theStatus
{
    btnStatus.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnStatus setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", theStatus] forState:UIControlStateNormal];
    [self.statusPopover dismissPopoverAnimated:YES];
}

-(void)selectedIDType:(NSString *)selectedIDType
{
    btnIDType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnIDType setTitle:[[NSString stringWithFormat:@" "] stringByAppendingFormat:@"%@", selectedIDType] forState:UIControlStateNormal];
    [self.IDTypePopover dismissPopoverAnimated:YES];
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
    [[cell.contentView viewWithTag:2006] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,0, 204, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [[clientData objectAtIndex:0]objectAtIndex:indexPath.row];
    label1.textAlignment = UITextAlignmentCenter;
    label1.tag = 2001;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(204,0, 119, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= [[clientData objectAtIndex:1]objectAtIndex:indexPath.row];
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 2002;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label2];
    
    CGRect frame3=CGRectMake(323,0, 137, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= [[clientData objectAtIndex:2]objectAtIndex:indexPath.row];
    label3.textAlignment = UITextAlignmentCenter;
    label3.tag = 2003;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label3];
    
    CGRect frame4=CGRectMake(460,0, 206, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= [[clientData objectAtIndex:3]objectAtIndex:indexPath.row];
    label4.textAlignment = UITextAlignmentLeft;
    label4.tag = 2004;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label4];
    
    CGRect frame5=CGRectMake(666,0, 157, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text= [[clientData objectAtIndex:4]objectAtIndex:indexPath.row];
    label5.textAlignment = UITextAlignmentCenter;
    label5.tag = 2005;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label5];
    
    CGRect frame6=CGRectMake(823,0, 133, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    label6.text= [[clientData objectAtIndex:5]objectAtIndex:indexPath.row];
    label6.textAlignment = UITextAlignmentCenter;
    label6.tag = 2006;
    cell.textLabel.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    [cell.contentView addSubview:label6];
    
    if (indexPath.row % 2 == 0) {
        label1.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        label6.backgroundColor = [CustomColor colorWithHexString:@"D0D8E8"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    else {
        label1.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label2.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label3.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label4.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label5.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        label6.backgroundColor = [CustomColor colorWithHexString:@"E9EDF4"];
        
        label1.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label2.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label3.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label4.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label5.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
        label6.font = [UIFont fontWithName:@"TreBuchet MS" size:16];
    }
    
    return cell;
}

- (void)viewDidUnload
{
    [self setIdTypeLabel:nil];
    [self setIdNoLabel:nil];
    [self setPolicyNoLabel:nil];
    [self setNameLabel:nil];
    [self setStatusLabel:nil];
    [self setMyTableView:nil];
    [self setBtnDate:nil];
    [self setDateLabel:nil];
    [self setBtnIDType:nil];
    [self setBtnStatus:nil];
    [super viewDidUnload];
}
@end
