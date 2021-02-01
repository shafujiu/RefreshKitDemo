//
//  UIView+Empty.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/2/1.
//

import UIKit

fileprivate var emptyViewKey :Void?
extension UIView {
    
    
    func showEmpty(with image: UIImage?, title: String?, btnTitle: String?, offsetY: CGFloat = 0, tapAction: (()->())?, btnClickAction: (()->())?) {
        // 添加新的
        var blankView = objc_getAssociatedObject(self, &emptyViewKey) as? EmptyView
        blankView?.removeFromSuperview()
//        if blankView == nil {
        blankView = EmptyView(image: image, title: title, btnTitle: btnTitle, offsetY:  offsetY, emptyTapAction: tapAction, btnClickAction: btnClickAction)
            self.addSubview(blankView!)
            self.sendSubviewToBack(blankView!)
        objc_setAssociatedObject(self, &emptyViewKey, blankView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//
//        if let _ = action {
//            blankView?.isUserInteractionEnabled = true
//        }else {
//            blankView?.isUserInteractionEnabled = false
//        }
        var y: CGFloat = 0
        var height = self.frame.height
        if let tableV = self as? UITableView {
            y += tableV.tableHeaderView?.frame.height ?? 0
            height -= (tableV.tableHeaderView?.frame.height ?? 0) + (tableV.tableFooterView?.frame.height ?? 0)
        }
        let width = self.frame.width
        blankView?.frame = CGRect(x: 0, y: y, width: width, height: height)
    }
    
    
}
