//
//  ASPhotoManager.m
//  ASPhotoBrowserView_Example
//
//  Created by sunpx on 2020/10/30.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import "ASPhotoManager.h"

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
            CGFloat scale = 2;
            CGFloat width = MIN(kViewWidth, kMaxImageWidth);
            CGSize size = CGSizeMake(width*scale, width*scale*model.asset.pixelHeight/model.asset.pixelWidth);
            [self requestImageForAsset:model.asset size:size progressHandler:nil completion:completion];
        }
    }
}

@end
