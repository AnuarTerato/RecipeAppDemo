//
//  RecipeRealm.swift
//  RecipeApp
//
//  Created by Anuar Nordin on 03/03/2021.
//

import Foundation
import RealmSwift

class RecipeNameArrayTempRealm: Object {
    let recipeNameArrayTemp = List<String>()
}

class RecipeNameArrayRealm: Object {
    let recipeNameArray = List<String>()
}

class RecipePictureUIImageArrayTempRealm: Object {
    let recipePictureUIImageArrayTemp = List<Data>()
}

class RecipePictureUIImageArrayRealm: Object {
    let recipePictureUIImageArray = List<Data>()
}

class RecipeIngredientsArrayRealm: Object {
    let recipeIngredientsArray = List<String>()
}

class RecipeStepsArrayRealm: Object {
    let recipeStepsArray = List<String>()
}

