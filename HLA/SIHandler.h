//
//  SIHandler.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIHandler : NSObject

@property (nonatomic, retain) NSString *storedSINo;
@property (nonatomic ,assign ,readwrite) int storedAge;
@property (nonatomic, retain) NSString *storedOccpCode;
@property (nonatomic ,assign ,readwrite) int storedOccpClass;
@property (nonatomic, retain) NSString *storedSex;
@property (nonatomic ,assign ,readwrite) int storedIndexNo;

-(id) initWithSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode andOccpClass:(int)aaOccpClass andSex:(NSString *)aaSex andIndexNo:(int)aaIndexNo;


@end
