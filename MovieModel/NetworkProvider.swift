//
//  NetworkProvider.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 02.03.2021.
//

import Moya

public class NetworkProvider<RequestTarget: TargetType> {
    
    private var provider: MoyaProvider<RequestTarget>?
    
    public init() {
        
        provider = MoyaProvider<RequestTarget>()
        
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
