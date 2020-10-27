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

- (instancetype)init
{
    if (self = [super init]) {
        _imageUrl = @"";
    }
    return self;
}

@end

@interface ASPhotoBrowser()

/// 自定义工具栏
@property (nonatomic, strong) ASPhotoToolViewHandler *customToolHandler;
/// 浏览视图
@property (nonatomic, strong) YBImageBrowser *photoBrowser;

@end

@implementation ASPhotoBrowser

- (instancetype)initWithDataSource:(NSArray<ASPhotoModel *> *)dataSource toolHandler:(ASPhotoToolViewHandler * __nullable)toolHandler
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
            if (obj.isRemote) {
                data.imageURL = [NSURL URLWithString:obj.imageUrl];
            }else{
                if (obj.localImage) {
                    data.image = ^UIImage * _Nullable{
                        return obj.localImage;
                    };
                }else{
                    if ([fileManager fileExistsAtPath:obj.imageUrl]) {
                        data.imagePath = obj.imageUrl;
                    }else{
                        data.imageName = obj.imageUrl;
                    }
                }
            }
            if (obj.fromView) data.projectiveView = obj.fromView;
            [datas addObject:data];
        }else if (obj.dataType == ASDataVideo){
            YBIBVideoData *data = [YBIBVideoData new];
            if (obj.isRemote) {
                data.videoURL = [NSURL URLWithString:obj.imageUrl];
            }else{
               if ([fileManager fileExistsAtPath:obj.imageUrl]) {
                    data.videoURL = [NSURL fileURLWithPath:obj.imageUrl];
                }else{
                    NSString *path = [[NSBundle mainBundle] pathForResource:obj.imageUrl.stringByDeletingPathExtension ofType:obj.imageUrl.pathExtension];
                    data.videoURL = [NSURL fileURLWithPath:path];
                }
            }
            if (obj.fromView) data.projectiveView = obj.fromView;
            [datas addObject:data];
        }
    }];
    
    self.photoBrowser = [YBImageBrowser new];
    self.photoBrowser.dataSourceArray = datas;
    self.photoBrowser.toolViewHandlers = @[self.customToolHandler];
}

- (void)initToolHandler:(ASPhotoToolViewHandler * __nullable)toolHandler
{
    if (toolHandler) {
        self.customToolHandler = toolHandler;
    }else{
        self.customToolHandler = [ASPhotoToolViewHandler new];
        self.customToolHandler.canDownload = YES;
        self.customToolHandler.currentPageFontSize = 20;
        self.customToolHandler.totalPageFontSize = 15;
    }
    __strong typeof(self) strongSelf = self;
    [self.customToolHandler setBackClickBlock:^{
        [strongSelf.photoBrowser hide];
        strongSelf.photoBrowser = nil;
        strongSelf.customToolHandler = nil;
        strongSelf.delegate = nil;
    }];
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
