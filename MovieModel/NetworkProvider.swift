//
//  NetworkProvider.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import Moya


protocol CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy { get }
}

final class CachePolicyPlugin: PluginType {
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let cachePolicyGettable = target as? CachePolicyGettable {
            var mutableRequest = request
            mutableRequest.cachePolicy = cachePolicyGettable.cachePolicy
            return mutableRequest
        }
        return request
    }
}

public class NetworkProvider<RequestTarget: TargetType> {
    
    private var provider: MoyaProvider<RequestTarget>?
    
    public init() {
        
        provider = MoyaProvider<RequestTarget>(plugins: [CachePolicyPlugin()])
        
    }
    
    public func request(target: RequestTarget, callback: @escaping (Result<Response, Error>) -> Void) {
        
        self.provider?.request(target, completion: { (result) in
            switch result {
            case let .success( moyaResponse ) where 200..<400 ~= moyaResponse.statusCode:
                callback(Result.success(moyaResponse))
            case let .failure( error ):
                callback(Result.failure(error))
            default:
                assertionFailure("not hndle case")
            }
        })
    }
}
