//
//  LoremIpsum.h
// 
//
//  Created by Benjamin Gordon on 2/6/13.
//  Copyright (c) 2013 Benjamin Gordon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoremIpsum : NSObject

+(NSString *)generateLoremIpsumWithWords:(int)num punctuation:(NSString *)punctuation;

@end
