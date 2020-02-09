//
//  ViewModel.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/7/20.
//

import Foundation
import Combine

/// Provides data and loading state for the UI to be setup properly
class EventViewModel: ObservableObject {
    private let repository: EventRepository
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    /// Sorted array of `EventModel`s that holds the events data to display to the user
    @Published var data: [[EventUI]]?
    @Published var dateList: [String]?
    @Published var loading: Bool = true
    
    init(repository: EventRepository) {
        self.repository = repository
        
        repository.data
            .receive(on: RunLoop.main) // receive data on main thread
            .sink { [weak self] (events) in
                if let events = events, let strongSelf = self {
                    let matrixAndOrder = strongSelf.getMatrixAndOrder(events)
                    self?.data = matrixAndOrder.0
                    self?.dateList = matrixAndOrder.1
                    self?.loading = false
                } else {
                    self?.data = nil
                    self?.dateList = nil
                }
        }.store(in: &disposables)
    }
    
    /// Fetch new data
    func refresh() {
        loading = true
        repository.refresh()
    }
    
    /// Clear data
    func clear() {
        repository.clear()
    }
    // Creating a Matrix of events to build tableView and list of dates to fill in headers of sections
    private func getMatrixAndOrder(_ events: [EventModel]) -> ([[EventUI]],[String]) {
        var eventMatrix = [[EventUI]]()
        var dateOrdering = [String]()
        var prevDate = ""
        var i = -1
        for event in events {
            let date = event.start.getDate()
            let ui = EventUI(title: event.title, start: event.start.getTime(), end: event.end.getTime(), isConflict: event.isConflict)
            if prevDate == date {
                eventMatrix[i].append(ui)
            } else {
                i += 1
                eventMatrix.append([ui])
                dateOrdering.append(date)
            }
            prevDate = date
        }
        return (eventMatrix,dateOrdering)
    }
    
}
