/*!
 * \file GSSlidingSelectorDataSource.h
 * \author Galarius
 * \date 07.10.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import <Foundation/Foundation.h>

@class GSSlidingSelectorViewController;

@protocol GSSlidingSelectorDataSource <NSObject>

@required
/*!
 * \brief Number of items that will be displayed in slide selector.
 * \note This control is convinient for only a small number of elements. The maximum number
 * of elements is defined in `GSMaximumNumberOfElements` which is equal to 25 by default.
 * \see GSMaximumNumberOfElements
 */
- (NSUInteger)numberOfItemsInSlideSelector:(GSSlidingSelectorViewController*)selector;
/*!
 * \brief Title for each item
 * \see numberOfItemsInSlideSelector:
 */
- (NSString *)slideSelector:(GSSlidingSelectorViewController*)selector titleForItemAtIndex:(NSUInteger)index;

@end
