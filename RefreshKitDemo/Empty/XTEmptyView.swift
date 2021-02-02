//
//  EmptyView.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/2/1.
//

import UIKit
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
    
    
    init(image: UIImage?, title: String?, btnTitle: String?, offsetY: CGFloat = 0, emptyTapAction: (()->())?, btnClickAction: (()->())?) {
        
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
