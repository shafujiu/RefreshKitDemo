//
//  XTEmptyView.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/2/1.
//  XTEmptyView 不推荐直接使用 通过扩展使用空页面方法 showTableEmpty,   dismissEmpty 配对使用

import UIKit

fileprivate var emptyViewKey :Void?

extension UIView {
    /// 展示空页面
    /// - Parameters:
    ///   - image: 空页面图片
    ///   - title: 标题
    ///   - btnTitle: 按钮标题
    ///   - offsetY: 居中后的offsetY
    ///   - tapAction: 空页面点击
    ///   - btnClickAction: 按钮点击
    ///   - updateFrameBlock: 可以通过该方法修正frame 默认frame覆盖在当前view上
    func showEmpty(with image: UIImage?, title: String?, btnTitle: String? = nil, offsetY: CGFloat = 0, tapAction: (()->())?, btnClickAction: (()->())?, updateFrameBlock: ((CGRect, UIView)->(CGRect))? = nil) {
        // 添加新的
        let emptyView = XTEmptyView(image: image, title: title, btnTitle: btnTitle, offsetY:  offsetY, emptyTapAction: tapAction, btnClickAction: btnClickAction)
        self.showEmpty(emptyView, updateFrameBlock: updateFrameBlock)
    }
    
    func showEmpty(_ emptyView: XTEmptyView, updateFrameBlock: ((CGRect, UIView)->(CGRect))? = nil) {
        // 移除旧的
        let empty = objc_getAssociatedObject(self, &emptyViewKey) as? XTEmptyView
        empty?.removeFromSuperview()
        // 添加新的
        self.addSubview(emptyView)
        self.sendSubviewToBack(emptyView)
        
        objc_setAssociatedObject(self, &emptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        let y: CGFloat = 0
        let height = self.frame.height
        let width = self.frame.width
        var rect = CGRect(x: 0, y: y, width: width, height: height)
        rect = updateFrameBlock?(rect, self) ?? rect
        emptyView.frame = rect
    }
    
    /// 隐藏当前view添加的空页面
    func dismissEmpty() {
        let emptyView = objc_getAssociatedObject(self, &emptyViewKey) as? XTEmptyView
        emptyView?.removeFromSuperview()
        objc_setAssociatedObject(self, &emptyViewKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

extension UITableView {
    
    /// tableView空页面
    /// - Parameters:
    ///   - image: image description
    ///   - title: title description
    ///   - btnTitle: btnTitle description
    ///   - offsetY: offsetY description
    ///   - tapAction: tapAction description
    ///   - btnClickAction: btnClickAction description
    func showTableEmpty(with image: UIImage?, title: String?, btnTitle: String? = nil, offsetY: CGFloat = 0, tapAction: (()->())?, btnClickAction: (()->())?) {
        
        let emptyView = XTEmptyView(image: image, title: title, btnTitle: btnTitle, offsetY:  offsetY, emptyTapAction: tapAction, btnClickAction: btnClickAction)
        showTableEmpty(emptyView)
    }
    
    func showTableEmpty(_ emptyView: XTEmptyView, updateFrameBlock: ((CGRect, UIView)->(CGRect))? = nil) {
        
        let block = updateFrameBlock ?? {
            // 自动矫正
            let width = $0.width
            let x: CGFloat = 0
            var y: CGFloat = 0
            var height = $0.height
            
            if let tableV = $1 as? UITableView {
                y += tableV.tableHeaderView?.frame.height ?? 0
                height -= (tableV.tableHeaderView?.frame.height ?? 0) + (tableV.tableFooterView?.frame.height ?? 0)
            }
            return CGRect(x: x, y: y, width: width, height: height)
        }
        showEmpty(emptyView, updateFrameBlock: block)
    }
}

import SnapKit

class XTEmptyView: UIView {
    
    private var kContentSpace: CGFloat = 20
    
    private var kTitleFont = UIFont.systemFont(ofSize: 16)
    private var kTitleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    
    private var kBtnFont = UIFont.systemFont(ofSize: 16)
    private var kBtnBgColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    private var kBtnTextColor = UIColor.white
    private var kBtnHeight: CGFloat = 30
    private var kMinBtnWidth: CGFloat = 120
    
    private var offsetY: CGFloat = 0
    
    private var image: UIImage? {
        didSet {
            addImageView()
        }
    }
    
    private var title: String? {
        didSet {
            addTitleLbl()
        }
    }
    
    private var btnTitle: String? {
        didSet {
            addBtn()
        }
    }
    
    private var emptyTapAction: (()->())?
    private var btnClickAction: (()->())?
    
    fileprivate init(image: UIImage?, title: String?, btnTitle: String?, offsetY: CGFloat = 0, emptyTapAction: (()->())?, btnClickAction: (()->())?) {
        
        super.init(frame: .zero)
        self.image = image
        self.title = title
        self.btnTitle = btnTitle
        self.emptyTapAction = emptyTapAction
        self.btnClickAction = btnClickAction
        self.offsetY = offsetY
        setupSubViews()
    }
    
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = kTitleFont
        lbl.textColor = kTitleColor
        lbl.textAlignment = .center
        return lbl
    }()

    private lazy var bottomView: BottomView = {
        let view = BottomView()
        let btn = view.btn
        btn.titleLabel?.font = kTitleFont
        btn.setTitleColor(kBtnTextColor, for: .normal)
        btn.backgroundColor = kBtnBgColor
        btn.layer.cornerRadius = kBtnHeight * 0.5
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickAct), for: .touchUpInside)
        return view
    }()
    
    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = kContentSpace
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubViews()
    }
    
    private func setupSubViews() {
        addSubview(contentStack)
        contentStack.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(offsetY)
            make.left.equalToSuperview().offset(20)
        }
        
        addImageView()
        addTitleLbl()
        addBtn()
        addTapAction()
    }
    
    private func addImageView() {
        if let img = self.image {
            self.imageView.image = img
            
            if contentStack.arrangedSubviews.contains(self.imageView) {
                return
            }
            contentStack.addArrangedSubview(self.imageView)
        }
    }
    
    private func addTitleLbl() {
        if let title = self.title, title.count > 0 {
            self.titleLbl.text = title
            if contentStack.arrangedSubviews.contains(self.titleLbl) {
                return
            }
            contentStack.addArrangedSubview(self.titleLbl)
        }
    }

    private func addBtn() {
        if let btnT = self.btnTitle, btnT.count > 0 {
            
            self.bottomView.btn.setTitle(btnT, for: .normal)
            if contentStack.arrangedSubviews.contains(self.bottomView) {
                return
            }
            contentStack.addArrangedSubview(self.bottomView)
            self.bottomView.btn.sizeToFit()
            if self.bottomView.btn.frame.width < kMinBtnWidth {
                self.bottomView.btn.snp.makeConstraints { (make) in
                    make.width.equalTo(kMinBtnWidth)
                }
            }
        }
    }
    
    private func addTapAction() {
        if let _ = emptyTapAction {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
            self.addGestureRecognizer(tap)
        }
        
    }
    
    @objc private func tapAction()  {
        emptyTapAction?()
    }
    
    @objc private func clickAct() {
        btnClickAction?()
    }
    
    class BottomView: UIView {
        
        private var kMinBtnW: CGFloat = 120
        
        lazy var btn: UIButton = {
            let btn = UIButton(type: .system)
            btn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            return btn
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupSubViews()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupSubViews()
        }
        
        private func setupSubViews() {
            addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.height.equalTo(30)
                make.centerX.equalToSuperview()
            }
        }
    }
}

