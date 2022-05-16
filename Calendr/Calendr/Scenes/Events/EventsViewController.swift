//
//  EventsViewController.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/12/22.
//

import UIKit
import EventKitUI
import SnapKit
import RxSwift

class EventsViewController: UIViewController, EKEventEditViewDelegate, UINavigationControllerDelegate {
    private var viewModel: EventsViewModelTypes
    
    lazy var viewTitle: UILabel = UILabel()
    lazy var addEventButton: UIButton = UIButton()
    lazy var disposeBag = DisposeBag()
    lazy var tableView: UITableView = UITableView()
    lazy var datePicker: UIDatePicker = UIDatePicker()
    
    private let eventsCellID = "EventTableViewCell"
    
    init(viewModel: EventsViewModelTypes) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setupViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

// MARK: Setup views
extension EventsViewController {
    func setupViews() {
        setupViewTitle()
        setupDatePicker()
        setupEventsList()
        setupAddEventButton()
    }
    
    func setupViewTitle() {
        viewTitle.text = "Your Events"
        viewTitle.font = .systemFont(ofSize: 20, weight: .bold)
        view.addSubview(viewTitle)
        
        viewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
    
    func setupDatePicker(){
        datePicker.date = Date()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(340)
        }
    }
    
    func setupEventsList() {
        tableView.register(UINib.init(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: eventsCellID)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(-20)
            make.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
    }
    
    func setupAddEventButton() {
        addEventButton.backgroundColor = .systemBlue
        addEventButton.setTitle("Add Event", for: .normal)
        addEventButton.layer.cornerRadius = 9.0
        addEventButton.addTarget(self, action: #selector(self.addNewEvent), for: .touchUpInside)
        view.addSubview(addEventButton)
        
        addEventButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-50)
            make.left.right.equalToSuperview().inset(50)
        }
    }
    
    @objc func addNewEvent() {
        let eventVC = EKEventEditViewController()
        eventVC.eventStore = viewModel.outputs.getEventStore()
        eventVC.editViewDelegate = self
        
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.startDate = Date()
        
        present(eventVC, animated: true, completion: nil)
    }
    
    private func editEventViewController(for event: EKEvent?) {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = viewModel.outputs.getEventStore()
        
        if let event = event {
            eventVC.event = event
        }
        
        present(eventVC, animated: true)
    }
}

// MARK: Bindings
extension EventsViewController {
    func setupBindings() {
        
        viewModel.outputs.events
            .bind(to: tableView.rx.items) { [self](tableView, row, event) -> EventTableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.eventsCellID,
                                                        for: IndexPath.init(row: row, section: 0)) as! EventTableViewCell
                
                cell.eventDate.text = dateFormatter(date: event.startDate)
                cell.eventTitle.text = event.title
                cell.eventTime.text = timeFormatter(event: event)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.targetEvent
            .subscribe(onNext: { event in
                self.editEventViewController(for: event)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(EKEvent.self)
            .subscribe(onNext: { event in
                self.viewModel.inputs.setTargetEvent(event: event)
            })
            .disposed(by: disposeBag)
        
        datePicker.rx.value.changed.asObservable()
            .subscribe( { event in
                if let date = event.element {
                    self.viewModel.inputs.setTargetDate(date: date)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension EventsViewController {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true, completion: nil)
        viewModel.outputs.loadEvents()
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    private func dateFormatter(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "MMMM dd"
        return df.string(from: date)
    }
    
    private func timeFormatter(event: EKEvent) -> String {
        if !event.isAllDay {
            let df = DateFormatter()
            df.dateFormat = "hh:mm a"
            df.amSymbol = "AM"
            df.pmSymbol = "PM"
            return df.string(from: event.startDate) + " - " + df.string(from: event.endDate)
        }
        
        return "All Day Event"
    }
}
