//
//  RefreshTableView.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/1/29.
//

import UIKit
//import MJRefresh

protocol RefreshTableViewDelegate: class {
    /// 是否有下一页； 错误
    typealias Completion = (RefreshTableView.Response)->()
    
    func tableView(_ tableView: RefreshTableView, pageIndex: Int, complation: @escaping Completion)
}

fileprivate let kDefaultPageIndex = 1

class RefreshTableView: UITableView {
    
    enum Response {
        case success(_ object: [Any], _ noMoreData: Bool)
        case failure(_ error: Swift.Error)
    }

    weak var refreshDelegate: RefreshTableViewDelegate? {
        didSet {
            addRefreshHeader()
        }
    }
    
    private(set) var data: [Any] = []
    var customLoadBlock: ((_ list: [Any])->())?
    
    /// 最后一页是否展示 MJFooter 没更多数据
    @IBInspectable var allowShowMore: Bool = true
    @IBInspectable var allowShowBlank: Bool = true
    @IBInspectable var allowShowNoNetworkBlank: Bool = true
    @IBInspectable var blankImage: String?
    @IBInspectable var blankTitle: String?
    @IBInspectable var blankBtnTitle: String?
    @IBInspectable var topOffSet: CGFloat = 0
    
    var blankTapAction: (()->())?
    
    private var pageIndex = 1
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commontInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commontInit()
    }
    
    
    private func commontInit() {
        
    }
    
    
    class RefreshAutoNormalFooter: MJRefreshAutoNormalFooter {

        override func prepare() {
            super.prepare()
            
            self.mj_h = 65
            self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
            self.stateLabel?.textColor = #colorLiteral(red: 0.6784313725, green: 0.6941176471, blue: 0.7254901961, alpha: 1)
            self.setTitle("", for: .refreshing)
        }

    }

    class RefreshNormalHeader: MJRefreshNormalHeader {
        override func prepare() {
            super.prepare()
            self.mj_h = 50
            self.stateLabel?.font = UIFont.systemFont(ofSize: 12)
            self.stateLabel?.textColor = #colorLiteral(red: 0.6784313725, green: 0.6941176471, blue: 0.7254901961, alpha: 1)
            
            self.setTitle("下拉即可刷新", for: .idle)
            self.setTitle("松开立即刷新", for: .pulling)
            self.setTitle("数据加载中", for: .refreshing)
        }
    }
}


// MARK: - public api
extension RefreshTableView {
    
    /// MJHeader 下拉刷新动画 刷新
    func beginRefreshingData() {
        self.mj_header?.beginRefreshing()
    }
    
    /// 不带下拉刷新动画的刷新
    func refreshData() {
        loadData()
    }
}

// MARK: - header & footer
extension RefreshTableView {
    private func addRefreshHeader() {
        if let _ = mj_header { return }
        mj_header = RefreshNormalHeader { [weak self] in
            self?.loadData()
        }
    }
    
    private func addRefreshFooter() {
        if let _ = mj_footer { return }
        mj_footer = RefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            self?.loadMoreData()
        })
        
    }
    
    private func loadData() {
        let pageIdx = kDefaultPageIndex
        self.refreshDelegate?.tableView(self, pageIndex: pageIdx, complation: {
            switch $0 {
            case let .success(list, haveNext):
                self.mj_footer?.resetNoMoreData()
                self.mj_header?.endRefreshing()
                // 空页面逻辑
                if self.allowShowBlank, list.count == 0 {
                    self.mj_footer?.isHidden = true
                    self.showBlank()
                    return
                } else {
                    self.mj_footer?.isHidden = false
                    self.dismissBlank()
                }
                
                self.pageIndex = pageIdx
                self.addRefreshFooter()
                
                if haveNext {
                } else {
                    if self.allowShowMore {
                        self.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.mj_footer?.isHidden = true
                    }
                }
                
                if let _ = self.customLoadBlock {
                    self.customLoadBlock?(list)
                } else {
                    self.data = list
                    self.reloadData()
                }
            case .failure(let error):
                self.mj_header?.endRefreshing()
                if self.allowShowBlank, self.data.count == 0 {
                    self.mj_footer?.isHidden = true
                    
                    if self.allowShowNoNetworkBlank/*,是否有网络*/ {
                        self.showNoNetworkBlank()
                    } else {
                        self.showErrorBlank(error)
                    }
                } else {
                    self.mj_footer?.isHidden = false
                    self.dismissBlank()
                    // FIXME: - Toast
                    
                }
            }
        })
    }
    
    private func loadMoreData() {
        let pageIdx = pageIndex + 1
        refreshDelegate?.tableView(self, pageIndex: pageIdx, complation: {
            switch $0 {
            
            case let .success(list, hasNext):
                if hasNext {
                    self.mj_footer?.endRefreshing()
                } else {
                    if self.allowShowMore {
                        self.mj_footer?.endRefreshingWithNoMoreData()
                    } else {
                        self.mj_footer?.removeFromSuperview()
                        self.mj_footer = nil
                    }
                }
                self.pageIndex = pageIdx
                if let _ = self.customLoadBlock {
                    self.customLoadBlock?(list)
                } else {
                    self.data += list
                    self.reloadData()
                }
                
                
            case .failure(let error):
                
                self.mj_footer?.endRefreshing()
                // FIXME: - Toast
            }
            
            
        })
    }
    
    private func showBlank() {
        self.showBlank(withImage: blankImage,
                       title: blankTitle,
                       btnTitle: blankBtnTitle,
                       action: blankTapAction,
                       offsetY: topOffSet)
    }
    
    private func showNoNetworkBlank() {
        
        var disableTouch = true
        if let _ = self.blankTapAction {
            disableTouch = false
        }
        self.showBlank(withImage: "img_nonet",
                       title: "加载失败，点击按钮重新加载",
                       btnTitle: "刷新",
                       action: blankTapAction,
                       offsetY: topOffSet, disableTouch: disableTouch)
    }
    
    private func showErrorBlank(_ err: Error) {
        var disableTouch = true
        if let _ = self.blankTapAction {
            disableTouch = false
        }
        let blankTitle = err.localizedDescription.count == 0 ? self.blankTitle : err.localizedDescription
        self.showBlank(withImage: "img_nonet",
                       title: blankTitle,
                       btnTitle: "刷新",
                       action: blankTapAction,
                       offsetY: topOffSet, disableTouch: disableTouch)
    }
    
}


