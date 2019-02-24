/*!
 * \file GSSlideSelectorViewController.m
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlidingSelectorViewController.h"
#import "GSSlidingSelectorStyle.h"

const static CGFloat GSTransformTextFieldAnimationTime = 0.15f;
const static CGFloat GSHighlightBackColorAnimationTime = 0.05f;
const static CGFloat GSRestoreBackColorAnimationTime   = 0.55f;

const NSUInteger GSMaximumNumberOfElements = 25;

@interface GSSlidingSelectorViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

/*!
 *  \brief ScrollView to slide items horizontally
 */
@property(strong, nonatomic) UIScrollView   *scrollView;
/*!
 *  \brief Array of text fields in scroll view
 */
@property(strong, nonatomic) NSMutableArray *textFields;
/*!
 *  \brief Selected & displayed item
 */
@property(strong, nonatomic) NSString *selectedItem;
/*!
 * \brief Flag to know if scroll view's decelerating is active
 */
@property(nonatomic) BOOL decelerating;

@end

@implementation GSSlidingSelectorViewController
{
    struct {
        unsigned int numberOfItems:1;
        unsigned int titleForItem:1;
    } dataSourceRespondsTo;
    
    struct {
        unsigned int didSelectItem:1;
    } delegateRespondsTo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectedIndex = 0;
    
    [self setupView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = CGRectGetHeight(self.view.frame);
    self.scrollView.frame = CGRectMake(0, 0, w, h);
    self.scrollView.contentSize = CGSizeMake(w, h);
    
    if(self.textFields.count) {
        /*
         *   |       ][    active    ][      |       ][              ]
         *         <------------>
         *            1/2 * w
         */
        CGFloat w2 = w * 0.5f;
        CGFloat w4 = w2 * 0.5f;
        CGFloat x = w4;
        for(int i = 0; i < self.textFields.count; ++i) {
            UITextField *tf = [self.textFields objectAtIndex:i];
            tf.frame = CGRectMake(x, 0, w2, h);
            tf.alpha = (i == self.selectedIndex);
            x += w2;
        }
        self.scrollView.contentSize = CGSizeMake(x + w4, h);
        CGPoint target = CGPointMake(self.selectedIndex * w2, 0);
        [self.scrollView setContentOffset:target animated:NO];
    }
}

- (void)setDelegate:(id<GSSlidingSelectorDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        if(_delegate) {
            delegateRespondsTo.didSelectItem = [self.delegate respondsToSelector:@selector(slideSelector:didSelectItemAtIndex:)];
        }
    }
}

- (void)setDataSource:(id<GSSlidingSelectorDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if(_dataSource) {
            dataSourceRespondsTo.numberOfItems = [self.delegate respondsToSelector:@selector(numberOfItemsInSlideSelector:)];
            dataSourceRespondsTo.titleForItem  = [self.delegate respondsToSelector:@selector(slideSelector:titleForItemAtIndex:)];
        }
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    if(selectedIndex != _selectedIndex && selectedIndex < self.textFields.count) {
        [self transformTextFieldAtIndex:self.selectedIndex animated:animated];
        _selectedIndex = selectedIndex;
        [self restoreTextFieldAtIndex:self.selectedIndex animated:animated];
        [self scrollToIndex:selectedIndex animated:animated];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setupView
{
    self.view.backgroundColor = GSSlidingSelectorStyleKit.mainColor;
    
    _scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];

    // Configure the press and hold gesture recognizer
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(holdGesture:)];
    gr.minimumPressDuration = 0.0;
    gr.delegate = self;
    [self.scrollView addGestureRecognizer:gr];
}

