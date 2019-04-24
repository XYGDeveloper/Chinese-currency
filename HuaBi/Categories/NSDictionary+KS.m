//
//  NSDictionary+KS.m
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import "NSDictionary+KS.h"

@implementation NSDictionary (KS)

-(id)ksObjectForKey:(NSString*)aKey;
{
    id result = [self objectForKey: aKey];
    if ([result class] == [NSNull class]) {
        return nil;
        //    } else if ([result class])
        //    if ([result isEqualToString: @"<null>"] || [result isEqualToString: @"<Null>"]) {
        //        return  @"";
    } else {
        if (result == nil) {
            return nil;
        }
        return result;
    }
}
@end
