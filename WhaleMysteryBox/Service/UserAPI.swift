//
//  LoginService.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/21.
//

import UIKit
import Moya
import HandyJSON
import Alamofire

let kUserChanged = Notification(name: .init("kUserChanged"), object: nil)
let kUserMakeOrder = Notification(name: .init("kUserMakeOrder"), object: nil)


let userService = MoyaProvider<UserAPI>(endpointClosure:MoyaProvider.customEndpointMapping, plugins:moyaPlugins)


public enum UserAPI {
    case addWish(name:String, content: String ,good_type:Int, price:Float,list_pic:UIImage, content_pics:[UIImage], new_ratio_name: Int)
    case login(mobile:String, passwd: String)
    case register(mobile:String, passwd: String)
    case getAddressList
    case deleteAddress(id: Int)
    case addAddress(uname: String, phone: String, address_area: String, address_detail:String, is_default: Bool)
    case updateAddress(id:Int ,uname: String, phone: String, address_area: String, address_detail:String, is_default: Bool)
    case makeOrder(id: Int)
    case getOrderList(status: OrderStatus)
    case cancelOrder(id: Int)
    case getLikes
    case getFootprints
    case like(id:Int)
    case dislike(id: Int)
    case goodsList(data_type: Int = 0, me_publish: Bool = false)
    case goodDetail(id: Int)
}

extension UserAPI: TargetType {
    public var baseURL: URL { URL(string:kRequestHost)! }
    
    public var path: String {
        switch self {
        case .addWish:
            return "addWant"
        case .login:
            return "login"
        case .register:
            return "register"
        case .getAddressList:
            return "addressList"
        case .deleteAddress:
            return "delAddress"
        case .addAddress:
            return "addAddress"
        case .updateAddress:
            return "updateAddress"
        case .makeOrder:
            return "addOrder"
        case .getOrderList:
            return "orderList"
        case .cancelOrder:
            return "orderCancel"
        case .getLikes:
            return "userCollect"
        case .like, .dislike:
            return "setCollect"
        case .getFootprints:
            return "userFootprint"
        case .goodsList:
            return "goodsList"
        case .goodDetail:
            return "goodsDetail"

        }
    }
    
    
    public var method: Moya.Method { .post }

    public var task: Task {
        switch self {
        case .addWish(let name, let content, let good_type, let price, let list_pic, let content_pics, let new_ratio_name):
            return .requestParameters(parameters: [
                "name":name,
                "detail_content": content,
                "good_type":good_type,
                "price": price,
                "list_pic": list_pic.toBase64(),
                "content_pics": content_pics.map{$0.toBase64()}.joined(separator: ","),
                "new_ratio_name": new_ratio_name
            ], encoding: JSONEncoding.default)
        case .login(let userName, let passwd):
            return .requestParameters(parameters: ["phone": userName, "password": passwd], encoding: JSONEncoding.default)
        case .register(let mobile, let passwd):
            return .requestParameters(parameters: ["phone":mobile,"password":passwd], encoding: JSONEncoding.default)
        case .getAddressList:
            return .requestPlain
        case .deleteAddress(let id):
            return .requestParameters(parameters: ["address_id":id], encoding: JSONEncoding.default)
        case .addAddress(let uname, let phone, let address_area, let address_detail, let is_default):
            return .requestParameters(parameters: [
                "uname":uname,
                "phone":phone,
                "address_area":address_area,
                "address_detail": address_detail,
                "is_default": is_default
            ], encoding: JSONEncoding.default)
        case .updateAddress(id: let id, uname: let uname, phone: let phone, address_area: let address_area, address_detail: let address_detail, is_default: let is_default):
            return .requestParameters(parameters: [
                "address_id": id,
                "uname":uname,
                "phone":phone,
                "address_area":address_area,
                "address_detail": address_detail,
                "is_default": is_default
            ], encoding: JSONEncoding.default)
            
        case .makeOrder(let id):
            return .requestParameters(parameters: [
                "goods_id": id,
                "order_type" : 2
            ], encoding: JSONEncoding.default)
        case .getOrderList(let status):
            return .requestParameters(parameters: [
                "status" : status.rawValue
            ], encoding: JSONEncoding.default)
        case .getLikes:
            return .requestPlain
        case .like(let id):
            return .requestParameters(parameters: ["goods_id": id, "status" : 1], encoding: JSONEncoding.default)
        case .dislike(let id ):
            return .requestParameters(parameters: ["goods_id": id, "status" : 0], encoding: JSONEncoding.default)
        case .cancelOrder(id: let id):
            return .requestParameters(parameters: ["order_id":id], encoding: JSONEncoding.default)
        case .getFootprints:
            return .requestParameters(parameters: ["day_type":1], encoding: JSONEncoding.default)
        case .goodsList(let data_type, let me_publish):
            return .requestParameters(parameters: ["data_type":data_type, "me_publish": me_publish ? 1 : 0], encoding: JSONEncoding.default)
        case .goodDetail(let id):
            return .requestParameters(parameters: ["goods_id":id], encoding: JSONEncoding.default)
        }
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var headers: [String: String]? {
        [
            "Content-Type": "application/json",
        ]
    }
}


class UserAccount: HandyJSON{
    var mobile: String!
    
