//
//  SIUtilities.m
//  iMobile Planner
//
//  Created by shawal sapuan on 5/13/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUtilities.h"

static sqlite3 *contactDB = nil;

@implementation SIUtilities


+(BOOL)makeDBCopy:(NSString *)path
{
    BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	
    success = [fileManager fileExistsAtPath:path];
    if (success) return YES;
    
    if (!success) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hladb.sqlite"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:path error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            return NO;
        }
        
        defaultDBPath = Nil;
    }
    
	fileManager = Nil;
    error = Nil;
    return YES;
}


+(BOOL)createNewTable :(NSString *)table dbpath:(NSString *)path
{
    sqlite3_stmt *createStmt;
    if (sqlite3_open([path UTF8String] , &contactDB) == SQLITE_OK) {
        
        NSString *query=[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, ADDRESS TEXT, PHONE TEXT)",table];
        
        if (sqlite3_prepare_v2(contactDB, [query UTF8String], -1, &createStmt, NULL) != SQLITE_OK) {
            return NO;
        }
        sqlite3_exec(contactDB, [query UTF8String], NULL, NULL, NULL);
        return YES;
        sqlite3_close(contactDB);
    }
    return YES;
}


+(BOOL)addColumnTable:(NSString *)table column:(NSString *)columnName type:(NSString *)columnType dbpath:(NSString *)path
{
    sqlite3_stmt *statement;
    if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@",table,columnName,columnType];
        
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            return NO;
        }
        
        sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, NULL);
        return YES;
        sqlite3_close(contactDB);
    }
    return YES;
}


+(BOOL)updateTable:(NSString *)table set:(NSString *)column value:(NSString *)val where:(NSString *)param equal:(NSString *)val2 dbpath:(NSString *)path
{
    sqlite3_stmt *statement;
    if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"UPDATE %@ SET %@= \"%@\" WHERE %@=\"%@\"",table,column,val,param,val2];
        if (sqlite3_prepare_v2(contactDB, [querySQL UTF8String], -1, &statement, NULL) != SQLITE_OK) {
            return NO;
        }
        
        sqlite3_exec(contactDB, [querySQL UTF8String], NULL, NULL, NULL);
        return YES;
        sqlite3_close(contactDB);
    }
    return YES;
}


@end
