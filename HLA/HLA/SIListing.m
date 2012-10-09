//
//  SIListing.m
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/2/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIListing.h"
#import "ColorHexCode.h"

@interface SIListing ()

@end

@implementation SIListing
@synthesize outletGender;
@synthesize outletEdit;
@synthesize lblSINO, DBDateTo, DBDateFrom,OrderBy;
@synthesize lblDateCreated;
@synthesize lblName;
@synthesize lblPlan;
@synthesize lblBasicSA;
@synthesize outletDateFrom;
@synthesize outletDelete;
@synthesize myTableView;
@synthesize outletDate;
@synthesize outletDone;
@synthesize btnSortBy;
@synthesize outletDateTo;
@synthesize txtSINO,CustomerCode;
@synthesize txtLAName, SINO,FilteredBasicSA,FilteredDateCreated,FilteredName;
@synthesize FilteredSINO,FilteredPlanName,FilteredSIStatus,SIStatus;
@synthesize BasicSA,Name,PlanName, DateCreated;
@synthesize SortBy = _SortBy;
@synthesize Popover = _Popover;
@synthesize SIDate = _SIDate;
@synthesize SIDatePopover = _SIDatePopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    outletDelete.hidden = TRUE;
    outletDate.hidden = true;
    outletDone.hidden = true;
    DBDateFrom = @"";
    DBDateTo = @"";
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,230, 200, 50);
    lblSINO.frame = frame;
    lblSINO.textAlignment = UITextAlignmentCenter;
    lblSINO.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblSINO.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame2=CGRectMake(200,230, 200, 50);
    lblDateCreated.frame = frame2;
    lblDateCreated.textAlignment = UITextAlignmentCenter;
        lblDateCreated.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblDateCreated.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame3=CGRectMake(400,230, 200, 50);
    lblName.frame = frame3;
    lblName.textAlignment = UITextAlignmentCenter;
    lblName.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblName.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame4=CGRectMake(600,230, 200, 50);
    lblPlan.frame = frame4;
    lblPlan.textAlignment = UITextAlignmentCenter;
    lblPlan.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblPlan.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    CGRect frame5=CGRectMake(800,230, 150, 50);
    lblBasicSA.frame = frame5;
    lblBasicSA.textAlignment = UITextAlignmentCenter;
    lblBasicSA.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    lblBasicSA.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];

    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *SIListingSQL = [NSString stringWithFormat:@"select A.Sino, A.datecreated, name, planname, basicSA, 'Not Created', A.CustCode "
                                  " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D "
                                  " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode "];
        const char *SelectSI = [SIListingSQL UTF8String];
        if(sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK) {
            
            SINO = [[NSMutableArray alloc] init ];
            DateCreated = [[NSMutableArray alloc] init ];
            Name = [[NSMutableArray alloc] init ];
            PlanName = [[NSMutableArray alloc] init ];
            BasicSA = [[NSMutableArray alloc] init ];
            SIStatus = [[NSMutableArray alloc] init ];
            CustomerCode = [[NSMutableArray alloc] init ];
            
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSString *SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                NSString *ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                NSString *ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                NSString *ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                NSString *ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                NSString *ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                
                [SINO addObject:SINumber];
                [DateCreated addObject:ItemDateCreated ];
                [Name addObject:ItemName ];
                [PlanName addObject:ItemPlanName ];
                [BasicSA addObject:ItemBasicSA ];
                [SIStatus addObject:ItemStatus];
                [CustomerCode addObject:ItemCustomerCode];
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    
    
    //    UITableView *tableView =  [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] style:UITableViewStylePlain];
    
    /*    UITableView *tableView =  [[UITableView alloc] initWithFrame:CGRectMake(100.0,100.0,300,500) style:UITableViewStyleGrouped ];
     
     tableView.delegate = self;
     tableView.dataSource = self;
     
     self.myTableView = tableView;
     
     //self.view = tableView;
     [self.view addSubview:tableView];
     */  
    myTableView.rowHeight = 50;
    myTableView.backgroundColor = [UIColor clearColor];
    myTableView.opaque = NO;
    myTableView.backgroundView = nil;
    
    [self.view addSubview:myTableView];

}

