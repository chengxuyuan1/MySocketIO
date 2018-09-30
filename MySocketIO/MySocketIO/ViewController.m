//
//  ViewController.m
//  MySocketIO
//
//  Created by 许传信 on 2018/9/30.
//  Copyright © 2018年 zhifu. All rights reserved.
//

#import "ViewController.h"
#import "SockeIOtView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SockeIOtView *socket=[[SockeIOtView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [socket socketIOResult:^(id  _Nonnull data) {
        //io.connect
        if ([data isEqualToString:@"io.connect"]) {
            [socket ioConnectWithUrl:@"http://103.231.167.85:9081"];
        }
        if ([data isEqualToString:@"socketOn"]) {
            [socket socketOn:@"hall" Data:^(id  _Nonnull data) {
                    NSLog(@"%@",[self jsonWithArr:data]);
            }];
        }
        if ([data isEqualToString:@"connect"]) {
            NSString *str=@"{'game':'baccarat'}";
            [socket emitWith:@[@"joingame",str]];
        }
        
    }];
     [self.view addSubview:socket];

}

-(NSString *)jsonWithArr:(NSArray *)arr{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:kNilOptions
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
@end
