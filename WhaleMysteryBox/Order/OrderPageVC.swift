//
//  YQHGOrderController.swift
//  YQHG
//
//  created by wyy on 2023/7/14.
//

import UIKit
import JXSegmentedView
class OrderPageVC: BaseVC, JXSegmentedListContainerViewDataSource {
    
    
    var dataSource:JXSegmentedTitleDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "订单"
    }
    
    
    
    override func configSubViews() {
        view.addSubview(segmentedV)
        view.addSubview(listContainerView)
        
        segmentedV.listContainer = listContainerView
        segmentedV.defaultSelectedIndex = 0
        
        dataSource = JXSegmentedTitleDataSource()
        dataSource.titles =  ["全部","进行中","已完成","已取消"]
        dataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        dataSource.titleSelectedFont = UIFont.semibold(18)
        dataSource.titleNormalColor = .kTextLightGray
        dataSource.titleSelectedColor = .kBlack
        segmentedV.dataSource = dataSource
        segmentedV.reloadData()
    }
    
    lazy var listContainerView: JXSegmentedListContainerView = {
        let lv = JXSegmentedListContainerView(dataSource: self)
        lv.frame = CGRect(x: 0, y: kNavBarMaxY + 35 , width: kScreenWidth, height: kScreenHeight - kNavBarMaxY - 35 - kTabbarHeight)
        return lv
    }()
    
    private lazy var segmentedV: JXSegmentedView = {
        let segment = JXSegmentedView(frame: CGRect(x: 0, y: kNavBarMaxY, width: kScreenWidth, height: 35))
        segment.backgroundColor = .clear
        
        let lineView =  JXSegmentedIndicatorLineView()
        lineView.indicatorColor = .kBlack
        lineView.indicatorWidth = 14
        lineView.indicatorHeight = 3 //横线高度
        lineView.verticalOffset = 0 //垂直方向偏移
        lineView.indicatorCornerRadius = 1.5
        
        segment.indicators = [lineView]
        return segment
    }()
    
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        4
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = OrderListVC(status: .all)
            return vc
        }
        else if index == 1 {
            let vc = OrderListVC(status: .waitToP)
            return vc
        }
        else if index == 2 {
            let vc = OrderListVC(status: .completed)
            return vc
        }
        else {
            let vc = OrderListVC(status: .cancelled)
            return vc
        }
    }
    
}

