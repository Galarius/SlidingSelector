/*!
 * \file GSSlideSelectorViewController.m
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlidingSelectorViewController.h"
#import "GSSlidingSelectorStyle.h"

const static CGFloat GSBackColorChangeAnimationTime = 0.05f;

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
/*!
 * \brief Index to know the last active item
 */
@property(nonatomic) NSUInteger activeIndex;

@end

@implementation GSSlidingSelectorViewController
{
    struct {
        unsigned int numberOfItems:1;
        unsigned int titleForItem:1;
        unsigned int didSelectItem:1;
    } delegateRespondsTo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.activeIndex = 0;
    
    [self setupView];
    [self reloadData];
}

- (void)setDelegate:(id<GSSlidingSelectorDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        if(_delegate) {
            delegateRespondsTo.numberOfItems = [self.delegate respondsToSelector:@selector(numberOfItemsInSlideSelector:)];
            delegateRespondsTo.titleForItem = [self.delegate respondsToSelector:@selector(slideSelector:titleForItemAtIndex:)];
            delegateRespondsTo.didSelectItem = [self.delegate respondsToSelector:@selector(slideSelector:didSelectItemAtIndex:)];
        } else {
            delegateRespondsTo.numberOfItems = NO;
            delegateRespondsTo.titleForItem = NO;
            delegateRespondsTo.didSelectItem = NO;
        }
    }
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
    if(delegateRespondsTo.numberOfItems && delegateRespondsTo.titleForItem) {
        if(self.textFields.count) {
            // Remove all previously added text fields
            [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.textFields removeAllObjects];
        }
        // Recreate scroll view content
        NSUInteger count = [self.delegate numberOfItemsInSlideSelector:self];
        self.textFields = [NSMutableArray arrayWithCapacity:count];
        for(int i = 0; i < count; ++i) {
            NSString *title = [self.delegate slideSelector:self titleForItemAtIndex:i];
            UITextField *textField = [GSSlidingSelectorStyleKit createTextFieldWithText:title];
            [self.textFields addObject:textField];
            [self.scrollView addSubview:textField];
        }
        if(self.textFields.count) {
            UITextField *tf = [self.textFields firstObject];
            tf.transform = CGAffineTransformScale(tf.transform, 1.5, 1.5);
        }
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGFloat w = CGRectGetWidth(self.view.frame);
    CGFloat h = CGRectGetHeight(self.view.frame);
    self.scrollView.frame = CGRectMake(0, 0, w, h);
    
    /*
     *   |       ][    active    ][      |       ][              ]
     *         <------------>
     *            1/2 * w
     */
    CGFloat w2 = w * 0.5f;
    CGFloat w4 = w2 * 0.5f;
    
    UITextField *tField = [self.textFields firstObject];
    tField.frame = CGRectMake(w4, 0, w2, h);
    CGFloat x = w4 + w2;
    
    for(int i = 1; i < self.textFields.count; ++i) {
        tField = [self.textFields objectAtIndex:i];
        tField.frame = CGRectMake(x, 0, w2, h);
        tField.alpha = 0;
        x += w2;
    }
    self.scrollView.contentSize = CGSizeMake(x + w4, h);
}

#pragma mark - State

- (void)hideNeighbors:(BOOL)hidden
{
    for(int i = 0; i < self.scrollView.subviews.count; ++i) {
        UIView* subview = [self.scrollView.subviews objectAtIndex:i];
        if( i != self.activeIndex && [subview isKindOfClass:[UITextField class]]) {
            subview.alpha = !hidden;
        }
    }
}

- (void)toggleState:(BOOL)updating
{
    [UIView animateWithDuration:GSBackColorChangeAnimationTime animations:^{
        if(updating) {
            self.scrollView.backgroundColor = GSSlidingSelectorStyleKit.holdTouchColor;
            [self hideNeighbors:NO];
        } else {
            self.scrollView.backgroundColor = [UIColor clearColor];
            [self hideNeighbors:YES];
        }
    }];
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
    NSUInteger idx = round(offset / pageWidth);
    if (idx > self.textFields.count - 1) {
        idx = self.textFields.count - 1;
    }
    targetContentOffset->x = idx * pageWidth;
    // Notify observer
    if(delegateRespondsTo.didSelectItem) {
        [self.delegate slideSelector:self didSelectItemAtIndex:idx];
    }
    
    if(idx != self.activeIndex) {
        UITextField *tf = [self.textFields objectAtIndex:self.activeIndex];
        tf.transform = CGAffineTransformIdentity;
        tf = [self.textFields objectAtIndex:idx];
        [UIView animateWithDuration:GSBackColorChangeAnimationTime animations:^{
            tf.transform = CGAffineTransformScale(tf.transform, 1.5, 1.5);
        }];
        self.activeIndex = idx;
    }
}

#pragma mark - GestureRecognizer Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - GestureRecognizer Action

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
