//
//  PDSViewController.m
//  HLA Ipad
//
//  Created by infoconnect on 1/7/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "PDSViewController.h"
#import "DBController.h"
#import "DataTable.h"

@interface PDSViewController ()

@end

@implementation PDSViewController
@synthesize dataTable = _dataTable;
@synthesize db = _db;
@synthesize SINo;

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
	// Do any additional setup after loading the view.
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"hladb.sqlite"]];
    
    
    NSString *siNo = @"";
    NSString *databaseName = @"hladb.sqlite";
    NSString *databaseName1 = @"0000000000000001.db";
    NSString *masterName = @"Databases.db";
    int pageNum = 0;
    int riderCount = 0;
    NSString *desc = @"Page";
    int DBID;
    
    [self deleteTemp]; //clear all temp data
    [self InsertToSI_Temp_Trad];
    [self InsertToSI_Temp_Trad_LA];
    
    self.db = [DBController sharedDatabaseController:databaseName];
    NSString *sqlStmt = [NSString stringWithFormat:@"SELECT SiNo FROM SI_Temp_Trad"];
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    NSArray* row = [_dataTable.rows objectAtIndex:0];
    //siNo = [row objectAtIndex:0];
    siNo = SINo;
    
    /*
    sqlStmt = [NSString stringWithFormat:@"DELETE FROM SI_Temp_Pages_PDS"];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error Deleting data");
    }
     */
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('ENG_PDS1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('ENG_PDS2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    riderCount = 0; //reset rider count
    int descRiderCountStart = 10; //start of rider description page
    int riderInPageCount = 0; //number of rider in a page, maximum 3
    NSString *riderInPage = @""; //rider in a page, write to db
    NSString *headerTitle = @"tblHeader;";
    NSString *curRider = @"";
    NSString *prevRider = @"";
    
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode "
                                "NOT IN ('C+', 'HB', 'HMM', 'HSP_II', 'MG_II', 'MG_IV','CPA','PA') ORDER BY RiderCode ASC ",siNo];
    //NSLog(@"%@",sqlStmt);
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    for (row in _dataTable.rows) //income rider
    {
        riderCount++;
        curRider = [row objectAtIndex:0];
        
        //NSLog(@"%@",curRider);
        
        if ([curRider isEqualToString:@"CCTR"] || [curRider isEqualToString:@"ETPD"] || [curRider isEqualToString:@"HB"]
            || [curRider isEqualToString:@"HMM"] || [curRider isEqualToString:@"HSP_II"] || [curRider isEqualToString:@"MG_II"]
            || [curRider isEqualToString:@"MG_IV"] || [curRider isEqualToString:@"PA"] || [curRider isEqualToString:@"PR"] ||
            [curRider isEqualToString:@"SP_STD"] || [curRider isEqualToString:@"PTR"]){
            riderInPageCount++;
            prevRider = curRider;
            
            if(riderCount == 1){
                //riderInPage = [headerTitle stringByAppendingString:riderInPage];
            }
            
            riderInPage = [riderInPage stringByAppendingString:curRider];
            riderInPage = [riderInPage stringByAppendingString:@";"];
            if (riderInPageCount == 3){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                //if(riderCount == 1)
                //  riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 1 && riderCount == _dataTable.rows.count){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            
            if (riderInPageCount == 2 && riderCount == _dataTable.rows.count) {
                pageNum++;
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
        }
        else{
            if (riderInPageCount == 2){
                //NSLog(@"%@",riderInPage);
                pageNum++;
                if(riderCount == 1)
                    riderInPage = [headerTitle stringByAppendingString:riderInPage];
                descRiderCountStart++;
                sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
                DBID = [_db ExecuteINSERT:sqlStmt];
                if (DBID <= 0){
                    NSLog(@"Error inserting data into database.");
                }
                //NSLog(@"%@",sqlStmt);
                riderInPageCount = 0;
                riderInPage = @"";
            }
            if ([prevRider isEqualToString:@"CCTR"] || [prevRider isEqualToString:@"ETPD"] || [prevRider isEqualToString:@"HB"] || [prevRider isEqualToString:@"HMM"] || [prevRider isEqualToString:@"HSP_II"] || [prevRider isEqualToString:@"MG_II"] || [prevRider isEqualToString:@"MG_IV"] || [prevRider isEqualToString:@"PA"] || [prevRider isEqualToString:@"PR"] || [prevRider isEqualToString:@"SP_STD"] || [prevRider isEqualToString:@"PTR"]){
                prevRider = [prevRider stringByAppendingString:@";"];
                curRider = [prevRider stringByAppendingString:curRider];
                riderInPageCount = 0;
                riderInPage = @"";
            }
            //NSLog(@"%@",curRider);
            pageNum++;
            if(riderCount == 1)
                curRider = [headerTitle stringByAppendingString:curRider];
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",curRider,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
        }
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('ENG_PDS4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    riderCount = 0; //reset rider count
    descRiderCountStart = 20; //start of rider description page
    riderInPageCount = 0; //number of rider in a page, maximum 3
    riderInPage = @""; //rider in a page, write to db
    headerTitle = @"tblHeader;";
    
    sqlStmt = [NSString stringWithFormat:@"SELECT RiderCode FROM Trad_Rider_Details Where SINo = '%@' AND "
               "RiderCode NOT IN ('C+','MG_II','MG_IV','HB','HSP_II','CPA','PA','HMM','CIR') ORDER BY RiderCode ASC ",siNo];
    
    //NSLog(@"%@",sqlStmt);
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    for (row in _dataTable.rows) //income rider
    {
        riderCount++;
        curRider = [row objectAtIndex:0];
        
        //NSLog(@"%@",curRider);
        
        riderInPageCount++;
        prevRider = curRider;
        
        if(riderCount == 1){
            //riderInPage = [headerTitle stringByAppendingString:riderInPage];
        }
        
        riderInPage = [riderInPage stringByAppendingString:curRider];
        riderInPage = [riderInPage stringByAppendingString:@";"];
        if (riderInPageCount == 3){
            //NSLog(@"%@",riderInPage);
            pageNum++;
            //if(riderCount == 1)
            //  riderInPage = [headerTitle stringByAppendingString:riderInPage];
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
            riderInPageCount = 0;
            riderInPage = @"";
        }
        
        if (riderInPageCount == 1 && riderCount == _dataTable.rows.count){
            //NSLog(@"%@",riderInPage);
            pageNum++;
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
            riderInPageCount = 0;
            riderInPage = @"";
        }
        
        if (riderInPageCount == 2 && riderCount == _dataTable.rows.count) {
            pageNum++;
            descRiderCountStart++;
            sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(riders,htmlName, PageNum, PageDesc) VALUES ('%@','ENG_PDS%d.html',%d,'%@')",riderInPage,descRiderCountStart,pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
            DBID = [_db ExecuteINSERT:sqlStmt];
            if (DBID <= 0){
                NSLog(@"Error inserting data into database.");
            }
            //NSLog(@"%@",sqlStmt);
            riderInPageCount = 0;
            riderInPage = @"";
        }
        
    }
    
    pageNum++;
    sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('ENG_PDS6.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
    DBID = [_db ExecuteINSERT:sqlStmt];
    if (DBID <= 0){
        NSLog(@"Error inserting data into database.");
    }
    
    // for C+ only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"C+\"  ",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) { //got C+
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_C_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_C_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_C_3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
    }
    // C+ end
    
    // for HMM only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"HMM\"  ",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HMM_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HMM_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HMM_3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HMM_4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
    }
    
    // for HSP_II only
    
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"HSP_II\"  ",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HS_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HS_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HS_3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_HS_4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
    }
    
    //for MG_IV only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"MG_IV\"  ",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG4_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG4_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG4_3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG4_4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
    }
    
    // for MG_II only
    sqlStmt = [NSString stringWithFormat:@"SELECT * FROM Trad_Rider_Details Where SINo = '%@' AND RiderCode = \"MG_II\"  ",siNo];
    
    _dataTable = [_db  ExecuteQuery:sqlStmt];
    
    if (_dataTable.rows.count > 0) {
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG2_1.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG2_2.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG2_3.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
        
        pageNum++;
        sqlStmt = [NSString stringWithFormat:@"INSERT INTO SI_Temp_Pages_PDS(htmlName, PageNum, PageDesc) VALUES ('PDS_ENG_MG2_4.html',%d,'%@')",pageNum,[desc stringByAppendingString:[NSString stringWithFormat:@"%d",pageNum]]];
        DBID = [_db ExecuteINSERT:sqlStmt];
        if (DBID <= 0){
            NSLog(@"Error inserting data into database.");
        }
    }
    // pds END---
    
    NSString* library = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString* documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *WebSQLSubdir;
    NSString *WebSQLPath;
    NSString *WebSQLDb;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (IsAtLeastiOSVersion(@"6.0")){
        /*
         WebSQLSubdir = @"WebKit/LocalStorage";
         WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
         WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
         */
        NSString *viewerPlist = [library stringByAppendingPathComponent:@"viewer.plist"];
        BOOL plistExist = [fileManager fileExistsAtPath:viewerPlist];
        if (!plistExist){
            NSLog(@"not exist!");
            NSString *viewerPlistFromDoc = [documents stringByAppendingPathComponent:@"viewer.plist"];
            [fileManager copyItemAtPath:viewerPlistFromDoc toPath:viewerPlist error:nil];
            
            databaseName = @"hladb.sqlite";//actual
            databaseName1 = @"hladb.sqlite";//dummy
            WebSQLSubdir = @"Caches";
            WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
            WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
            
            
            
        }
        else{
            NSLog(@"exist!");
            
            databaseName = @"hladb.sqlite";//actual
            databaseName1 = @"hladb.sqlite";//dummy
            WebSQLSubdir = @"WebKit/LocalStorage";
            WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
            WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
            
            
        }
        
    }
    else{
        /*
         WebSQLSubdir = (IsAtLeastiOSVersion(@"5.1")) ? @"Caches" : @"WebKit/Databases";
         WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
         WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
         */
        databaseName = @"hladb.sqlite";//actual
        databaseName1 = @"hladb.sqlite";//dummy
        WebSQLSubdir = (IsAtLeastiOSVersion(@"5.1")) ? @"Caches" : @"WebKit/Databases";
        WebSQLPath = [library stringByAppendingPathComponent:WebSQLSubdir];
        WebSQLDb = [WebSQLPath stringByAppendingPathComponent:@"file__0"];
    }
    
    NSString *masterFile = [WebSQLPath stringByAppendingPathComponent:masterName];
    NSString *databaseFile = [WebSQLDb stringByAppendingPathComponent:databaseName1];
    
    [fileManager removeItemAtPath:databaseFile error:nil];
    [fileManager removeItemAtPath:masterFile error:nil];
    
    //NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    NSString *masterPathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:masterName];
    
    
    NSString *databasePathFromDoc = [docsDir stringByAppendingPathComponent:databaseName];
    //NSString *masterPathFromDoc = [docsDir stringByAppendingPathComponent:masterName];
    
    [fileManager createDirectoryAtPath:WebSQLDb withIntermediateDirectories:YES attributes:nil error:NULL];
    [fileManager copyItemAtPath:databasePathFromDoc toPath:databaseFile error:nil];
    [fileManager copyItemAtPath:masterPathFromApp toPath:masterFile error:nil];
    fileManager = Nil;
    
    
}

