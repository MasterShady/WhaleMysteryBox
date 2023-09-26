//
//  HomeVC.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import UIKit
import JXSegmentedView
import JXPagingView

class HomeHeader : BaseView{
    override func configSubviews() {
        let mainTitle = UILabel()
        self.addSubview(mainTitle)
        mainTitle.snp.makeConstraints { make in
            make.top.equalTo(11 + kStatusBarHeight)
            make.left.equalTo(20)
        }
        mainTitle.chain.font(.boldSystemFont(ofSize: 22)).text(color: .kTextBlack).text(kAppName)
        
        let subTitle = UILabel()
        self.addSubview(subTitle)
        subTitle.snp.makeConstraints { make in
            make.left.equalTo(mainTitle.snp.right).offset(4)
            make.centerY.equalTo(mainTitle)
        }
        subTitle.chain.font(.normal(14)).text(color: .kTextLightGray).text("专业游戏周边交易")
        
        
        let searchView = makeUnRegularBorderView { container in
            let searchIcon = UIImageView()
            container.addSubview(searchIcon)
            searchIcon.snp.makeConstraints { make in
                make.left.equalTo(17)
                make.width.height.equalTo(24)
                make.centerY.equalToSuperview()
            }
            searchIcon.chain.imageNamed("searchIcon")

            let searchLabel = UILabel()
            container.addSubview(searchLabel)
            searchLabel.snp.makeConstraints { make in
                make.left.equalTo(searchIcon.snp.right).offset(4)
                make.centerY.equalToSuperview()
            }
            searchLabel.chain.font(.systemFont(ofSize: 14)).text(color: .kTextLightGray).text("搜索")
            container.chain.tap { [weak self] in
                let searchVC =  SearchVC()
                self?.viewController?.navigationController?.pushViewController(searchVC, animated: true)
            }
        }

        self.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(mainTitle.snp.bottom).offset(12)
            make.left.equalTo(20)
            make.right.equalTo(-12)
            make.height.equalTo(38)
        }


        let itemW = (kScreenWidth - 50) / 2
        let leftView = makeUnRegularBorderView { container in
            container.chain.tap { [weak self] in
                let vc = BoxDetailVC(box: .init())
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }

        self.addSubview(leftView)
        leftView.snp.makeConstraints { make in
            make.width.height.equalTo(itemW)
            make.top.equalTo(searchView.snp.bottom).offset(10)
            make.left.equalTo(20)
        }

        let rightTopView = makeUnRegularBorderView {container  in
            container.chain.tap { [weak self] in
                let vc = BoxDetailVC(box: .init())
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.addSubview(rightTopView)
        rightTopView.snp.makeConstraints { make in
            make.top.equalTo(leftView)
            make.left.equalTo(leftView.snp.right).offset(10)
            make.width.equalTo(itemW)
            make.height.equalTo(itemW/2 - 5)
        }

        let rightBottomView = makeUnRegularBorderView {container  in
            container.chain.tap { [weak self] in
                let vc = BoxDetailVC(box: .init())
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.addSubview(rightBottomView)
        rightBottomView.snp.makeConstraints { make in
            make.top.equalTo(rightTopView.snp.bottom).offset(10)
            make.left.equalTo(leftView.snp.right).offset(10)
            make.width.equalTo(itemW)
            make.height.equalTo(itemW/2 - 5)
            make.bottom.equalTo(-20)
        }
    }
    
    func makeUnRegularBorderView(containerConfig: (UIView) ->()) -> UIView{
        let view = UIView()
        view.chain.corner(radius: 10).clipsToBounds(true).backgroundColor(.black)
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 1, left: 1, bottom: 3, right: 1))
        }
        container.chain.corner(radius: 9.5).clipsToBounds(true).backgroundColor(.white)
        containerConfig(container)
        return view
    }
    
    override func decorate() {
        let size = self.size
        let color = UIColor.gradient(fromColors:[.init(hexColor: "#C9D4F8"), .white] , size: size)
        self.backgroundColor = color
    }
    
    func scrollViewDidScroll(contentOffsetY: CGFloat) {
        var frame = self.frame
        frame.size.height -= contentOffsetY
        frame.origin.y = contentOffsetY
        self.frame = frame
    }
}


extension JXPagingListContainerView: JXSegmentedViewListContainer {}

class HomeVC: BaseVC {
    
    let headerH = 286 + kNavBarMaxY
    let segmentH = 48.0
    
    var pagingView: JXPagingView!
    var header = HomeHeader()
    var segmentView: JXSegmentedView!
    var datasource: JXSegmentedTitleDataSource!
    
    var titles = ["王者荣耀","原神","和平精英","火影忍者"]

    override func configSubViews() {
        self.hideNavBar = true
        

        segmentView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: segmentH))
        segmentView.backgroundColor = UIColor.white
        
        datasource = JXSegmentedTitleDataSource()
        datasource.titles = titles
        datasource.titleSelectedColor = .kTextBlack
        datasource.titleSelectedFont = .semibold(18)
        datasource.titleNormalColor = .kTextDrakGray
        datasource.titleNormalFont = .normal(18)
        datasource.isTitleColorGradientEnabled = true
        datasource.isTitleZoomEnabled = true
        
        
        segmentView.dataSource = datasource
        segmentView.isContentScrollViewClickTransitionAnimationEnabled = false
        
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = .kThemeColor
        lineView.indicatorWidth = 28
        lineView.indicatorHeight = 4
        segmentView.indicators = [lineView]
        
        pagingView = JXPagingView(delegate: self)
        self.view.addSubview(pagingView)
        pagingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentView.listContainer = pagingView.listContainerView
        

        
    }
    
}


extension HomeVC: JXPagingViewDelegate {
    
    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(headerH)
    }
    
    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return header
    }
    
    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return Int(segmentH)
    }
    
    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return segmentView
    }
    
    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return titles.count
    }
    
    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        let list = BoxListVC()
        return list
    }
    
    func mainTableViewDidScroll(_ scrollView: UIScrollView) {
        header.scrollViewDidScroll(contentOffsetY: scrollView.contentOffset.y)
    }
}

