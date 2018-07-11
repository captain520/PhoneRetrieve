//
//  CPMemberQuoteManager.m
//  PhoneRetrieve
//
//  Created by 王璋传 on 2018/7/10.
//  Copyright © 2018年 Captain. All rights reserved.
//

#import "CPMemberQuoteManager.h"

@implementation CPMemberQuoteManager

+ (instancetype)shareInstance {
    static CPMemberQuoteManager *obj;
    static dispatch_once_t once;

    if (nil == obj) {
        dispatch_once(&once, ^{
            obj = [[CPMemberQuoteManager alloc] init];
            obj.singlebQuoteFlowDataDict = @{}.mutableCopy;
            obj.mutipleQuoteFlowDataDict = @{}.mutableCopy;
        });
    }
    
    return obj;
}

@end
