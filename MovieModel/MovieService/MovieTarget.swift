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
    case movieDetails(id: Int)
    case search(query: String, page: Int)
    
    public var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    public var path: String {
        switch self {
        case .popular: return "/discover/movie"
        case let .movieDetails(id): return "/movie/\(id)"
        case .search: return "/search/movie"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .popular: return .get
        case .movieDetails: return .get
        case .search: return .get
        }
    }
    
    public var sampleData: Data { Data() }
    
    public var task: Task {
        
        var parameters: [String: Any] = ["api_key" : apiKey]
        
        switch self {
        case let .popular(page):
            parameters["page"] = page
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .movieDetails:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
       
        case let .search(query, page):
            parameters["query"] = query
            parameters["page"] = page
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return .none
    }
}

extension MovieTraget: CachePolicyGettable {
    var cachePolicy: URLRequest.CachePolicy {
        switch self {
        case .popular:
            return .reloadIgnoringLocalCacheData

        default:
            return .useProtocolCachePolicy
        }
    }
}
