//
//  MyException.swift
//  App
//
//  Created by CaryZheng on 2018/4/8.
//

import Foundation

enum MyException: Error {
    case requestParamError
}

extension MyException: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .requestParamError:
            return NSLocalizedString("Request param error", comment: "")
        }
    }
    
}
