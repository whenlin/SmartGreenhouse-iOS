//
//  Constants.swift
//  SmartGreenhouse
//
//  Created by WHenlin on 2019-02-12.
//  Copyright © 2019 SmartGreenhouse. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//URL Constants
let BASE_URL = "https://smart-greenhouse-rest-api-whenlin.c9users.io/"
let URL_GETPLANTS = "\(BASE_URL)listPlants/"
//let URL_GETREVIEWS = "\(BASE_URL)reviews/"
//let URL_GETALLREVIEWS = "\(BASE_URL)allReviews/"
let URL_SIGNUP = "\(BASE_URL)createUser/"
let URL_LOGIN = "\(BASE_URL)signIn/"


//Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

//HEADERS
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
