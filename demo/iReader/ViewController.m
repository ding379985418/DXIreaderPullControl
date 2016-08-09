//
//  ViewController.m
//  iReader
//
//  Created by simon on 16/8/6.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import "ViewController.h"
#import "DXIreader.h"
#import "DXIreaderPullControl.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, strong)   DXIreader *reader;
@end

@implementation ViewController

- (void)awakeFromNib{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    bar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithRed:0.231 green:0.098 blue:0.078 alpha:1.00]};
    self.title = @"模仿iReader下拉效果";

}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scrollBg"]];
    [self.view addSubview:scrollView];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height + 30)];
    imgView.image = [UIImage imageNamed:@"scroll"];
    [scrollView addSubview:imgView];
    scrollView.contentSize = imgView.bounds.size;

    
    DXIreaderPullControl *control = [DXIreaderPullControl new];
    control.containViewHeight = 150;
    [scrollView addSubview:control];
    [control addTarget:self action:@selector(controlChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)controlChange:(DXIreaderPullControl *)sender{
    UIImageView *show = [[UIImageView alloc]initWithFrame:sender.containView.bounds];

    show.image = [UIImage imageNamed:@"show"];
    [sender.containView addSubview:show];

}
- (IBAction)sliderValueDidChanged:(UISlider *)sender {
    _reader.progress = sender.value;
    
}


@end
