//
//  Copyright 2016 Lionheart Software LLC
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.


import UIKit

protocol TableViewPopoverPresentingHelper: class {
    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController?
    func permittedArrowDirectionsForPopoverAtPoint(point: CGPoint) -> UIPopoverArrowDirection
}

public protocol TableViewPopoverPresenting: class, UIGestureRecognizerDelegate {
    var tableView: UITableView! { get }

    /**
     - parameter indexPath: The indexPath to optionally provide a popover for.
     - returns: Optionally returns a UIViewController. If no view controller is returned, no popover will be displayed for this index path.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func viewControllerForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIViewController?
    func permittedArrowDirectionsForPopoverAtIndexPath(indexPath: NSIndexPath) -> UIPopoverArrowDirection?
}

extension UIViewController: TableViewPopoverPresentingHelper {
    func viewControllerForPopoverAtPoint(point: CGPoint) -> UIViewController? {
        guard let controller = self as? TableViewPopoverPresenting,
            let indexPath = controller.tableView.indexPathForRowAtPoint(point) else {
            return nil
        }

        return controller.viewControllerForPopoverAtIndexPath(indexPath)
    }

    func permittedArrowDirectionsForPopoverAtPoint(point: CGPoint) -> UIPopoverArrowDirection {
        guard let controller = self as? TableViewPopoverPresenting,
            let indexPath = controller.tableView.indexPathForRowAtPoint(point),
            let arrowDirections = controller.permittedArrowDirectionsForPopoverAtIndexPath(indexPath) else {
                return .Any
        }

        return arrowDirections ?? .Any
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        guard let controller = self as? TableViewPopoverPresenting else {
            return true
        }

        if gestureRecognizer is UITapGestureRecognizer {
            let point = touch.locationInView(controller.tableView)
            return viewControllerForPopoverAtPoint(point) != nil
        }

        return false
    }

    @objc func handlePopoverGesture(gesture: UIGestureRecognizer?) {
        guard let popoverPresenter = self as? TableViewPopoverPresenting,
            let gesture = gesture else {
            return
        }

        let point = gesture.locationInView(popoverPresenter.tableView)
        guard let controller = viewControllerForPopoverAtPoint(point) else {
            return
        }

        controller.modalPresentationStyle = .Popover

        if let popover = controller.popoverPresentationController {
            popover.sourceView = popoverPresenter.tableView
            popover.permittedArrowDirections = permittedArrowDirectionsForPopoverAtPoint(point)
            popover.sourceRect = CGRect(x: point.x, y: point.y, width: 1, height: 1)
        }

        presentViewController(controller, animated: true, completion: nil)
    }
}

public extension TableViewPopoverPresenting where Self: UIViewController {
    /**
     This method instantiates `popoverPresentingTapGestureRecognizer` and adds it to the view controller's table view.

     - parameter selector: An Objective-C selector representing `popoverPresentingGestureDetected`.
     - author: Daniel Loewenherz
     - copyright: ©2016 Lionheart Software LLC
     - date: June 19, 2016
     */
    func initializeTableViewPopover() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handlePopoverGesture(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self

        tableView.addGestureRecognizer(tapGestureRecognizer)
    }
}