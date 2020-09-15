//
//  HudStatus.swift
//  WeatherApp
//
//  Created by Oleksandr Vaker on 14/09/2020.
//  Copyright © 2020 Oleksandr Vaker. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt

public enum HudStatus {
    case success(message : String)
    case error(message : String)
    case loading
    case loaded
    case info(message: String)
    
    //If any request in loading state - return loading
    //Else return last received response
    public static func merge(_ requests: Driver<HudStatus>...) -> Driver<HudStatus> {
        return merge(requests: requests)
    }
    
    public static func merge(requests: [Driver<HudStatus>], requestsAreAsync: Bool = true) -> Driver<HudStatus> {
        let lastRequest = Driver.merge(requests)
        let emittedRequests = requests.map{ request -> Driver<HudStatus?> in
            return request.map{$0 as HudStatus?}.startWith(nil)
        }
        let combine = Driver.combineLatest(emittedRequests)
        
        let combineWithLastRequest = combine.withLatestFrom(lastRequest) { (requests, lastRequest) -> ([HudStatus?], HudStatus) in
            return (requests, lastRequest)
        }
        
        return combineWithLastRequest.map { (input:(requests: [HudStatus?], lastRequest: HudStatus)) -> HudStatus in
            let isLoading = input.requests.reduce(false) { isLoading, request in
                return isLoading || (request?.isLoading ?? false)
            }
            
            let error: HudStatus? = input.requests.reduce(nil) { (error: HudStatus?, request: HudStatus?) in
                if let request = request, request.isError {
                    return request
                } else {
                    return error
                }
            }
            
            if isLoading {
                return .loading
            } else if !requestsAreAsync, let error = error  {
                return error
            } else {
                return input.lastRequest // Return last request result
            }
        }
    }
    
    //If any request in loading state - return loading
    //Else return last received error if exists
    //Else return last received response
    public static func group(_ requests: Driver<HudStatus>...) -> Driver<HudStatus> {
        return merge(requests: requests, requestsAreAsync: false)
    }
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }
    
    public var isError: Bool {
        if case .error = self {
            return true
        } else {
            return false
        }
    }
    
    public var isSuccess: Bool {
        switch self {
        case .loaded, .success, .info:
            return true
        case .loading, .error:
            return false
        }
    }
}

extension HudStatus: Equatable {
    public static func ==(lhs: HudStatus, rhs: HudStatus) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhsMessage), .success(let rhsMessage)):
            return lhsMessage == rhsMessage
        case (.error(let lhsMessage), .error(let rhsMessage)):
            return lhsMessage == rhsMessage
            
        case (.loading, .loading):
            return true
            
        case (.loaded, .loaded):
            return true
            
        case (.info(let lhsMessage), .info(let rhsMessage)):
            return lhsMessage == rhsMessage
            
        default:
            return false
        }
    }
}

//Use Observable<ApiEvent<Data>>> to access this methods
extension ObservableType where Element: ApiEventConvertible, Element.Data: Any  {
    func hud(successMessage: String? = nil, defaultError: String? = nil) -> Driver<HudStatus> {
        return self.map { event -> HudStatus in
            switch event.value {
            case .loading:
                return .loading
            case .loaded(let item):
                if let message = successMessage {
                    return .success(message: message)
                } else if let message = item as? String {
                    return .success(message: message)
                } else {
                    return .loaded
                }
            case .error(let error):
                if let error = error as? ApiError {
                    let message: String
                    if let msg = defaultError {
                        message = msg
                    } else {
                        switch error {
                        case .jsonParseError(let msg):
                            message = msg
                        case .encodingError(let msg):
                            message = msg
                        case .error(let msg):
                            message = msg
                        }
                    }
                    return .error(message: message)
                } else {
                    return .error(message: error.localizedDescription)
                }
            }
        }
        .asDriver(onErrorDriveWith: .empty())
    }
}

//Use Observable<Bool> to access this methods
extension ObservableType where Element == Bool  {
    func hud(successMessage: String? = nil, defaultError: String? = nil) -> Driver<HudStatus> {
        return self.map { isLoading -> HudStatus in
            if isLoading {
                return .loading
            } else {
                if let message = successMessage {
                    return .success(message: message)
                } else {
                    return .loaded
                }
            }
        }
        .catchError { error -> Observable<HudStatus> in
            if let error = error as? ApiError {
                let message: String
                //Try default error message
                if let msg = defaultError {
                    message = msg
                } else {
                    //Parse ApiError
                    switch error {
                    case .jsonParseError(let msg):
                        message = msg
                    case .encodingError(let msg):
                        message = msg
                    case .error(let msg):
                        message = msg
                    }
                }
                return .just(.error(message: message))
            } else {
                return .just(.error(message: error.localizedDescription))
            }
        }
        .asDriver(onErrorDriveWith: .empty())
    }
}