- (void)reloadData
{
    if(dataSourceRespondsTo.numberOfItems && dataSourceRespondsTo.titleForItem) {
        if(self.textFields.count) {
            // Remove all previously added text fields
            [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.textFields removeAllObjects];
        }
        // Recreate scroll view content
        NSUInteger count = [self.dataSource numberOfItemsInSlideSelector:self];
        
        if(count > GSMaximumNumberOfElements) {
            NSLog(@"[GSSlidingSelectorViewController] Error: Maximum number of elements is %lu, \
                  requested: %lu. Only %lu elements will be loaded.",
                  (unsigned long)GSMaximumNumberOfElements,
                  (unsigned long)count,
                  (unsigned long)GSMaximumNumberOfElements);
            count = GSMaximumNumberOfElements;
        }
        
        self.textFields = [NSMutableArray arrayWithCapacity:count];
        for(int i = 0; i < count; ++i) {
            NSString *title = [self.dataSource slideSelector:self titleForItemAtIndex:i];
            UITextField *textField = [GSSlidingSelectorStyleKit createTextFieldWithText:title];
            textField.transform = CGAffineTransformScale(textField.transform, 0.5, 0.5);
            [self.textFields addObject:textField];
            [self.scrollView addSubview:textField];
        }
        if(self.textFields.count) {
            [self restoreTextFieldAtIndex:self.selectedIndex animated:YES];
        }
        [self.view setNeedsLayout];
    }
}

#pragma mark - State

- (void)hideNeighbors:(BOOL)hidden
{
    for(int i = 0; i < self.scrollView.subviews.count; ++i) {
        UIView* subview = [self.scrollView.subviews objectAtIndex:i];
        if( i != self.selectedIndex && [subview isKindOfClass:[UITextField class]]) {
            subview.alpha = !hidden;
        }
    }
}

- (void)toggleState:(BOOL)updating
{
    if(updating) {
        [UIView animateWithDuration:GSHighlightBackColorAnimationTime animations:^{
            self.scrollView.backgroundColor = GSSlidingSelectorStyleKit.holdTouchColor;
            [self hideNeighbors:NO];
        }];
    } else {
        [UIView animateWithDuration:GSRestoreBackColorAnimationTime animations:^{
            self.scrollView.backgroundColor = [UIColor clearColor];
            [self hideNeighbors:YES];
        }];
    }
}

- (void)restoreTextFieldAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    UITextField *tf = [self.textFields objectAtIndex:index];
    if(animated) {
        [UIView animateWithDuration:GSTransformTextFieldAnimationTime animations:^{
            tf.transform = CGAffineTransformIdentity;
        }];
    } else {
        tf.transform = CGAffineTransformIdentity;
    }
}

- (void)transformTextFieldAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    UITextField *tf = [self.textFields objectAtIndex:index];
    if(animated) {
        [UIView animateWithDuration:GSTransformTextFieldAnimationTime animations:^{
            tf.transform = CGAffineTransformScale(tf.transform, 0.5, 0.5);
        }];
    } else {
        tf.transform = CGAffineTransformScale(tf.transform, 0.5, 0.5);
    }
}

- (void)scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat w2 = w * 0.5f;
    CGPoint target = CGPointMake(index * w2, 0);
    [self.scrollView setContentOffset:target animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.decelerating = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self toggleState:NO];
    self.decelerating = NO;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offset = scrollView.contentOffset.x + velocity.x * 60.0f;
    CGFloat w = CGRectGetWidth(self.scrollView.frame);
    CGFloat pageWidth = w * 0.5f;
    NSInteger idx = MAX(0, round(offset / pageWidth));
    idx = MIN(idx, self.textFields.count - 1);
    targetContentOffset->x = idx * pageWidth;
    // Notify observer
    if(delegateRespondsTo.didSelectItem) {
        [self.delegate slideSelector:self didSelectItemAtIndex:idx];
    }
    
    if(idx != self.selectedIndex) {
        [self transformTextFieldAtIndex:self.selectedIndex animated:YES];
        [self restoreTextFieldAtIndex:idx animated:YES];
        _selectedIndex = idx;
    }
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Gesture Recognizer Handler

- (void)holdGesture:(UIGestureRecognizer *)gesture
{    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self toggleState:YES];
    } else if((gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateFailed ||
              gesture.state == UIGestureRecognizerStateCancelled) &&
              !self.decelerating) {
        [self toggleState:NO];
    }
}

@end
