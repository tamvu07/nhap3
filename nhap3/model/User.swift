//
//  User.swift
//  nhap3
//
//  Created by vuminhtam on 3/28/19.
//  Copyright © 2019 vuminhtam. All rights reserved.
//

import Foundation
import UIKit

struct User {
    let id:String!
    let email:String!
    let fullName:String!
    let linkAvatar:String!
    var Avatar:UIImage!
    
    init()
    {
        id = ""
        email = ""
        fullName = ""
        linkAvatar = ""
        Avatar = UIImage(named: "anh_dai_dien")
    }
    
    init(id:String,email:String,fullname:String,linkAvatar:String) {
        self.id = id
        self.email = email
        self.fullName = fullname
        self.linkAvatar = linkAvatar
        self.Avatar = UIImage(named: "anh_dai_dien")
    }
    
}
