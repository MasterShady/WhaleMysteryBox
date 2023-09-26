//
//  OrderCell.swift
//  YQHG
//
//  created by wyy on 2023/7/18.
//

import UIKit
import Kingfisher

class OrderCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        uiConfigure()
        myAutoLayout()
    }
    

    
    var data: Order? {
        didSet {
            guard let data = data else {return}
            
            
            var statusTitle = ""
            var statusIcon = ""
            if data.status == .cancelled{
                statusTitle = "已取消"
                statusIcon = "order_completed_dot"
            }else if data.status == .waitToP{
                statusTitle = "待发货"
                statusIcon = "order_renting_dot"
            }else if data.status == .inRenting{
                statusTitle = "已发货"
                statusIcon = "order_renting_dot"
            }else if data.status == .completed{
                statusTitle = "已完成"
                statusIcon = "order_completed_dot"
            }
            
            statusBtn.chain.normalTitle(text:statusTitle).normalImage(.init(named: statusIcon))
            statusBtn.setImagePosition(.left, spacing: 4)
            
            
            
            icon.kf.setImage(with: URL(subPath:data.goods_info!.list_pic))
            nameLbl.text = data.goods_info!.name
            orderTimeLB.text = data.create_time
            
            let rawTitle = " 自营  \(data.goods_info!.name)"
            let title = NSMutableAttributedString(rawTitle, color: .kBlack, font: .semibold(14))
            title.setAttributes([
                .backgroundColor : UIColor(hexColor: "#36F5FF")
            ], range: (rawTitle as NSString).range(of: " 自营 "))
            nameLbl.attributedText = title

 
            priceLabel.text = String(format: "合计：¥%.2f", data.amount)
            
            let priceString = String(format: "%.2f", data.amount)
            let raw = String(format: "实付款: %@元", priceString)
            let text = NSMutableAttributedString(raw, color: .kTextBlack, font: .systemFont(ofSize: 13))
            text.setAttributes([
                .font: UIFont.semibold(13),
                .foregroundColor: UIColor.kTextBlack
            ], range: (raw as NSString).range(of: priceString))
            
            priceLabel.attributedText = text
            
            tagStack.removeAllSubviews()
            data.goods_info?.goods_tag.forEach({ tag in
                let label = UIButton()
                label.chain.normalTitle(text:tag ).font(.systemFont(ofSize: 10)).normalTitleColor(color:.init(hexColor: "#A1A0AB")).content(edgeInsets: .init(top: 0, left: 7, bottom: 0, right: 7)).corner(radius: 7.5).clipsToBounds(true).backgroundColor(.init(hexColor: "#F3F4F7"))
                label.snp.makeConstraints { make in
                    make.height.equalTo(15)
                }
                tagStack.addArrangedSubview(label)
            })
            
            if data.status == .waitToP || data.status == .inRenting {
                priceLabel.snp.remakeConstraints { make in
                    make.top.equalTo(tagStack.snp.bottom).offset(6)
                    make.right.equalTo(-12)
                }
                //取消按钮
                BgView.addSubview(rightBtn)
                rightBtn.snp.remakeConstraints { make in
                    make.height.equalTo(30)
                    make.width.equalTo(71)
                    make.bottom.right.equalTo(-12)
                    make.top.equalTo(priceLabel.snp.bottom).offset(12)
                }
                
            }else{
                rightBtn.removeFromSuperview()
                priceLabel.snp.remakeConstraints { make in
                    make.top.equalTo(tagStack.snp.bottom).offset(6)
                    make.bottom.right.equalTo(-12)
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func uiConfigure() {
        contentView.addSubview(self.BgView)
        
        
    }
    func myAutoLayout() {
        BgView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.top.equalTo(8)
            make.bottom.equalToSuperview()
        }
        
        BgView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(46)
        }
        
        let sep = UIView()
        topView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(0.5)
        }
        sep.backgroundColor = .init(hexColor: "#EEEEEE")
        
        
        topView.addSubview(statusBtn)
        statusBtn.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        topView.addSubview(orderTimeLB)
        orderTimeLB.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        
        BgView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(11)
            make.left.equalTo(12)
            make.height.width.equalTo(78)
        }
        
        
        BgView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(icon)
            make.left.equalTo(icon.snp.right).offset(8)
            make.right.equalTo(-12)
        }
        
        BgView.addSubview(propertyLB)
        propertyLB.snp.makeConstraints { make in
            make.left.equalTo(nameLbl)
            make.top.equalTo(nameLbl.snp.bottom).offset(5)
            make.right.equalTo(-12)
        }
        
        BgView.addSubview(tagStack)
        tagStack.snp.makeConstraints { make in
            make.bottom.equalTo(icon)
            make.left.equalTo(nameLbl)
        }
        
        
        
        BgView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(tagStack.snp.bottom).offset(6)
            make.right.equalTo(-12)
        }
        
        
        
        

        
    }
    
    lazy var BgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds  = true
        imageView.backgroundColor = .init(hexColor: "#F5F5F5")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let label =  UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .kTextBlack
        label.text = "租赁中"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var tagStack : UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    lazy var statusBtn : UIButton = {
        let btn = UIButton()
        btn.chain.normalImage(.init(named: "order_renting_dot")).normalTitle(text: "进行中").font(.systemFont(ofSize: 12)).normalTitleColor(color: .init(hexColor: "#333333"))
        btn.setImagePosition(.left, spacing: 4)
        return btn
    }()
    
    
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hexColor: "#333333")
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var propertyLB: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .kTextBlack
        label.text = "货到付款/现货速发"
        return label
    }()
    
    
    lazy var orderTimeLB: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .init(hexColor: "#A1A0AB")
        label.text = "订单时间：2023/07/12 11:30"
        return label
    }()
    
//    lazy var rentTimeLB: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        label.textColor = COLORA0A0AC
//        label.text = "租赁时长：07/12-08/03 合计30日"
//        return label
//    }()
//
    
    
    lazy var priceLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .white
        label.text = "合计：¥70.0"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var rightBtn: UIButton = {
        let button =  UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(.init(hexColor: "#2D2D2D"), for: .normal)
        button.setTitle("取消", for: .normal)
        let gradientColor = UIColor.gradient(fromColors: [.init(hexColor: "#B2FAFD"), .init(hexColor: "#FEF2FF")], size: CGSize(width: 71, height: 30))
        
        button.chain.backgroundColor(gradientColor).corner(radius: 15).clipsToBounds(true)
        return button
    }()
    
    
    
    
}