- (void)viewDidUnload
{
    [self setTxtSINO:nil];
    [self setTxtLAName:nil];
    [self setOutletDateFrom:nil];
    [self setOutletDateTo:nil];
    [self setBtnSortBy:nil];
    [self setOutletDelete:nil];
    [self setMyTableView:nil];
    [self setOutletDate:nil];
    [self setOutletDone:nil];
    [self setLblSINO:nil];
    [self setLblDateCreated:nil];
    [self setLblName:nil];
    [self setLblPlan:nil];
    [self setLblBasicSA:nil];
    [self setOutletDateFrom:nil];
    [self setOutletGender:nil];
    [self setOutletEdit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (interfaceOrientation==UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight)
        return YES;
    
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;   
}

- (NSInteger)tableView:(UITableView *)myTableView numberOfRowsInSection:(NSInteger)section {
    //return List.count;
    if (isFilter == false) {
        return SINO.count;
    }
    else {
        return FilteredSINO.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    /*
     cell.textLabel.text = [[List objectAtIndex:indexPath.row] stringByAppendingFormat:@"                 dsadsa"];
     cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
     */
    
    /*
     cell.detailTextLabel.numberOfLines = 0;
     cell.detailTextLabel.text = @"dasdsadsdadas\ndsadsadsa";
     cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
     */
    //cell.backgroundColor = [UIColor redColor];
    
    
    [[cell.contentView viewWithTag:1001] removeFromSuperview ];
    [[cell.contentView viewWithTag:1002] removeFromSuperview ];
    [[cell.contentView viewWithTag:1003] removeFromSuperview ];
    [[cell.contentView viewWithTag:1004] removeFromSuperview ];
    [[cell.contentView viewWithTag:1005] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    if (isFilter == false) {
        CGRect frame=CGRectMake(0,0, 200, 50);
        UILabel *label1=[[UILabel alloc]init];            
        label1.frame=frame;
        label1.text= [SINO objectAtIndex:indexPath.row];
        label1.tag = 1001;
        label1.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label1];
        
        //label1.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame2=CGRectMake(200,0, 200, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= [DateCreated objectAtIndex:indexPath.row];
        label2.textAlignment = UITextAlignmentCenter;    
        label2.tag = 1002;
        //label2.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        CGRect frame3=CGRectMake(400,0, 200, 50);
        UILabel *label3=[[UILabel alloc]init];            
        label3.frame=frame3;
        label3.text= [Name objectAtIndex:indexPath.row];
        label3.tag = 1003;
        label3.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label3];
        //label3.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame4=CGRectMake(600,0, 200, 50);
        UILabel *label4=[[UILabel alloc]init];
        label4.frame=frame4;
        label4.text= [PlanName objectAtIndex:indexPath.row];
        label4.textAlignment = UITextAlignmentCenter;    
        label4.tag = 1004;
        //label4.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label4];
        
        CGRect frame5=CGRectMake(800,0, 150, 50);
        UILabel *label5=[[UILabel alloc]init];            
        label5.frame=frame5;
        label5.text= [BasicSA objectAtIndex:indexPath.row];
        label5.tag = 1005;
        label5.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label5];
        //label5.backgroundColor = [UIColor lightGrayColor];
        
        /*
         CGRect frame6=CGRectMake(850,0, 150, 50);
         UILabel *label6=[[UILabel alloc]init];
         label6.frame=frame6;
         label6.text= [SIStatus objectAtIndex:indexPath.row];
         label6.textAlignment = UITextAlignmentCenter;    
         label6.tag = 1006;
         //label6.backgroundColor = [UIColor grayColor];
         [cell.contentView addSubview:label6];
         */
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
    }
    else {
        CGRect frame=CGRectMake(0,0, 200, 50);
        UILabel *label1=[[UILabel alloc]init];            
        label1.frame=frame;
        label1.text= [FilteredSINO objectAtIndex:indexPath.row];
        //label1.tag = 1001;
        label1.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label1];
        label1.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame2=CGRectMake(200,0, 200, 50);
        UILabel *label2=[[UILabel alloc]init];
        label2.frame=frame2;
        label2.text= [FilteredDateCreated objectAtIndex:indexPath.row];
        label2.textAlignment = UITextAlignmentCenter;    
        //label2.tag = 1002;
        //label2.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label2];
        
        CGRect frame3=CGRectMake(400,0, 200, 50);
        UILabel *label3=[[UILabel alloc]init];            
        label3.frame=frame3;
        label3.text= [FilteredName objectAtIndex:indexPath.row];
        //label3.tag = 1003;
        label3.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label3];
        //label3.backgroundColor = [UIColor lightGrayColor];
        
        CGRect frame4=CGRectMake(600,0, 200, 50);
        UILabel *label4=[[UILabel alloc]init];
        label4.frame=frame4;
        label4.text= [FilteredPlanName objectAtIndex:indexPath.row];
        label4.textAlignment = UITextAlignmentCenter;    
        //label4.tag = 1004;
        //label4.backgroundColor = [UIColor grayColor];
        [cell.contentView addSubview:label4];
        
        CGRect frame5=CGRectMake(800,0, 150, 50);
        UILabel *label5=[[UILabel alloc]init];            
        label5.frame=frame5;
        label5.text= [FilteredBasicSA objectAtIndex:indexPath.row];
        //label5.tag = 1005;
        label5.textAlignment = UITextAlignmentCenter;
        [cell.contentView addSubview:label5];
        //label5.backgroundColor = [UIColor lightGrayColor];
        
        /*
         CGRect frame6=CGRectMake(850,0, 150, 50);
         UILabel *label6=[[UILabel alloc]init];
         label6.frame=frame6;
         label6.text= [FilteredSIStatus objectAtIndex:indexPath.row];
         label6.textAlignment = UITextAlignmentCenter;    
         label6.tag = 1006;
         //label6.backgroundColor = [UIColor grayColor];
         [cell.contentView addSubview:label6];
         */
        
    }
    //[cell setSelected:NO animated:NO];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   /*
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
    
    [selectionView setBackgroundColor:[UIColor clearColor]];
    
    cell.selectedBackgroundView = selectionView;
    */
    //    [myTableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells]) {
            
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        }
        else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
 
    }
    
        
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([myTableView isEditing] == TRUE ) {
        BOOL gotRowSelected = FALSE;
        
        for (UITableViewCell *zzz in [myTableView visibleCells]) {
            
            if (zzz.selected  == TRUE) {
                gotRowSelected = TRUE;
                break;
            }
            
        }
        
        if (!gotRowSelected) {
            [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
            outletDelete.enabled = FALSE;
        }
        else {
            [outletDelete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            outletDelete.enabled = TRUE;
        }
        
    }
}

- (IBAction)btnDateFrom:(id)sender {
    /*outletDate.hidden = false;
    outletDone.hidden = false;
    outletDate.tag = 1;
     */
    outletDate.tag = 1;
    if (_SIDate == Nil) {
        
        self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    

}
- (IBAction)btnDateTo:(id)sender {
    //outletDate.hidden = false;
    //outletDone.hidden = false;
    outletDate.tag = 2;
    if (_SIDate == Nil) {
        
        self.SIDate = [self.storyboard instantiateViewControllerWithIdentifier:@"SIDate"];
        _SIDate.delegate = self;
        self.SIDatePopover = [[UIPopoverController alloc] initWithContentViewController:_SIDate];
    }
    
    [self.SIDatePopover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}
- (IBAction)segOrderBy:(id)sender {
    if (outletGender.selectedSegmentIndex == 0) {
        OrderBy = @"ASC";
    }
    else {
        OrderBy = @"DESC";
    }
    
}

- (IBAction)btnSearch:(id)sender {
    
        
        //isFilter = true;
        
    
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsDir = [dirPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
        
        sqlite3_stmt *statement;
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
            NSString *SIListingSQL = [NSString stringWithFormat:@"select A.Sino, A.datecreated, name, planname, basicSA, 'Not Created', A.CustCode "
                                      " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D "
                                      " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode " ];        
            
            if (![txtSINO.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND A.Sino like \"%%%@%%\"", txtSINO.text ];
                
            }
            
            if (![txtLAName.text isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND name like \"%%%@%%\"", txtLAName.text ];
                
            }
            
            if ( ![DBDateFrom isEqualToString:@""]) {
                                
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAt > \"%@\" ", DBDateFrom ];
                
            }
            
            if ( ![DBDateTo isEqualToString:@""] ) {
                
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" AND createdAT < \"%@\" ", DBDateTo ];
                
            }
            
            NSString *Sorting = [[NSString alloc] init ];
            Sorting = @"";
            
            if (lblBasicSA.highlighted == TRUE) {
                Sorting = @"basicSA";
            }
            
            if (lblDateCreated.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"A.datecreated";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",A.datecreated"];
                    
                }
            }
            
            if (lblName.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"name";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",name"];
                    
                }
            }
            
            if (lblPlan.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"planname";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",planname"];
                    
                }
            }
            
            if (lblSINO.highlighted == TRUE) {
                if ([Sorting isEqualToString:@""]) {
                    Sorting = @"A.SINO";
                }
                else {
                    Sorting = [Sorting stringByAppendingFormat:@",A.SINO"];
                    
                }
            }
            
            if ([Sorting isEqualToString:@""]) {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@"", Sorting ];
                
            }
            else {
                SIListingSQL = [SIListingSQL stringByAppendingFormat:@" order by %@ %@ ", Sorting, OrderBy ];
            }
            
            NSLog(@"%@", SIListingSQL);
            
            const char *SelectSI = [SIListingSQL UTF8String];
            if(sqlite3_prepare_v2(contactDB, SelectSI, -1, &statement, NULL) == SQLITE_OK) {
                
                
                SINO = nil;
                DateCreated = nil;
                Name = nil;
                PlanName = nil;
                BasicSA = nil;
                SIStatus = nil;
                CustomerCode = nil;
                
                SINO = [[NSMutableArray alloc] init ];
                DateCreated = [[NSMutableArray alloc] init ];
                Name = [[NSMutableArray alloc] init ];
                PlanName = [[NSMutableArray alloc] init ];
                BasicSA = [[NSMutableArray alloc] init ];
                SIStatus = [[NSMutableArray alloc] init ];
                CustomerCode = [[NSMutableArray alloc] init ]; 
                
                /*
                 FilteredSINO = [[NSMutableArray alloc] init ];
                 FilteredDateCreated = [[NSMutableArray alloc] init ];
                 FilteredName = [[NSMutableArray alloc] init ];
                 FilteredPlanName = [[NSMutableArray alloc] init ];
                 FilteredBasicSA = [[NSMutableArray alloc] init ];
                 FilteredSIStatus = [[NSMutableArray alloc] init ];
                 */
                
                
                while (sqlite3_step(statement) == SQLITE_ROW){
                    NSString *SINumber = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                    NSString *ItemDateCreated = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *ItemName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *ItemPlanName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 3)];
                    NSString *ItemBasicSA = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 4)];
                    NSString *ItemStatus = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 5)];
                    NSString *ItemCustomerCode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 6)];
                    /*
                     [FilteredSINO addObject:SINumber];
                     [FilteredDateCreated addObject:ItemDateCreated ];
                     [FilteredName addObject:ItemName ];
                     [FilteredPlanName addObject:ItemPlanName ];
                     [FilteredBasicSA addObject:ItemBasicSA ];
                     [FilteredSIStatus addObject:ItemStatus];
                     */
                    [SINO addObject:SINumber];
                    [DateCreated addObject:ItemDateCreated ];
                    [Name addObject:ItemName ];
                    [PlanName addObject:ItemPlanName ];
                    [BasicSA addObject:ItemBasicSA ];
                    [SIStatus addObject:ItemStatus];
                    [CustomerCode addObject:ItemCustomerCode];
                }
                
                sqlite3_finalize(statement);
            }
            else {
                
                //NSLog(@"%@", SIListingSQL);
            }
            
            sqlite3_close(contactDB);
        }
        else {
            NSLog(@"cannot open DB");
        }
    
    [myTableView reloadData];
}

