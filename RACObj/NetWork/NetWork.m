//
//  NetWork.m
//  RACObj
//
//  Created by 王龙飞 on 2019/12/5.
//  Copyright © 2019 王龙飞. All rights reserved.
//

#import "NetWork.h"
#import <AFNetworking.h>
static NetWork *net = nil;
@implementation NetWork

+(NetWork *)shareInstanced{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        net = [[NetWork alloc] init];
    });
    return net;
}
-(instancetype)init{
    if (self = [super init]){
        
        
        
    }
    return self;
}
@end
