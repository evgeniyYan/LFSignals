//
//  Extension.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

extension UIColor {
    
    static func customBGNav() -> UIColor {
        
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                } else {
                    return .white
                }
            }
        }
        else {
            return .white
            
        }
    }
    
    static func customTabBarItem() -> UIColor {
        
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
                }
            }
        }
        else {
            return .black
            
        }
    }
    
    static func customBGTab() -> UIColor {
        
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                } else {
                    return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
            
        }
    }
    
    static func customBGToggle() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 1)
            
        }
    }
    
    static func customColorText() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.408, green: 0.408, blue: 0.408, alpha: 1)
            
        }
    }
    
    static func customBGViewController() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                } else {
                    return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
            
        }
    }
    
    static func customBGCell() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                } else {
                    return .white
                }
            }
        }
        else {
            return .white
            
        }
    }
    
    static func customFilterNabButtons() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return .white
                } else {
                    return .black
                }
            }
        }
        else {
            return .black
            
        }
    }
    
    static func customFilterSearchBar() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 1)
                } else {
                    return .white
                }
            }
        }
        else {
            return .white
            
        }
    }
    
    
    static func customNameIndicator() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.979, green: 0.979, blue: 0.979, alpha: 1)
                } else {
                    return UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.58, green: 0.584, blue: 0.6, alpha: 1)
            
        }
    }
    
    
    static func customFilterBG() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                } else {
                    return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
            
        }
    }
    
    static func customIndicatorView() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.851, green: 0.851, blue: 0.851, alpha: 0.7)
                } else {
                    return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0.949, green: 0.953, blue: 0.969, alpha: 1)
            
        }
    }
    
    static func customFilterHeaderViewBG() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
                } else {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
                }
            }
        }
        else {
            return UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
            
        }
    }
    
    
    
    static func customRabgeTableView() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
                } else {
                    return .white
                }
            }
        }
        else {
            return .white
            
        }
    }
    
    static func customButtonInCollection() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 0.404, green: 0.408, blue: 0.435, alpha: 1)
                } else {
                    return .white
                }
            }
        }
        else {
            return .white
            
        }
        
    }
    
    static func customTextButtonInCollection() -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in
                if trait.userInterfaceStyle == .dark {
                    return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
                } else {
                    return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                }
            }
        }
        else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            
        }
        
    }
    
    
    //MARK: - цвета кругов
    static func customRatingGreen() -> UIColor {
        return  UIColor(red: 0.6, green: 0.8, blue: 0.4, alpha: 1)
    }
    

    static func customRatingWait() -> UIColor {
        return .systemGray2
    }
    
    
    static func customRatingRed() -> UIColor {
        return UIColor(red: 0.929, green: 0.431, blue: 0.49, alpha: 1)
    }

}

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main ,value: self, comment: self)
    }
}


extension UIViewController {
    static func setEmptyView(width: CGFloat, height: CGFloat) -> UIView {
        let emptyView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
            view.frame = CGRect(x: 0, y: 0, width: width, height: height)
            //view.alpha = 0.0
            view.isHidden = true
            return view
        }()
        
        return emptyView
    }
}

extension Int {
    func minutes() -> String {
        var dayString: String!
        if "1".contains("\(self % 10)")      {dayString = "минуту".localized()}
        if "234".contains("\(self % 10)")    {dayString = "минуты".localized() }
        if "567890".contains("\(self % 10)") {dayString = "минут".localized()}
        if 11...14 ~= self % 100                   {dayString = "минут".localized()}
        return "\(self) " + dayString
    }
}
