//
//  eAppsListing.m
//  iMobile Planner
//
//  Created by shawal sapuan on 6/18/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "eAppsListing.h"
#import "ColorHexCode.h"
#import "MainScreen.h"
#import "AppDelegate.h"

@interface eAppsListing ()

@end

@implementation eAppsListing
@synthesize SILabel,dateLabel,idTypeLabel,idNoLabel,nameLabel,planLabel;
@synthesize myTableView,SINO,DateCreated,Name,PlanName,BasicSA,SIStatus,CustomerCode;

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorColor = [UIColor clearColor];
    
    SILabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    SILabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    dateLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    dateLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    idTypeLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idTypeLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    idNoLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    idNoLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    idNoLabel.text = @"Identification\n Number";
    idNoLabel.numberOfLines = 2;
    idNoLabel.textAlignment = UITextAlignmentCenter;
    
    nameLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    nameLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    planLabel.textColor = [CustomColor colorWithHexString:@"FFFFFF"];
    planLabel.backgroundColor = [CustomColor colorWithHexString:@"4F81BD"];
    
    [self LoadAllResult];
}

- (void)LoadAllResult
{
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK){
        NSString *SIListingSQL = [NSString stringWithFormat:@"select A.Sino, createdAT, name, planname, basicSA, 'Not Created', A.CustCode "
                                  " from trad_lapayor as A, trad_details as B, clt_profile as C, trad_sys_profile as D "
                                  " where A.sino = B.sino and A.CustCode = C.custcode and B.plancode = D.plancode AND A.Sequence = 1 AND A.ptypeCode = \"LA\" "];
        
        if(sqlite3_prepare_v2(contactDB, [SIListingSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
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
                
                SINumber = Nil;
                ItemDateCreated = Nil;
                ItemName = Nil;
                ItemPlanName = Nil;
                ItemBasicSA = Nil;
                ItemStatus = Nil;
                ItemCustomerCode = Nil;
            }
            
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
        
        SIListingSQL = Nil;
        
    }
    statement = Nil;
    dbpath = Nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [SINO count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    
    [[cell.contentView viewWithTag:1001] removeFromSuperview ];
    [[cell.contentView viewWithTag:1002] removeFromSuperview ];
    [[cell.contentView viewWithTag:1003] removeFromSuperview ];
    [[cell.contentView viewWithTag:1004] removeFromSuperview ];
    [[cell.contentView viewWithTag:1005] removeFromSuperview ];
    [[cell.contentView viewWithTag:1006] removeFromSuperview ];
    
    ColorHexCode *CustomColor = [[ColorHexCode alloc]init ];
    
    CGRect frame=CGRectMake(0,0, 137, 50);
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=frame;
    label1.text= [SINO objectAtIndex:indexPath.row];
    label1.tag = 1001;
    label1.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label1];
    
    CGRect frame2=CGRectMake(137,0, 163, 50);
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=frame2;
    label2.text= [DateCreated objectAtIndex:indexPath.row];
    label2.textAlignment = UITextAlignmentCenter;
    label2.tag = 1002;
    [cell.contentView addSubview:label2];
        
    CGRect frame3=CGRectMake(300,0, 195, 50);
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=frame3;
    label3.text= @"New Identification Number";
    label3.tag = 1003;
    label3.textAlignment = UITextAlignmentCenter;
    [cell.contentView addSubview:label3];
        
    CGRect frame4=CGRectMake(495,0, 135, 50);
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=frame4;
    label4.text= @"880101117753";
    label4.textAlignment = UITextAlignmentCenter;
    label4.tag = 1004;
    [cell.contentView addSubview:label4];
        
    CGRect frame5=CGRectMake(630,0, 190, 50);
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=frame5;
    label5.text = [Name objectAtIndex:indexPath.row];
    label5.tag = 1005;
    label5.textAlignment = UITextAlignmentLeft;
    [cell.contentView addSubview:label5];
        
    CGRect frame6=CGRectMake(820,0, 195, 50);
    UILabel *label6=[[UILabel alloc]init];
    label6.frame=frame6;
    label6.text= [PlanName objectAtIndex:indexPath.row];
    label6.textAlignment = UITextAlignmentLeft;
    label6.tag = 1006;
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
    CustomColor = Nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate *MenuOption= (AppDelegate*)[[UIApplication sharedApplication] delegate ];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:Nil];
    MainScreen *main = [mainStoryboard instantiateViewControllerWithIdentifier:@"Main"];
    main.tradOrEver = @"TRAD";
    main.IndexTab = MenuOption.NewSIIndex ;
    main.requestSINo = [SINO objectAtIndex:indexPath.row];
    main.EAPPorSI = @"eAPP";
    
    [self presentViewController:main animated:NO completion:nil];
    
    MenuOption = Nil, mainStoryboard = Nil, main = Nil;
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
