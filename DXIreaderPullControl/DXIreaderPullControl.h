//
//  DXIreaderPull.h
//  iReader
//
//  Created by simon on 16/8/9.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXIreaderPullControl : UIControl
///不用初始化可以添加一个自定义的视图,直接可以拿到
@property (nonatomic, strong) UIView *containView;
///containViewHeight ,默认为100
@property (nonatomic, assign) CGFloat containViewHeight;

///结束展示
- (void)endPullShow;
@end
