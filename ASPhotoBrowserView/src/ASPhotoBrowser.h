//
//  ASPhotoBrowser.h
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/6/29.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBImageBrowserDelegate.h>
#import "ASPhotoToolViewHandler.h"

typedef NS_ENUM(NSInteger, ASDataType) {
    /**图片*/
    ASDataImage = 0,
    /**视频*/
    ASDataVideo = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface ASPhotoModel : NSObject

@property (nonatomic, copy) NSString        *originalUrl;   //原图地址
@property (nonatomic, strong) NSString      *originalPath;  //本地原图路径）
@property (nonatomic, strong) UIImage       *originalImage; //本地原图
@property (nonatomic, copy) NSString        *thumbUrl;      //缩略图地址（当不为空时，将使用此地址，优先级大于fromView.image）
@property (nonatomic, strong) UIImage       *thumbImage;    //本地缩略图（当不为空时，将使用此image，优先级大于thumbUrl）
@property (nonatomic, copy) NSString        *imageName;     //本地图片（资源类型）
@property (nonatomic, assign) ASDataType    dataType;       //资源类型
@property (nonatomic, strong) UIView        *fromView;      //映射的父View（当thumbUrl为空、thumbImage为空以及fromView是ImageView时，将使用image作为缩略图）
@property (nonatomic, strong) id            extraData;      //额外扩展参数

@end

@interface ASPhotoBrowser : NSObject

/// 自定义cell，与customCellData捆绑使用，缺一不可（预留，无特殊要求不处理）
@property (nonatomic, strong) UICollectionViewCell *customCell;

/// 自定义cell绑定的data，与customCell捆绑使用，缺一不可（预留，无特殊要求不处理）
@property (nonatomic, strong) NSObject *customCellData;

/// 当前索引
@property (nonatomic, assign) NSInteger currentIndex;

/// 状态回调代理
@property (nonatomic, weak) id<YBImageBrowserDelegate> delegate;

/// 初始化方法
/// @param dataSource 数据源
/// @param toolHandler 自定义工具栏
- (instancetype)initWithDataSource:(NSArray<ASPhotoModel *> *)dataSource toolHandler:(id __nullable)toolHandler;

/// show view
/// @param superView 从指定父视图显示
- (void)showFromSuperView:(UIView * __nullable)superView;

/// 移除数据源中的某个元素（含reload）
/// @param indexes 索引数组
/// @param currentPage 当前索引
- (void)removeDataAtIndex:(NSArray <NSNumber*>*)indexes currentPage:(NSInteger)currentPage;

/// 隐藏
- (void)hide;

@end

NS_ASSUME_NONNULL_END