- (IBAction)btnEdit:(id)sender {
    if ([self.myTableView isEditing]) {
        [self.myTableView setEditing:NO animated:TRUE];
        outletDelete.hidden = true;
        [outletEdit setTitle:@"Edit" forState:UIControlStateNormal ];
    }
    else{
        [self.myTableView setEditing:YES animated:TRUE]; 
        outletDelete.hidden = FALSE;
        [outletDelete setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        [outletEdit setTitle:@"Cancel" forState:UIControlStateNormal ];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.tag == 1) {
        
        if (buttonIndex == 1) {
            NSArray *visibleCells = [myTableView visibleCells];
            NSMutableArray *ItemToBeDeleted = [[NSMutableArray alloc] init];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            
            for (UITableViewCell *cell in visibleCells) {
                //[myTableView beginUpdates];
                if (cell.selected) {
                    NSIndexPath *indexPath = [myTableView indexPathForCell:cell];
                    
                    NSString *zzz = [NSString stringWithFormat:@"%d", indexPath.row];
                    [ItemToBeDeleted addObject:zzz];
                    [indexPaths addObject:indexPath];
                }
                //[myTableView endUpdates];
            }
            
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
            
            sqlite3_stmt *statement;
            sqlite3_stmt *statement2;
            const char *dbpath = [databasePath UTF8String];
            
            if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
                for(int a=0; a<ItemToBeDeleted.count; a++){
                    int value = [[ItemToBeDeleted objectAtIndex:a] intValue];
                    value = value - a;
                    
                    NSString *DeleteLAPayorSQL = [NSString stringWithFormat:@"Delete from "
                                                  " trad_lapayor where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteLAPayorSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        
                        int zzz = sqlite3_step(statement);
                        if (zzz == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement);
                        
                    }
                    
                    NSString *DeleteCltProfileSQL = [NSString stringWithFormat:@"Delete from "
                                                     " clt_Profile where custcode = \"%@\" ", [CustomerCode objectAtIndex:value]];
                    
                    if(sqlite3_prepare_v2(contactDB, [DeleteCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                        int zzz = sqlite3_step(statement2);
                        if (zzz == SQLITE_DONE) {
                            
                        }
                        sqlite3_finalize(statement2);
                    }
                    
                    [SINO removeObjectAtIndex:value];
                    [DateCreated removeObjectAtIndex:value];
                    [Name removeObjectAtIndex:value];
                    [PlanName removeObjectAtIndex:value];
                    [BasicSA removeObjectAtIndex:value];
                    [SIStatus removeObjectAtIndex:value];
                    [CustomerCode removeObjectAtIndex:value];
                    
                }
                
                sqlite3_close(contactDB);
                
            }
            
            
            
            [myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            
            [self.myTableView reloadData]; 
        }
        
    }

}


- (IBAction)btnDelete:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle: NSLocalizedString(@"Delete SI",nil)
                          message: NSLocalizedString(@"Are you sure you want to delete these SI ?",nil)
                          delegate: self
                          cancelButtonTitle: NSLocalizedString(@"No",nil)
                          otherButtonTitles: NSLocalizedString(@"Yes",nil), nil];
    alert.tag = 1;
    [alert show];

    
}
- (IBAction)btnDone:(id)sender {
    outletDate.hidden = true;
    outletDone.hidden = true;
}

- (IBAction)ActionDate:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    
    NSString *pickerDate = [dateFormatter stringFromDate:[outletDate date]];
    
    NSString *msg = [NSString stringWithFormat:@"%@",pickerDate];
    if (outletDate.tag == 1) {
          [self.outletDateFrom setTitle:msg forState:UIControlStateNormal];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        DBDateFrom = [dateFormatter stringFromDate:[outletDate date]];
    }
    else {
          [self.outletDateTo setTitle:msg forState:UIControlStateNormal];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        DBDateTo = [dateFormatter stringFromDate:[outletDate date]];  
    }
  
}

