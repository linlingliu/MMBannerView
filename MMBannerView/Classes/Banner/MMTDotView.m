//
//  MMTDotView.m
//  MMTBanner
//
//  Created by LX on 2018/7/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "MMTDotView.h"

@interface MMTDotView()
{
    NSMutableArray <__kindof CALayer *>           *_dots;
    NSInteger                                     _margin;
}

@end

@implementation MMTDotView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //init data
        self.numberOfPages = 0;
        _currentPage = 0;
        self.hidesForSinglePage = NO;
        self.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.currentPageIndicatorTintColor = [UIColor whiteColor];
        self.pageIndicatorSize = CGSizeMake(5, 5);
        
        _dots = @[].mutableCopy;
        _margin = 5;
    }
    return self;
}

- (void)refreshUI
{
    if(self.numberOfPages==1&&self.hidesForSinglePage){
        self.hidden = YES;
    }else{
        self.hidden = NO;
    }
    
    //remove
    if(_dots){
        for (CALayer *_layer in _dots) {
            [_layer removeFromSuperlayer];
        }
        [_dots removeAllObjects];
    }else{
        _dots = @[].mutableCopy;
    }
    
    //add
    for (NSInteger i=0; i<self.numberOfPages; i++) {
        CALayer *_layer = [CALayer layer];
        _layer.opaque = 0.9f;
        _layer.masksToBounds = YES;
        _layer.frame = CGRectMake(0, (self.frame.size.height-self.pageIndicatorSize.height)/2, self.pageIndicatorSize.width, self.pageIndicatorSize.height);
        _layer.backgroundColor = self.pageIndicatorTintColor.CGColor;
        if(i==self.currentPage){
            _layer.backgroundColor = self.currentPageIndicatorTintColor.CGColor;
        }
        _layer.cornerRadius = self.pageIndicatorSize.width/2;
        [_dots addObject:_layer];
    }
    [self _updateUI];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if(currentPage>=_dots.count){
        return;
    }
    CALayer *_layer_before = _dots[_currentPage];
    CALayer *_layer_after = _dots[currentPage];
    
    _layer_before.backgroundColor = self.pageIndicatorTintColor.CGColor;
    _layer_after.backgroundColor = self.currentPageIndicatorTintColor.CGColor;

    _layer_before.frame=CGRectMake(_layer_before.frame.origin.x+self.pageIndicatorSize.width/2, _layer_before.frame.origin.y, self.pageIndicatorSize.width, self.pageIndicatorSize.height);
    _layer_after.frame=CGRectMake(_layer_after.frame.origin.x-self.pageIndicatorSize.width/2, _layer_before.frame.origin.y, self.pageIndicatorSize.width*2, self.pageIndicatorSize.height);
    _currentPage = currentPage;
}

#pragma mark private method

- (void)_updateUI
{
    CGFloat _x = 0;
    CGFloat _width = (self.numberOfPages-1)*(self.pageIndicatorSize.width+_margin)+self.pageIndicatorSize.width;
    _x = (self.frame.size.width-_width)/2;
    for (NSInteger i=0;i<_dots.count;i++) {
        CALayer *_layer = _dots[i];
        _layer.frame = CGRectMake(_x, _layer.frame.origin.y, _layer.frame.size.width, _layer.frame.size.height);
        _x += _layer.frame.size.width+_margin;
        if (i==0) {
            _layer.frame = CGRectMake((self.frame.size.width-_width)/2-self.pageIndicatorSize.width/2, (self.frame.size.height-self.pageIndicatorSize.height)/2, self.pageIndicatorSize.width*2, self.pageIndicatorSize.height);
        }
        [self.layer addSublayer:_layer];
    }
}

@end
