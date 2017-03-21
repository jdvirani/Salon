//: Playground - noun: a place where people can play

import UIKit


let date = Date()
let dateFmt = DateFormatter()
dateFmt.dateFormat = "hh:mm a"
print(dateFmt.string(from: date))

