//
//  SIUtilities.m
//  iMobile Planner
//
//  Created by shawal sapuan on 5/13/13.
//  Copyright (c) 2013 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIUtilities.h"
#import "DataTable.h"


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

+(BOOL)UPDATETrad_Sys_Medical_Comb:(NSString *)path
{
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE Trad_Sys_Medical_Comb SET \"LIMIT\" = '400' where OccpCode like '%%UNEMP%%'"];
    [database executeUpdate:query];

    [database close];
    return YES;
}

+(BOOL)InstallUpdate:(NSString *)path
{
	NSString * AppsVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];

	sqlite3_stmt *statement;
    NSString *QuerySQL;
	NSString *CurrenVersion = @"";
	
	if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK){
		
		QuerySQL = [ NSString stringWithFormat:@"select SIVersion FROM Trad_Sys_SI_version_Details"];
		if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
			if (sqlite3_step(statement) == SQLITE_ROW) {
				CurrenVersion = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
			}
			sqlite3_finalize(statement);
		}
		sqlite3_close(contactDB);
	}
	
	
	if (![AppsVersion isEqualToString:CurrenVersion]) {
		[self InstallVersion1dot3:path];
			
		if (sqlite3_open([path UTF8String], &contactDB) == SQLITE_OK){
			
			QuerySQL = [ NSString stringWithFormat:@"Update Trad_Sys_SI_version_Details set SIVersion = '%@'", AppsVersion];
			if(sqlite3_prepare_v2(contactDB, [QuerySQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
				if (sqlite3_step(statement) == SQLITE_DONE) {
					
				}
				sqlite3_finalize(statement);
			}
			sqlite3_close(contactDB);
		}
		
	}
	
    return YES;
}

+(void)InstallVersion1dot3:(NSString *)path{
	
	FMDatabase *database = [FMDatabase databaseWithPath:path];
    [database open];
	
	NSString *query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Details (\"SINO\" VARCHAR, \"PlanCode\" VARCHAR, \"CovTypeCode\" INTEGER, \"ATPrem\" "
					   "DOUBLE, \"BasicSA\" DOUBLE, \"CovPeriod\" INTEGER, \"OccpCode\" VARCHAR, \"OccLoading\" DOUBLE, \"CPA\" INTEGER, "
					   "\"PA\" INTEGER, \"HLoading\" DOUBLE, \"HloadingTerm\" INTEGER, \"HloadingPct\" VARCHAR, \"HloadingPctTerm\" VARCHAR "
					   ", \"MedicalReq\" VARCHAR, \"ComDate\" VARCHAR, \"HLGES\" VARCHAR, \"ATU\" VARCHAR, \"BUMPMode\" VARCHAR "
					   ", \"InvCode\" VARCHAR, \"InvHorizon\" VARCHAR, \"RiderRTU\" VARCHAR, \"RiderRTUTerm\" VARCHAR, \"PolicySustainYear\" VARCHAR"
					   ", \"Package\" VARCHAR, \"TotATPrem\" VARCHAR, \"TotUpPrem\" VARCHAR, \"VU2023\" VARCHAR, \"VU2023To\" VARCHAR"
					   ", \"VU2025\" VARCHAR, \"VU2025To\" VARCHAR, \"VU2028\" VARCHAR, \"VU2028To\" VARCHAR, \"VU2030\" VARCHAR"
					   ", \"VU2030To\" VARCHAR, \"VU2035\" VARCHAR, \"VU2035To\" VARCHAR, \"VUCash\" VARCHAR, \"VUCashTo\" VARCHAR"
					   ", \"ReinvestYI\" VARCHAR, \"FullyPaidUp6Year\" VARCHAR, \"FullyPaidUp10Year\" VARCHAR, \"ReduceBSA\" VARCHAR"
					   ", \"SpecialVersion\" VARCHAR, \"VURet\" VARCHAR, \"VURetTo\" VARCHAR, \"VURetOpt\" VARCHAR, \"VURetToOpt\" VARCHAR"
					   ", \"VUCashOpt\" VARCHAR, \"VUCashToOpt\" VARCHAR, \"DateCreated\" DATETIME, \"CreatedBy\" VARCHAR, \"DateModified\" DATETIME, \"ModifiedBy\" VARCHAR, )"];

    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_LAPayor (\"SINO\" VARCHAR, \"CustCode\"	VARCHAR, \"PTypeCode\" "
					   "VARCHAR, \"Seq\" INTEGER, \"DateCreated\" DATETIME, \"CreatedBy\" VARCHAR, \"DateModified\" DATETIME, \"ModifiedBy\" VARCHAR) "];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_ReducedPaidUp (\"SINO\" VARCHAR, \"ReducedYear\" INTEGER, \"Amount\" "
					   "DOUBLE) "];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_RegTopUp (\"SINO\" VARCHAR, \"FromYear\" VARCHAR, \"ToYear\" "
			 "VARCHAR, \"Amount\" DOUBLE)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Rider_Details (\"SINO\" VARCHAR, \"RiderCode\" VARCHAR, \"PTypeCode\" "
			 "VARCHAR, \"Seq\" INTEGER, \"RiderTerm\" INTEGER, \"SumAssured\" DOUBLE, \"Units\" INTEGER, \"PlanOption\" VARCHAR, "
			 "\"HLoading\" DOUBLE, \"HLoadingTerm\" INTEGER, \"HLoadingPCt\" INTEGER, \"HLoadingPCtTerm\" INTEGER, \"Premium\" DOUBLE, "
			 "\"Deductible\" VARCHAR, \"PaymentTerm\" INTEGER, \"ReinvestYI\" VARCHAR, \"GYIYear\" INTEGER, \"RRTUOFromYear\" INTEGER, "
			 "\"RRTUOYear\" INTEGER) "];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_TopupPrem (\"SINO\" VARCHAR, \"PolYear\" INTEGER, \"Amount\" "
			 "DOUBLE) "];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_TPExcess (\"SINO\" VARCHAR, \"FromYear\" INTEGER, \"YearInt\" INTEGER, \"Amount\" "
			 "DOUBLE, \"ForYear\" INTEGER,) "];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_TPIncrease (\"SINO\" VARCHAR, \"FromYear\" INTEGER, \"YearInt\" INTEGER, \"Amount\" "
			 "DOUBLE) "];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Fund_Maturity_Option (\"SINO\" VARCHAR, \"Fund\" VARCHAR, \"Option\" VARCHAR, "
			 "\"Partial_withd_Pct\" DOUBLE, \"EverGreen2025\" DOUBLE, \"EverGreen2028\" DOUBLE, \"EverGreen2030\" DOUBLE, "
			 "\"EverGreen2035\" DOUBLE, \"CashFund\" DOUBLE, \"RetireFund\" DOUBLE) "];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Rider_mtn (\"RiderCode\" VARCHAR, \"isEDD\" INTEGER, \"MinAge\" INTEGER, "
			 "\"MaxAge\" INTEGER, \"ExpiryAge\" INTEGER, \"MinSA\" DOUBLE, \"MaxSA\" DOUBLE, "
			 "\"MinTerm\" INTEGER, \"MaxTerm\" INTEGER, \"PlanCode\" VARCHAR, \"PTypeCode\" VARCHAR, \"Seq\" INTEGER)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Rider_Profile ('RiderCode' VARCHAR, 'RiderDesc' VARCHAR, 'LifePlan' INTEGER, "
			 "'Status' INTEGER)"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS UL_Rider_Label (\"LabelCode\" VARCHAR, \"LabelDesc\" VARCHAR, \"RiderCode\" VARCHAR, "
			 "\"RiderName\" VARCHAR, \"InputCode\" VARCHAR, \"TableName\" VARCHAR, \"FieldName\" VARCHAR, \"Condition\" VARCHAR, "
			 "\"DateCreated\" DATETIME, \"CreatedBy\" VARCHAR, \"DateModified\" DATETIME, \"ModifiedBy\" VARCHAR)"];
    [database executeUpdate:query];
/*
	//
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"ACIR\", 0, 0, 65, -100, 10000, 1500000,0 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"CIRD\", 0, 30, 55, 65, 20000, 100000, 10 , 10, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"CIWP\", 0, 0, 70, -80, 0.00, 0.00, 3 , 25, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"DCA\", 0, 0, 70, -75, 10000, 0.00, 5 , 75, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"DHI\", 0, 0, 70, -75, 50, 0.00, 5 , 75, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"ECAR\", 0, 0, 65, 80, 45000, 0.00, 20 , 25, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"ECAR55\", 0, 0, 50, -100, 50.00, 0.00, 0 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"HMM\", 0, 0, 70, -100, 0.00, 0.00,0 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"LCWP\", 0, 16, 65, 80, 0.00, 0.00, 3 , 25, \"EverLife\", \"PY\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"LCWP\", 0, 16, 65, 80, 0.00, 0.00, 3 , 25, \"EverLife\", \"LA\", 2 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"LSR\", 0, 0, 70, -100, 20000, 0.00, 0 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"MG_IV\", 0, 0, 70, -100, 0.00, 0.00, 0 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"MR\", 0, 0, 70, 75, 1000, 5000, 5, 75, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"PA\", 0, 0, 70, 75, 10000, 0.00, 5 , 75, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"PR\", 0, 16, 65, 80, 0.00, 0.00, 3 , 25, \"EverLife\", \"PY\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"PR\", 0, 16, 65, 80, 0.00, 0.00, 3 , 25, \"EverLife\", \"LA\", 2 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"RRTUO\", 0, 0, 100, 100, 1.00, 10000, 1 , 100, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"TPDMLA\", 0, 0, 70, 75, 500, 10000, 5 , 75, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"TPDWP\", 0, 0, 65, 80, 0.00, 0.00, 3 , 80, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_mtn VALUES(\"WI\", 0, 20, 65, 70, 100, 8000, 5 , 70, \"EverLife\", \"LA\", 1 )"];
    [database executeUpdate:query];
	
	//
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('ACIR', 'Accelerated Critical Illness', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('CIRD', 'Diabetes Wellness Care Rider"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('CIWP', 'Critical Illness Waiver of Premium Rider', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('DCA', 'Acc. Death & Compassionate Allowance Rider', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"DHI\", \"Acc. Daily Hospitalisation Income Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"ECAR\", \"EverCash 1 Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"ECAR55\", \"EverCash 55 Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('HMM', 'HLA Major Medi', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('LCWP', 'Living Care Waiver of Premium Rider', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"LSR\", \"LifeShield Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('MG_IV', 'MedGlobal IV Plus', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"MR\", \"Acc. Medical Reimbursement Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('PA', 'Personal Accident Rider', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES('PR', 'Waiver of Premium Rider', 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"RRTUO\", \"Rider Regular Top Up Option\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"TPDMLA\", \"Acc. TPD Monthly Living Allowance Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"TPDWP\", \"TPD Waiver of Premium Rider\", 0, 1)"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Profile VALUES(\"WI\", \"Acc. Weekly Indemnity Rider\", 0, 1)"];
    [database executeUpdate:query];
 */

	//
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"ACIR\", \"Accelerated Critical Illness\", \"TF\", "
										"\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"ACIR\", \"Accelerated Critical Illness\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"ACIR\", \"Accelerated Critical Illness\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"CIWP\", \"Critical Illness Waiver of Premium Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HL1K\", \"Health Loading (Per 1K SA)\", \"CIWP\", \"Critical Illness Waiver of Premium Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"DCA\", \"Acc. Death & Compassionate Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"DCA\", \"Acc. Death & Compassionate Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PAYT\", \"Payment Term\", \"DCA\", \"Acc. Death & Compassionate Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"DCA\", \"Acc. Death & Compassionate Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"DHI\", \"Acc. Daily Hospitalisation Income Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"DHI\", \"Acc. Daily Hospitalisation Income Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PAYT\", \"Payment Term\", \"DHI\", \"Acc. Daily Hospitalisation Income Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"DHI\", \"Acc. Daily Hospitalisation Income Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"ECAR\", \"EverCash 1 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"YINC\", \"Yearly Income\", \"ECAR\", \"EverCash 1 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PAYT\", \"Payment Term\", \"ECAR\", \"EverCash 1 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"REYI\", \"Reinvestment of Yearly Income\", \"ECAR\", \"EverCash 1 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HL1K\", \"Health Loading (Per 1KSA)\", \"ECAR\", \"EverCash 1 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"MINC\", \"Monthly Income\", \"ECAR55\", \"EverCash 55 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PAYT\", \"Payment Term\", \"ECAR55\", \"EverCash 55 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"REMI\", \"Reinvestment of Month Income\", \"ECAR55\", \"EverCash 55 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HL1K\", \"Health Loading (Per 1KSA)\", \"ECAR55\", \"EverCash 55 Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PLCH\", \"Plan Choice\", \"HMM\", \"HLA Major Medi\", \"DD\", "
			 "\"\", \"\", \"PlanChoiceHMM\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"DEDUC\", \"Deductible\", \"HMM\", \"HLA Major Medi\", \"DD\", "
			 "\"\", \"\", \"DeductibleHMM\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"HMM\", \"HLA Major Medi\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"LSR\", \"LifeShield Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HL1K\", \"Health Loading (Per 1KSA)\", \"LSR\", \"LifeShield Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PLCH\", \"Plan Choice\", \"MGIV\", \"MedGlobal IV Plus\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"MGIV\", \"MedGlobal IV Plus\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"MR\", \"Acc. Medical Reimbursement Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"MR\", \"Acc. Medical Reimbursement Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"MR\", \"Acc. Medical Reimbursement Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"PA\", \"Personal Accident Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"PA\", \"Personal Accident Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"PA\", \"Personal Accident Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"CFPA\", \"Commencing From\n(pol. anniversary)\", \"RRTUO\", \"Rider Regular Top Up Option\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"FORY\", \"for(year)\", \"RRTUO\", \"Rider Regular Top Up Option\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"PREM\", \"Premium\", \"RRTUO\", \"Rider Regular Top Up Option\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"TPDMLA\", \"Acc. TPD Monthly Living Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"TPDMLA\", \"Acc. TPD Monthly Living Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"TPDMLA\", \"Acc. TPD Monthly Living Allowance Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"TPDWP\", \"TPD Waiver of Premium Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];

	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HL1K\", \"Health Loading (Per 1K SA)\", \"TPDWP\", \"TPD Waiver of Premium Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"RITM\", \"Rider Term\", \"WI\", \"Acc. Weekly Indemnity Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"SUMA\", \"Sum Assured\", \"WI\", \"Acc. Weekly Indemnity Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	query = [NSString stringWithFormat:@"INSERT INTO UL_Rider_Label VALUES(\"HLP\", \"Health Loading (%%)\", \"WI\", \"Acc. Weekly Indemnity Rider\", \"TF\", "
			 "\"\", \"\", \"\",  date('now'), 'HLA', date('now'), 'HLA')"];
    [database executeUpdate:query];
	
	[database close];
}


+(NSString *)WSLogin{
	
	return @"http://echannel.dev/";
	//return @"http://www.hla.com.my:2880/";
}

@end
