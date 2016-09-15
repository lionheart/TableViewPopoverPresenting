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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)!
        cell.textLabel?.text = {
            switch (indexPath as NSIndexPath).row {
            case 0:
                return "Colors"

            default:
                return "Row #\((indexPath as NSIndexPath).row)"
            }
        }()

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let alert = UIAlertController(title: "Hey", message: "Here be dragons.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: ":(", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    // MARK: - TableViewPopoverPresenting

    func permittedArrowDirectionsForPopoverAtIndexPath(_ indexPath: IndexPath) -> UIPopoverArrowDirection? {
        return nil
    }

    func viewControllerForPopoverAtIndexPath(_ indexPath: IndexPath) -> UIViewController? {
        if (indexPath as NSIndexPath).row == 0 {
            let actionSheet = UIAlertController(title: "Important Question", message: "What's your favorite color?", preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Red", style: .default) { _ in })
            actionSheet.addAction(UIAlertAction(title: "Green", style: .default) { _ in })
            actionSheet.addAction(UIAlertAction(title: "Blue", style: .default) { _ in })

            if traitCollection.horizontalSizeClass == .compact {
                actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in })
            }

            if let popover = actionSheet.popoverPresentationController {
                popover.delegate = self
            }
            return actionSheet
        }

        return nil
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

