//
//  DXIreaderPull.m
//  iReader
//
//  Created by simon on 16/8/9.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import "DXIreaderPullControl.h"
#import "DXIreader.h"
#define KControlHeight 70
/// 刷新状态枚举
/// - Normal:       默认状态或者松开手就回到默认状态
/// - Pulling:   `将要展示` - 松开手就进入展示的状态
/// - Showing:   正在展示状态
typedef enum : NSUInteger {
    Normal,
    Pulling,
    Showing,
} DXIreaderPullControlState;
@interface DXIreaderPullControl()
/// 父视图 - 滚动视图
@property (nonatomic, weak) UIScrollView *scrollView;
/// 刷新控件状态
@property (nonatomic, assign) DXIreaderPullControlState showControlState;
// 之前的状态，用于在设置成 `Normal` 时，判断之前的状态是否是 `Showing` 状态
@property (nonatomic, assign) DXIreaderPullControlState preShowContrlState;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong)  DXIreader *ireaderView;
@end

@implementation DXIreaderPullControl
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.containViewHeight = KControlHeight;
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.ireaderView.backgroundColor = [UIColor clearColor];
    self.containView.backgroundColor = [UIColor whiteColor];
    [self bringSubviewToFront:self.containView];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (UIScrollView *)newSuperview;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.frame = CGRectMake(0, -KControlHeight,/** -self.containViewHeight,**/ self.scrollView.bounds.size.width, KControlHeight);//self.containViewHeight);
        self.containViewHeight = self.containViewHeight;
    }
}

- (void)endPullShow{
    self.showControlState = Normal;

}

#pragma mark -私有方法
- (void)modifyInset:(CGFloat)offset {
    // 恢复顶部滑动距离
    UIEdgeInsets inset = self.scrollView.contentInset;
    inset.top += offset;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.contentInset = inset;
        self.scrollView.contentOffset = CGPointMake(0, -inset.top);
    }];
}
#pragma mark -setter方法
- (void)setContainViewHeight:(CGFloat)containViewHeight{
    _containViewHeight = containViewHeight;
//    self.containView.bounds = CGRectMake(0, 0, self.bounds.size.width, containViewHeight);
    self.containView.frame = CGRectMake(0, KControlHeight - containViewHeight, self.bounds.size.width, containViewHeight);
    

}
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    _ireaderView.progress = progress;
}

- (void)setShowControlState:(DXIreaderPullControlState)showControlState{
    _showControlState = showControlState;
    switch (_showControlState) {
        case Pulling:
            _ireaderView.hidden = NO;
            break;
            
        case Showing:{
            // 增加顶部滑动距离
            [self modifyInset:self.containViewHeight];
            self.containView.hidden = NO;
            _ireaderView.hidden = YES;
            // 发送数值变化事件
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
            break;
            
        case Normal:{
        
        if (self.preShowContrlState == Showing) {
            [self modifyInset:-self.containViewHeight];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.containView.hidden = YES;
                _ireaderView.hidden = NO;
                
            });
        }
            break;
    }
     self.preShowContrlState = showControlState;
    }


#pragma mark -KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    // 1. 判断父视图偏移量
    if (self.scrollView.contentOffset.y > 0) {
        return;
    }
    // 2. 计算偏移量
    CGFloat contentInsetTop = self.scrollView.contentInset.top;
    CGFloat conditionValue = -contentInsetTop - KControlHeight;//self.containViewHeight;
    // 3. 判断是否正在拖拽 UIScrollView
    if (self.scrollView.dragging) {
        if (self.showControlState == Normal && (self.scrollView.contentOffset.y < conditionValue)) {
            
            self.showControlState = Pulling;
        } else if (self.showControlState == Pulling && (self.scrollView.contentOffset.y >= conditionValue)) {
            self.showControlState = Normal;
            
        }
        if (self.showControlState == Showing){
            self.progress = 1.f;
            
            if (self.scrollView.contentOffset.y > -self.containViewHeight + 10) {
                [self endPullShow];
            }
        }else{
            self.progress = (self.scrollView.contentOffset.y + 40)/conditionValue;
        }
        
    } else {
        // 用户松手的时候会执行
        if (self.showControlState == Pulling) {
            self.showControlState = Showing;
        }
    }
    
    NSLog(@"-contentInsetTop:%F-conditionValue:%f--contentOffset:%f",contentInsetTop,conditionValue,self.scrollView.contentOffset.y);
}

#pragma mark -懒加载
- (DXIreader *)ireaderView{
    if (!_ireaderView) {
        _ireaderView = [DXIreader new];
        _ireaderView.progress = 0;
        _ireaderView.bounds = self.bounds;
        _ireaderView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        [self addSubview:_ireaderView];
    }
    
    return _ireaderView;
}

- (UIView *)containView{
    if (!_containView) {
        _containView = [UIView new];
        _containView.bounds = self.bounds;
        _containView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        _containView.hidden = YES;
        _containView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_containView];
    }
    return _containView;
}

#pragma mark -dealloc

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];

}

@end
