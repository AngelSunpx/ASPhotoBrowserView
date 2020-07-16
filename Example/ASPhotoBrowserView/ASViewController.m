//
//  ASViewController.m
//  ASPhotoBrowserView
//
//  Created by AngelSunpx on 07/16/2020.
//  Copyright (c) 2020 AngelSunpx. All rights reserved.
//

#import "ASViewController.h"
#import "ASPhotoBrowser.h"
#import "ASPhotoPicker.h"

@interface ASViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
        _tableView.rowHeight = 45;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identity = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"相册浏览";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"拍照";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"选择图片";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    if (indexPath.row == 0) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < 6; i ++) {
            ASPhotoModel *photoModel = [[ASPhotoModel alloc] init];
            if (i == 0){
                photoModel.dataType = 0;
                photoModel.isRemote = NO;
                photoModel.imageUrl = @"localImage0.jpg";
            }else if (i == 1) {
                photoModel.dataType = 0;
                photoModel.isRemote = YES;
                photoModel.imageUrl = @"http://gss0.baidu.com/-fo3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/aec379310a55b31905caba3b43a98226cffc1748.jpg";
            }else if (i == 2) {
                photoModel.dataType = 0;
                photoModel.isRemote = NO;
                photoModel.imageUrl = @"localImage1.gif";
            }else if (i == 3) {
                photoModel.dataType = 1;
                photoModel.isRemote = NO;
                photoModel.imageUrl = @"localVideo0.mp4";
            }else if (i == 4){
                photoModel.dataType = 1;
                photoModel.isRemote = YES;
                photoModel.imageUrl = @"https://aweme.snssdk.com/aweme/v1/playwm/?video_id=v0200ff00000bdkpfpdd2r6fb5kf6m50&line=0.mp4";
            }else if (i == 5){
                photoModel.dataType = 0;
                photoModel.isRemote = YES;
                photoModel.imageUrl = @"http://attachments.gfan.com/forum/attachments2/day_120501/1205012009f594464a3d69a145.jpg";
            }
            [arr addObject:photoModel];
        }
        ASPhotoBrowser *photoBrowser = [[ASPhotoBrowser alloc] initWithDataSource:arr toolHandler:nil];
        [photoBrowser showFromSuperView:nil];
    }else if (indexPath.row == 1){
        ASPhotoPicker *photoPicker = [[ASPhotoPicker alloc] init];
        photoPicker.allowTakePhoto = YES;
        photoPicker.allowTakeVideo = YES;
        photoPicker.maxRecordDuration = 30;
        photoPicker.circleProgressColor = [UIColor colorWithRed:86/255.0 green:119/255.0 blue:251/255.0 alpha:1];//238,120,0
        photoPicker.sessionPreset = ZLCaptureSessionPreset640x480;
        photoPicker.videoType = ZLExportVideoTypeMp4;
        photoPicker.doneBlock = ^(UIImage * _Nonnull image, NSURL * _Nonnull videoUrl) {
            
        };
        [photoPicker openCameraFromSender:self];
    }else if (indexPath.row == 2){
        ASPhotoPicker *photoPicker = [[ASPhotoPicker alloc] init];
        photoPicker.allowTakePhoto = NO;
        photoPicker.allowTakeVideo = YES;
        photoPicker.maxSelectCount = 9;
        photoPicker.maxPreviewCount = 0;
        photoPicker.maxRecordDuration = 30;
        photoPicker.allowOpenCamera = NO;
        photoPicker.circleProgressColor = [UIColor colorWithRed:86/255.0 green:119/255.0 blue:251/255.0 alpha:1];//238,120,0
        photoPicker.allowEditVideo = YES;
        photoPicker.sessionPreset = ZLCaptureSessionPreset640x480;
        photoPicker.videoType = ZLExportVideoTypeMp4;
        photoPicker.selectImageBlock = ^(NSArray<UIImage *> * _Nullable images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            NSLog(@"%@",images);
        };
        [photoPicker openLibraryFromSender:self animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
