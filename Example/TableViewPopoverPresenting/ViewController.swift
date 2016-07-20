//
//  ViewController.swift
//  TableViewPopoverPresenting
//
//  Created by Dan Loewenherz on 06/19/2016.
//  Copyright (c) 2016 Dan Loewenherz. All rights reserved.
//

import UIKit
import TableViewPopoverPresenting

class ViewController: UITableViewController, TableViewPopoverPresenting, UIPopoverPresentationControllerDelegate {
    let CellIdentifier = "CellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "TableViewPopoverPresenting Example"

        initializeTableViewPopover()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)!
        cell.textLabel?.text = {
            switch indexPath.row {
            case 0:
                return "Colors"

            default:
                return "Row #\(indexPath.row)"
            }
        }()

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let alert = UIAlertController(title: "Hey", message: "Here be dragons.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: ":(", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - TableViewPopoverPresenting

    func permittedArrowDirectionsForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIPopoverArrowDirection? {
        return nil
    }

    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController? {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: "Important Question", message: "What's your favorite color?", preferredStyle: .ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "Red", style: .Default) { _ in })
            actionSheet.addAction(UIAlertAction(title: "Green", style: .Default) { _ in })
            actionSheet.addAction(UIAlertAction(title: "Blue", style: .Default) { _ in })

            if traitCollection.horizontalSizeClass == .Compact {
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { _ in })
            }

            if let popover = actionSheet.popoverPresentationController {
                popover.delegate = self
            }
            return actionSheet
        }

        return nil
    }

    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}

