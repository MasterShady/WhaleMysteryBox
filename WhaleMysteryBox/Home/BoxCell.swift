//
//  BoxCell.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import UIKit

class BoxCell: UICollectionViewCell{
    var cover: UIImageView!
    var titleLabel: UILabel!
    var priceLabel: UILabel!
    var product : Box? {
        didSet{
            guard let product = product else {return}
            titleLabel.text = product.name
            priceLabel.text = String(format: "¥%.2f", product.price)
            cover.kf.setImage(with: URL(subPath: product.list_pic))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        self.chain.backgroundColor(.white).corner(radius: 5).clipsToBounds(true)
        cover = .init()
        contentView.addSubview(cover)
        cover.chain.corner(radius: 4).clipsToBounds(true).contentMode(.scaleAspectFit).backgroundColor(.kBlack)
        cover.snp.makeConstraints { make in
            make.top.left.equalTo(7)
            make.right.equalTo(-7)
            make.height.equalTo(cover.snp.width).multipliedBy(112/152.0)
        }
        
        
        let newTag = UIImageView()
        contentView.addSubview(newTag)
        newTag.snp.makeConstraints { make in
            make.top.equalTo(cover.snp.bottom).offset(8)
            make.left.equalTo(9)
            make.size.equalTo(CGSize(width: 47, height: 20))
        }
        newTag.image = .init(named: "tag_bg")
        
        let tagButton = UIButton()
        newTag.addSubview(tagButton)
        tagButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        tagButton.chain.normalImage(.init(named: "tag_star")).normalTitle(text: "New").normalTitleColor(color: .kTextBlack).font(.semibold(10))
        
        
        titleLabel = .init()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(newTag.snp.bottom).offset(8)
            make.left.equalTo(9)
            make.right.equalTo(-9)
        }
        
        // "a\na" 这个是用来layout计算高度用的.
        titleLabel.chain.text(color: .kTextBlack).font(.semibold(14)).numberOfLines(2).text("a\na")
        
        
        priceLabel = .init()
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(9)
        }
        priceLabel.chain.text(color: .init(hexColor: "#A4328A")).font(.semibold(18))
        
        
        let buyBtn = UIButton()
        contentView.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.width.equalTo(64)
            make.height.equalTo(28)
            make.right.equalTo(-12)
            make.bottom.equalTo(-12)
        }
        buyBtn.chain.normalTitleColor(color: .white).normalTitle(text: "购买").font(.medium(12)).backgroundColor(.black).corner(radius: 14).clipsToBounds(true).userInteractionEnabled(false)
    }
}
