//
//  SingleSelectView.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import Foundation

private let itemW = 76.0
private let itemH = 28.0

class WhaleSelectView : UIView{
    let items : [String]
    let selectedHandler: ([(title:String, index:Int)]) -> ()
    let isSingleSeleted: Bool
    
    var selectedObjs = [(title: String, index: Int)]()
    
    private var itemBtns = [UIButton]()
    
//    override var frame: CGRect{
//        didSet{
//            if oldValue != frame{
//                relayoutItems()
//            }
//        }
//    }
    
    override func layoutSubviews() {
        relayoutItems()
    }
    
    
    
    init(items: [String], isSingleSeleted: Bool,selectedHandler: @escaping ([(title:String, index:Int)]) -> Void) {
        self.items = items
        self.selectedHandler = selectedHandler
        self.isSingleSeleted = isSingleSeleted
        super.init(frame: .zero)
        configSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configSubViews(){
        
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        for (i,title) in items.enumerated() {
            let btn = UIButton()
            btn.size = CGSizeMake(itemW, itemH)
            btn.chain.normalTitle(text: title).normalTitleColor(color: .kTextDrakGray).selectedTitleColor(color: .white).normalBackgroundImage(.init(color: .kExLightGray)).selectedBackgroundImage(.init(color: .kThemeColor)).font(.normal(12)).corner(radius: itemH/2).clipsToBounds(true)
            btn.addBlock(for: .touchUpInside) {[weak self] sender in
                guard let self = self, let sender = sender as? UIButton else {return}
                if isSingleSeleted{
                    self.itemBtns.forEach { itemBtn in
                        itemBtn.isSelected = itemBtn == sender
                    }
                    self.selectedObjs = [(title,i)]
                    self.selectedHandler(self.selectedObjs)
                }else{
                    sender.isSelected.toggle()
                    if sender.isSelected{
                        self.selectedObjs.append((title,i))
                        self.selectedHandler(self.selectedObjs)
                    }else{
                        self.selectedObjs.removeAll { (ititle, ii) in
                            return title == ititle && i == ii
                        }
                        self.selectedHandler(self.selectedObjs)
                    }
                }
            }
            addSubview(btn)
            itemBtns.append(btn)
        }
        
    }
    
    
    func relayoutItems(){
        //let inset = 14
        let spacing = 10.0
        let layoutW = self.width
        var row = 0
        var line = -1
        var totalW = -spacing
        
        var lastBtn : UIButton!
        for (_, btn) in self.itemBtns.enumerated(){
            //下班.
            totalW += itemW + spacing
            if totalW > self.width{
                row += 1
                line = 0
                totalW = -spacing
            }else{
                line += 1
            }
            btn.frame = CGRect(x: (itemW + spacing) * line, y: (itemH + spacing) * row, width: itemW, height: itemH)
            lastBtn = btn
        }
        
        self.snp.updateConstraints { make in
            make.height.equalTo(lastBtn.frame.maxY)
        }
    }
}
