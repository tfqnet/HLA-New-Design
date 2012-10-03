//
//  SIHandler.m
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import "SIHandler.h"

@implementation SIHandler

@synthesize SINo,Age,OccpCode;

-(id)initWithSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode
{
    self = [super init];
    if(self) {
        self.SINo = aaSINo;
        self.Age = aaAge;
        self.OccpCode = aaOccpCode;
    }
    return self;
}

@end
