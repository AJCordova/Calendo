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
    func loadEvents()
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
            .bind(onNext: { _ in
                self.loadEvents()
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
                    loadEvents()
                }
            }
        }
    }
    
    func setTargetDate(date: Date) {
        targetDate.accept(date)
    }
    
    func loadEvents() {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: targetDate.value)
        let endDate = startDate.advanced(by: TimeInterval.day)
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
        
        events.onNext(eventStore.events(matching: predicate))
    }
    
    func deleteEvent() {
        print(events)
    }
    
    func setTargetEvent(event: EKEvent) {
        targetEvent.accept(event)
    }
}
