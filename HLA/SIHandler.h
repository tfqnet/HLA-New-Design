//
//  SIHandler.h
//  HLA Ipad
//
//  Created by shawal sapuan on 10/3/12.
//  Copyright (c) 2012 InfoConnect Sdn Bhd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SIHandler : NSObject

@property (nonatomic, retain) NSString *SINo;
@property (nonatomic ,assign ,readwrite) int Age;
@property (nonatomic, retain) NSString *OccpCode;

-(id) initWithSI:(NSString *)aaSINo andAge:(int)aaAge andOccpCode:(NSString *)aaOccpCode;

@end
