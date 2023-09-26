//
//  CreateBoxVC.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import Foundation
import RxCocoa
import RxSwift
import CLImagePickerTool


class CreateBoxVC: BaseVC{
    
    var series: String?
    var finess = 1.0
    var boxTitle: String?
    var boxtContent: String?
    var boxImages = [UIImage]()
    var imagesRelay = BehaviorRelay(value: [UIImage]())
    var titleFiled: UITextField!
    var contentTextView: YYTextView!

    
    override func configSubViews() {
        self.title = "盲盒发布"
        self.edgesForExtendedLayout = []
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        let stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
//            make.top.left.right.equalToSuperview()
            make.width.equalTo(kScreenWidth)
        }
        stackView.axis = .vertical
        stackView.addArrangedSubview(gameSelectView)
        stackView.addSpacing(12)
        stackView.addArrangedSubview(finessView)
        stackView.addSpacing(12)
        stackView.addArrangedSubview(infoView)
        
        
        let commitBtn = UIButton()
        view.addSubview(commitBtn)
        commitBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kBottomSafeInset - 20)
            make.width.equalTo(280)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
        commitBtn.chain.backgroundColor(.kThemeColor).corner(radius: 22).clipsToBounds(true).normalTitle(text: "发布").font(.semibold(16)).normalTitleColor(color: .white)
        commitBtn.addTarget(self, action: #selector(commit(sender:)), for: .touchUpInside)
        
    }
    
    @objc func commit(sender: UIButton){
        if !self.series.isValid{
            "请选择盲盒系列".hint()
            return
        }
        if !titleFiled.text.isValid{
            "请输入商品的名称".hint()
            return
        }
        
        if !contentTextView.text.isValid{
            "请输入商品的描述信息".hint()
            return
        }
        
        if imagesRelay.value.count == 0{
            "请添加商品图片(至少一张)".hint()
            return
        }
        
        
        let alert = AEAlertView(style: .custom, title:nil , message: "提交成功,我们将在24小时内对商品进行审核,审核通过后您的商品将展示给平台用户")
        alert.addAction(action: .init(title: "确定", style: .cancel, handler: {[weak alert] action in
            alert?.dismiss()
        }))
        alert.show()
        
        
        
    }
    
    lazy var gameSelectView: UIView = {
        let gameSelectView = UIView()
        gameSelectView.backgroundColor = .white
        let titleLabel = UILabel()
        gameSelectView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(14)
        }
        titleLabel.chain.text("选择盲盒系列").font(.semibold(16)).text(color: .kTextBlack)
        
        let selectView = WhaleSelectView(items: ["王者荣耀", "原神", "和平精英", "火影忍者","王者荣耀", "原神", "和平精英", "火影忍者"], isSingleSeleted: true) {[weak self] obj in
            self?.series = obj[0].title
        }
        
        gameSelectView.addSubview(selectView)
        selectView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.bottom.equalTo(-14)
        }
                
        return gameSelectView
    }()
    
    lazy var finessView: UIView = {
        let finessView = UIView()
        finessView.backgroundColor = .white
        let titleLabel = UILabel()
        finessView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(14)
            make.bottom.equalTo(-14)
        }
        titleLabel.chain.text("商品成色").font(.semibold(16)).text(color: .kTextBlack)
        
        let valueBtn = UIButton()
        finessView.addSubview(valueBtn)
        valueBtn.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.centerY.equalToSuperview()
        }
        valueBtn.chain.normalImageNamed("arrow").font(.normal(14)).normalTitle(text: "全新").normalTitleColor(color: .kTextBlack).userInteractionEnabled(false)
        valueBtn.setImagePosition(.right, spacing: 5)
        
        let titleMap = [ 1: "全新", 0.99 :"99新", 0.9: "9新以上", 0.8: "8新以上", 0: "不限"]
        
        let finessPicker = SinglePicker(title: .init("全新", color: .white, font: .semibold(16)), data: [1,0.99,0.9,0.8,0]) {[weak self] item, sender in
            let value = titleMap[item]
            valueBtn.chain.normalTitle(text: titleMap[item]!)
            valueBtn.setImagePosition(.right, spacing: 5)
            self?.finess = item
            sender.popDismiss()
        } titleForDatum: {
            return titleMap[$0]!
        }
        finessPicker.setSelectedData(1)
        
        finessPicker.snp.makeConstraints { make in
            make.height.equalTo(280)
            make.width.equalTo(kScreenWidth)
        }
        

        finessView.chain.tap {
            finessPicker.popFromBottom()
        }

        return finessView
    }()
    
    lazy var infoView: UIView = {
        let infoView = UIView()
        infoView.backgroundColor = .white
        titleFiled = UITextField()
        infoView.addSubview(titleFiled)
        titleFiled.snp.makeConstraints { make in
            make.left.top.equalTo(14)
            make.right.equalTo(-14)
        }
        titleFiled.chain.font(.normal(16)).text(color: .kTextBlack).attributedPlaceholder(.init("请简要描述商品名称", color: .kTextLightGray, font: .normal(16)))
        
        
        let sep = UIView()
        infoView.addSubview(sep)
        sep.snp.makeConstraints { make in
            make.top.equalTo(titleFiled.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(1)
        }
        sep.backgroundColor = .kSepLineColor
        
        contentTextView = YYTextView()
        infoView.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(sep.snp.bottom).offset(12)
            make.left.equalTo(14)
            make.right.equalTo(-14)
            make.height.equalTo(120)
        }
        
        contentTextView.placeholderAttributedText = .init("请详细描述您的商品,比如发行商,购买日期,购买渠道,是否有原盒等等", color: .kTextLightGray, font: .normal(14))
        contentTextView.font = .normal(16)
        contentTextView.textColor = .kTextBlack
        
        let spacing = 20.0
        let inset = 14.0
        let imageStackView = UIStackView()
        imageStackView.axis = .horizontal
        imageStackView.spacing = 20
        infoView.addSubview(imageStackView)
//
        let imgWH = (kScreenWidth - inset * 2 - spacing * 2) / 3
//
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(10)
            make.left.equalTo(14)
            make.height.equalTo(imgWH)
            make.bottom.equalTo(-14)
        }
        
        

        
        imagesRelay.subscribe {[weak self] value in
            guard let self = self else {return}
            imageStackView.removeAllSubviews()
            
            let loopCount = min(3, value.element!.count + 1)
            for i in 0..<loopCount {
                let imageView = UIImageView()
                imageView.snp.makeConstraints { make in
                    make.width.height.equalTo(imgWH)
                }
                imageView.isUserInteractionEnabled = true
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true

                var action = {
                    let alert = AEAlertView(style: .defaulted, title: "", message: "确定删除该照片吗?")
                    alert.addAction(action: .init(title: "删除", handler: { action in
                        var array = value.element!
                        array.removeLast()
                        self.imagesRelay.accept(array)
                        alert.dismiss()
                    }))
                    alert.addAction(action: .init(title: "取消", handler: { action in
                        alert.dismiss()
                    }))
                    alert.show()

                }
                if i == loopCount - 1{
                    if i == value.element!.count - 1 {
                        //最后一个,是照片
                        imageView.image = value.element![i]
                    }else{
                        //添加照片的+好
                        imageView.image = UIImage(named: "plus")?.resizeImageToSize(size: CGSizeMake(30, 30))
                        imageView.contentMode = .center
                        imageView.size = CGSize(width: imgWH, height: imgWH)
                        imageView.addDashLine(with: .kTextLightGray, width: 1, lineDashPattern: [5,5], cornerRadius: 5)

                        action = {
                            self.pickerTool.cl_setupImagePickerWith(MaxImagesCount: 1, superVC: self) {[weak self] (assets, cutImage) in
                                guard let self = self else {return}
                                guard let image = cutImage else { return }
                                var raw = self.imagesRelay.value
                                raw.append(image)
                                self.imagesRelay.accept(raw)

                            }
                        }
                    }
                }else{
                    imageView.image = value.element![i]
                }
                let tap = UITapGestureRecognizer { _ in
                    action()
                }
                imageView.addGestureRecognizer(tap)
                imageStackView.addArrangedSubview(imageView)
            }
            
        }.disposed(by: disposeBag)
        
        return infoView
    }()
    
    lazy var pickerTool : CLImagePickerTool = {
        let pickerTool = CLImagePickerTool.init()
        pickerTool.isHiddenVideo = true
        pickerTool.cameraOut = true //设置相机选择在外部
        pickerTool.singleImageChooseType = .singlePicture //单选模式
        pickerTool.singleModelImageCanEditor = true //设置单选模式下图片可以编辑涂鸦
        return pickerTool
    }()
    
}
