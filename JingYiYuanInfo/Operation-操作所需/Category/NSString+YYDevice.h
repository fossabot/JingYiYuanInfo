//
//  NSString+YYDevice.h
//  JingYiYuanInfo
//
//  Created by VINCENT on 2018/4/3.
//  Copyright © 2018年 北京京壹元资讯信息服务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, YYDeviceType) {
    YYDeviceTypeNONE,
    YYDeviceTypeSimulator,
    YYDeviceTypeAirPods,
    YYDeviceTypeAppleTV_2,
    YYDeviceTypeAppleTV_3,
    YYDeviceTypeAppleTV_4,
    YYDeviceTypeAppleTV_4K,
    YYDeviceTypeAppleWatch_1,
    YYDeviceTypeAppleWatch_Series1,
    YYDeviceTypeAppleWatch_Series2,
    YYDeviceTypeAppleWatch_Series3,
    YYDeviceTypeHomePod,
    YYDeviceTypeiPad,
    YYDeviceTypeiPad2,
    YYDeviceTypeiPad3,
    YYDeviceTypeiPad4,
    YYDeviceTypeiPad5,
    YYDeviceTypeiPadAir,
    YYDeviceTypeiPadAir2,
    YYDeviceTypeiPadPro_9inch,
    YYDeviceTypeiPadPro_10inch,
    YYDeviceTypeiPadPro_12inch,
    YYDeviceTypeiPadPro_12inch_2,
    YYDeviceTypeiPadmini,
    YYDeviceTypeiPadmini2,
    YYDeviceTypeiPadmini3,
    YYDeviceTypeiPadmini4,
    YYDeviceTypeiPhone_1G,
    YYDeviceTypeiPhone_3G,
    YYDeviceTypeiPhone_3GS,
    YYDeviceTypeiPhone_4,
    YYDeviceTypeiPhone_4S,
    YYDeviceTypeiPhone_5,
    YYDeviceTypeiPhone_5C,
    YYDeviceTypeiPhone_5S,
    YYDeviceTypeiPhone_6,
    YYDeviceTypeiPhone_6P,
    YYDeviceTypeiPhone_6S,
    YYDeviceTypeiPhone_6SP,
    YYDeviceTypeiPhone_SE,
    YYDeviceTypeiPhone_7,
    YYDeviceTypeiPhone_7P,
    YYDeviceTypeiPhone_7S,
    YYDeviceTypeiPhone_7SP,
    YYDeviceTypeiPhone_8,
    YYDeviceTypeiPhone_8P,
    YYDeviceTypeiPhone_X,
    YYDeviceTypeiPodtouch,
    YYDeviceTypeiPodtouch2,
    YYDeviceTypeiPodtouch3,
    YYDeviceTypeiPodtouch4,
    YYDeviceTypeiPodtouch5,
    YYDeviceTypeiPodtouch6
};

typedef NS_ENUM(NSUInteger, DeviceScreenSize) {
    DeviceScreenSizeMini,
    DeviceScreenSizeMiddle,
    DeviceScreenSizeLarge,
};

@interface NSString (YYDevice)

+ (YYDeviceType)deviceModelName;

+ (DeviceScreenSize)currentDeviceScreenSize;

@end
