//
//  YQHGOrderAllViewController.swift
//  YQHG
//
//  created by wyy on 2023/7/18.
//

import UIKit
import JXSegmentedView
import MJRefresh

class OrderListVC: BaseVC {
    let status: OrderStatus
    var scrollCallBack: ((UIScrollView) -> ())?
    var dataList = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .init(hexColor: "#1D1E22")
        NotificationCenter.default.addObserver(self, selector: #selector(onUserMakeOrder), name: kUserMakeOrder.name, object: nil)
    }
    
    
    init(status: OrderStatus){
        self.status = status
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func onUserChanged() {
        loadOrders()
    }
    
    override func onReconnet() {
        loadOrders()
    }
    
    @objc func onUserMakeOrder(){
        loadOrders()
    }
    
    func loadOrders(){
        if !UserStore.isLogin{
            DispatchQueue.main.async {
                self.tableView.mj_header?.endRefreshing()
                self.dataList = []
                self.configNoData()
                self.tableView.reloadData()
            }
            return
        }
        
        userService.request(.getOrderList(status: status)) { result in
            self.tableView.mj_header?.endRefreshing()
            result.hj_map2(Order.self) { body, error in
                guard let body = body else {return}
                self.dataList = body.decodedObjList!
                self.tableView.reloadData()
                self.configNoData()
            }
        }
    }
   
    
    func configNoData() {
        if self.dataList.count > 0 {
            self.tableView.hideStatus()
        } else {
            self.tableView.showStatus(.noData)
        }
    }
    
    
    override func configNavigationBar() {
        self.title = status.statusText
    }
    
    override func configSubViews() {        
        view.addSubview(tableView)
        tableView.register(OrderCell.self, forCellReuseIdentifier: NSStringFromClass(OrderCell.self))
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top:0 , left: 0, bottom: 0, right: 0))
        }
        loadOrders()
        
        self.view.rx.observe(\.frame).debounce(.milliseconds(20), scheduler: MainScheduler.instance).distinctUntilChanged().subscribe { frame in
            printLog("triggerd")
            let size = frame.size
            let gradientColor = UIColor.gradient(fromColors: [.init(hexColor: "#E7F8FA"), .init(hexColor: "#FFF3FF")], size: size)
            self.view.backgroundColor = gradientColor
        }.disposed(by: disposeBag)
    }
    
    
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        let mj_header = MJRefreshNormalHeader{ [weak self] in
            self?.loadOrders()
        }
        if (self.parent is UINavigationController){
            mj_header.ignoredScrollViewContentInsetTop = kNavBarMaxY
        }
        
        tableView.mj_header = mj_header
        return tableView
    }()
    
}
    
extension OrderListVC:UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(OrderCell.self), for: indexPath) as! OrderCell
        cell.data = self.dataList[indexPath.row]
        cell.rightBtn.tag = indexPath.row
        cell.rightBtn.addTarget(self, action: #selector(rightBtnClick(btn:)), for: .touchUpInside)
       
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = OrderDetailVC(data: dataList[indexPath.row])

        self.navigationController?.pushViewController(VC, animated: true)
    }

    
    //新增收货地址
    @objc private func rightBtnClick(btn:UIButton) {
        
        let alertController = UIAlertController(title: "", message: "确认取消订单?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "我再想想", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (ACTION) in
            
            userService.request(.cancelOrder(id: self.dataList[btn.tag].id)) { result in
                result.hj_map2(IgnoreData.self) { _, error in
                    if let error = error{
                        error.msg.hint()
                        return
                    }
                    "取消订单成功".hint()
                    self.loadOrders()
                }
            }
        }
               alertController.addAction(cancelAction);
               alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
        
    }
}



extension OrderListVC :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}
