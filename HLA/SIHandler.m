//
//  SIHandler.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIHandler.h"

@implementation SIHandler

@synthesize storedSINo,storedAge,storedOccpCode,storedOccpClass,storedSex;


-(id)initWithSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex
{
    self = [super init];
    if(self) {
        self.storedSINo = aaSINo;
        self.storedAge = aaAge;
        self.storedOccpCode = aaOccpCode;
        self.storedOccpClass = aaOccpClass;
        self.storedSex = aaSex;
    }
    return self;
}

@end
