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
    var viewModel: EventsViewModelTypes
    
    lazy var viewTitle: UILabel = UILabel()
    lazy var addEventButton: UIButton = UIButton()
    lazy var disposeBag = DisposeBag()
    
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
        setupEventsList()
        setupEventListViewCell()
        setupAddEventButton()
    }
    
    func setupViewTitle() {
        viewTitle.text = "Your Events"
        viewTitle.font = .systemFont(ofSize: 30, weight: .bold)
        view.addSubview(viewTitle)
        
        viewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
    
    func setupEventsList() { }
    
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
            .subscribe(onNext: { event in
                print(event)
            })
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
