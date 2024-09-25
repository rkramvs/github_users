
import Foundation

public struct APIKit {
    public static func request(_ requestConvertible: RequestConvertible,
                               session: URLSession) async throws -> Data {
        let request = try await requestConvertible.request()
        #if DEBUG
        print("URL: \(request.url?.absoluteString ?? "")")
        #endif
        let (data, response) = try await session.data(for: request)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            return data
        }
        throw NetworkError.networkFailure
    }
    
    
    public static func request<T: Decodable>(_ requestConvertible: RequestConvertible,
                                             session: URLSession,
                                             responseType: T.Type,
                                             jsonDecoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let request = try await requestConvertible.request()
        #if DEBUG
        print("URL: \(request.url?.absoluteString ?? "")")
        #endif
        let (data, response) = try await session.data(for: request)
        if (response as? HTTPURLResponse)?.statusCode == 200 {
            let response = try jsonDecoder.decode(responseType, from: data)
            return response
        }
        throw NetworkError.networkFailure
    }
}
