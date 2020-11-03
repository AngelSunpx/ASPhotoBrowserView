//
//  ASPhotoBrowser.m
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/6/29.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import "ASPhotoBrowser.h"
#import <YBImageBrowser/YBImageBrowser.h>
#import <YBImageBrowser/YBIBVideoData.h>

@implementation ASPhotoModel

@end

@interface ASPhotoBrowser()

/// 自定义工具栏
@property (nonatomic, strong) id customToolHandler;
/// 浏览视图
@property (nonatomic, strong) YBImageBrowser *photoBrowser;

@end

@implementation ASPhotoBrowser

- (instancetype)initWithDataSource:(NSArray<ASPhotoModel *> *)dataSource toolHandler:(id __nullable)toolHandler
{
    if (self = [super init]) {
        [self initToolHandler:toolHandler];
        [self initPhotoBrowser:dataSource];
    }
    return self;
}

- (void)initPhotoBrowser:(NSArray *)dataSource
{
    NSMutableArray *datas = [NSMutableArray array];
    [dataSource enumerateObjectsUsingBlock:^(ASPhotoModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (obj.dataType == ASDataImage) {
            YBIBImageData *data = [YBIBImageData new];
            data.defaultLayout.verticalFillType = YBIBImageFillTypeFullWidth;
            
            if (obj.originalUrl)  data.imageURL = [NSURL URLWithString:obj.originalUrl];
            if (obj.originalPath) data.imagePath = obj.originalPath;
            if (obj.originalImage) {
                data.image = ^UIImage * _Nullable{
                    return obj.originalImage;
                };
            }
            if (obj.thumbUrl) data.thumbURL = [NSURL URLWithString:obj.thumbUrl];
            if (obj.thumbImage) data.thumbImage = obj.thumbImage;
            if (obj.imageName) data.imageName = obj.imageName;
            if (obj.fromView) data.projectiveView = obj.fromView;
            if (obj.extraData) data.extraData = obj.extraData;
            [datas addObject:data];
        }else if (obj.dataType == ASDataVideo){
            YBIBVideoData *data = [YBIBVideoData new];
            if (obj.originalUrl) {
                data.videoURL = [NSURL URLWithString:obj.originalUrl];
            }else{
                if (obj.originalPath) {
                    if ([fileManager fileExistsAtPath:obj.originalPath]) {
                         data.videoURL = [NSURL fileURLWithPath:obj.originalPath];
                     }else{
                         NSString *path = [[NSBundle mainBundle] pathForResource:obj.originalPath.stringByDeletingPathExtension ofType:obj.originalPath.pathExtension];
                         data.videoURL = [NSURL fileURLWithPath:path];
                     }
                }else{
                    NSString *path = [[NSBundle mainBundle] pathForResource:obj.originalPath.stringByDeletingPathExtension ofType:obj.originalPath.pathExtension];
                    data.videoURL = [NSURL fileURLWithPath:path];
                }
            }
            if (obj.fromView) data.projectiveView = obj.fromView;
            if (obj.extraData) data.extraData = obj.extraData;
            [datas addObject:data];
        }
    }];
    
    self.photoBrowser = [YBImageBrowser new];
    self.photoBrowser.dataSourceArray = datas;
    self.photoBrowser.toolViewHandlers = @[self.customToolHandler];
}

- (void)initToolHandler:(id __nullable)toolHandler
{
    if (toolHandler) {
        self.customToolHandler = toolHandler;
    }else{
        self.customToolHandler = [ASPhotoToolViewHandler new];
        ((ASPhotoToolViewHandler*)self.customToolHandler).canDownload = YES;
        ((ASPhotoToolViewHandler*)self.customToolHandler).currentPageFontSize = 20;
        ((ASPhotoToolViewHandler*)self.customToolHandler).totalPageFontSize = 15;
        
        __strong typeof(self) strongSelf = self;
        [((ASPhotoToolViewHandler*)self.customToolHandler) setBackClickBlock:^{
            [strongSelf.photoBrowser hide];
            strongSelf.photoBrowser = nil;
            strongSelf.customToolHandler = nil;
            strongSelf.delegate = nil;
        }];
    }
}

- (void)showFromSuperView:(UIView * __nullable)superView
{
    self.photoBrowser.currentPage = self.currentIndex;
    if (self.delegate) {
        self.photoBrowser.delegate = self.delegate;
    }
    if (superView) {
        [self.photoBrowser showToView:superView];
    }else{
        [self.photoBrowser show];
    }
}

- (void)removeDataAtIndex:(NSArray <NSNumber*>*)indexes currentPage:(NSInteger)currentPage
{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:self.photoBrowser.dataSourceArray];
    for (NSNumber *indexNum in indexes) {
        [tmpArr removeObjectAtIndex:[indexNum unsignedIntegerValue]];
    }
    self.photoBrowser.dataSourceArray = tmpArr;
    [self.photoBrowser reloadData];
    [self.photoBrowser setCurrentPage:currentPage];
}

- (void)hide
{
    [self.photoBrowser hide];
}

@end
