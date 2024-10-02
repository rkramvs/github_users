
import Foundation

public struct APIKit {
    
    public static func fetchDataWithResponse(_ requestConvertible: RequestConvertible,
                               session: URLSession) async throws -> (data: Data, httpResponse: HTTPURLResponse) {
        let request = try await requestConvertible.request()
        #if DEBUG
        print("URL: \(request.url?.absoluteString ?? "")")
        #endif
        let (data, response) = try await session.data(for: request)
        if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 {
            return (data, httpResponse)
        }
        throw NetworkError.networkFailure
    }
    
    public static func fetchData(_ requestConvertible: RequestConvertible,
                               session: URLSession) async throws -> Data {
        let response = try await fetchDataWithResponse(requestConvertible, session: session)
        return response.data
    }
    
    
    public static func fetchDecodedData<T: Decodable>(_ requestConvertible: RequestConvertible,
                                             session: URLSession,
                                             responseType: T.Type,
                                             jsonDecoder: JSONDecoder = JSONDecoder()) async throws -> T {
        let response = try await fetchDataWithResponse(requestConvertible, session: session)
        let model = try jsonDecoder.decode(responseType, from: response.data)
        return model
    }
    
    //MARK: - Download
    
    public static func downloadData(_ requestConvertible: RequestConvertible,
                                    session: URLSession) async throws -> Data {
        let request = try await requestConvertible.request()
        
        #if DEBUG
        print("URL: \(request.url?.absoluteString ?? "")")
        #endif
        let (url, response) = try await session.download(for: request)
        if let httpResponse = (response as? HTTPURLResponse), httpResponse.statusCode == 200 {
            return try Data(contentsOf: url)
        }
        throw NetworkError.networkFailure
    }
}
