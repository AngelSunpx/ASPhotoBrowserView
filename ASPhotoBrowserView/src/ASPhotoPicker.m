//
//  ASPhotoPicker.m
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/6/29.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import "ASPhotoPicker.h"
#import <ZLPhotoBrowser/ZLPhotoBrowser.h>

@implementation ASPhotoPicker

- (void)openCameraFromSender:(UIViewController *)sender
{
    ZLCustomCamera *camera = [[ZLCustomCamera alloc] init];
    camera.allowTakePhoto = self.allowTakePhoto;
    camera.allowRecordVideo = self.allowTakeVideo;
    camera.circleProgressColor = self.circleProgressColor;
    camera.maxRecordDuration = self.maxRecordDuration;
    camera.doneBlock = ^(UIImage *image, NSURL *videoUrl) {
        if (self.savePhotoToAlbum) {
            if(image) {
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:),nil);
            }
        }
        if (self.saveVideoToAlbum) {
            if (videoUrl) {
                if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoUrl.path)) {
                    //保存相册核心代码
                    UISaveVideoAtPathToSavedPhotosAlbum(videoUrl.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
                }
            }
        }
        if (self.doneBlock) {
            self.doneBlock(image, videoUrl);
        }
    };
    [sender showDetailViewController:camera sender:nil];
}
    
#pragma mark -- <保存到相册>
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo: (void*)contextInfo {
    if(error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
    }else{
        NSLog(@"保存图片成功");
    }
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败：%@", error);
    } else {
        NSLog(@"保存视频成功");
    }
}

#pragma mark -- <打开相册>
- (void)openLibraryFromSender:(UIViewController *)sender animated:(BOOL)animated
{
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];

    // 相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = self.maxSelectCount;
    ac.configuration.maxPreviewCount = self.maxPreviewCount;
    ac.configuration.allowEditVideo = self.allowEditVideo;
    ac.configuration.allowSelectVideo = self.allowTakeVideo;
    ac.configuration.allowSelectImage = self.allowTakePhoto;
    ac.configuration.maxRecordDuration = self.maxRecordDuration;
    ac.configuration.maxVideoDuration = self.maxRecordDuration;
    ac.configuration.maxEditVideoTime = self.maxRecordDuration;
    ac.configuration.cameraProgressColor = self.circleProgressColor;
    ac.configuration.allowTakePhotoInLibrary = self.allowOpenCamera;

    //如调用的方法无sender参数，则该参数必传
    ac.sender = sender;

    // 选择回调
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        if (self.selectImageBlock) {
            self.selectImageBlock(images, assets, isOriginal);
        }
    }];
    // 调用相册
    if (animated) {
        [ac showPreviewAnimated:YES];
    }else{
        [ac showPhotoLibrary];
    }
}

@end
