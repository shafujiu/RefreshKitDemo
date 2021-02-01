//
//  UIView+Blank.m
//  XTHKOL
//
//  Created by xthk on 2018/10/26.
//  Copyright © 2018年 xthk. All rights reserved.
//

#import "UIView+Blank.h"
//#import "BlankView.h"
#import <objc/runtime.h>
//#import "XTConstant.h"

@implementation UIView (Blank)

const char *__blankView__ = "__blankView__";
const char *__blankAction__ = "__blankAction__";
- (void)showBlankWithImage:(nullable NSString *)image
                     title:(nullable NSString *)title
                  btnTitle:(nullable NSString *)btnTitle
                    action:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
//    BlankView *blankView = objc_getAssociatedObject(self, __blankView__);
//    if (blankView == nil) {
//        blankView = [[BlankView alloc] init];
//        blankView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self addSubview:blankView];
//        [self sendSubviewToBack:blankView];
//        objc_setAssociatedObject(self, __blankView__, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//
//    if (image) {
//        blankView.backgroundColor = [UIColor clearColor];
//    } else {
//        blankView.backgroundColor = [UIColor clearColor];
//    }
//
//    if (!offsetY){
//        offsetY = 0;
//    }
//
//    //修正TableView上对header和footer的遮挡
//    CGFloat y = 0.0;
//    CGFloat height = self.height;
//    if ([self isKindOfClass:[UITableView class]]) {
//        UITableView *tableView = (UITableView *)self;
//
//        y += tableView.tableHeaderView.height ;
//        height -= tableView.tableHeaderView.height + tableView.tableFooterView.height ;
//    }
//
//    //    blankView.frame = CGRectMake(0, 0, self.width, self.height);
//    blankView.frame = CGRectMake(0, y, self.width, height);
//    blankView.image(image).title(title).btnTitle(btnTitle).offsetY(offsetY);
//    if (action) {
//        objc_setAssociatedObject(self, __blankAction__, action, OBJC_ASSOCIATION_COPY);
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__blankAction:)];
//        [blankView addGestureRecognizer:tapGesture];
//    }
}

- (void)showBlankWithImage:(nullable NSString *)image
                     title:(nullable NSString *)title
                  btnTitle:(nullable NSString *)btnTitle
                    action:(nullable void (^)(void))action offsetY:(CGFloat)offsetY disableTouch:(BOOL) disableTouch {
//    BlankView *blankView = objc_getAssociatedObject(self, __blankView__);
//    if (blankView == nil) {
//        blankView = [[BlankView alloc] init];
//        blankView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [self addSubview:blankView];
//        [self sendSubviewToBack:blankView];
//        objc_setAssociatedObject(self, __blankView__, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//
//    if (image) {
//        blankView.backgroundColor = [UIColor clearColor];
//    } else {
//        blankView.backgroundColor = [UIColor clearColor];
//    }
//
//    blankView.userInteractionEnabled = !disableTouch;
//
//    if (!offsetY){
//        offsetY = 0;
//    }
//
//    //修正TableView上对header和footer的遮挡
//    CGFloat y = 0.0;
//    CGFloat height = self.height;
//    if ([self isKindOfClass:[UITableView class]]) {
//        UITableView *tableView = (UITableView *)self;
//
//        y += tableView.tableHeaderView.height ;
//        height -= tableView.tableHeaderView.height + tableView.tableFooterView.height ;
//    }
//
//    //    blankView.frame = CGRectMake(0, 0, self.width, self.height);
//    blankView.frame = CGRectMake(0, y, self.width, height);
//    blankView.image(image).title(title).btnTitle(btnTitle).offsetY(offsetY);
//    if (action) {
//        objc_setAssociatedObject(self, __blankAction__, action, OBJC_ASSOCIATION_COPY);
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__blankAction:)];
//        [blankView addGestureRecognizer:tapGesture];
//    }
}

- (void)showBlankWithImage:(nullable NSString *)image
                     title:(nullable NSString *)title
                  btnTitle:(nullable NSString *)btnTitle
                    action:(nullable void (^)(void))action {
//    [self showBlankWithImage:image title:title btnTitle:btnTitle action:action offsetY:0 disableTouch:NO];
}


- (void)showBlankWithType:(BlankType)type
                    title:(nullable NSString *)title
                 btnTitle:(nullable NSString *)btnTitle
                   action:(nullable void (^)(void))action
                  offsetY:(CGFloat)offsetY{
//    NSString *image = nil;
//    switch (type) {
//        case BlankType_NoData: {
//            image = @"no_data";
//        }break;
//        case BlankType_NoNetWork: {
//            image = @"no_network";
//        }break;
//        case BlankType_LoadFailure: {
//            image = @"failed_to_load";
//        }break;
//    }
//    [self showBlankWithImage:image title:title btnTitle:btnTitle action:action offsetY:offsetY disableTouch:NO];
}
- (void)showBlankWithType:(BlankType)type
                    title:(nullable NSString *)title
                 btnTitle:(nullable NSString *)btnTitle
                   action:(nullable void (^)(void))action {
//    [self showBlankWithType:type title:title btnTitle:btnTitle action:action offsetY:-40];
}

- (void)dismissBlank {
//    BlankView *blankView = objc_getAssociatedObject(self, __blankView__);
//    [blankView removeFromSuperview];
//
//    objc_setAssociatedObject(self, __blankView__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    objc_setAssociatedObject(self, __blankAction__, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**********************************************************************/
#pragma mark -
/**********************************************************************/

//暂无数据
- (void)showBlankNoData:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
//    __weak typeof(self) weakSelf = self;
//    [self showBlankWithType:BlankType_NoData title:action?@"暂无数据，点击刷新":@"暂无数据" btnTitle:nil action:^{
//        if (action) {
//            [weakSelf dismissBlank];
//            action();
//        }
//    } offsetY:offsetY];
}
- (void)showBlankNoData:(nullable void (^)(void))action {
//    [self showBlankNoData:action offsetY:0];
}

//网络断开
- (void)showBlankNoNetWork:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
//    __weak typeof(self) weakSelf = self;
//    [self showBlankWithType:BlankType_NoNetWork title:@"网络已断开，请连接后重试" btnTitle:nil action:^{
//        if (action) {
//            [weakSelf dismissBlank];
//            action();
//        }
//    } offsetY:offsetY];
}
- (void)showBlankNoNetWork:(nullable void (^)(void))action {
//    [self showBlankNoNetWork:action offsetY:0];
}

//加载失败
- (void)showBlankLoadFailure:(nullable void (^)(void))action offsetY:(CGFloat)offsetY {
//    __weak typeof(self) weakSelf = self;
//    [self showBlankWithType:BlankType_LoadFailure title:action?@"加载失败，点击刷新":@"加载失败" btnTitle:nil action:^{
//        if (action) {
//            [weakSelf dismissBlank];
//            action();
//        }
//    } offsetY:offsetY];
}
- (void)showBlankLoadFailure:(nullable void (^)(void))action {
//    [self showBlankLoadFailure:action offsetY:0];
}

/**********************************************************************/
#pragma mark - Action
/**********************************************************************/

- (void)__blankAction:(id)sender {
//    void (^action)(void) = objc_getAssociatedObject(self, __blankAction__);
//    if (action) {
//        action();
//    }
}

@end

