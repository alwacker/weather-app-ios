//
//  ApiGateway.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation

protocol Gateway {
    func getEndpointURL(endPoint: ApiEndPoint) -> String
}

class ApiGateway: Gateway {
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getEndpointURL(endPoint: ApiEndPoint) -> String {
        let url = endPoint.rawValue.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? endPoint.rawValue
        return prepareUrl(endPoint: url)
    }
    
    func prepareUrl(endPoint: String) -> String {
        let url = endPoint.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? endPoint
        return "\(baseUrl)\(url)"
    }
}
