//
//  ViewController.swift
//  RefreshKitDemo
//
//  Created by Shafujiu on 2021/1/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: RefreshTableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.refreshDelegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//            tableView.isHidden = true
//            tableView.allowShowMore = false
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.backgroundColor = .orange
        tableView.tableHeaderView = view
        
        tableView.beginRefreshingData()
        
//        _ = EmptyView(image: UIImage(named: "placeholder_empty"), title: "没有更多数据了", btnTitle: "刷新,数据了,数据了,数据了", emptyTapAction: nil)
//        self.view.addSubview(empty)
        
        
        
        
//        self.tableView.showEmpty(with: UIImage(named: "placeholder_empty"), title: "没有更多数据了", offsetY: 0, tapAction: {
//            print("tap")
//        }, btnClickAction: {
//            print("click")
//        })
        
            
        
//        empty.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableView.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = self.tableView.data[indexPath.row] as! Int
        cell.textLabel?.text = "\(model)"
        return cell
    }
}

extension ViewController: RefreshTableViewDelegate {
    func tableView(_ tableView: RefreshTableView, pageIndex: Int, complation: @escaping (RefreshTableView.Response) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            
            complation(.success([], pageIndex != 1))
        }
    }
    
    
}
