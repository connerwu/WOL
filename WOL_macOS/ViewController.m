//
//  ViewController.m
//  WOL_macOS
//
//  Created by Conner Wu on 2019/4/4.
//  Copyright © 2019年 Conner Wu. All rights reserved.
//  Mail: 244295790@qq.com

#import "ViewController.h"
#import "WOLManager.h"

@interface ViewController ()

- (IBAction)wakeUp:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (IBAction)wakeUp:(id)sender {
//    NSString *host = @"192.168.1.111";
//    uint16_t port = 8888;
//    NSString *macAddress = @"aa:bb:cc:dd:ee:ff";
    [[WOLManager shared] sendWakeUpDataToHost:host port:port macAddress:macAddress];
}


@end
