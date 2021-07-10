//
//  PacksClient.swift
//  Packs
//
//  Created by Alex Layton on 10/07/2021.
//

import Foundation
import Combine

typealias Packs = [Pack]

struct Pack: Decodable {
    let count: Int
    let size: Int
}

struct CalculateRequest: Encodable {
    let count: Int
    let packSizes: [Int]
}

struct CalculateResponse: Decodable {
    let packs: Packs
}

enum PacksError: Error {
    case invalidResponse
}

struct PacksClient {
    
    private let baseURL = URL(string: "https://gi891qg1u8.execute-api.eu-west-1.amazonaws.com/dev/")!
    
    private let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    func calculate(count: Int, packSizes: [Int]) -> AnyPublisher<Packs, Error> {
        
        let url = baseURL.appendingPathComponent("calculate")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            let calculateRequest = CalculateRequest(count: count, packSizes: packSizes)
            request.httpBody = try encoder.encode(calculateRequest)
        } catch {
            return Fail(outputType: Packs.self, failure: error)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw PacksError.invalidResponse
                }
                return data
            }
            .decode(type: CalculateResponse.self, decoder: decoder)
            .map { $0.packs }
            .eraseToAnyPublisher()
    }
}
