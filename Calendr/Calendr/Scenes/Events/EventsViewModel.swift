//
//  EventsViewModel.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import Foundation
import EventKit
import RxSwift
import RxRelay

protocol EventsViewModelInputs {
    func deleteEvent()
    func setTargetDate(date: Date)
    func setTargetEvent(event: EKEvent)
    
}

protocol EventsViewModelOutputs {
    func loadEvents(for date: Date)
    func getEventStore() -> EKEventStore
    var events: PublishSubject<[EKEvent]> { get }
    var targetDate: BehaviorRelay<Date> { get }
    var targetEvent: PublishRelay<EKEvent> { get }
}

protocol EventsViewModelTypes {
    var inputs: EventsViewModelInputs { get }
    var outputs: EventsViewModelOutputs { get }
}

class EventsViewModel: EventsViewModelTypes, EventsViewModelInputs, EventsViewModelOutputs {
    var inputs: EventsViewModelInputs { return self }
    var outputs: EventsViewModelOutputs { return self }
    
    var events: PublishSubject<[EKEvent]> = PublishSubject<[EKEvent]>()
    var targetDate: BehaviorRelay<Date> = BehaviorRelay<Date>(value: Date())
    var targetEvent: PublishRelay<EKEvent> = PublishRelay()
    
    private let eventStore = EKEventStore()
    private let disposeBag = DisposeBag()
    private var coordinator: EventsCoordinatorDelegate
    
    init(coordinator: EventsCoordinatorDelegate) {
        self.coordinator = coordinator
        requestCalendarAccess()
        
        targetDate
            .bind(onNext: { date in
                self.loadEvents(for: date)
            })
            .disposed(by: disposeBag)
    }
    
    func getEventStore() -> EKEventStore {
        return eventStore
    }
    
    func requestCalendarAccess() {
        eventStore.requestAccess(to: .event) { [self] (granted, error) in
            if granted {
                DispatchQueue.main.async {
                    loadEvents(for: Date())
                }
            }
        }
    }
    
    func setTargetDate(date: Date) {
        targetDate.accept(date)
    }
    
    // Retrieve events from ALL calendars.
    func loadEvents(for date: Date) {
        let startDate = date
        let endDate = date
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        events.onNext(eventStore.events(matching: predicate))
    }
    
    func deleteEvent() {
        print(events)
    }
    
    func editEvent(event: EKEvent) {
        //self.coordinator.editEvent(event: <#EKEvent#>)
    }
    
    func setTargetEvent(event: EKEvent) {
        targetEvent.accept(event)
    }
}
