/**
 * @file GSSlideSelectorDelegate.swift
 * @author Galarius
 * @date 23.02.2019
 * @copyright (c) 2019 galarius. All rights reserved.
 */

import Foundation

protocol GSSlidingSelectorDelegate : NSObjectProtocol {
    /**
     * @brief Called when item selected in slide selector
     */
    func slideSelector(_ selector: GSSlidingSelectorViewController!, didSelectItemAtIndex index: UInt)
}


