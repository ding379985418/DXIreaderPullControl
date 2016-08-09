//
//  DXIreader.m
//  iReader
//
//  Created by simon on 16/8/6.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import "DXIreader.h"
#define kCircleRadius 25  //圆的半径
#define kSquarenessWith kCircleRadius * 0.9 //外框的宽度
#define kFactorOfWithHeight 1.3  //外框的长度与宽度的比
@interface DXIreaderLayer:CALayer
@property (nonatomic, assign) CGFloat progress;//进度

@end

@implementation DXIreaderLayer

- (void)setProgress:(CGFloat)progress{
    _progress = MAX( MIN(progress, 1), 0);
    [self setNeedsDisplay];
    NSLog(@"%f",progress);
}
- (void)drawInContext:(CGContextRef)ctx{
    [super drawInContext:ctx];
    UIGraphicsPushContext(ctx);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_progress < 1.f) {
        [[UIColor colorWithRed:0.125 green:0.133 blue:0.149 alpha:0.5] setStroke];
    }else{
    [[UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.00] setStroke];
    }
    
    CGSize layerSize = self.frame.size;
    CGPoint layerCenter = CGPointMake(layerSize.width * 0.5, layerSize.height *0.5);
//    layer本身的size
    CGFloat startAngle = M_PI / 2;//-M_PI *3/2;
    CGFloat endAngle = -2*M_PI * _progress + startAngle;
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:layerCenter radius:kCircleRadius startAngle:startAngle endAngle:endAngle clockwise:NO];
//    第一外边框线
    CGFloat completefactor = 0.8;
    UIBezierPath *squarenessPath1 = [UIBezierPath bezierPath];
    CGFloat L = kSquarenessWith;
    CGFloat H = kFactorOfWithHeight * kSquarenessWith ;
    CGFloat factor = 0.3;
    CGFloat factor1 = 0.25;
    CGPoint point_A = CGPointMake(layerCenter.x - L *factor, layerCenter.y - H* 0.5);
    CGPoint point_B = CGPointMake(layerCenter.x + L *0.5, layerCenter.y - H* 0.5);
    CGPoint point_C = CGPointMake(layerCenter.x + L *0.5, layerCenter.y + H* 0.5);
    CGPoint point_D = CGPointMake(layerCenter.x - L *factor1, layerCenter.y + H* 0.5);
    CGPoint point_M = CGPointMake(layerCenter.x - L *0.5, layerCenter.y + H* 0.5 -(0.5 - factor1)*L);
    CGPoint point_E = CGPointMake(layerCenter.x - L *0.5, layerCenter.y - H* 0.5 + (0.5 - factor) * L);
    CGFloat x1 = 0;
    CGFloat y1 = 0;
    CGFloat path1Radius = (0.5 - factor) * L;
    CGFloat path2Radius = (0.5 - factor1) * L;
    if (_progress < 0.2 * completefactor ) {
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:point_A];
        x1 = 5 * _progress * L/completefactor + point_A.x;
        y1 = point_A.y;
        [path1 addLineToPoint:CGPointMake(x1, y1)];
        [squarenessPath1 appendPath:path1];

      }else if(_progress < 0.4 * completefactor){
          [squarenessPath1 moveToPoint:point_A];
          [squarenessPath1 addLineToPoint:point_B];
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:point_B];
        x1 = point_B.x;
        y1 = 10 * _progress * H /4/completefactor + point_B.y;
        [path2 addLineToPoint:CGPointMake(x1, y1)];
        [squarenessPath1 appendPath:path2];
    }else if (_progress < 0.6 * completefactor){
        [squarenessPath1 moveToPoint:point_A];
        [squarenessPath1 addLineToPoint:point_B];
        [squarenessPath1 moveToPoint:point_B];
        [squarenessPath1 addLineToPoint:point_C];
        
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [path3 moveToPoint:point_C];
        x1 = point_C.x - 10 * _progress * L /6/completefactor;
        y1 = point_C.y;
        [path3 addLineToPoint:CGPointMake(x1, y1)];
        [squarenessPath1 appendPath:path3];
    }else if (_progress < 0.65 * completefactor){
        [squarenessPath1 moveToPoint:point_A];
        [squarenessPath1 addLineToPoint:point_B];
        [squarenessPath1 moveToPoint:point_B];
        [squarenessPath1 addLineToPoint:point_C];
        [squarenessPath1 moveToPoint:point_C];
        [squarenessPath1 addLineToPoint:point_D];
        UIBezierPath *pathCircle2 = [UIBezierPath bezierPath];
        CGPoint pathCircle2Center = CGPointMake(point_M.x + path2Radius, point_M.y);
        CGFloat pathCircle2EndAngle = M_PI * 0.5 *_progress /0.65/completefactor + M_PI*0.5;
        [pathCircle2 addArcWithCenter:pathCircle2Center radius:path2Radius startAngle:M_PI*0.5 endAngle:pathCircle2EndAngle clockwise:YES];
        [squarenessPath1 appendPath:pathCircle2];

    }
    else if (_progress < 0.8 * completefactor){
        [squarenessPath1 moveToPoint:point_A];
        [squarenessPath1 addLineToPoint:point_B];
        [squarenessPath1 moveToPoint:point_B];
        [squarenessPath1 addLineToPoint:point_C];
        [squarenessPath1 moveToPoint:point_C];
        [squarenessPath1 addLineToPoint:point_D];
        CGPoint pathCircle2Center = CGPointMake(point_M.x + path2Radius, point_M.y);
        [squarenessPath1 addArcWithCenter:pathCircle2Center radius:path2Radius startAngle:M_PI*0.5 endAngle:M_PI clockwise:YES];
        
        UIBezierPath *path4 = [UIBezierPath bezierPath];
        [path4 moveToPoint:point_M];
        x1 =   point_M.x;
        y1 = point_M.y - 10 * _progress * L /8/completefactor;
        [path4 addLineToPoint:CGPointMake(x1, y1)];
        [squarenessPath1 appendPath:path4];
    
    }else if(_progress < 1 * completefactor){
        [squarenessPath1 moveToPoint:point_A];
        [squarenessPath1 addLineToPoint:point_B];
        [squarenessPath1 moveToPoint:point_B];
        [squarenessPath1 addLineToPoint:point_C];
        [squarenessPath1 moveToPoint:point_C];
        [squarenessPath1 addLineToPoint:point_D];
        CGPoint pathCircle2Center = CGPointMake(point_M.x + path2Radius, point_M.y);
        [squarenessPath1 addArcWithCenter:pathCircle2Center radius:path2Radius startAngle:M_PI*0.5 endAngle:M_PI clockwise:YES];
        [squarenessPath1 moveToPoint:point_M];
        [squarenessPath1 addLineToPoint:point_E];
        
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        CGPoint path1Center = CGPointMake(point_E.x + path1Radius, point_E.y);
        CGFloat pathCircleEndAngle = M_PI * 0.5 *_progress/completefactor + M_PI;
        [path5 addArcWithCenter:path1Center radius:path1Radius startAngle:M_PI endAngle:pathCircleEndAngle clockwise:YES];
        [squarenessPath1 appendPath:path5];
    
    }else{
        [squarenessPath1 moveToPoint:point_A];
        [squarenessPath1 addLineToPoint:point_B];
        [squarenessPath1 moveToPoint:point_B];
        [squarenessPath1 addLineToPoint:point_C];
        [squarenessPath1 moveToPoint:point_C];
        [squarenessPath1 addLineToPoint:point_D];
        CGPoint pathCircle2Center = CGPointMake(point_M.x + path2Radius, point_M.y);
        [squarenessPath1 addArcWithCenter:pathCircle2Center radius:path2Radius startAngle:M_PI*0.5 endAngle:M_PI clockwise:YES];
        [squarenessPath1 moveToPoint:point_M];
        [squarenessPath1 addLineToPoint:point_E];
         CGPoint path1Center = CGPointMake(point_E.x + path1Radius, point_E.y);
        [squarenessPath1 addArcWithCenter:path1Center radius:path1Radius startAngle:M_PI endAngle:3*M_PI*0.5 clockwise:YES];
    }
