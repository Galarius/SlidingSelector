/*!
 * \file GSSlideSelectorViewController.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

@import UIKit;

extern const NSUInteger GSMaximumNumberOfElements;

@protocol GSSlidingSelectorDelegate;
@protocol GSSlidingSelectorDataSource;

@interface GSSlidingSelectorViewController : UIViewController

@property(weak, nonatomic) id<GSSlidingSelectorDelegate>   delegate;
@property(weak, nonatomic) id<GSSlidingSelectorDataSource> dataSource;
@property(nonatomic) NSUInteger selectedIndex;

/*!
 * \brief Initiate data reloading
 * \see GSSlideSelectorDelegate methods
 * \see GSMaximumNumberOfElements
 */
- (void)reloadData;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
