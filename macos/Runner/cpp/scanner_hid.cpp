// scanner_hid.cpp
#include <IOKit/hid/IOHIDManager.h>
#include <CoreFoundation/CoreFoundation.h>
#include <functional>

static std::function<void()> g_buttonCallback;

void Handle_Input(void* context, IOReturn result, void* sender, IOHIDValueRef value) {
    IOHIDElementRef element = IOHIDValueGetElement(value);
    if (!element) return;

    // Check if it's a button element
    uint32_t usagePage = IOHIDElementGetUsagePage(element);
    uint32_t usage = IOHIDElementGetUsage(element);

    if (usagePage == kHIDPage_Button && usage == 1) {
        CFIndex intValue = IOHIDValueGetIntegerValue(value);
        if (intValue == 1) { // Button down
            if (g_buttonCallback) {
                g_buttonCallback();
            }
        }
    }
}

void startListeningForScannerPress(std::function<void()> buttonPressedCallback) {
    g_buttonCallback = buttonPressedCallback;

    IOHIDManagerRef hidManager = IOHIDManagerCreate(kCFAllocatorDefault, kIOHIDOptionsTypeNone);

    int vendor = 0x0C45;
    int product = 0x636D;

    CFMutableDictionaryRef matchDict = CFDictionaryCreateMutable(kCFAllocatorDefault,
        0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);

    CFDictionarySetValue(matchDict, CFSTR(kIOHIDVendorIDKey),
        CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &vendor));
    CFDictionarySetValue(matchDict, CFSTR(kIOHIDProductIDKey),
        CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &product));

    IOHIDManagerSetDeviceMatching(hidManager, matchDict);
    CFRelease(matchDict);

    IOHIDManagerRegisterInputValueCallback(hidManager, Handle_Input, NULL);
    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
}
