//
//  ReportViewController.h
//  HLA Ipad
//
//  Created by Md. Nazmus Saadat on 10/18/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface ReportViewController : UIViewController
{
    NSString *databasePath;
    sqlite3 *contactDB;
}
@end
