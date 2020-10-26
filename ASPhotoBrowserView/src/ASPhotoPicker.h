//
//  ASPhotoPicker.h
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/6/29.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ZLPhotoBrowser/ZLDefine.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

@interface ASPhotoPicker : NSObject

#pragma -mark -----公用相关-----
/**
 是否允许拍摄或选取照片
*/
@property (nonatomic, assign) BOOL allowTakePhoto;

/**
 是否允许录制或选取视频
*/
@property (nonatomic, assign) BOOL allowTakeVideo;

/**
 最大录制时长 默认15s
*/
@property (nonatomic, assign) NSInteger maxRecordDuration;

/**
 录制视频时候进度条颜色 默认 rgb(80, 169, 56)
*/
@property (nonatomic, strong) UIColor *circleProgressColor;

/**
 视频分辨率 默认 ZLCaptureSessionPreset1280x720
*/
@property (nonatomic, assign) ZLCaptureSessionPreset sessionPreset;

/**
 视频格式 默认 ZLExportVideoTypeMp4
*/
@property (nonatomic, assign) ZLExportVideoType videoType;

#pragma -mark -----拍摄相关-----
/**
 确定回调，如果拍照则videoUrl为nil，如果视频则image为nil
 */
@property (nonatomic, copy, nullable) void (^doneBlock)(UIImage *image, NSURL *videoUrl);

/**
 拍完照是否保存图片到相册
*/
@property (nonatomic, assign) BOOL savePhotoToAlbum;

/**
 录制完是否保存视频到相册
*/
@property (nonatomic, assign) BOOL saveVideoToAlbum;

/**
 打开相机,sender为父视图
*/
- (void)openCameraFromSender:(UIViewController *)sender;

#pragma -mark -----相册相关-----
/**
 选择图片回调
*/
@property (nonatomic, copy, nullable) void (^selectImageBlock)(NSArray<UIImage *> *_Nullable images, NSArray<PHAsset *> *assets, BOOL isOriginal);

/**
 最大选择数 默认9张，最小 1
*/
@property (nonatomic, assign) NSInteger maxSelectCount;

/**
 预览图最大显示数 默认20张，该值为0时将不显示上方预览图，仅显示 '拍照、相册、取消' 按钮
*/
@property (nonatomic, assign) NSInteger maxPreviewCount;

/**
 是否允许编辑视频
*/
@property (nonatomic, assign) BOOL allowEditVideo;

/**
 是否支持在相册内拍摄
*/
@property (nonatomic, assign) BOOL allowOpenCamera;

/**
 底部工具条背景色，默认 rgb(44, 45, 46)
 */
@property (nonatomic, strong) UIColor *bottomViewBgColor;

/**
 导航条背景色，默认 rgb(44, 45, 46)
 */
@property (nonatomic, strong) UIColor *navBarColor;

/**
 底部工具栏按钮 可交互 状态背景颜色，默认rgb(80, 169, 56)
 */
@property (nonatomic, strong) UIColor *bottomBtnsNormalBgColor;

/**
 底部工具栏按钮 不可交互 状态背景颜色，默认rgb(39, 80, 32)
 */
@property (nonatomic, strong) UIColor *bottomBtnsDisableBgColor;

/**
 选中图片右上角index background color, 默认rgb(80, 169, 56)
 */
@property (nonatomic, strong) UIColor *indexLabelBgColor;

/**
 打开相册,sender为父视图
*/
- (void)openLibraryFromSender:(UIViewController *)sender animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
