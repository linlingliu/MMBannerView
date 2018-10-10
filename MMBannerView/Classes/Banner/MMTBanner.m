//
//  MMTBanner.m
//  MMTBanner
//
//  Created by LX on 2018/7/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import "MMTBanner.h"
#import "MMTBannerCell.h"
#import "MMTDotView.h"

static NSString *bannerIdentifier = @"bannerIdentifier";
static CGFloat scrollInterval = 3.0f;

@interface MMTBanner ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView             *_mainView;
    NSInteger                    _currentIndex;
    MMTDotView                   *_pageControl;
    NSTimer                      *_timer;
    NSMutableArray               *_images;
}
@end

@implementation MMTBanner

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        UICollectionViewFlowLayout *_flow=[[UICollectionViewFlowLayout alloc]init];
        _flow.minimumLineSpacing=0;
        _flow.scrollDirection=UICollectionViewScrollDirectionHorizontal;
        _mainView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:_flow];
        _mainView.dataSource=self;
        _mainView.delegate=self;
        _mainView.pagingEnabled=YES;
        _mainView.backgroundColor=[UIColor whiteColor];
        [_mainView registerClass:[MMTBannerCell class] forCellWithReuseIdentifier:bannerIdentifier];
        _mainView.showsHorizontalScrollIndicator=NO;
        [self addSubview:_mainView];
        
        CGFloat controlHeight = 35.0f;
        _pageControl = [[MMTDotView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - controlHeight, self.bounds.size.width, controlHeight)];
        [self addSubview:_pageControl];
        __weak typeof(self)_weakSelf=self;
        _timer = [NSTimer scheduledTimerWithTimeInterval:scrollInterval target:_weakSelf selector:@selector(showNext) userInfo:nil repeats:true];
        _images=[NSMutableArray array];
    }
    return self;
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;
    }
}

- (void)setItems:(NSArray<NSString *> *)items
{
    [_images removeAllObjects];
    [_images addObjectsFromArray:items];
    [_images addObject:items.firstObject];
    [_images insertObject:items.lastObject atIndex:0];
    [_mainView reloadData];
    [_mainView setContentOffset:CGPointMake(_mainView.bounds.size.width, 0)animated:YES];
    _pageControl.numberOfPages=items.count;
    _pageControl.currentPage=0;
    [_pageControl refreshUI];
}

#pragma mark - Delegate&DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MMTBannerCell *_cell=[collectionView dequeueReusableCellWithReuseIdentifier:bannerIdentifier forIndexPath:indexPath];
    _cell.imageUrl=_images[indexPath.row];
    [_cell show];
    return _cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.banner_delegate respondsToSelector:@selector(didClickIndex:)]) {
        [self.banner_delegate didClickIndex:indexPath.row];
    }
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self cycleShow];
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:scrollInterval]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self cycleShow];
}

#pragma mark - private

//循环显示
- (void)cycleShow {
    NSInteger page = _mainView.contentOffset.x/_mainView.bounds.size.width;
    if (page == 0) {//滚动到左边
        _mainView.contentOffset = CGPointMake(_mainView.bounds.size.width * (_images.count - 2), 0);
        _pageControl.currentPage = _images.count - 2-1;
    }else if (page == _images.count - 1){//滚动到右边
        _mainView.contentOffset = CGPointMake(_mainView.bounds.size.width, 0);
        _pageControl.currentPage = 0;
    }else{
        _pageControl.currentPage = page - 1;
    }
}

- (void)showNext
{
    //手指拖拽是禁止自动轮播
    if (_mainView.isDragging) {return;}
    CGFloat targetX =  _mainView.contentOffset.x + _mainView.bounds.size.width;
    [_mainView setContentOffset:CGPointMake(targetX, 0) animated:YES];
}

@end
