//
//  SIHandler.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIHandler.h"

@implementation SIHandler

@synthesize storedAge,storedOccpCode,storedOccpClass,storedSex,storedIndexNo,storedCommDate,storedSmoker;
@synthesize storedIdPayor,storedIdProfile;

-(id)initWithIDPayor:(int)aaIdPayor andIDProfile:(int)aaIdProfile andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo andCommDate:(NSString *)aaCommDate andSmoker:(NSString *)aaSmoker
{
    self = [super init];
    if(self) {
        self.storedAge = aaAge;
        self.storedOccpCode = aaOccpCode;
        self.storedOccpClass = aaOccpClass;
        self.storedSex = aaSex;
        self.storedIndexNo = aaIndexNo;
        self.storedCommDate = aaCommDate;
        self.storedIdProfile = aaIdProfile;
        self.storedIdPayor = aaIdPayor;
        self.storedSmoker = aaSmoker;
    }
    return self;
}
@end
