//
//  YFJLeftSwipeDeleteTableView.h
//  YFJLeftSwipeDeleteTableView
//
//  Created by Yuichi Fujiki on 6/27/13.
//  Copyright (c) 2013 Yuichi Fujiki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YFJMenuButton;

@interface YFJLeftSwipeDeleteTableView : UITableView <UIGestureRecognizerDelegate>

@property (nonatomic, strong, setter = setSwipeView:) UIView* swipeView;

- (void)setSwipeView:(UIView *)swipeView;

- (void)hideSwipeView;

@end
