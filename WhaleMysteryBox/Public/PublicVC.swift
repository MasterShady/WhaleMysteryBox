//
//  PublicVC.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import Foundation

let steps = """
        1.按规定格式发布盲盒/明盒，由卖家上传商品图片，生成商品上架平台.
        2.卖家可以选择将商品邮寄给平台进行审核来保证质量,审核通过则商品被标记为平台自营商品. 若审核不通过则商品将被下架
        3.卖家若不选择将商品邮寄给平台,商品信息通过审核后,将被标记为三分自营,商品的曝光度相较更低.
        4.买家可以在平台中进行购买,平台代收款后，全程引导双方交易.
        """



class PublicVC : BaseVC{
    
    
    override func configSubViews() {
        self.hideNavBar = true
        view.backgroundColor = .init(hexColor: "#EFEEF3")
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(39 + kStatusBarHeight)
            make.centerX.equalToSuperview()
        }
        imageView.image = .init(named: "public_header")
        
        let titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
        }
        titleLabel.chain.text("发布盲盒").font(.boldSystemFont(ofSize:  22)).text(color: .kTextBlack)
        
        let stepsLabel = UILabel()
        view.addSubview(stepsLabel)
        stepsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        stepsLabel.chain.text(color: .kTextBlack).font(.normal(14)).numberOfLines(0)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 8
        let stepsTitle = NSMutableAttributedString(string: steps, attributes: [
            .foregroundColor : UIColor.kTextBlack,
            .font: UIFont.normal(14),
            .paragraphStyle : paragraph
        ])
        stepsLabel.attributedText = stepsTitle
        
        let publishBtn = UIButton()
        
        view.addSubview(publishBtn)
        publishBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-20 - kBottomSafeInset - kTabbarHeight)
            make.width.equalTo(320)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
        publishBtn.chain.normalTitle(text: "立即发布").normalTitleColor(color: .kTextBlack).font(.boldSystemFont(ofSize: 16)).corner(radius: 24).backgroundColor(.white).clipsToBounds(true)
        
        publishBtn.addBlock(for: .touchUpInside) {[weak self] _ in
            self?.navigationController?.pushViewController(CreateBoxVC(), animated: true)
        }
        
    }
    
}
