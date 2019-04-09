//
//  WOLManager.m
//  WOL
//
//  Created by Conner Wu on 2019/4/4.
//  Copyright © 2019年 Conner Wu. All rights reserved.
//  Mail: 244295790@qq.com

#import "WOLManager.h"
#import <CocoaAsyncSocket/GCDAsyncUdpSocket.h>

@interface WOLManager () <GCDAsyncUdpSocketDelegate>
{
    GCDAsyncUdpSocket *_asyncUdpSocket;
}
@end

@implementation WOLManager

+ (instancetype)shared {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        NSError *error = nil;
        _asyncUdpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_asyncUdpSocket enableBroadcast:YES error:&error];
        if (error) {
            NSLog(@"error: %@", error);
        }
    }
    return self;
}

#pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"Send Successfully");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError * _Nullable)error {
    NSLog(@"Not Send, error: %@", error);
}

#pragma mark - 发送唤醒数据

- (void)sendWakeUpDataToHost:(NSString *)host port:(uint16_t)port macAddress:(NSString *)macAddress {
    NSArray *macArray = [macAddress componentsSeparatedByString:@":"];
    NSString *hexString = [macArray componentsJoinedByString:@""]; // 16进制字符串
    int j = 0;
    Byte macs[macArray.count]; // 3ds key的Byte 数组， 128位
    for (int i = 0; i < [hexString length]; i++) {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if (hex_char1 >= '0' && hex_char1 <= '9') {
            int_ch1 = (hex_char1 - 48) * 16;   //// 0 的Ascll - 48
        } else if (hex_char1 >= 'A' && hex_char1 <='F') {
            int_ch1 = (hex_char1 - 55) * 16; //// A 的Ascll - 65
        } else {
            int_ch1 = (hex_char1 - 87) * 16; //// a 的Ascll - 97
        }
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9') {
            int_ch2 = (hex_char2 - 48); //// 0 的Ascll - 48
        } else if(hex_char1 >= 'A' && hex_char1 <= 'F') {
            int_ch2 = hex_char2 - 55; //// A 的Ascll - 65
        } else {
            int_ch2 = hex_char2 - 87; //// a 的Ascll - 97
        }
        
        int_ch = int_ch1+int_ch2;
        macs[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    Byte packet[17 * 6] = {};
    for (int i = 0 ; i < 6; i++) {
        packet[i] = 0xFF;
        for (int i = 1; i <= 16; i++) {
            for (int j = 0; j < 6; j++) {
                packet[i * 6 + j] = macs[j];
            }
        }
    }
    
    NSData *data = [NSData dataWithBytes:packet length:sizeof(packet)];
    [_asyncUdpSocket sendData:data toHost:host port:port withTimeout:-1 tag:0];
}

@end
