/*!
 * \file GSSlideSelectorViewController.h
 * \author Galarius
 * \date 30.06.2018
 * \copyright (c) 2018 galarius. All rights reserved.
 */

#import "GSSlideSelectorDelegate.h"

#import <UIKit/UIKit.h>

@interface GSSlideSelectorViewController : UIViewController

@property(weak, nonatomic) id<GSSlideSelectorDelegate> delegate;

/*!
 * \brief Initiate data reloading
 * \see GSSlideSelectorDelegate methods
 */
- (void)reloadData;

@end
