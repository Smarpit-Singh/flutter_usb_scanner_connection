#import "UsbScannerPlugin.h"
#import <FlutterMacOS/FlutterMacOS.h>

@implementation UsbScannerPlugin {
    FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
            methodChannelWithName:@"usb_scanner"
                  binaryMessenger:[registrar messenger]];
    UsbScannerPlugin* instance = [[UsbScannerPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];

    FlutterEventChannel* eventChannel = [FlutterEventChannel
            eventChannelWithName:@"usb_scanner_events"
                 binaryMessenger:[registrar messenger]];
    [eventChannel setStreamHandler:instance];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"listen" isEqualToString:call.method]) {
        // Handle the listen method
        result(@(YES));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - FlutterStreamHandler methods

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
    _eventSink = events;
    // Start sending events
    return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _eventSink = nil;
    // Stop sending events
    return nil;
}

@end