//
//  Decodable.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import Foundation
extension Decodable {
    public static func decode(data: Data) throws -> Self {
        let cleanedData: Data
        if data.count == 0 {
            guard let emptyJsonData = "{}".data(using: .utf8) else {
                throw NSError(
                    domain: "openweathermap.org",
                    code: 0,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Failed to create data from empty json string"
                    ]
                )
            }
            cleanedData = emptyJsonData
        } else {
            cleanedData = data
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(Self.self, from: cleanedData)
    }
}
