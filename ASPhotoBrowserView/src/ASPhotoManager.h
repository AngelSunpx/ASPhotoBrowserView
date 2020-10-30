//
//  ASPhotoManager.h
//  ASPhotoBrowserView_Example
//
//  Created by sunpx on 2020/10/30.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPhotoManager : ZLPhotoManager

/// 获取图片或动图
/// @param model ZLPhotoModel
/// @param isOriginal 是否原图
/// @param allowSelectGif 是否可以选择动图
/// @param completion 结果回调
+ (void)requestSelectedImageOrDataForAsset:(ZLPhotoModel *)model isOriginal:(BOOL)isOriginal allowSelectGif:(BOOL)allowSelectGif completion:(void (^)(id, NSDictionary *))completion;

@end

NS_ASSUME_NONNULL_END
