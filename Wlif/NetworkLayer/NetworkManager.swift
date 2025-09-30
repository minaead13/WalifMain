//
//  NetworkManager.swift
//  Wlif
//
//  Created by OSX on 01/07/2025.
//

import Foundation
import Alamofire
import UIKit

class NetworkManager {
    
    static let instance = NetworkManager()
    let errorMsg = "Network Failed, Please try again.".localized
    
    func request<T: Codable>(_ strURL: String, parameters: [String : Any]?, method: HTTPMethod, type: T.Type, hasLoading: Bool = true, api_response: @escaping (BaseModel<T>? , String?) -> Void){
        let headers = getHeaders()
        let parameters = parameters ?? [:]
        
#if DEBUG
        print("Parameters:", parameters)
#endif
        
        var fullLink = Urls.base + strURL
        
        AF.request(fullLink, method: method, parameters: parameters, headers: headers ).responseDecodable(of: BaseModel<T>.self) { (response) -> Void in
            print(response.debugDescription)
            print(response.description)
            
            switch response.result {
            case .success:
                if let statusCode = response.response?.statusCode {
                    print(statusCode)
                    switch statusCode {
                    case 200..<300:
                        if let resJson = response.data {
                            do {
                                let model = try JSONDecoder().decode(BaseModel<T>.self, from: resJson)
                                api_response(model, nil)
                            } catch {
                                print("Bad request error")
                                api_response(nil, nil)
                            }
                        }
                        
                    default:
                        if let data = response.data {
                            do {
                                let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                api_response(nil, errorResponse.message)
                            } catch {
                                api_response(nil, "Server returned status \(statusCode)")
                            }
                        } else {
                            api_response(nil, "Server returned status \(statusCode)")
                        }
                    }
                }
            case .failure(let error):
                print("Network error:", error.localizedDescription)
                
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let errorMessage = errorResponse.message
                        print("Decoded server error message:", errorMessage)
                        api_response(nil, errorMessage)
                    } catch {
                        print("Failed to decode error message, returning generic error")
                        api_response(nil, self.errorMsg)
                    }
                } else {
                    api_response(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func upload<T: Decodable>(_ strURL: String, parameters: [String : Any]?, method: HTTPMethod, type: T.Type, images: [UIImage], fileName: String, fileExt: String , api_response: @escaping (BaseModel<T>?, String?) -> Void){
        
        let fullLink = Urls.base + strURL
        
        let headers = getHeaders()
        let parameters = parameters ?? [:]
        
#if DEBUG
        print("Headers:", headers)
        print("Parameters:", parameters)
#endif
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if let string = value as? String {
                    multipartFormData.append(string.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                // Append images
                for (index, image) in images.enumerated() {
                    if let imageData = image.jpegData(compressionQuality: 0.7) {
                        multipartFormData.append(imageData, withName: "images[]", fileName: "image\(index).jpg", mimeType: "image/jpeg")
                    }
                }
                
                if let integer = value as? Int {
                    multipartFormData.append("\(integer)".data(using: .utf8)!, withName: key)
                }
                if let double = value as? Double {
                    multipartFormData.append("\(double)".data(using: .utf8)!, withName: key)
                }
                if let data = value as? Data {
                    multipartFormData.append(data, withName: key, fileName: fileName, mimeType: "media/\(fileExt)")
                }
                if let data = value as? URL {
                    multipartFormData.append(data, withName: key, fileName: fileName, mimeType: "media/\(fileExt)")
                    
                }
                if let dict = value as? Dictionary<String, Any> {
                    let data = try? JSONSerialization.data(withJSONObject: dict)
                    multipartFormData.append(data!, withName: key)
                }
    }
        }, to: fullLink, method: method, headers: headers).uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseDecodable(of: BaseModel<T>.self) { (response) -> Void in
#if DEBUG
            print(response.debugDescription)
            print(response.description)
#endif
            switch response.result {
            case .success:
                if let statusCode = response.response?.statusCode {
                    print(statusCode)
                    switch statusCode {
                    case 200..<300:
                        if let resJson = response.data {
                            do {
                                let model = try JSONDecoder().decode(BaseModel<T>.self, from: resJson)
                                api_response(model, nil)
                            } catch {
                                print("Bad request error")
                                api_response(nil, nil)
                            }
                        }
                        
                    default:
                        break
                    }
                }
            case .failure(let error):
                print("Network error:", error.localizedDescription)
                
                if let data = response.data {
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        let errorMessage = errorResponse.message
                        print("Decoded server error message:", errorMessage)
                        api_response(nil, errorMessage)
                    } catch {
                        print("Failed to decode error message, returning generic error")
                        api_response(nil, self.errorMsg)
                    }
                } else {
                    api_response(nil, error.localizedDescription)
                }
            }
        }
    }
    
    func getHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Accept-Language" : "\(LanguageManager.shared.currentLanguage)",
            "Authorization" : "Bearer " + (UserUtil.load()?.token ?? "")
        ]
        return headers
    }
    
    static func getDeviceId() -> String {
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            return idfv
        } else {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: "com.yourapp.deviceId")
            return uuid
        }
    }
}

struct ErrorResponse: Codable {
    let message: String
}
