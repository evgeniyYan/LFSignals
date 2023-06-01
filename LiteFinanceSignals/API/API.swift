//
//  API.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import Foundation
import UIKit


class API {
    static let allNameTools = "https://api.litemarkets.com/v2/signals/instruments-v2?token=f3fa21a4550406e0fdc6117ca8113e59"
    static let allDataTools = "https://api.litemarkets.com/v2/signals/summary-v2?token=f3fa21a4550406e0fdc6117ca8113e59"
//    static let symbolURL = "https://api.litemarkets.com/v2/signals/symbol-v2?token=f3fa21a4550406e0fdc6117ca8113e59&symbol=\(symbol)"
//    static let iconSymbolURL = "https://api.litemarkets.com/images/signals/day/\(icon).svg"
    
    
    func createSymbolURL(symbol: String) -> String {
        return "https://api.litemarkets.com/v2/signals/symbol-v2?token=f3fa21a4550406e0fdc6117ca8113e59&symbol=\(symbol)"
    }
    
   static func createIconURL(icon: String) -> String {
        var url = ""
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        switch window?.overrideUserInterfaceStyle {
        case .dark:
            url = "https://api.litemarkets.com/images/signals/night/\(icon).svg"
        case .light:
            url = "https://api.litemarkets.com/images/signals/day/\(icon).svg"
        case .unspecified:
            url =  "https://api.litemarkets.com/images/signals/day/\(icon).svg"
        default:
            print("error mode of app")
        }
        
    return url
    }
    
    static func createIndicatorsURL(tool: String) -> String {
        var str = tool
        if let i = tool.firstIndex(of: "#") {
            str = GetCurrencyName().replacementSymbol(text: tool)
        }
        return "https://api.litemarkets.com/v2/signals/symbol-v2?token=f3fa21a4550406e0fdc6117ca8113e59&symbol=\(str)"
    }
}
