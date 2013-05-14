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


+(BOOL)createTableCFF:(NSString *)path
{
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_CA_Recommendation (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, Seq TEXT, PTypeCode TEXT, InsuredName TEXT, PlanType TEXT, Term TEXT, Premium TEXT, Frequency TEXT, SumAssured TEXT, BoughtOption TEXT, AddNew TEXT)"];
    [database executeUpdate:query];
    
    
    NSString *query2 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_CA_Recommendation_Rider (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, Seq TEXT, RiderName TEXT);"];
    [database executeUpdate:query2];
    
    
    NSString *query3 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Education (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, NoChild TEXT, NoExistingPlan TEXT, CurrentAmt_Child_1 TEXT, RequiredAmt_Child_1 TEXT, SurplusShortFallAmt_Child_1 TEXT, CurrentAmt_Child_2 TEXT, RequiredAmt_Child_2 TEXT, SurplusShortFallAmt_Child_2 TEXT, CurrentAmt_Child_3 TEXT, RequiredAmt_Child_3 TEXT, SurplusShortFallAmt_Child_3 TEXT, CurrentAmt_Child_4 TEXT, RequiredAmt_Child_4 TEXT, SurplusShortFallAmt_Child_4 TEXT, AllocateIncome_1 TEXT)"];
    [database executeUpdate:query3];
    
    
    NSString *query4 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Education_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, SeqNo TEXT, Name TEXT, CompanyName TEXT, Premium TEXT, Frequency TEXT, StartDate TEXT, MaturityDate TEXT, ProjectedValueAtMaturity TEXT)"];
    [database executeUpdate:query4];
    
    
    NSString *query5 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Family_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, AddFromCFF TEXT, CompleteFlag TEXT, SameAsPO TEXT, PTypeCode TEXT, Name TEXT, Relationship TEXT, DOB TEXT, Age TEXT, Sex TEXT, YearsToSupport TEXT)"];
    [database executeUpdate:query5];
    
    
    NSString *query6 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Master (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, IntermediaryStatus TEXT, BrokerName TEXT, ClientChoice TEXT, RiskReturnProfile TEXT, NeedsQ1_Ans1 TEXT, NeedsQ1_Ans2 TEXT, NeedsQ1_Priority TEXT, NeedsQ2_Ans1 TEXT, NeedsQ2_Ans2 TEXT, NeedsQ2_Priority TEXT, NeedsQ3_Ans1 TEXT, NeedsQ3_Ans2 TEXT, NeedsQ3_Priority TEXT, NeedsQ4_Ans1 TEXT, NeedsQ4_Ans2 TEXT, NeedsQ4_Priority TEXT, NeedsQ5_Ans1 TEXT, NeedsQ5_Ans2 TEXT, NeedsQ5_Priority TEXT, IntermediaryCode TEXT, IntermediaryName TEXT, IntermediaryNRIC TEXT, IntermediaryContractDate TEXT, IntermediaryAddress1 TEXT, IntermediaryAddress2 TEXT, IntermediaryAddress3 TEXT, IntermediaryAddress4 TEXT, IntermediaryManagerName TEXT, ClientAck TEXT, ClientComments TEXT, CreatedAt TEXT, LastUpdatedAt TEXT)"];
    [database executeUpdate:query6];
    
    
    NSString *query7 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Personal_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, AddFromCFF TEXT, CompleteFlag TEXT, PTypeCode TEXT, PYFlag TEXT, AddNewPayor TEXT, SameAsPO TEXT, Title TEXT, Name, NewICNo TEXT, OtherIDType TEXT, OtherID TEXT, Nationality TEXT, Race TEXT, Religion TEXT, Sex TEXT, Smoker TEXT, DOB TEXT, Age TEXT, MaritalStatus TEXT, OccupationCode TEXT, MailingForeignAddressFlag TEXT, MailingAddressSameAsPO TEXT, MailingAddress1 TEXT, MailingAddress2 TEXT, MailingAddress3 TEXT, MailingTown TEXT, MailingState TEXT, MailingPostCode TEXT, MailingCountry TEXT, PermanentForeignAddressFlag TEXT, PermanentAddressSameAsPO TEXT, PermanentAddress1 TEXT, PermanentAddress2 TEXT, PermanentAddress3 TEXT, PermanentTown TEXT, PermanentState TEXT, PermanentPostCode TEXT, PermanentCountry TEXT, ResidencePhoneNo TEXT, OfficePhoneNo TEXT, MobilePhoneNo TEXT, FaxPhoneNo TEXT, EmailAddress TEXT)"];
    [database executeUpdate:query7];
    
    
    NSString *query8 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Protection (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, NoExistingPlan TEXT, AllocateIncome_1 TEXT, AllocateIncome_2 TEXT, TotalSA_CurrentAmt TEXT, TotalSA_RequiredAmt TEXT, TotalSA_SurplusShortFall TEXT, TotalCISA_CurrentAmt TEXT, TotalCISA_RequiredAmt TEXT, TotalCISA_SurplusShortFall TEXT, TotalHB_CurrentAmt TEXT, TotalHB_RequiredAmt TEXT, TotalHB_SurplusShortFall TEXT, TotalPA_CurrentAmt TEXT, TotalPA_RequiredAmt TEXT, TotalPA_SurplusShortFall TEXT)"];
    [database executeUpdate:query8];
    
    
    NSString *query9 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_RecordOfAdvice (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, SameAsQuotation TEXT, Priority TEXT, PlanType TEXT, Term TEXT, InsurerName TEXT, PTypeCode TEXT, InsuredName TEXT, SumAssured TEXT, ReasonRecommend TEXT, ActionRemark TEXT)"];
    [database executeUpdate:query9];
    
    
    NSString *query10 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Protection_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, AddFromCFF TEXT, CompleteFlag TEXT, PTypeCode TEXT, PYFlag TEXT, AddNewPayor TEXT, SameAsPO TEXT, Title TEXT, Name TEXT, NewICNo TEXT, OtherIDType TEXT, OtherID TEXT, Nationality TEXT, Race TEXT, Religion TEXT, Sex TEXT, Smoker TEXT, DOB TEXT, Age TEXT, MaritalStatus TEXT, OccupationCode TEXT, MailingForeignAddressFlag TEXT, MailingAddressSameAsPO TEXT, MailingAddress1 TEXT, MailingAddress2 TEXT, MailingAddress3 TEXT, MailingTown TEXT, MailingState TEXT, MailingPostCode TEXT, MailingCountry TEXT, PermanentForeignAddressFlag TEXT, PermanentAddressSameAsPO TEXT, PermanentAddress1 TEXT, PermanentAddress2 TEXT, PermanentAddress3 TEXT, PermanentTown TEXT, PermanentState TEXT, PermanentPostCode TEXT, PermanentCountry TEXT, ResidencePhoneNo TEXT, OfficePhoneNo TEXT, MobilePhoneNo TEXT, FaxPhoneNo TEXT, EmailAddress TEXT)"];
    [database executeUpdate:query10];
    
    
    NSString *query11 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_RecordOfAdvice_Rider (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, Priority TEXT, RiderName TEXT, Seq TEXT)"];
    [database executeUpdate:query11];
    
    
    NSString *query12 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Retirement (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, NoExistingPlan TEXT, AllocateIncome_1 TEXT, AllocateIncome_2 TEXT, CurrentAmt TEXT, RequiredAmt TEXT, SurplusShortFallAmt TEXT, OtherIncome_1 TEXT, OtherIncome_2 TEXT)"];
    [database executeUpdate:query12];
    
    
    NSString *query13 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_Retirement_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, SeqNo TEXT, POName TEXT, CompanyName TEXT, PlanType TEXT, Premium TEXT, Frequency TEXT, StartDate TEXT, MaturityDate TEXT, ProjectedLumSum TEXT, ProjectedAnnualIncome TEXT, AdditionalBenefits TEXT)"];
    [database executeUpdate:query13];
    
    
    NSString *query14 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_SavingsInvest (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, NoExistingPlan TEXT, CurrentAmt TEXT, RequiredAmt TEXT, SurplusShortFallAmt TEXT, AllocateIncome_1 TEXT)"];
    [database executeUpdate:query14];
    
    
    NSString *query15 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_SavingsInvest_Details (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, SeqNo TEXT, POName TEXT, CompanyName TEXT, PlanType TEXT, Purpose TEXT, Premium TEXT, CommDate TEXT, MaturityAmt TEXT)"];
    [database executeUpdate:query15];
    
    
    NSString *query16 = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS CFF_CA (ID INTEGER PRIMARY KEY AUTOINCREMENT, eProposalNo TEXT, Choice1 TEXT, Choice2 TEXT, Choice3 TEXT, Choice4 TEXT, Choice5 TEXT, Choice6 TEXT, Choices6Desc TEXT)"];
    [database executeUpdate:query16];
    
    [database close];
    return YES;
}


@end