-(void)deleteTemp{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        QuerySQL = @"Delete from SI_Temp_Pages_PDS";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_Temp_trad";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        QuerySQL = @"Delete from SI_Temp_trad_LA";
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    
}

-(void)InsertToSI_Temp_Trad{
    sqlite3_stmt *statement;
    NSString *QuerySQL;
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        
        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad (\"SINo\") VALUES (\"%@\") ", SINo];
        
        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

-(void)InsertToSI_Temp_Trad_LA{
    sqlite3_stmt *statement;
    sqlite3_stmt *statement2;
    sqlite3_stmt *statement3;
    NSString *getCustomerCodeSQL;
    NSString *getFromCltProfileSQL;
    NSString *CustCode;
    NSString *QuerySQL;
    int Age;
    
    NSLog(@"insert to SI Temp Trad LA --- start");
    
    if (sqlite3_open([databasePath UTF8String], &contactDB) == SQLITE_OK){
        getCustomerCodeSQL = [ NSString stringWithFormat:@"select CustCode from Trad_LaPayor where sino = \"%@\" AND sequence = %d ", SINo, 1];
        
        if(sqlite3_prepare_v2(contactDB, [getCustomerCodeSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                CustCode  = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
                
                getFromCltProfileSQL  = [NSString stringWithFormat:@"Select Name, Smoker, sex, ALB from clt_profile where custcode  = \"%@\"",  CustCode];
                
                if(sqlite3_prepare_v2(contactDB, [getFromCltProfileSQL UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                    
                    if (sqlite3_step(statement2) == SQLITE_ROW) {
                        
                        Age = sqlite3_column_int(statement2, 3);
                        
                        QuerySQL  = [ NSString stringWithFormat:@"Insert INTO SI_Temp_Trad_LA (\"SINo\", \"Age\") "
                                     " VALUES (\"%@\",\"%d\")", SINo,  Age];
                        
                        if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement3, NULL) == SQLITE_OK) {
                            if (sqlite3_step(statement3) == SQLITE_DONE) {
                                
                            }
                            sqlite3_finalize(statement3);
                        }
                    }
                    sqlite3_finalize(statement2);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(contactDB);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
