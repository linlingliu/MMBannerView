//
//  MMTBanner.h
//  MMTBanner
//
//  Created by LX on 2018/7/20.
//  Copyright © 2018年 LX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMTBannerDelegate <NSObject>

- (void)didClickIndex:(NSInteger)index;

@end

@interface MMTBanner : UIView

@property (nonatomic, strong) NSArray <NSString *> *items;
@property (nonatomic, weak) id <MMTBannerDelegate>banner_delegate;

@end
