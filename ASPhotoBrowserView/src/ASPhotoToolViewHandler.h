//
//  ASPhotoToolViewHandler.h
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/7/1.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBIBToolViewHandler.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASPhotoToolViewHandler : NSObject <YBIBToolViewHandler>

/// 点击返回按钮
@property (nonatomic, strong, nullable) void(^backClickBlock)(void);
/// 当前页字体大小，默认是15
@property (nonatomic, assign) float currentPageFontSize;
/// 当前页字体大小，默认是15
@property (nonatomic, assign) float totalPageFontSize;
/// 页码字体颜色，默认是白色
@property (nonatomic, strong) UIColor *pageTitleColor;
/// 返回按钮图片，默认是白色箭头
@property (nonatomic, strong) UIImage *backBtnImg;
/// 下载保存图片，有默认图
@property (nonatomic, strong) UIImage *downloadBtnImg;
/// 是否支持下载保存
@property (nonatomic, assign) BOOL canDownload;

@end

NS_ASSUME_NONNULL_END