//    第一条横线
    UIBezierPath *linePath1 = [UIBezierPath bezierPath];
    CGFloat line1_x = 0;
    CGFloat line1_y = point_M.y;
    if (_progress < 0.6) {
        line1_x = L /0.6*_progress + point_M.x;
    }else{
    line1_x = L + point_M.x;
    }
    [linePath1 moveToPoint:point_M];
    [linePath1 addLineToPoint:CGPointMake(line1_x, line1_y)];
//    第二条横线
    UIBezierPath *linePath2 = [UIBezierPath bezierPath];
    CGFloat line2_x = 0;
    CGFloat line2_y = point_M.y + path2Radius * 0.5;
    if (0.6<_progress && _progress< 0.8) {
        line2_x = (L*5 - 10)*_progress +6 -3 *L + point_M.x + 2;
        [linePath2 moveToPoint:CGPointMake(point_M.x + 2, line2_y)];
        [linePath2 addLineToPoint:CGPointMake(line2_x, line2_y)];
    }else if (_progress > 0.8&&_progress <= 1){
        line2_x = L + point_M.x - 1;
        [linePath2 moveToPoint:CGPointMake(point_M.x + 2, line2_y)];
        [linePath2 addLineToPoint:CGPointMake(line2_x, line2_y)];
    }
