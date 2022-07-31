//
//  UICollectionViewController+Ext.swift
//  ios-base-architecture
//
//  Created by Luiz on 23/02/20.
//  Copyright © 2020 PEBMED. All rights reserved.
//

import UIKit

extension UICollectionViewController {
    func reloadDataOnMainThread() {
        if Thread.isMainThread {
            self.collectionView.reloadData()
        } else {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
