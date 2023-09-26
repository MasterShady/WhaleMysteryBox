//
//  MineVC.swift
//  WhaleMall
//
//  Created by 刘思源 on 2023/9/13.
//

import UIKit


class MineVC: BaseVC {
    var stackView : UIStackView!
    var userAvater : UIImageView!
    var userNameLabel : UILabel!
    
    override func configSubViews() {
        hideNavBar = true
        
        stackView = .init()
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
        
        stackView.addArrangedSubview(self.header)
        stackView.addArrangedSubview(self.orderSection)
        stackView.addArrangedSubview(self.moreSection)
        
        updateUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUser()
    }
    
    func updateUser(){
        if (UserStore.isLogin){
            let currentUser = UserStore.currentUser!
            userAvater.image = currentUser.photo
            userNameLabel.text = currentUser.realname
        }else{
            userAvater.image = .init(named: "user_avatar")
            userNameLabel.text = "去登录"
        }
    }
    
    lazy var header: UIView = {
        let header = UIView()
        header.layer.contents = UIImage(named: "common_bg")!.cgImage
        userAvater = .init(frame: .zero)
        header.addSubview(userAvater)
        userAvater.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight + 60)
            make.left.equalTo(30)
            make.width.height.equalTo(72)
            make.bottom.equalTo(-30)
        }
        userAvater.chain.corner(radius: 36).clipsToBounds(true).backgroundColor(.kExLightGray)
        
        userNameLabel = .init()
        header.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            //make.top.equalTo(userAvater.snp.bottom).offset(12)
            make.left.equalTo(userAvater.snp.right).offset(12)
            make.centerY.equalTo(userAvater)
        }
        userNameLabel.chain.font(.semibold(16)).text(color: .kTextBlack)
        
        let goSettings = { [weak self] in
            UserStore.checkLoginStatusThen {
//                let vc = MinePersonalVC()
//                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        userAvater.chain.userInteractionEnabled(true).tap {
            goSettings()
        }
        
        userNameLabel.chain.userInteractionEnabled(true).tap {
            goSettings()
        }
        
        return header
    }()
    
    lazy var orderSection: UIView = {
        let orderSection = UIView()
        let title = UILabel()
        orderSection.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        title.chain.text("我的订单").font(.semibold(16)).text(color: .kTextBlack)
        
        let items : [(String, String, OrderStatus)] = [
            ("全部", "mine_all", .all),
            ("待发货", "mine_wait_to_ship", .waitToP),
            ("待收货", "mine_shipping", .inRenting),
            ("完成", "mine_wait_to_evaluate",.completed),
            ("已取消", "mine_refund", .cancelled)
        ]
        
        let insets = 20
        let itemW = (kScreenWidth - insets * 2)/items.count
        
        for (i, item) in items.enumerated() {
            let itemView = UIButton()
            orderSection.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.left.equalTo(insets + itemW * i)
                make.width.equalTo(itemW)
                make.top.equalTo(title.snp.bottom).offset(20)
                make.bottom.equalTo(-10)
            }
            
            let itemIcon = UIImageView()
            itemView.addSubview(itemIcon)
            itemIcon.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.height.equalTo(30)
                make.centerX.equalToSuperview()
            }
            itemIcon.image = .init(named: item.1)
            
            let itemNameLabel = UILabel()
            itemView.addSubview(itemNameLabel)
            itemNameLabel.snp.makeConstraints { make in
                make.top.equalTo(itemIcon.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            itemNameLabel.chain.text(item.0).text(color: .kTextBlack).font(.normal(14))
            
            itemView.addBlock(for: .touchUpInside) {[weak self] _ in
                guard let self = self else {return}
                UserStore.checkLoginStatusThen {
                    let vc = OrderListVC(status: item.2)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        return orderSection
    }()
    
    lazy var moreSection: UIView = {
        let moreSection = UIView()
        let title = UILabel()
        moreSection.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        title.chain.text("更多功能").font(.semibold(16)).text(color: .kTextBlack)
        
        let items = [
            ("客服", "mine_service", { [weak self] in
                let manager = MQChatViewManager()
                manager.pushMQChatViewController(in: self)

            }),

            ("收藏", "mine_collect",{ [weak self] in
                guard let self = self else {return}
//                userService.request(.getLikes) { result in
//                    result.hj_map2(Product.self) { body in
//                        let vc = ProductListVC(products: body.decodedObjList!)
//                        vc.title = "我的收藏"
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                }
            }),
            ("求购", "mine_wishlist", { [weak self] in
//                let vc = MyWishListVC()
//                self?.navigationController?.pushViewController(vc, animated: true)
            }),
            ("设置", "mine_settings",{ [weak self] in
//                let vc = SettingsVC()
//                self?.navigationController?.pushViewController(vc, animated: true)
            }),
        ]
        
        let insets = 20
        let itemW = (kScreenWidth - insets * 2)/5
        
        for (i, item) in items.enumerated() {
            let itemView = UIButton()
            moreSection.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.left.equalTo(insets + itemW * i)
                make.width.equalTo(itemW)
                make.top.equalTo(title.snp.bottom).offset(20)
                make.bottom.equalTo(-10)
            }
            
            let itemIcon = UIImageView()
            itemView.addSubview(itemIcon)
            itemIcon.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.width.height.equalTo(30)
                make.centerX.equalToSuperview()
            }
            itemIcon.image = .init(named: item.1)
            
            let itemNameLabel = UILabel()
            itemView.addSubview(itemNameLabel)
            itemNameLabel.snp.makeConstraints { make in
                make.top.equalTo(itemIcon.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            itemNameLabel.chain.text(item.0).text(color: .kTextBlack).font(.normal(14))
            itemView.addBlock(for: .touchUpInside) { _ in
                item.2()
            }
        }
        
        return moreSection
    }()
    
    
}
