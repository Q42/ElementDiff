//
//  ViewController.swift
//  ElementDiff-Example
//
//  Created by Tom on 2016-12-06.
//  Copyright © 2016 Q42. All rights reserved.
//

import UIKit
import GameKit
import ElementDiff

class ViewController: UITableViewController {

  var items: [(String, UIColor)] = [] {
    didSet {
      let diff = oldValue.diff(items, identifierSelector: { $0.0 })

      tableView.beginUpdates()
      tableView.updateSection(0, diff: diff)
      tableView.endUpdates()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    self.tableView.contentInset.top = 20

    self.items = allItems
    Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
      self.items = newItems()
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let item = items[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.textColor = .white

    cell.textLabel?.text = item.0
    cell.backgroundColor = item.1

    return cell
  }
}

// Produce new data

var allItems: [(String, UIColor)] = [
  ("One", #colorLiteral(red: 0.8274509804, green: 0.2784313725, blue: 0.2784313725, alpha: 1)),
  ("Two", #colorLiteral(red: 0.8156862745, green: 0.5215686275, blue: 0.2784313725, alpha: 1)),
  ("Three", #colorLiteral(red: 0.1647058824, green: 0.4941176471, blue: 0.4941176471, alpha: 1)),
  ("Four", #colorLiteral(red: 0.2274509804, green: 0.662745098, blue: 0.2235294118, alpha: 1)),
  ("Five", #colorLiteral(red: 0.6039215686, green: 0.1960784314, blue: 0.4039215686, alpha: 1)),
  ("Six", #colorLiteral(red: 0.7333333333, green: 0.7176470588, blue: 0.2392156863, alpha: 1)),
  ("Seven", #colorLiteral(red: 0.3568627451, green: 0.1803921569, blue: 0.4941176471, alpha: 1)),
  ("Eight", #colorLiteral(red: 0.5098039216, green: 0.6823529412, blue: 0.2156862745, alpha: 1))
]

func newItems() -> [(String, UIColor)] {

  var items = allItems

  if arc4random_uniform(3) == 1 {
    items.remove(at: Int(arc4random_uniform(UInt32(items.count))))
  }

  if arc4random_uniform(3) == 1 {
    let from = Int(arc4random_uniform(UInt32(items.count)))
    let item = items.remove(at: from)

    let to = Int(arc4random_uniform(UInt32(items.count)))
    items.insert(item, at: to)
  }

  return items
}
