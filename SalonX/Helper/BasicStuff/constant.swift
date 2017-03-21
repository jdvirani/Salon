//
//  constant.swift
//  SalonX
//
//  Created by Haresh Vavadiya on 2/28/17.
//  Copyright © 2017 dignizant. All rights reserved.
//

import Foundation

var isGoesToMainDash:Bool = false

// MARK:- Authenication Credential

let AUTHUSERNAME = "salon"
let AUTHPASSWORD = "b.7]>hp}wQDxN#B"


// MARK:- API Init

//let BASE_URL  = "http://192.168.0.10/salonx/api/" //Local

let BASE_URL  = "http://52.66.6.178/salonx/api/" //Live


//MARK:- USER
let API_Login_Email = BASE_URL + "user/login"

let API_Registration = BASE_URL + "user/register"

let API_Social_Login = BASE_URL + "user/facebook_login"

let API_Generate_AccessToken = BASE_URL + "user/generate_access_token"

let API_Update_UserProfile = BASE_URL + "user/save_user_profile"

let API_Logout_User = BASE_URL + "user/logout"

// MARK:- HOME
let API_HomeList = BASE_URL + "user/home_list"

let API_HomeSearchList = BASE_URL + "user/search_home_list"


//MARK:- Salon List
let API_SalonList = BASE_URL + "user/salon_list"

let API_SalonDetail = BASE_URL + "user/salon_details"

let API_SalonFavorite = BASE_URL + "user/salon_favorite"

let API_SalonMyAppointment = BASE_URL + "user/my_appointment"


//MARK:- Book Salon
let API_SalonBook_Appointment = BASE_URL + "user/book_appointment"

let API_SalonBook_EmployeeList = BASE_URL + "user/employee_list"

let API_SalonBook_TimeSlot = BASE_URL + "user/get_salon_hours"

//MARK:- Chat Salon

let API_SalonChatAppointment = BASE_URL + "user/chat_appointment"



extension Notification.Name {
    public static let BecomeActive:Notification.Name = Notification.Name(rawValue: "becomeActive")
    public static let DidEnterBackGround:Notification.Name = Notification.Name(rawValue: "DidEnterBackGround")
}
