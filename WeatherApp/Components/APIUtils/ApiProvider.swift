//
//  ApiProvider.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import Alamofire

public enum ApiError: Error {
    case jsonParseError(message: String)
    case error(message: String)
    case encodingError(message: String)
}

public enum Method: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

public class ApiProvider {
    public static let instance = ApiProvider()
    private let requestQueue = DispatchQueue(label: "com.openweathermap.response-queue",
                                             qos: .background,
                                             attributes: [DispatchQueue.Attributes.concurrent])
    private let logQueue = DispatchQueue(label: "com.openweathermap.api-log", qos: .background)
    private let manager: Session
    
    init() {
        manager = Alamofire.Session.default
        manager.session.configuration.requestCachePolicy = .returnCacheDataElseLoad
        manager.session.configuration.urlCache = URLCache.shared
        manager.session.configuration.httpCookieStorage = HTTPCookieStorage.shared
    }
    
    private func log(message: String) {
        logQueue.async {
            print(message)
        }
    }
    
    func request<T:Decodable>(
        endPoint: String,
        method: Method = .get,
        params: [String: Any]? = nil,
        headers: HTTPHeaders? = nil)
        -> Observable<ApiEvent<T>> {
        return Observable<ApiEvent<T>>.create { (observer) -> Disposable in
            observer.onNext(ApiEvent.loading)
            var debugString = "DEBUG: - ApiProvider: request to \(endPoint)"
            self.log(message: debugString)
            let httpMethod = HTTPMethod(rawValue: method.rawValue)
            let request = self.createRequest(endPoint, method: httpMethod, parameters: params, headers: headers)
                .responseData(queue: self.requestQueue, completionHandler: { (dataResponse) in
                    do {
                        switch dataResponse.result {
                        case .success(let data):
                            if let status = dataResponse.response?.statusCode,
                                status < 200 || status >= 300 {
                                let error = try ErrorEntity.decode(data: data)
                                debugString = """
                                    DEBUG: - ApiProvider:
                                    Deserealization of \(String(describing: dataResponse.request?.url?.absoluteString)) to \(ErrorEntity.self) success.
                                """
                                self.log(message: debugString)
                                
                                debugString = """
                                    DEBUG: - ApiProvider:
                                    Decoded string of \(T.self): \(String(describing: String(data: data, encoding: .utf8))) success.
                                """
                                self.log(message: debugString)
                                observer.onNext(ApiEvent.error(error))
                            } else {
                                let item = try T.decode(data: data)
                                debugString = """
                                    DEBUG: - ApiProvider:
                                    Deserealization of \(String(describing: dataResponse.request?.url?.absoluteString)) to \(T.self) success.
                                """
                                self.log(message: debugString)
                                debugString = """
                                    DEBUG: - ApiProvider:
                                    Decoded string of \(T.self): \(String(describing: String(data: data, encoding: .utf8))) success.
                                """
                                self.log(message: debugString)
                                observer.onNext(ApiEvent.loaded(item))
                                observer.onCompleted()
                            }
                        case .failure(let error):
                            debugString = """
                                DEBUG: - ApiProvider:
                                Loading of \(String(describing: dataResponse.request?.url?.absoluteString)) fail.
                                With status code: \(String(describing: dataResponse.response?.statusCode)).
                                Object: \(T.self)
                                Error: \(error)
                            """
                            self.log(message: debugString)
                            observer.onNext(ApiEvent.error(error))
                        }
                    } catch {
                        debugString = """
                            DEBUG: - ApiProvider:
                            Deserealization of \(String(describing: dataResponse.request?.url?.absoluteString)) fail.
                            With status code: \(String(describing: dataResponse.response?.statusCode)).
                            Object: \(T.self)
                            Error: \(error)
                        """
                        observer.onNext(ApiEvent.error(error))
                        self.log(message: debugString)
                    }
                })
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func createRequest(
        _ url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil) -> DataRequest {
        let debugString = """
            DEBUG: - ApiProvider:
            Request to \(url),
            method \(method),
            params: \(String(describing: parameters))
        """
        self.log(message: debugString)
        let encoding: ParameterEncoding = JSONEncoding.default
        return manager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
}