//内部中的小框
     UIBezierPath *insideSquareness = [UIBezierPath bezierPath];
     CGFloat d = L * 0.6;
     CGFloat h = d * 0.3;
     CGPoint point_a = CGPointMake(layerCenter.x - 0.5 * d, point_E.y);
     CGPoint point_b = CGPointMake(layerCenter.x + 0.5 * d, point_E.y);
     CGPoint point_c = CGPointMake(layerCenter.x + 0.5 * d, point_E.y + h);
     CGPoint point_d = CGPointMake(layerCenter.x - 0.5 * d, point_E.y + h);
    CGFloat inside_x = 0;
    CGFloat inside_y = 0;
    if (_progress < 0.4) {
        inside_x = _progress/0.4 * d + point_a.x;
        inside_y = point_a.y;
        [insideSquareness moveToPoint:point_a];
        [insideSquareness addLineToPoint:CGPointMake(inside_x, inside_y)];
    }else if (_progress < 0.5)
    {
        [insideSquareness moveToPoint:point_a];
        [insideSquareness addLineToPoint:point_b];
        
        
        UIBezierPath *insidePath1 = [UIBezierPath bezierPath];
        inside_x = point_b.x;
        inside_y = h*_progress/0.1 - 4*h + point_b.y;
        [insidePath1 moveToPoint:point_b];
        [insidePath1 addLineToPoint:CGPointMake(inside_x, inside_y)];
        [insideSquareness appendPath:insidePath1];
    
    }else if (_progress < 0.7)
    {
        [insideSquareness moveToPoint:point_a];
        [insideSquareness addLineToPoint:point_b];
        [insideSquareness moveToPoint:point_b];
        [insideSquareness addLineToPoint:point_c];
        
        UIBezierPath *insidePath2 = [UIBezierPath bezierPath];
        inside_x = point_c.x - (_progress * d / 0.2 - 5*d/2);
        inside_y = point_c.y;
        [insidePath2 moveToPoint:point_c];
        [insidePath2 addLineToPoint:CGPointMake(inside_x, inside_y)];
        [insideSquareness appendPath:insidePath2];
        
        
    }else if (_progress< 0.8)
    {
        [insideSquareness moveToPoint:point_a];
        [insideSquareness addLineToPoint:point_b];
        [insideSquareness moveToPoint:point_b];
        [insideSquareness addLineToPoint:point_c];
        [insideSquareness moveToPoint:point_c];
        [insideSquareness addLineToPoint:point_d];
        
        UIBezierPath *insidePath3 = [UIBezierPath bezierPath];
        inside_x = point_d.x;
        inside_y = point_d.y - (_progress *h /0.1 - 7 * h);
        [insidePath3 moveToPoint:point_d];
        [insidePath3 addLineToPoint:CGPointMake(inside_x, inside_y)];
        [insideSquareness appendPath:insidePath3];
    }else{
    
        [insideSquareness moveToPoint:point_a];
        [insideSquareness addLineToPoint:point_b];
        [insideSquareness moveToPoint:point_b];
        [insideSquareness addLineToPoint:point_c];
        [insideSquareness moveToPoint:point_c];
        [insideSquareness addLineToPoint:point_d];
        [insideSquareness moveToPoint:point_d];
        [insideSquareness addLineToPoint:point_a];
    }
    
    
    
    circlePath.lineWidth = 1.f;
    circlePath.lineCapStyle = kCGLineCapRound;
    circlePath.lineJoinStyle = kCGLineJoinRound;
    [circlePath stroke];
    
    squarenessPath1.lineWidth = 1.f;
    squarenessPath1.lineCapStyle = kCGLineCapRound;
    squarenessPath1.lineJoinStyle = kCGLineJoinRound;
    [squarenessPath1 stroke];
    
    linePath1.lineWidth = 1.f;
    linePath1.lineCapStyle = kCGLineCapRound;
    linePath1.lineJoinStyle = kCGLineJoinRound;
    [linePath1 strokeWithBlendMode:kCGBlendModeNormal alpha:0.9];
    
    linePath2.lineWidth = 1.f;
    linePath2.lineCapStyle = kCGLineCapRound;
    linePath2.lineJoinStyle = kCGLineJoinRound;
    [linePath2 strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];
//    [linePath2 stroke];
    [insideSquareness stroke];
    NSLog(@"-------重绘---");
    
    CGContextSaveGState(context);
    CGContextRestoreGState(context);
    UIGraphicsPopContext();
}



@end




@interface DXIreader()
@property (nonatomic, strong) DXIreaderLayer *readerLayer;
@end

@implementation DXIreader

- (void)setProgress:(CGFloat)progress{
    progress = progress >1?1:progress;
    _progress = progress;
    _readerLayer.progress = progress;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    _readerLayer = [DXIreaderLayer layer];
    _readerLayer.bounds = self.bounds;
    _readerLayer.position = CGPointMake(self.bounds.size.width * 0.5,self.bounds.size.height * 0.6);
//    _readerLayer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.layer addSublayer:_readerLayer];
}
@end
