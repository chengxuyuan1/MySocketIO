//
//  SockeIOtView.h
//  MySocketIO
//
//  Created by 许传信 on 2018/9/30.
//  Copyright © 2018年 zhifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN
typedef void (^SocketIOBlock)(id data);
@protocol TestJSObjectProtocol <JSExport>
-(void)TestOneParameter:(NSString *)message;
JSExportAs(nativeCall, - (void)nativeCallHandleWithType:(NSString *)nativeType parameter:(NSString *)parameter jsType:(NSString *)jstype);
@end

@interface SockeIOtView : UIView<UIWebViewDelegate,TestJSObjectProtocol>
@property (nonatomic,strong) UIWebView *webView;
@property (strong, nonatomic) JSContext *context;
@property (nonatomic,copy) SocketIOBlock block;
@property (nonatomic,copy) SocketIOBlock dataBlock;
-(void)socketIOResult:(SocketIOBlock)complete;
-(void)ioConnectWithUrl:(NSString *)url;
-(void)socketOn:(NSString *)str Data:(SocketIOBlock)complete;
-(void)emitWith:(NSArray *)arr;
@end

NS_ASSUME_NONNULL_END
