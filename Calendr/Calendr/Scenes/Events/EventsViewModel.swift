//
//  EventsViewModel.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import EventKit
import RxSwift

protocol EventsViewModelInputs {
    func deleteEvent()
    func editEvent(event: EKEvent)
    
}

protocol EventsViewModelOutputs {
    func loadEvents()
    func getEventStore() -> EKEventStore
    var events: PublishSubject<[EKEvent]> { get }
}

protocol EventsViewModelTypes {
    var inputs: EventsViewModelInputs { get }
    var outputs: EventsViewModelOutputs { get }
}

class EventsViewModel: EventsViewModelTypes, EventsViewModelInputs, EventsViewModelOutputs {
    var inputs: EventsViewModelInputs { return self }
    var outputs: EventsViewModelOutputs { return self }
    
    var events: PublishSubject<[EKEvent]> = PublishSubject<[EKEvent]>()
    
    private let eventStore = EKEventStore()
    
    private var coordinator: EventsCoordinatorDelegate
    
    init(coordinator: EventsCoordinatorDelegate) {
        self.coordinator = coordinator
        requestCalendarAccess()
    }
    
    func getEventStore() -> EKEventStore {
        return eventStore
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { [self] (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    loadEvents()
                }
            }
        }
    }
    
    // Retrieve events from ALL calendars.
    func loadEvents() {
        let weekFromNow = Date().advanced(by: TimeInterval.week)
        let weekBefore = Date(timeIntervalSinceNow: -7*24*3600)
        let predicate = eventStore.predicateForEvents(withStart: weekBefore, end: weekFromNow, calendars: nil)
        
        events.onNext(eventStore.events(matching: predicate))
    }
    
    func deleteEvent() {
        print(events)
    }
    
    func editEvent(event: EKEvent) {
        //self.coordinator.editEvent(event: <#EKEvent#>)
    }
}
