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
    
    
    /// 最后一页，是否允许展示 底部加载更多
    var allowShowMore: Bool { get }
    
    /// 是否允许空页面
    var allowShowEmpty: Bool { get }
    
    /// 是否允许无网络空页面
    var allowShowNoNetworkEmpty: Bool { get }
    
    /// 空页面图
    var emptyImage: UIImage? { get }
    
    /// 空页面 title
    var emptyTitle: String? { get }
    
    /// 空页面 按钮的文字
    var emptyBtnTitle: String? { get }
    
    /// 空页面偏移
    var emptyOffSetY: CGFloat { get }
    /// 加载第一页数据 没有任何数据的空页面 返回nil 时候，有默认值， 有值优先级最高
    var emptyView: XTEmptyView? { get }
    
    /// 加载第一页数据，接口返回error 有默认值
    var errorEmptyView: XTEmptyView? { get }
    
    
    /// 执行数据加载的代理
    /// - Parameters:
    ///   - tableView: 当前table
    ///   - pageIndex: 当前page
    ///   - complation: 需要回传给table的回调 RefreshTableView 根据该回调处理接口请求完成后的业务，包含空页面 refresh，pageindex 更新
    func tableView(_ tableView: RefreshTableView, pageIndex: Int, complation: @escaping Completion)
    
}

extension RefreshTableViewDelegate {
    var emptyView: XTEmptyView? { nil }
    var errorEmptyView: XTEmptyView? { nil }
    var allowShowMore: Bool { true }
    var allowShowEmpty: Bool { true }
    var allowShowNoNetworkEmpty: Bool { true }
    var emptyImage: UIImage? { UIImage(named: kDefaultEmptyImgName) }
    var emptyTitle: String? { kDefaultEmptyTitle }
    var emptyBtnTitle: String? { nil }
    var emptyOffSetY: CGFloat { 0 }
}

fileprivate let kDefaultPageIndex = 1
fileprivate let kDefaultEmptyImgName = "placeholder_empty"
fileprivate let kDefaultErrorImgName = "placeholder_error"
fileprivate let kDefaultEmptyTitle = "暂无数据"
fileprivate let kDefaultEmptyNoNetworkTitle = "加载失败，点击按钮重新加载"

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
    
//    @IBInspectable var blankBtnTitle: String?
//    @IBInspectable var topOffSet: CGFloat = 0
    
//    var blankTapAction: (()->())?
    
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
        self.refreshDelegate?.tableView(self, pageIndex: pageIdx, complation: { [weak self] in
            guard let self = self else {return}
            switch $0 {
            case let .success(list, haveNext):
                self.mj_footer?.resetNoMoreData()
                self.mj_header?.endRefreshing()
                // 空页面逻辑
                if self.refreshDelegate?.allowShowEmpty ?? true, list.count == 0 {
                    self.mj_footer?.isHidden = true
                    self.showBlank()
                    return
                } else {
                    self.mj_footer?.isHidden = false
                    self.dismissEmptyView()
                }
                
                self.pageIndex = pageIdx
                self.addRefreshFooter()
                
                if !haveNext {
                    if self.refreshDelegate?.allowShowMore ?? true {
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
                if self.refreshDelegate?.allowShowEmpty ?? true, self.data.count == 0 {
                    self.mj_footer?.isHidden = true
                    // FIXME: - 是否有网络
                    if self.refreshDelegate?.allowShowNoNetworkEmpty ?? true/*,是否有网络*/ {
                        self.showNoNetworkBlank()
                    } else {
                        self.showErrorBlank(error)
                    }
                } else {
                    self.mj_footer?.isHidden = false
                    self.dismissEmptyView()
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
                    if self.refreshDelegate?.allowShowMore ?? true {
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
}

// MARK: - private api
extension RefreshTableView {
    private func dismissEmptyView() {
        self.dismissEmpty()
    }
    
    private func showBlank() {
        if let empty = self.refreshDelegate?.emptyView {
            self.showTableEmpty(empty)
        } else {
            let image = self.refreshDelegate?.emptyImage
            let title = self.refreshDelegate?.emptyTitle ?? kDefaultEmptyTitle
            let btnTitle = self.refreshDelegate?.emptyBtnTitle
            let topOffsetY = self.refreshDelegate?.emptyOffSetY ?? 0
            self.showTableEmpty(with: image, title: title, btnTitle: btnTitle, offsetY: topOffsetY, tapAction: nil, btnClickAction: nil)
        }
    }
    
    private func showNoNetworkBlank() {
        
        let image = self.refreshDelegate?.emptyImage
        let title = self.refreshDelegate?.emptyTitle ?? kDefaultEmptyNoNetworkTitle
        let btnTitle = self.refreshDelegate?.emptyBtnTitle
        let topOffsetY = self.refreshDelegate?.emptyOffSetY ?? 0
        self.showTableEmpty(with: image, title: title, btnTitle: btnTitle, offsetY: topOffsetY, tapAction: { [weak self] in
            self?.loadData()
        }, btnClickAction: nil)
    }
    
    private func showErrorBlank(_ err: Error) {
        
        if let empty = self.refreshDelegate?.errorEmptyView {
            self.showTableEmpty(empty)
        } else {
            let blankTitle = err.localizedDescription.count == 0 ? self.refreshDelegate?.emptyTitle : err.localizedDescription
            let btnTitle = self.refreshDelegate?.emptyBtnTitle
            let topOffsetY = self.refreshDelegate?.emptyOffSetY ?? 0
            self.showTableEmpty(with: UIImage(named: kDefaultErrorImgName), title: blankTitle, btnTitle: btnTitle, offsetY: topOffsetY, tapAction: nil) { [weak self] in
                   self?.loadData()
            }
        }
    }
}


