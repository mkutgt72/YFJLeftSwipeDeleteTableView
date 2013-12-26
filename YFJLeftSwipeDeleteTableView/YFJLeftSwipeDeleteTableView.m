//
//  YFJLeftSwipeDeleteTableView.m
//
//  Provides drop-in TableView component that allows to show iOS7 style left-swipe delete
//
//  Created by Yuichi Fujiki on 6/27/13.
//  Copyright (c) 2013 Yuichi Fujiki. All rights reserved.
//

#import "YFJLeftSwipeDeleteTableView.h"
#import "YFJMenuButton.h"
#import "UIView+NSIndexPath.h"

#define screenWidth() (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

@interface YFJLeftSwipeDeleteTableView() {
    UISwipeGestureRecognizer * _leftGestureRecognizer;
    UISwipeGestureRecognizer * _rightGestureRecognizer;
    UITapGestureRecognizer * _tapGestureRecognizer;

    NSIndexPath * _editingIndexPath;
}

@end

@implementation YFJLeftSwipeDeleteTableView

@synthesize swipeView=_swipeView;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _leftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        _leftGestureRecognizer.delegate = self;
        [self addGestureRecognizer:_leftGestureRecognizer];

        _rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
        _rightGestureRecognizer.delegate = self;
        _rightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_rightGestureRecognizer];

        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        _tapGestureRecognizer.delegate = self;
        // Don't add this yet

        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    }
    return self;
}

- (void)setSwipeView:(UIView *)swipeView {
    if (self.swipeView != nil) {
        [self.swipeView removeFromSuperview];
    }

    [self addSubview:swipeView];

    _swipeView = swipeView;

    _swipeView.frame = CGRectMake(self.frame.size.width, 0, _swipeView.frame.size.width, _swipeView.frame.size.height);
}

- (void)swiped:(UISwipeGestureRecognizer *)gestureRecognizer {
    NSIndexPath * indexPath = [self cellIndexPathForGestureRecognizer:gestureRecognizer];
    if(indexPath == nil)
        return;

    if(![self.dataSource tableView:self canEditRowAtIndexPath:indexPath]) {
        return;
    }

    if(gestureRecognizer == _leftGestureRecognizer && ![_editingIndexPath isEqual:indexPath]) {
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:YES atIndexPath:indexPath cell:cell];
    } else if (gestureRecognizer == _rightGestureRecognizer && [_editingIndexPath isEqual:indexPath]){
        UITableViewCell * cell = [self cellForRowAtIndexPath:indexPath];
        [self setEditing:NO atIndexPath:indexPath cell:cell];
    }
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer
{
    if(_editingIndexPath) {
        UITableViewCell * cell = [self cellForRowAtIndexPath:_editingIndexPath];
        [self setEditing:NO atIndexPath:_editingIndexPath cell:cell];
    }
}

- (NSIndexPath *)cellIndexPathForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    UIView * view = gestureRecognizer.view;
    if(![view isKindOfClass:[UITableView class]]) {
        return nil;
    }

    CGPoint point = [gestureRecognizer locationInView:view];
    NSIndexPath * indexPath = [self indexPathForRowAtPoint:point];
    return indexPath;
}

- (void)setEditing:(BOOL)editing atIndexPath:indexPath cell:(UITableViewCell *)cell {

    if(editing) {
        if(_editingIndexPath) {
            UITableViewCell * editingCell = [self cellForRowAtIndexPath:_editingIndexPath];
            [self setEditing:NO atIndexPath:_editingIndexPath cell:editingCell];
        }
        [self addGestureRecognizer:_tapGestureRecognizer];
    } else {
        [self removeGestureRecognizer:_tapGestureRecognizer];
    }

    CGRect frame = cell.frame;

    CGFloat cellXOffset;
    CGFloat deleteButtonXOffsetOld, deleteButtonXOffset;

    CGFloat buttonsWidth = self.swipeView.frame.size.width;

    if(editing) {
        cellXOffset = -buttonsWidth;
        deleteButtonXOffset = screenWidth() - buttonsWidth;
        deleteButtonXOffsetOld = screenWidth();
        _editingIndexPath = indexPath;
    } else {
        cellXOffset = 0;
        deleteButtonXOffset = screenWidth();
        deleteButtonXOffsetOld = screenWidth() - buttonsWidth;
        _editingIndexPath = nil;
    }

    CGFloat cellHeight = [self.delegate tableView:self heightForRowAtIndexPath:indexPath];
    self.swipeView.frame = CGRectMake(deleteButtonXOffsetOld, frame.origin.y, self.swipeView.frame.size.width, cellHeight);
    self.swipeView.indexPath = indexPath;

    [UIView animateWithDuration:0.2f animations:^{
        cell.frame = CGRectMake(cellXOffset, frame.origin.y, frame.size.width, frame.size.height);
        self.swipeView.frame = CGRectMake(deleteButtonXOffset, frame.origin.y, self.swipeView.frame.size.width, cellHeight);
    }];
}

- (void)hideSwipeView {
    [self setEditing:NO atIndexPath:_editingIndexPath cell:[self cellForRowAtIndexPath:_editingIndexPath]];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO; // Recognizers of this class are the first priority
}

@end
