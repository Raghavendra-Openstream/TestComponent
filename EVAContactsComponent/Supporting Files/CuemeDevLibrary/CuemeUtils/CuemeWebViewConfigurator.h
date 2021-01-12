#import <Foundation/Foundation.h>
#import "IApplicationContext.h"

@class Logger;

@interface CuemeWebViewConfigurator : NSObject

@property (nonatomic) WKWebViewConfiguration *wkWebviewConfig;

- (instancetype)initWithAppContent:(id<IApplicationContext>)appContext logger:(Logger *)logger;

- (void)setDefaultWebViewProperties:(WKWebView *)webview;

@end

