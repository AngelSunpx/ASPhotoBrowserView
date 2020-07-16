//
//  ASPhotoToolViewHandler.m
//  ASPhotoBrowserView_Example
//
//  Created by 孙攀翔 on 2020/7/1.
//  Copyright © 2020 AngelSunpx. All rights reserved.
//

#import "ASPhotoToolViewHandler.h"
#import <YBImageBrowser/YBIBImageData.h>
#import <YBImageBrowser/YBIBToastView.h>
#import <YBImageBrowser/YBIBUtilities.h>
#import <SDWebImage/SDWebImage.h>

#define kIsBangsScreen ({\
    BOOL isBangsScreen = NO; \
    if (@available(iOS 11.0, *)) { \
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject]; \
    isBangsScreen = window.safeAreaInsets.bottom > 0; \
    } \
    isBangsScreen; \
})

@interface ASPhotoToolViewHandler ()

@property (nonatomic, strong) UIView *toolSuperView;
@property (nonatomic, strong) UIButton *downloadButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel  *pageLabel;

@end

@implementation ASPhotoToolViewHandler

#pragma mark - <YBIBToolViewHandler>

@synthesize yb_containerView = _yb_containerView;
@synthesize yb_currentData = _yb_currentData;
@synthesize yb_containerSize = _yb_containerSize;
@synthesize yb_currentOrientation = _yb_currentOrientation;
@synthesize yb_currentPage = _yb_currentPage;
@synthesize yb_totalPage = _yb_totalPage;

- (void)yb_containerViewIsReadied {
    [self.yb_containerView addSubview:self.toolSuperView];
}

- (void)yb_hide:(BOOL)hide {
    self.toolSuperView.hidden = hide;
}

- (void)yb_pageChanged {
    [self setPage:self.yb_currentPage() totalPage:self.yb_totalPage()];
}

- (void)yb_orientationChangeAnimationWithExpectOrientation:(UIDeviceOrientation)orientation {
    [self layoutWithExpectOrientation:orientation];
}

#pragma mark - private

- (void)updateViewOriginButtonSize {
    CGSize size = self.toolSuperView.intrinsicContentSize;
    self.toolSuperView.bounds = (CGRect){CGPointZero, CGSizeMake(size.width + 15, size.height)};
}

- (void)setPage:(NSInteger)page totalPage:(NSInteger)totalPage {
    if (totalPage <= 1) {
        self.pageLabel.hidden = YES;
    } else {
        self.pageLabel.hidden  = NO;
        
        NSString *currentPageStr = [NSString stringWithFormat:@"%ld", page + (NSInteger)1];
        NSString *totalPageStr = [NSString stringWithFormat:@"%ld", totalPage];
        NSString *text = [NSString stringWithFormat:@"%@/%@", currentPageStr, totalPageStr];
        
        NSShadow *shadow = [NSShadow new];
        shadow.shadowBlurRadius = 4;
        shadow.shadowOffset = CGSizeMake(0, 1);
        shadow.shadowColor = UIColor.darkGrayColor;
        //当前页码
        UIFont *currentFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        if (_currentPageFontSize > 0) {
            currentFont = [UIFont fontWithName:@"HelveticaNeue" size:_currentPageFontSize];
        }
        //总页码
        UIFont *totalFont = [UIFont fontWithName:@"HelveticaNeue" size:15];
        if (_totalPageFontSize > 0) {
            totalFont = [UIFont fontWithName:@"HelveticaNeue" size:_totalPageFontSize];
        }
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSShadowAttributeName:shadow}];
        [attr addAttribute:NSFontAttributeName value:currentFont range:NSMakeRange(0, currentPageStr.length)];
        [attr addAttribute:NSFontAttributeName value:totalFont range:NSMakeRange(currentPageStr.length, totalPageStr.length+1)];
        self.pageLabel.attributedText = attr;
    }
}

- (void)layoutWithExpectOrientation:(UIDeviceOrientation)orientation {
    CGSize containerSize = self.yb_containerSize(orientation);
    UIEdgeInsets padding = YBIBPaddingByBrowserOrientation(orientation);
    
    self.toolSuperView.frame = CGRectMake(padding.left, padding.top, containerSize.width - padding.left - padding.right, 40);
}

#pragma mark - event

- (void)downloadClick
{
    YBIBImageData *data = self.yb_currentData();
    [data yb_saveToPhotoAlbum];
}

- (void)backClick
{
    if (self.backClickBlock) {
        self.backClickBlock();
    }
}

#pragma mark - getters

- (UIView *)toolSuperView {
    if (!_toolSuperView) {
        _toolSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, (kIsBangsScreen?64:20), [UIScreen mainScreen].bounds.size.width, 40)];
        _toolSuperView.backgroundColor = [UIColor clearColor];
        
        [_toolSuperView addSubview:self.backButton];
        [_toolSuperView addSubview:self.pageLabel];
        if (_canDownload) {
            [_toolSuperView addSubview:self.downloadButton];
        }
    }
    return _toolSuperView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, 0, 40, 40);
        if (_backBtnImg) {
            [_backButton setImage:_backBtnImg forState:UIControlStateNormal];
        }else{
            [_backButton setImage:[UIImage imageNamed:@"back_button_white"] forState:UIControlStateNormal];
        }
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-100)/2.0, 0, 100, 40)];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        if (_pageTitleColor) {
            _pageLabel.textColor = _pageTitleColor;
        }else{
            _pageLabel.textColor = [UIColor whiteColor];
        }
    }
    return _pageLabel;
}

- (UIButton *)downloadButton {
    if (!_downloadButton) {
        _downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 0, 40, 40);
        if (_downloadBtnImg) {
            [_downloadButton setImage:_downloadBtnImg forState:UIControlStateNormal];
        }else{
            [_downloadButton setImage:[UIImage imageNamed:@"icon_im_avplayerDown"] forState:UIControlStateNormal];
        }
        [_downloadButton addTarget:self action:@selector(downloadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadButton;
}

@end
