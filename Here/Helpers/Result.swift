//
//  Result.swift
//  here
//
//  Created by Joel Klabo on 7/6/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
