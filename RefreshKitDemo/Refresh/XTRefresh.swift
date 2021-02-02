//
//  XTRefresh.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/2/2.
//

import Foundation

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
