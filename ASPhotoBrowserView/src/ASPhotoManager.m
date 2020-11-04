//
//  ASPhotoManager.m
//  ASPhotoBrowserView_Example
//
//  Created by sunpx on 2020/10/30.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import "ASPhotoManager.h"
#import <sys/utsname.h>

typedef NS_ENUM(NSInteger, ASDeviceType) {
    /**6S之前的设备（包含6S）*/
    ASDevice_6SBefore = 0,
    /**7-X之间的设备*/
    ASDevice_7To10 = 1,
    /**11之后的设备（包含11）*/
    ASDevice_11After = 2,
    /**其他设备（如iTV、iPad等）*/
    ASDevice_Others = 3,
};

@implementation ASPhotoManager

+ (void)requestSelectedImageOrDataForAsset:(ZLPhotoModel *)model isOriginal:(BOOL)isOriginal allowSelectGif:(BOOL)allowSelectGif completion:(void (^)(id, NSDictionary *))completion
{
    if (model.type == ZLAssetMediaTypeGif && allowSelectGif) {
        [self requestOriginalImageDataForAsset:model.asset progressHandler:nil completion:^(NSData *data, NSDictionary *info) {
            if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                if (completion) {
                    completion(data, info);
                }
            }
        }];
    } else {
        if (isOriginal) {
            [self requestOriginalImageForAsset:model.asset progressHandler:nil completion:completion];
        } else {
            CGFloat targetLength = [self getLegalImageLengthForAllDevice];
            CGSize size = CGSizeMake(targetLength, targetLength*model.asset.pixelHeight/model.asset.pixelWidth);
            [self requestImageForAsset:model.asset size:size progressHandler:nil completion:completion];
        }
    }
}

+ (CGFloat)getLegalImageLengthForAllDevice
{
    CGFloat targetLength = 2000;
    switch ([self getCurrentDeviceType]) {
        case ASDevice_6SBefore:
        {
            targetLength = 2000;
        }
            break;
        case ASDevice_7To10:
        {
            targetLength = 4000;
        }
            break;
        case ASDevice_11After:
        {
            targetLength = 8000;
        }
            break;
            
        default:
        {
            targetLength = 10000;
        }
            break;
    }
    return targetLength;
}

+ (ASDeviceType)getCurrentDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel containsString:@"iPhone"]) {
        NSUInteger commaLocation = [deviceModel rangeOfString:@","].location;
        NSString *seriesPrefix = [deviceModel substringWithRange:NSMakeRange(6, commaLocation-6)];
        if ([seriesPrefix integerValue] < 9) {
            return ASDevice_6SBefore;
        }else if ([seriesPrefix integerValue] < 11){
            return ASDevice_7To10;
        }else{
            return ASDevice_11After;
        }
    }else{
        return ASDevice_Others;
    }
}

@end
