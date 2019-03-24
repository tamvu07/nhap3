//
//  Modle.swift
//  QuanTro
//
//  Created by Le Nguyen Quoc Cuong on 11/24/18.
//  Copyright © 2018 Le Nguyen Quoc Cuong. All rights reserved.
//

import Foundation
import Firebase

struct Vehicle:Codable{
    
    var licensePlates:String!
    var sortVehicel:String!
    var imageString:String!
    var nameRoomer:String!
    
}

struct FeeBill:Codable {
    var beginIndex:Index!
    var endIndex:Index!
    var nameRoom:String!
    var isCollected :Bool!
    var roomID:String!
}

struct Roomer:Codable {
    var dateOfBirth:Date!
    var identifyCard:String!
    var listVehicle:Vehicle!
    var name:String!
    var numPhone:String!
    var roomID:String!
    var profileImageString:String!
    var identityImageString:[String]!
}

struct Index:Codable {
    var date:Date!
    var electricIndex:Int!
    var waterIndex:Int!
}

struct Contract:Codable{
    var contractSigningDate:Date!
    var dayStartAt:Date!
    var dayEndAt:Date!
    var desposit:UInt32!
    //var idRoom:String!
    //var paymentCycle:String!
    var rentalPrice:UInt32!
    var index:Index!
    var nameRoomer:String!
}

struct ServicePrices:Codable {
    var waterPrice:UInt!
    var electricPrice:UInt!
}

struct Room:Codable{
    var isStaying:Bool!
    var area:Float!
    var contract:Contract!
    var id:String!
    var listIndex :[Index]!
    var listRoomer:[Roomer]!
    var maxRoomer:Int!
    var name:String!
    var rentalPrice:UInt32!
    var imagesStringURL:[String]!
   
//    func toAnyObject()->[String:AnyObject]{
//        let result = ["isStaying":self.isStaying,
//                      "area":self.area,
//                      "contract":self.contract,
//                      "id":self.id,
//                      "listIndex":self.listIndex,
//                      "listRoomer":self.listRoomer,
//                      "maxRoomer":self.maxRoomer,
//                      "name":self.name,
//                      "rentalPrice":self.rentalPrice,
//                      "imagesStringURL":self.imagesStringURL,
//                      "unit":self.unit ] as [String:AnyObject]
//        return result as [String:AnyObject]
//    }
//
//    init(){}
//    init(withDataSnapshot: DataSnapshot){
//        let dict = withDataSnapshot.value as? [String:AnyObject]
//        self.isStaying = dict?["isStaying"] as? Bool
//        self.area = dict?["area"] as? Float ?? 0
//        self.contract = dict?["contract"] as? Contract
//        self.id = dict?["id"] as? String ?? ""
//        self.listIndex = dict?["listIndex"] as! [Index]
//        self.name = dict?["name"] as? String ?? ""
//        self.maxRoomer = dict?["maxRoomer"] as? Int ?? 0
//        self.imagesStringURL = dict?["imagesStringURL"] as? [String] ?? [String]()
//        self.rentalPrice = dict?["rentalPrice"] as? UInt32 ?? 0
//        self.unit = dict?["unit"] as? String ?? ""
//
//    }
}

struct Motel:Codable{
    var dayCalenderIndex:Int!
    var dayCollectingRent:Int!
    var formLease:String!
    var id:String!
    var listRoom:[Room]?
    var name:String!
    var sortMotel:String!
    var imagesStringURL:[String]!
    var servicePrices:ServicePrices!
    var collectedRent:[String:[String:Bool]]!
    var collectedFee:[String:[FeeBill]]!
    var listVehicle:[Vehicle]!
//    func toAnyObject()->[String:AnyObject]{
//        let result = ["dayCalenderIndex":self.dayCalenderIndex,
//                      "dayCollectingRent":self.dayCollectingRent,
//                      "formLease":self.formLease,
//                      "id":self.id,
//                      "listRoom":self.listRoom!,
//                      "name":self.name,
//                      "sortMotel":self.sortMotel,
//                      "imagesStringURL":self.imagesStringURL] as [String : AnyObject]
//        return result as [String : AnyObject]
//    }
//    init(){}
//    init(withDataSnapshot: DataSnapshot){
//        let dict = withDataSnapshot.value as? [String:AnyObject]
//        self.dayCalenderIndex = dict?["dayCalenderIndex"] as? String ?? ""
//        self.dayCollectingRent = dict?["dayCollectingRent"] as? String ?? ""
//        self.formLease = dict?["formLease"] as? String ?? ""
//        self.id = dict?["id"] as? String ?? ""
//        self.listRoom = dict?["listRoom"] as? [Room]
//        self.name = dict?["name"] as? String ?? ""
//        self.sortMotel = dict?["sortMotel"] as? String ?? ""
//        self.imagesStringURL = dict?["imagesStringURL"] as? [String] ?? [String]()
//
//    }
}


