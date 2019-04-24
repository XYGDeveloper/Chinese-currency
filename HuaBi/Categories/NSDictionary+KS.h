//
//  NSDictionary+KS.h
//
//  Created by 周勇 on 16/12/29.
//  Copyright © 2016年 周勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KS)
/**  取json数据里面的字段  */
-(id)ksObjectForKey:(NSString*)aKey;


@end
