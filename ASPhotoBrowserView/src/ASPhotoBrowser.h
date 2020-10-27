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

@property (nonatomic, copy) NSString *imageUrl;     //资源地址（本地path或远程url）
@property (nonatomic, assign) ASDataType dataType;  //资源类型
@property (nonatomic, assign) BOOL isRemote;        //是否远程资源
@property (nonatomic, strong) UIView *fromView;     //映射的父View
@property (nonatomic, strong) UIImage *localImage;  //本地图片

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
- (instancetype)initWithDataSource:(NSArray<ASPhotoModel *> *)dataSource toolHandler:(ASPhotoToolViewHandler * __nullable)toolHandler;

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