    var nickname: String!
    var foot_num: Int!
    var collect_num: Int!
    var bill_num: Int!
    var is_sub_merchant: Bool!
    var uid: Int!
    
//    var phone: String!
//    var avatar: String?
//    var avatarImage : UIImage {
//        avatar?.toImage() ?? .init(named: "user_avatar")!
//    }
    
    var realname: String!
    var photo: UIImage!
    var birthday: String!
    var gender: String!
    
    func mapping(mapper: HelpingMapper) {
        mapper >>> realname
        mapper >>> photo
        mapper >>> gender
        mapper >>> birthday
    }

    required init(){

    }
    
}


struct UserStore {
//    static var remained: Double {
//        get{
//            let double = UserDefaults.standard.object(forKey: "remained") as? NSNumber
//            guard let double = double else {return 200}
//            return double.doubleValue
//        }
//        set{
//            UserDefaults.standard.set(NSNumber(value: newValue), forKey: "remained")
//        }
//    }
    
    static var currentUser: UserAccount?{
        set{
            if let json = newValue?.toJSON(){
                UserDefaults.standard.set(json, forKey: "currentUser")
            }else{
                UserDefaults.standard.removeObject(forKey:"currentUser")
            }
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(kUserChanged)
        }
        get{
            if let json = UserDefaults.standard.dictionary(forKey: "currentUser"){
                let user = UserAccount.deserialize(from: json)!
                loadCustomProperty(user: user)
                return user
            }
            return nil
        }
    }
    
    static func logout(){
        self.currentUser = nil
    }
    
    static func loadCustomProperty(user: UserAccount){
        if let userDefineProperties = UserDefaults.standard.dictionary(forKey: "\(String(describing: user.uid))_userDefineProperties"){
            user.realname = userDefineProperties["realname"] as? String
            user.birthday = userDefineProperties["birthday"] as? String
            user.gender = userDefineProperties["gender"] as? String
        }else{
            user.realname = user.nickname
            user.birthday = "2000-01-01"
            user.gender = "男"
        }

        if let userDefinePhotoData = UserDefaults.standard.data(forKey: "\(String(describing: user.uid))_userDefinePhoto"){
            user.photo = UIImage(data: userDefinePhotoData)
        }else{
            user.photo = .init(named: "user_avatar")
        }
    }
    
    static func updateUserCutomProperties(_ user:UserAccount){
        let dic = [
            "realname": user.realname,
            "birthday": user.birthday,
            "gender": user.gender
        ]
        UserDefaults.standard.set(dic, forKey: "\(String(describing: user.uid))_userDefineProperties")
        let data = user.photo.jpegData(compressionQuality: 1)
        UserDefaults.standard.set(data, forKey:"\(String(describing: user.uid))_userDefinePhoto" )
        UserDefaults.standard.synchronize()
    }
    
    
    static var isLogin: Bool{
        return currentUser != nil
    }
    
    static func checkLoginStatusThen(_ block:()->()){
        if isLogin{
            block()
        }else{
            UIViewController.getCurrentNav().pushViewController(LoginVC(), animated: true)
        }
        
        
    }
    
}



