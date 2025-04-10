//
//  Network.swift
//  DesertEagle
//
//  Created by Pavel Ivanov on 22.03.2025.
//

import Foundation

class Network: NSObject {
    func isAcc() async -> Bool {
        if let encodedURLString = Other.greeting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let lnk = URL(string: encodedURLString) {
            do {
                let result = try await URLSession.shared.data(for: URLRequest(url: lnk))
                print(result.1)
                guard let urlResponse = result.1 as? HTTPURLResponse, urlResponse.statusCode == 200 else { return false }
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}
