//
//  UserModel.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-13.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import Foundation

struct UserInfoToSend: Encodable {
    var username: String!
    var password: String!
}
