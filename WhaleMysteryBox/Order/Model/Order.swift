//
//  OrderListModel.swift
//  YQHG
//
//  Created by wyy on 2023/7/21.
//

import Foundation
import HandyJSON

public enum OrderStatus: Int, HandyJSONEnum{
    case all = -1
    case waitToP = 0
    case inRenting = 1
    case completed = 2
    case cancelled = 5
    
    var statusText : String{
        switch self {
        case .waitToP:
            return "待发货"
        case .inRenting:
            return "已发货"
        case .completed:
            return "已完成"
        case .cancelled:
            return "已取消"
        case .all:
            return "全部"
        }
    }
}

class Order : HandyJSON{
    required init() {
        
    }
    
    
    var id : Int = 0
    var order_sn : String = ""
    var goods_id : Int = 0
    var price : Double = 0
    var order_day: Int = 0
    var amount : Double = 0
    var start_date : String = ""
    var end_date : String = ""
    var spec_ids : String = ""
    var create_time : String = ""
    var status: OrderStatus = .all //订单状态 待付款： 0 、 租赁中: 1、 已完成: 2、 已关闭/已取消: 5
    var goods_info : OrderGoodsInfo!
    var goods_cate_name : String = ""
}

class OrderGoodsInfo: HandyJSON{
    required init() {
        
    }
    
    var id:Int = 0
    var name:String = ""
    var list_pic:String = ""
    
    lazy var goods_tag: [String] = ["角色再现","手工制作","工艺","材质好","配件齐全","适合拍摄","可机洗"].shuffled().suffix(3)
    
    func mapping(mapper: HelpingMapper) {
        mapper >>> self.goods_tag
    }
    
    
}
