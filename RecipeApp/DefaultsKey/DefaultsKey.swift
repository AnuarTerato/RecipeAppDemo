//
//  DefaultsKey.swift
//  RecipeApp
//
//  Created by Anuar Nordin on 03/03/2021.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    
    // MARK:- General
    var userLogin: DefaultsKey<Bool>{ return .init("userLogin", defaultValue: false) }
    var initialFetch: DefaultsKey<Bool>{ return .init("initialFetch", defaultValue: false)}
}
