//
//  FakeNetwork.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/7/20.
//

import Foundation
import Combine

/// Stores and fetches event data
class EventRepository {
    /// Observable `EventData`
    var data: CurrentValueSubject<[EventModel]?, Never> = CurrentValueSubject<[EventModel]?, Never>(nil)
    var loading: CurrentValueSubject<Bool, Never> = CurrentValueSubject<Bool, Never>(true)
    
    private var network: FakeNetwork = FakeNetwork()

    private init() {}
    /// shared instance of `EventRepository`
    static let shared: EventRepository = EventRepository()
    
    /// Fetch new `EventData`
    func refresh() {
        network.fetchData { [weak self] (data) in
            self?.data.send(self?.convertData(data))
        }
    }
    
    /// Clear `EventData`
    func clear() {
        data.send(nil)
    }
    
    // sorting and conflict algorithms, overall time complexity: O(n*log(n))
    private func convertData(_ eventData: [EventData]) -> [EventModel] {
        var events = eventData.map { EventModel(title: $0.title, start: $0.start.convertDate(), end: $0.end.convertDate())}
            // sorting algorithm, time complexity: O(n*log(n))
            .sorted { $0.start < $1.start }
        // conflict algorithm, time complexity: O(n)
        for i in 0..<events.count-1 {
            var j = i + 1
            while j < events.count, events[i].end > events[j].start {
                events[i].isConflict = true
                events[j].isConflict = true
                j+=1
            }
        }
        
        return events
    }
}

