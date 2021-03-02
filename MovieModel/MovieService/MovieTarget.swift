//
//  MovieTarget.swift
//  MovieModel
//
//  Created by Nifantiev Leonid Dev on 03.03.2021.
//

import Moya

let apiKey = "1cc33b07c9aa5466f88834f7042c9258"

public enum MovieTraget: TargetType {
    case popular(page: Int)
    
    public var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    public var path: String {
        switch self {
        case .popular: return "/discover/movie"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .popular: return .get
        }
    }
    
    public var sampleData: Data { Data() }
    
    public var task: Task {
        switch self {
        case let .popular(page):
            let parameters: [String: Any] = [
                "api_key" : apiKey,
                "page": page
            ]
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return .none
    }
}
