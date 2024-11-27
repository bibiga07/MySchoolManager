//
//  MealModel.swift
//  MySchoolManager
//
//  Created by 김주환 on 11/26/24.
//

import Foundation

struct MealInfo: Identifiable {
    let id = UUID()
    let date: String    
    let mealType: String
    let dishName: String
}
