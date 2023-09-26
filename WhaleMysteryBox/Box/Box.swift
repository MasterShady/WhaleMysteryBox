//
//  Box.swift
//  WhaleMysteryBox
//
//  Created by 刘思源 on 2023/9/25.
//

import Foundation
import HandyJSON


let stringToArrayTransform = TransformOf<[String], Any>(fromJSON: { value in
    if let stringValue = value as? String{
        return stringValue.components(separatedBy: ",")
    }
    
    if let arrayValue = value as? [String]{
        return arrayValue
    }
    
    return nil
}, toJSON: { value in
    return value?.joined(separator: ",")
})




class Box : HandyJSON{
    
    var id: Int!
    var business_id: Int!
    var category_id: Int!
    var name: String!
    var price: Float = 0
    var pics = [String]()
    var list_pic: String = ""
    var deposit: Float!
    var rent_count: Int = 0
    var brand_name: String!
    var new_ratio_name: Int!
    
    var list_pic_base64: String!
    var content_pics_base64 = [String]()
    
    var content_pics = [String]()
    var is_specail_price: Bool!
    var status: Int!
    var create_time: Date!
    var update_time: Date!
    var is_collect = false
    //商品类型 1 手办、 2 显示器、 3 手柄 、 4 掌上电脑、5内存卡
    var goods_type: Int!
    
    lazy var goods_tag = ["角色再现","手工制作","工艺","材质好","配件齐全","适合拍摄","可机洗"].shuffled().suffix(3)
    lazy var wish_count = name.hashMapToInt(10)
    lazy var sales_count = name.hashMapToInt(30)
    var detail_content: String!
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<< self.create_time <-- CustomDateFormatTransform(formatString: "yyyy-MM-dd HH:mm:ss")
        mapper <<< pics <-- stringToArrayTransform
        mapper <<< content_pics <-- stringToArrayTransform
        mapper <<< content_pics_base64 <-- stringToArrayTransform
        mapper >>> goods_tag
    }
}
