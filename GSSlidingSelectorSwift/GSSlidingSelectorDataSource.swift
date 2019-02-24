/**
 * @file GSSlidingSelectorDataSource.swift
 * @author Galarius
 * @date 23.02.2019
 * @copyright (c) 2019 galarius. All rights reserved.
 */

import Foundation

protocol GSSlidingSelectorDataSource : NSObjectProtocol {
    /**
     * @brief Number of items that will be displayed in slide selector.
     * @note This control is convinient for only a small number of elements. The maximum number
     * of elements is defined in `GSMaximumNumberOfElements` which is equal to 25 by default.
     * @see GSMaximumNumberOfElements
     */
    func numberOfItemsInSlideSelector(_ selector: GSSlidingSelectorViewController!) -> Int;
    /**
     * @brief Title for each item
     * @see numberOfItemsInSlideSelector:
     */
    func slideSelector(_ selector: GSSlidingSelectorViewController!, titleForItemAtIndex index: Int) -> String;
}