- (void) SortBySelected:(NSMutableArray *)SortBySelected{
    
    //NSLog(@"%@", [SortBySelected objectAtIndex:0 ]);
    
    lblSINO.highlighted = false;
    lblDateCreated.highlighted= false;
    lblName.highlighted= false;
    lblPlan.highlighted = false;
    lblBasicSA.highlighted = false;
    
    if (SortBySelected.count > 0) {
        outletGender.enabled = true;
        
    }
    else {
        outletGender.enabled = false;
        outletGender.selected = false;
    }
    
    
    for (NSString *zzz in SortBySelected ) {
        if ([zzz isEqualToString:@"SI NO"]) {
            lblSINO.highlightedTextColor = [UIColor blueColor];
            lblSINO.highlighted = TRUE;
            
        }
        else if ([zzz isEqualToString:@"Plan Name"]) {
            lblPlan.highlightedTextColor = [UIColor blueColor];
            lblPlan.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Name"]) {
            lblName.highlightedTextColor = [UIColor blueColor];
            lblName.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Date Created"]) {
            lblDateCreated.highlightedTextColor = [UIColor blueColor];
            lblDateCreated.highlighted = TRUE;
            
        }
        
        else if ([zzz isEqualToString:@"Basic SA"]) {
            lblBasicSA.highlightedTextColor = [UIColor blueColor];
            lblBasicSA.highlighted = TRUE;
            
        }
    }
   
    
    
    
    
}
- (IBAction)btnSortBy:(id)sender {
    if (_SortBy == nil) {
        self.SortBy = [[siListingSortBy alloc] initWithStyle:UITableViewStylePlain];
        _SortBy.delegate = self;
        self.Popover = [[UIPopoverController alloc] initWithContentViewController:_SortBy];               
    }
    [self.Popover setPopoverContentSize:CGSizeMake(200, 300)];    
    [self.Popover presentPopoverFromRect:[sender frame ]  inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    

}

-(void)DateSelected:(NSString *)strDate:(NSString *)dbDate{
    if (outletDate.tag == 1) {
        [outletDateFrom setTitle:strDate forState:UIControlStateNormal];
        DBDateFrom = dbDate;
    }
    else {
        [outletDateTo setTitle:strDate forState:UIControlStateNormal];
        DBDateTo = dbDate;
    }
}

-(void)CloseWindow{
    [self.SIDatePopover dismissPopoverAnimated:YES];
}

@end
