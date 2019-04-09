//
//  WOLManager.h
//  WOL
//
//  Created by Conner Wu on 2019/4/4.
//  Copyright © 2019年 Conner Wu. All rights reserved.
//  Mail: 244295790@qq.com

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WOLManager : NSObject

+ (instancetype)shared;

- (void)sendWakeUpDataToHost:(NSString *)host port:(uint16_t)port macAddress:(NSString *)macAddress;

@end

NS_ASSUME_NONNULL_END
