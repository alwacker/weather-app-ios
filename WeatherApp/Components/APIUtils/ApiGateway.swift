//
//  ApiGateway.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation

protocol Gateway {
    func getEndpointURL(endPoint: String) -> String
}

class ApiGateway: Gateway {
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getEndpointURL(endPoint: String) -> String {
        return prepareUrl(endPoint: endPoint)
    }
    
    func prepareUrl(endPoint: String) -> String {
        return "\(baseUrl)\(endPoint)"
    }
}
