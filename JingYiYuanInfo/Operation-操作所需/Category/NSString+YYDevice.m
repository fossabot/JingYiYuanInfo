//
//  NSString+YYDevice.m
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/3.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import "NSString+YYDevice.h"
#import <sys/utsname.h>

@implementation NSString (YYDevice)



+ (YYDeviceType)deviceModelName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    //simulator
    if ([platform isEqualToString:@"i386"])          return YYDeviceTypeSimulator;
    if ([platform isEqualToString:@"x86_64"])        return YYDeviceTypeSimulator;
    
    //AirPods
    if ([platform isEqualToString:@"AirPods1,1"])    return YYDeviceTypeAirPods;
    
    //Apple TV
    if ([platform isEqualToString:@"AppleTV2,1"])    return YYDeviceTypeAppleTV_2;
    if ([platform isEqualToString:@"AppleTV3,1"])    return YYDeviceTypeAppleTV_3;
    if ([platform isEqualToString:@"AppleTV3,2"])    return YYDeviceTypeAppleTV_3;
    if ([platform isEqualToString:@"AppleTV5,3"])    return YYDeviceTypeAppleTV_4;
    if ([platform isEqualToString:@"AppleTV6,2"])    return YYDeviceTypeAppleTV_4;
    
    //Apple Watch
    if ([platform isEqualToString:@"Watch1,1"])    return YYDeviceTypeAppleWatch_1;
    if ([platform isEqualToString:@"Watch1,2"])    return YYDeviceTypeAppleWatch_1;
    if ([platform isEqualToString:@"Watch2,6"])    return YYDeviceTypeAppleWatch_Series1;
    if ([platform isEqualToString:@"Watch2,7"])    return YYDeviceTypeAppleWatch_Series2;
    if ([platform isEqualToString:@"Watch2,3"])    return YYDeviceTypeAppleWatch_Series2;
    if ([platform isEqualToString:@"Watch2,4"])    return YYDeviceTypeAppleWatch_Series2;
    if ([platform isEqualToString:@"Watch3,1"])    return YYDeviceTypeAppleWatch_Series3;
    if ([platform isEqualToString:@"Watch3,2"])    return YYDeviceTypeAppleWatch_Series3;
    if ([platform isEqualToString:@"Watch3,3"])    return YYDeviceTypeAppleWatch_Series3;
    if ([platform isEqualToString:@"Watch3,4"])    return YYDeviceTypeAppleWatch_Series3;
    
    //HomePod
    if ([platform isEqualToString:@"AudioAccessory1,1"])    return YYDeviceTypeHomePod;
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])    return YYDeviceTypeiPad;
    if ([platform isEqualToString:@"iPad2,1"])    return YYDeviceTypeiPad2;
    if ([platform isEqualToString:@"iPad2,2"])    return YYDeviceTypeiPad2;
    if ([platform isEqualToString:@"iPad2,3"])    return YYDeviceTypeiPad2;
    if ([platform isEqualToString:@"iPad2,4"])    return YYDeviceTypeiPad2;
    if ([platform isEqualToString:@"iPad3,1"])    return YYDeviceTypeiPad3;
    if ([platform isEqualToString:@"iPad3,2"])    return YYDeviceTypeiPad3;
    if ([platform isEqualToString:@"iPad3,3"])    return YYDeviceTypeiPad3;
    if ([platform isEqualToString:@"iPad3,4"])    return YYDeviceTypeiPad4;
    if ([platform isEqualToString:@"iPad3,5"])    return YYDeviceTypeiPad4;
    if ([platform isEqualToString:@"iPad3,6"])    return YYDeviceTypeiPad4;
    if ([platform isEqualToString:@"iPad4,1"])    return YYDeviceTypeiPadAir;
    if ([platform isEqualToString:@"iPad4,2"])    return YYDeviceTypeiPadAir;
    if ([platform isEqualToString:@"iPad4,3"])    return YYDeviceTypeiPadAir;
    if ([platform isEqualToString:@"iPad5,3"])    return YYDeviceTypeiPadAir2;
    if ([platform isEqualToString:@"iPad5,4"])    return YYDeviceTypeiPadAir2;
    if ([platform isEqualToString:@"iPad6,7"])    return YYDeviceTypeiPadPro_12inch;
    if ([platform isEqualToString:@"iPad6,8"])    return YYDeviceTypeiPadPro_12inch;
    if ([platform isEqualToString:@"iPad6,3"])    return YYDeviceTypeiPadPro_9inch;
    if ([platform isEqualToString:@"iPad6,4"])    return YYDeviceTypeiPadPro_9inch;
    if ([platform isEqualToString:@"iPad6,11"])    return YYDeviceTypeiPad5;
    if ([platform isEqualToString:@"iPad6,12"])    return YYDeviceTypeiPad5;
    if ([platform isEqualToString:@"iPad7,1"])    return YYDeviceTypeiPadPro_12inch_2;
    if ([platform isEqualToString:@"iPad7,2"])    return YYDeviceTypeiPadPro_12inch_2;
    if ([platform isEqualToString:@"iPad7,3"])    return YYDeviceTypeiPadPro_10inch;
    if ([platform isEqualToString:@"iPad7,4"])    return YYDeviceTypeiPadPro_10inch;
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])    return YYDeviceTypeiPadmini;
    if ([platform isEqualToString:@"iPad2,6"])    return YYDeviceTypeiPadmini;
    if ([platform isEqualToString:@"iPad2,7"])    return YYDeviceTypeiPadmini;
    if ([platform isEqualToString:@"iPad4,4"])    return YYDeviceTypeiPadmini2;
    if ([platform isEqualToString:@"iPad4,5"])    return YYDeviceTypeiPadmini2;
    if ([platform isEqualToString:@"iPad4,6"])    return YYDeviceTypeiPadmini2;
    if ([platform isEqualToString:@"iPad4,7"])    return YYDeviceTypeiPadmini3;
    if ([platform isEqualToString:@"iPad4,8"])    return YYDeviceTypeiPadmini3;
    if ([platform isEqualToString:@"iPad4,9"])    return YYDeviceTypeiPadmini3;
    if ([platform isEqualToString:@"iPad5,1"])    return YYDeviceTypeiPadmini4;
    if ([platform isEqualToString:@"iPad5,2"])    return YYDeviceTypeiPadmini4;
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])     return YYDeviceTypeiPhone_1G;
    if ([platform isEqualToString:@"iPhone1,2"])     return YYDeviceTypeiPhone_3G;
    if ([platform isEqualToString:@"iPhone2,1"])     return YYDeviceTypeiPhone_3GS;
    if ([platform isEqualToString:@"iPhone3,1"])     return YYDeviceTypeiPhone_4;
    if ([platform isEqualToString:@"iPhone3,2"])     return YYDeviceTypeiPhone_4;
    if ([platform isEqualToString:@"iPhone4,1"])     return YYDeviceTypeiPhone_4S;
    if ([platform isEqualToString:@"iPhone5,1"])     return YYDeviceTypeiPhone_5;
    if ([platform isEqualToString:@"iPhone5,2"])     return YYDeviceTypeiPhone_5;
    if ([platform isEqualToString:@"iPhone5,3"])     return YYDeviceTypeiPhone_5C;
    if ([platform isEqualToString:@"iPhone5,4"])     return YYDeviceTypeiPhone_5C;
    if ([platform isEqualToString:@"iPhone6,1"])     return YYDeviceTypeiPhone_5S;
    if ([platform isEqualToString:@"iPhone6,2"])     return YYDeviceTypeiPhone_5S;
    if ([platform isEqualToString:@"iPhone7,1"])     return YYDeviceTypeiPhone_6P;
    if ([platform isEqualToString:@"iPhone7,2"])     return YYDeviceTypeiPhone_6;
    if ([platform isEqualToString:@"iPhone8,1"])     return YYDeviceTypeiPhone_6S;
    if ([platform isEqualToString:@"iPhone8,2"])     return YYDeviceTypeiPhone_6SP;
    if ([platform isEqualToString:@"iPhone8,4"])     return YYDeviceTypeiPhone_SE;
    if ([platform isEqualToString:@"iPhone9,1"])     return YYDeviceTypeiPhone_7;
    if ([platform isEqualToString:@"iPhone9,3"])     return YYDeviceTypeiPhone_7;
    if ([platform isEqualToString:@"iPhone9,2"])     return YYDeviceTypeiPhone_7P;
    if ([platform isEqualToString:@"iPhone9,4"])     return YYDeviceTypeiPhone_7;
    if ([platform isEqualToString:@"iPhone10,1"])    return YYDeviceTypeiPhone_8;
    if ([platform isEqualToString:@"iPhone10,4"])    return YYDeviceTypeiPhone_8;
    if ([platform isEqualToString:@"iPhone10,2"])    return YYDeviceTypeiPhone_8P;
    if ([platform isEqualToString:@"iPhone10,5"])    return YYDeviceTypeiPhone_8P;
    if ([platform isEqualToString:@"iPhone10,3"])    return YYDeviceTypeiPhone_X;
    if ([platform isEqualToString:@"iPhone10,6"])    return YYDeviceTypeiPhone_X;
    
    //iPod touch
    if ([platform isEqualToString:@"iPod1,1"])    return YYDeviceTypeiPodtouch;
    if ([platform isEqualToString:@"iPod2,1"])    return YYDeviceTypeiPodtouch2;
    if ([platform isEqualToString:@"iPod3,1"])    return YYDeviceTypeiPodtouch3;
    if ([platform isEqualToString:@"iPod4,1"])    return YYDeviceTypeiPodtouch4;
    if ([platform isEqualToString:@"iPod5,1"])    return YYDeviceTypeiPodtouch5;
    if ([platform isEqualToString:@"iPod7,1"])    return YYDeviceTypeiPodtouch6;
    
    return YYDeviceTypeNONE;
    
}


+ (DeviceScreenSize)currentDeviceScreenSize {

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    DeviceScreenSize size = DeviceScreenSizeMini;
    if (width >= 320.f) {
        size = DeviceScreenSizeMini;
    }
    if (width >= 375.f) {
        size = DeviceScreenSizeMiddle;
    }
    if (width >= 414.f) {
        size = DeviceScreenSizeLarge;
    }

    return size;
}




@end
