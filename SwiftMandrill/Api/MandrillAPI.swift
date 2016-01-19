//
//  MandrillAPI.swift
//  SwiftMandrill
//
//  Created by Christopher Jimenez on 1/18/16.
//  Copyright © 2016 greenpixels. All rights reserved.
//

import Alamofire

import ObjectMapper

/// Mandrill API access and definition
public class MandrillAPI {
    
    private let apiKey : String
    

    //ApiRouter enum that will take care of the routing of the urls and paths of the API
    private enum ApiRouter: URLStringConvertible {
        
        static let baseURL = Constants.baseAPIURL;
        
        case sendMessage
        
        var path: String {
            switch self{
            case .sendMessage:
                return "/messages/send.json";
                
            }
        }
        
        var URLString : String{
            
            let url = NSURL(string: ApiRouter.baseURL)!
            let urlRequest = NSMutableURLRequest(URL: url.URLByAppendingPathComponent(path))
            return urlRequest.URLString;
        }
        
    }
    
    /**
     Initializer for the class the takes the Mandrill API key
     
     - parameter apiKey: Api key to be use in the request
     
     - returns:
     */
    public init(ApiKey apiKey:String)
    {
        self.apiKey = apiKey
    }
    
    
    
    /**
     Sends an email using the Mandrill email object values and returns the result in the result handler
     
     - parameter email:             Email Object
     - parameter completionHandler: Result completion handler
     */
    public func sendEmail(withEmail email:MandrillEmail, completionHandler:(MandrillResult) -> Void) -> Void
    {
        
        let params : [String:AnyObject]  = [
            "key": self.apiKey,
            "message": Mapper().toJSON(email)
        ]
        
        Alamofire.request(.POST, ApiRouter.sendMessage.URLString, parameters: params, encoding: .JSON)
            .validate()
            .responseJSON {response in
                
                switch response.result
                {
                    
                case .Failure(let error):
                    
                    
                        print("error calling \(ApiRouter.sendMessage)")
                        print(error)
                        
                        var errorMessage = error.description
                        
                        //Parse message from API
                        if let data = response.data
                        {
                            if let errorResult = Mapper<MandrillErrorResult>().map(String(data: data, encoding: NSUTF8StringEncoding))
                            {
                                 errorMessage = errorResult.message!
                            }
                        }
                        
                        let result = MandrillResult(success: false, message: errorMessage)
                        
                        completionHandler(result)
                        return
                    
                case .Success:
                    
                    if let value: AnyObject = response.result.value {
                        
                        let emailResults:[MandrillEmailResult] = Mapper<MandrillEmailResult>().mapArray(value)!
                        
                        let result = MandrillResult(success: true, emailResults: emailResults)
                        
                        completionHandler(result)
                        
                        return
                        
                        
                    }
                    
                }
        }
    }
    
}
