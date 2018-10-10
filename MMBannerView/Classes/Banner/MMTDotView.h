//
//  MMTDotView.h
//  MMTBanner
//
//  Created by LX on 2018/7/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTDotView : UIView

@property (nonatomic, assign) NSInteger numberOfPages;//default 0
@property (nonatomic, assign) NSInteger currentPage;//default 0
@property (nonatomic, assign) BOOL hidesForSinglePage;//default NO
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;//default lightgraycolor
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;//whitecolor
@property (nonatomic, assign) CGSize pageIndicatorSize;//{w:5,h:5}

- (void)refreshUI;

@end
