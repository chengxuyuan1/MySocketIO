//
//  SockeIOtView.m
//  MySocketIO
//
//  Created by 许传信 on 2018/9/30.
//  Copyright © 2018年 zhifu. All rights reserved.
//

#import "SockeIOtView.h"

@implementation SockeIOtView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
self.webView.delegate=self;
[self addSubview:self.webView];
NSString *path = [[[NSBundle mainBundle] bundlePath]  stringByAppendingPathComponent:@"JSCallOC.html"];
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
[self.webView loadRequest:request];
    }
    return self;
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // Undocumented access to UIWebView's JSContext
    self.context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 打印异常
    self.context.exceptionHandler =
    ^(JSContext *context, JSValue *exceptionValue)
    {
        context.exception = exceptionValue;
        NSLog(@"%@", exceptionValue);
    };
    
    // 以1
    self.context[@"native"] = self;
    [self.context evaluateScript:@"onload()"];
    __block typeof(self) weakSelf = self;
    // 以 block 形式关联 JavaScript function
    
    _block(@"io.connect");
     _block(@"socketOn");
    self.context[@"socketConsole"] =
    ^(id a)
    {
        NSLog(@"%@",a);
        if ([a isEqualToString:@"connect"]) {
            if (weakSelf.block) {
                weakSelf.block(a);
            }
        }
        if ([a isEqualToString:@"disconnect"]) {
            if (weakSelf.block) {
                weakSelf.block(a);
            }
        }
    };
    
    self.context[@"socketResult"] =
    ^(id data)
    {
        if (weakSelf.dataBlock) {
            weakSelf.dataBlock(data);
        }
    };
    self.context[@"logout"] =
    ^(id data)
    {
        NSLog(@"logout");
    };
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
-(void)socketIOResult:(SocketIOBlock)complete{
    _block=complete;
}
-(void)ioConnectWithUrl:(NSString *)url{
    NSString *js=[NSString stringWithFormat:@"IOconnect('%@')",url];
    [self.context evaluateScript:js];
}
-(void)socketOn:(NSString *)str Data:(SocketIOBlock)complete{
    _dataBlock=complete;
    //hall
    NSString *js=[NSString stringWithFormat:@"socketOn('%@');",str];
    [self.context evaluateScript:js];
}
-(void)emitWith:(NSArray *)arr{
    JSValue *function = [self.context objectForKeyedSubscript:@"SocketIOEmit"];
    JSValue *result = [function callWithArguments:arr];
    NSLog(@"%@",result.toString);
}
-(void)TestOneParameter:(NSString *)message{
    NSLog(@"TestOneParameter:%@",message);
}
- (void)nativeCallHandleWithType:(NSString *)nativeType parameter:(NSString *)parameter jsType:(NSString *)jsType {
    NSLog(@"callHandle-------");
}


@end
