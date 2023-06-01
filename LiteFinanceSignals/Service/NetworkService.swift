//
//  NetworkService.swift
//  LFSignals
//
//  Created by Евгений Янушкевич on 31.05.2023.
//

import UIKit

protocol NetworkProtocol {
    func parseAllNameTools(completion: @escaping (Result<[AllDataModel]?, Error>) -> Void)
    func parseIndicatorsTool(tool: String, completion: @escaping (Result<[ToolIndicator]?, Error>) -> Void)
    func parseChartData(tool: String, range: String, completion: @escaping (Result<[ChatrModel]?, Error>) -> Void)
    func parseFavoriteTools(ompletion: @escaping (Result<[AllDataModel]?, Error>) -> Void)
}

struct ChatrModel: Decodable {
    var time: Double
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        time = try container.decode(Double.self)
        open = try container.decode(Double.self)
        high = try container.decode(Double.self)
        low = try container.decode(Double.self)
        close = try container.decode(Double.self)
    }
}


class NetworkService: NetworkProtocol {
    func parseFavoriteTools(ompletion: @escaping (Result<[AllDataModel]?, Error>) -> Void) {
        
    }
    
    
    func parseAllNameTools(completion: @escaping (Result<[AllDataModel]?, Error>) -> Void) {
        guard let urlDataString = URL(string: API.allDataTools) else { return }
        
        URLSession.shared.dataTask(with: urlDataString) { data, _, error in
            
            if let error = error {
                completion(.failure(error))
            }
//
//            if #available(iOS 15.0, *) {
//                if let statusesArray = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .json5Allowed) as? [[AllDataModel]] {
//                    completion(.success(statusesArray))
//                } else {
//                    guard let error = error else {return}
//                    completion(.failure(error))
//                }
            //} else {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .secondsSince1970
//
//                do {
//                    let root = try decoder.decode([[AllNamesTools]].self, from: data!)
//                    print(root)
//
//                } catch {
//                    print(error)
//                }
            if let data = data {
                print(data)
            } else {
                completion(.failure(error!))
            }
               
                do {
                    let json = try JSONDecoder().decode([AllDataModel].self, from: data ?? Data())
                    if json.isEmpty {
                        completion(.failure(error!))
                    }
                    completion(.success(json))
                } catch {
                    completion(.failure(error))
                }
            //}
        }.resume()
        
        
    }
    
    func parseIndicatorsTool(tool: String, completion: @escaping (Result<[ToolIndicator]?, Error>) -> Void) {
        guard let urlString = URL(string: API.createIndicatorsURL(tool: tool)) else { return }
        
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            do {
                let json = try JSONDecoder().decode([ToolIndicator].self, from: data!)
                completion(.success(json))
            }
            catch {
                completion(.failure(error))
            }
            
            
//            if let statusesArray = try? JSONSerialization.jsonObject(with: data!, options: .json5Allowed) as? [Any] {
//                print(statusesArray)
//                print("date \(statusesArray[0])")
//                let date = statusesArray[0] as! Dictionary<String, Any>
//                print(date)
//
//                for (name, indi) in date {
//                    print(name)
//                    print(type(of: indi))
//                }
//
//            } else {
//                guard let error = error else {return}
//                completion(.failure(error))
//            }
            
        }.resume()
    }
    
    func parseChartData(tool: String, range: String, completion: @escaping (Result<[ChatrModel]?, Error>) -> Void) {
        var intRange = ""
        
        switch range {
        case "M1":
            intRange = "1"
        case "M5":
            intRange = "5"
        case "M15":
            intRange = "15"
        case "M30":
            intRange = "30"
        case "H1":
            intRange = "60"
        case "H4":
            intRange = "240"
        default:
            intRange = "D"
        }
        
        guard let urlString = URL(string: "https://api.litemarkets.com/v2/chart/get-chart?token=f3fa21a4550406e0fdc6117ca8113e59&symbol=\(tool)&resolution=\(intRange)") else { return }
        
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error = error {
                completion(.failure(error))
                print("error parse")
            }
            
//            if #available(iOS 15.0, *) {
//                if let statusesArray = try? JSONSerialization.jsonObject(with: data ?? Data(), options: .json5Allowed) as? [[Any]] {
//                    completion(.success(statusesArray))
//                } else {
//                    guard let error = error else {return}
//                    print("error parse")
//                    completion(.failure(error))
//                }
//            } else {
//
//            }

            do {
                let json = try JSONDecoder().decode([ChatrModel].self, from: data!)
                completion(.success(json))
            } catch {
                completion(.failure(error))
            }
            
        }.resume()
    }
}

//extension JSONDecoder.DateDecodingStrategy {
//    static let multiple = custom {
//        let container = try $0.singleValueContainer()
//        do {
//            return try Date(timeIntervalSince1970: container.decode(Double.self))
//        } catch DecodingError.typeMismatch {
//            let string = try container.decode(String.self)
//            if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ??
//                Formatter.iso8601.date(from: string) ??
//                Formatter.ddMMyyyy.date(from: string) {
//                return date
//            }
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
//        }
//    }
//}
//
//
//extension Formatter {
//    static let iso8601withFractionalSeconds: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
//        return formatter
//    }()
//    static let iso8601: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        return formatter
//    }()
//    static let ddMMyyyy: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.dateFormat = "dd-MM-yyyy"
//        return formatter
//    }()
//}

