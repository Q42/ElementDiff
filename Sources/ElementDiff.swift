//
//  ElementDiff.swift
//
//  Created by Tom Lokhorst on 2015-07-29.
//  Copyright (c) 2015 Q42. All rights reserved.
//

import UIKit

/// Differences between two sequences of elements, computed by `SequenceType.diff`
/// Can be passed to `UITableView.updateSection` or `UICollectionView.updateSection`.
public struct ElementDiff {
  public var deleted: [Int]
  public var inserted: [Int]
  public var moved: [Int:Int]
  public var unmoved: [Int]

  public init(deleted: [Int] = [], inserted: [Int] = [], moved: [Int:Int] = [:], unmoved: [Int] = []) {
    self.deleted = deleted
    self.inserted = inserted
    self.moved = moved
    self.unmoved = unmoved
  }
}

extension SequenceType where Generator.Element : Hashable {
  typealias T = Generator.Element

  /// Compute differences between two sequences of elements.
  /// These can be passed to `updateSection` extensions to animate transitions.
  ///
  /// Example:
  /// ```swift
  /// // Update self.items array of view models
  /// let previous: [ViewModel] = self.items
  /// self.items = model.currentViewModels()
  /// let diff = previous.diff(self.items)
  ///
  /// // Animate changes to view models array
  /// self.tableView.beginUpdates()
  /// self.tableView.updateSection(0, diff: diff)
  /// self.tableView.endUpdates()
  /// ```
  public func diff(updated: Self) -> ElementDiff {
    let original = self

    var originalIndex = [T:Int]()
    for (ix, obj) in original.enumerate() {
      originalIndex[obj] = ix
    }

    var updatedIndex = [T:Int]()
    for (ix, obj) in updated.enumerate() {
      updatedIndex[obj] = ix
    }

    var deleted: [Int] = []
    var deletedSet = Set<Int>()
    for (ix, orig) in original.enumerate() {
      if updatedIndex[orig] != nil {
        continue
      }

      deleted.append(ix)
      deletedSet.insert(ix)
    }

    var inserted: [Int] = []
    for (ix, new) in updated.enumerate() {
      if originalIndex[new] != nil {
        continue
      }

      inserted.append(ix)
    }

    var moved: [Int:Int] = [:]
    var movedSet = Set<Int>()

    var unmoved: [Int] = []
    for (previousIx, orig) in original.enumerate() {
      if deletedSet.contains(previousIx) {
        continue
      }

      if let currentIx = updatedIndex[orig] {
        if currentIx != previousIx && !movedSet.contains(currentIx) {
          moved[previousIx] = currentIx
          movedSet.insert(currentIx)
        }
        else {
          unmoved.append(currentIx)
        }
      }
    }

    return ElementDiff(deleted: deleted, inserted: inserted, moved: moved, unmoved: unmoved)
  }
}

extension SequenceType {

  /// Compute differences between two sequences of elements using a custom identifier.
  /// These can be passed to `updateSection` extensions to animate transitions.
  ///
  /// Example:
  /// ```swift
  /// // Update self.items array of view models
  /// let previous: [ViewModel] = self.items
  /// self.items = model.currentViewModels()
  /// let diff = previous.diff(self.items)
  ///
  /// // Animate changes to view models array
  /// self.tableView.beginUpdates()
  /// self.tableView.updateSection(0, diff: diff)
  /// self.tableView.endUpdates()
  /// ```
  public func diff<H : Hashable>(updated: Self, identifierSelector: Generator.Element -> H) -> ElementDiff {
    let selfIdentifiers = self.map(identifierSelector)
    let updatedIdentifiers = updated.map(identifierSelector)

    return selfIdentifiers.diff(updatedIdentifiers)
  }
}

extension UICollectionView {

  /// Update UICollectionView items based on `ElementDiff`
  public func updateSection(section: Int, diff: ElementDiff) {
    let deletedIndexPaths = diff.deleted.map { NSIndexPath(forItem: $0, inSection: section) }
    self.deleteItemsAtIndexPaths(deletedIndexPaths)

    let insertedIndexPaths = diff.inserted.map { NSIndexPath(forItem: $0, inSection: section) }
    self.insertItemsAtIndexPaths(insertedIndexPaths)

    for (fromIx, toIx) in diff.moved {
      let fromIndexPath = NSIndexPath(forItem: fromIx, inSection: section)
      let toIndexPath = NSIndexPath(forItem: toIx, inSection: section)
      self.moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
  }
}

extension UITableView {

  /// Update UITableView items based on `ElementDiff`.
  ///
  /// Call `beginUpdates` before, and `endUpdates` after.
  public func updateSection(
    section: Int,
    diff: ElementDiff,
    withRowAnimation defaultRowAnimation: UITableViewRowAnimation = UITableViewRowAnimation.Automatic,
    deleteRowAnimation: UITableViewRowAnimation? = nil,
    insertRowAnimation: UITableViewRowAnimation? = nil)
  {
    let deletedIndexPaths = diff.deleted.map { NSIndexPath(forItem: $0, inSection: section) }
    self.deleteRowsAtIndexPaths(deletedIndexPaths, withRowAnimation: deleteRowAnimation ?? defaultRowAnimation)

    let insertedIndexPaths = diff.inserted.map { NSIndexPath(forItem: $0, inSection: section) }
    self.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: insertRowAnimation ?? defaultRowAnimation)

    for (fromIx, toIx) in diff.moved {
      let fromIndexPath = NSIndexPath(forItem: fromIx, inSection: section)
      let toIndexPath = NSIndexPath(forItem: toIx, inSection: section)
      self.moveRowAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
  }
}
