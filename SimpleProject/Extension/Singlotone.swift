//
//  Singlotone.swift
//  SimpleProject
//
//  Created by applicationsupport on 16/10/17.
//  Copyright © 2017 SandipJadhav. All rights reserved.
//

import UIKit

class Singlotone: NSObject {
   static let sharerdinstance : Singlotone = Singlotone()
    let arr1 = [1,3,5,7]
    let arr2 = [2,4,6]
    func callmethod()-> [Int]
    {
        let arr3 = arr1 + arr2
       // print(arr3)
        return arr3
        
        
    }
}

