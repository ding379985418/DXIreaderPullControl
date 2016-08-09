# DXIreaderPullControl ———仿iReader阅读器下拉效果
---- 
## 一、说明：
本控件模仿iReader阅读器下拉效果，主要原理为利用下拉距离为变量，使用贝塞尔曲线绘制“小书”，最后仿照系统刷新控件UIRefreshControl的API来自定义下拉展示控件。
## 二、效果图
![][image-1]
## 三、使用方法（参考文件夹中的demo）
1、DXIreaderPullControl文件夹拖入项目中

2、实例化控件并添加到父控件中,设置Target

	DXIreaderPullControl *control = [DXIreaderPullControl new];
	    control.containViewHeight = 150;
	    [scrollView addSubview:control];
	    [control addTarget:self action:@selector(controlChange:) forControlEvents:UIControlEventValueChanged];
	    
3、实现监听方法

	- (void)controlChange:(DXIreaderPullControl *)sender{
	}
	
## 四、主要API介绍
	///不用初始化可以添加一个自定义的视图,直接可以拿到
	@property (nonatomic, strong) UIView *containView;
	///containViewHeight ,默认为100
	@property (nonatomic, assign) CGFloat containViewHeight;
	///结束展示
	- (void)endPullShow;

[image-1]:	https://github.com/ding379985418/DXIreaderPullControl/blob/master/DXIreaderPullControl.gif "动画效果图"