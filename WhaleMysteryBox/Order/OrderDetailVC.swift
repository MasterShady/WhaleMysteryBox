//
//  YQHGOrderDetailController.swift
//  YQHG
//
//  created by wyy on 2023/7/18.
//

import UIKit

class OrderDetailVC: BaseVC {
    let data: Order
    
    var goodsView:UIView!
    var messageView:UIView!
    
    weak var timer : Timer?

    init(data: Order) {
        self.data = data
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        timer?.invalidate()
        timer = nil
    }
    
    func formatTime(seconds: Int) -> String {
        let days = seconds / 86400
        let hours = (seconds % 86400) / 3600
        let minutes = (seconds % 3600) / 60
        let remainingSeconds = seconds % 60
        if days > 0 {
            return String(format: "%zd天 %02zd:%02zd:%02zd", days,hours,minutes,remainingSeconds)
        }else{
            return String(format: "%02zd:%02zd:%02zd",hours,minutes,remainingSeconds)
        }
    }
    
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }
    
    override func configSubViews(){
        self.title = "订单详情"
        self.view.backgroundColor = .kExLightGray
        
        let indicator = UIImageView()
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.top.left.equalTo(kNavBarMaxY + 14)
            make.left.equalTo(14)
        }
        indicator.image = .init(named: "order_progress_gray")?.withTintColor(.kThemeColor)
        
        let statusLabel = UILabel()
        view.addSubview(statusLabel)
        statusLabel.snp.makeConstraints { make in
            make.left.equalTo(indicator.snp.right).offset(16)
            make.top.equalTo(kNavBarMaxY + 8)
        }
        statusLabel.chain.text(data.status.statusText).font(.semibold(20)).text(color: .kBlack)
        
        
        let cardView = UIView()
        view.addSubview(cardView)
        let colorW = kScreenWidth - 12.0 * 2
        let colorH: CGFloat = 112.0
        let gradientColor = UIColor.gradient(colors: [.kThemeColor, .init(hexColor: "#FEF2FF")], from: CGPoint(x: colorW/2, y: 0), to: CGPoint(x: colorW/2, y: colorH), size: CGSize(width: colorW, height: colorH))
        cardView.chain.backgroundColor(gradientColor).corner(radius: 10).clipsToBounds(true)
        
        
        let container = UIView()
        cardView.addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4))
        }
        container.chain.backgroundColor(.white).corner(radius: 6).clipsToBounds(true)
        

        cardView.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(14)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(112)
        }
        
        let cover = UIImageView()
        container.addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.equalTo(17)
            make.bottom.equalTo(-17)
            make.left.equalTo(12)
            make.width.height.equalTo(78)
        }
        cover.backgroundColor = .init(hexColor: "#F5F5F5")
        cover.contentMode = .scaleAspectFill
        cover.kf.setImage(with: URL(subPath: data.goods_info.list_pic))
        
        let nameLabel = UILabel()
        container.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(cover.snp.right).offset(8)
            make.right.equalTo(-12)
            make.top.equalTo(17)
        }
        nameLabel.chain.font(.semibold(13)).text(color: .init(hexColor: "#333333")).numberOfLines(0).text(data.goods_info.name)
        
        let maillingLabel = UILabel()
        container.addSubview(maillingLabel)
        maillingLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel)
        }
        maillingLabel.chain.font(.systemFont(ofSize: 12)).text(color: .init(hexColor: "#A1A0AB")).text("顺丰包邮/现货速发")
        
        let priceLabel = UILabel()
        container.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cover)
            make.left.equalTo(nameLabel)
        }
        
        let row = String(format: "¥%.2f/天起", data.price) as NSString
        let price = NSMutableAttributedString(string: row as String, attributes: [
            .foregroundColor : UIColor.kTextBlack,
            .font : UIFont.systemFont(ofSize: 18, weight: .semibold)
        ])
        price.setAttributes([
            .foregroundColor : UIColor.kTextBlack,
            .font : UIFont.systemFont(ofSize: 10)
        ], range: row.range(of: "¥"))
        
        price.setAttributes([
            .foregroundColor : UIColor(hexColor: "#A1A0AB"),
            .font : UIFont.systemFont(ofSize: 10)
        ], range: row.range(of: "/天起"))
        priceLabel.attributedText = price
        
        let infoView = UIView()
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(cardView.snp.bottom).offset(8)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        infoView.chain.backgroundColor(.white).corner(radius: 10).clipsToBounds(true)
        
        let infoTitle = UILabel()
        infoView.addSubview(infoTitle)
        infoTitle.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(12)
        }
        infoTitle.chain.text("订单信息").font(.semibold(15)).text(color: .init(hexColor: "333333"))
        
        
        let startDate = Date(string: data.start_date, format: "YYYY-MM-dd")!
        let endDate = Date(string: data.end_date, format: "YYYY-MM-dd")!
        let dayCount = daysBetweenDates(startDate: startDate, endDate: endDate)
        
        var infos = [
            ("订单编号", data.order_sn),
            ("创建时间", data.create_time),
            //("租赁时长", "\(startDate.dateString(withFormat: "YYYY/MM/dd"))-\(endDate.dateString(withFormat: "YYYY/MM/dd"))"),

        ]
        
        if data.status != .cancelled{
            infos.append(contentsOf:[
                ("物流状态", "通知商家备货中,预计48小时内发出"),
                ("快递单号", "待揽收...")
            ])
        }
        
        let stack = UIStackView()
        infoView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(infoTitle.snp.bottom).offset(4)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        stack.axis = .vertical
        infos.forEach { title,value in
            let item = UIView()
            item.snp.makeConstraints { make in
                make.height.equalTo(47)
            }
            
            let titleLabel = UILabel()
            item.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(0)
                make.centerY.equalToSuperview()
            }
            titleLabel.chain.font(.systemFont(ofSize: 15)).text(color: .init(hexColor: "#333333")).text(title)
            
            let valueLabel = UILabel()
            item.addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                make.right.equalTo(0)
                make.centerY.equalToSuperview()
            }
            valueLabel.chain.font(.systemFont(ofSize: 15)).text(color: .init(hexColor: "#333333")).text(value)
            stack.addArrangedSubview(item)
        }
        
        let sep = UILabel()
        infoView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.height.equalTo(0.5)
        }
        sep.backgroundColor = .init(hexColor: "#EEEEEE")
        
        let amountLabel = UILabel()
        infoView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).offset(19)
            make.left.equalTo(12)
            //make.bottom.equalTo(-20)
        }
        amountLabel.chain.font(.semibold(14)).text(color: .init(hexColor: "333333")).text("订单金额")
        
        
        
        let amountValue = UILabel()
        infoView.addSubview(amountValue)
        amountValue.snp.makeConstraints { make in
            make.right.equalTo(-12)
            make.centerY.equalTo(amountLabel)
        }
        
        let raw = String(format: "¥%.2f", data.amount)
        let amount = NSMutableAttributedString(raw, color: .kTextBlack, font: .semibold(18))
        amount.setAttributes([
            .font : UIFont.semibold(10),
            .foregroundColor: UIColor.kTextBlack
        ], range: (raw as NSString).range(of: "¥"))
        
        amountValue.attributedText = amount
        
        let shipHint = UILabel()
        infoView.addSubview(shipHint)
        shipHint.snp.makeConstraints { make in
            make.top.equalTo(amountValue.snp.bottom).offset(10)
            make.right.equalTo(-12)
            make.bottom.equalTo(-16)
        }
        shipHint.chain.font(.normal(12)).text(color: .red).text(data.status == .cancelled ? "已取消" : "* 货到付款,请于快递员确认货品完好后签收")

    }
    

//    @objc private func BtnClickAction() {
//
//        let alertController = UIAlertController(title: "", message: "确认取消订单?", preferredStyle: UIAlertController.Style.alert)
//        let cancelAction = UIAlertAction(title: "我再想想", style: UIAlertAction.Style.cancel, handler: nil )
//        let okAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (ACTION) in
//            userService.request(.cancelOrder(id: self.data.id)) { result in
//                result.hj_map2(IgnoreData.self) { body, error in
//                    if let error = error{
//                        error.msg.hint()
//                        return
//                    }
//                    "取消成功".hint()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                        self.navigationController?.popViewController(animated: true)
//                    }
//                }
//            }
//        }
//               alertController.addAction(cancelAction);
//               alertController.addAction(okAction);
//        self.present(alertController, animated: true, completion: nil)
//
//    }



}
