//
//  Network.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/7/20.
//

import UIKit
import Combine

/// Fake networking object used to pull json data locally and convert to `EventData`
struct FakeNetwork {
    let decoder: JSONDecoder = JSONDecoder()
    func fetchData(completion: @escaping ([EventData]) -> Void) {
        // Dispatch on background thread for fake network request
        DispatchQueue.global(qos: .background).async {
            // Simulate RTT
            sleep(3)
            // Grab data from Assets
            guard let asset = NSDataAsset(name: "mock") else { fatalError("unable to grab mock data") }
            let data: Data = asset.data
            // Convert data to a list of events
            var eventData: [EventData] = []
            do {
                eventData = try self.decoder.decode([EventData].self, from: data)
            } catch {
                fatalError("failed to decode data: \(error.localizedDescription)")
            }
            completion(eventData)
        }
    }
}

