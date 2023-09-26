//
//  BoxListVC.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import UIKit
import JXPagingView

class BoxListVC: BaseVC {
    var collectionView : UICollectionView!
    var boxesRelay = BehaviorRelay(value: [Box]())
    var listViewDidScrollCallback: ((UIScrollView) -> ())?
    
    override func configSubViews() {
        let layout = UICollectionViewFlowLayout()
        let itemW = (kScreenWidth - 28 - 10) / 2
        layout.itemSize = CGSize(width: itemW, height: itemW * 1.5)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.contentInset = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        collectionView.register(BoxCell.self, forCellWithReuseIdentifier:"cellId")
        
        boxesRelay.bind(to: collectionView.rx.items(cellIdentifier: "cellId", cellType: BoxCell.self)) { index, element ,cell in
            cell.backgroundColor = .random()
        }.disposed(by: disposeBag)
        
        
        
    }
    
    override func networkRequest() {
        boxesRelay.accept([.init(),.init(),.init()])
    }

}


extension BoxListVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
}


extension BoxListVC: JXPagingViewListViewDelegate {
    public func listView() -> UIView {
        return self.view
    }
    
    public func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    public func listScrollView() -> UIScrollView {
        return self.collectionView
    }
}
