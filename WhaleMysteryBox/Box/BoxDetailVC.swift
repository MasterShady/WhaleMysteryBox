//
//  BoxDetailVC.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import UIKit





//struct GoodSpec : HandyJSON{
//    struct ListModel: HandyJSON {
//        var id : Int!
//        var name : String!
//        var can_select: Bool!
//    }
//
//    var spec_name: String!
//    var list: [ListModel]!
//}



//
//struct GoodDetail : HandyJSON{
//    var goods_info: Box!
//    var goods_spec: [GoodSpec]!
//}


class BoxDetailVC: BaseVC {
    
    let box : Box
    
    init(box: Box) {
        self.box = box
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}
