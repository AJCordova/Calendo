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
//import RxDataSources

class EventsViewController: UIViewController, EKEventEditViewDelegate, UINavigationControllerDelegate {
    var viewModel: EventsViewModelTypes
    
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

extension EventsViewController {
    func setupViews() {
        setupViewTitle()
        setupDatePicker()
        setupEventsList()
        setupEventListViewCell()
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
        datePicker.addTarget(self, action: #selector(sendDateSelection), for: .valueChanged)
        view.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).offset(5)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(300)
        }
    }
    
    func setupEventsList() {
        tableView.register(UINib.init(nibName: "EventViewCell", bundle: nil), forCellReuseIdentifier: eventsCellID)
        
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(280)
        }
    }
    
    func setupEventListViewCell() { }
    
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
    
    @objc func sendDateSelection() {
        datePicker.rx.date
            .bind(to: viewModel.outputs.targetDate)
            .disposed(by: disposeBag)
    }
    
    private func showEventViewController() {
        let eventVC = EKEventEditViewController()
        eventVC.editViewDelegate = self
        eventVC.eventStore = EKEventStore()
        
        let event = EKEvent(eventStore: eventVC.eventStore)
        event.title = "Hello calendar!"
        event.startDate = Date()
        
        present(eventVC, animated: true)
    }
}

// MARK: Bindings
extension EventsViewController {
    func setupBindings() {
        viewModel.outputs.events
            .bind(to: tableView.rx.items) {(tableView, row, event) -> EventTableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: self.eventsCellID,
                                                        for: IndexPath.init(row: row, section: 0)) as! EventTableViewCell
                
                cell.eventDate.text = "Some Date here"
                cell.eventTitle.text = event.title
                cell.eventTime.text = "Some time here"
                return cell
            }
            .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension EventsViewController {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true, completion: nil)
        print("Dismissed modal")
        viewModel.outputs.loadEvents()
    }
}

extension EventsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
