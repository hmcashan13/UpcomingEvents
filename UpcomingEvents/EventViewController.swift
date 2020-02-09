//
//  ViewController.swift
//  UpcomingEvents
//
//  Created by Hudson Mcashan on 2/7/20.
//

import UIKit
import Combine

class EventViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel: EventViewModel = EventViewModel(repository: EventRepository.shared)
    private var disposables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Called here because view controller was not initialized completely in the viewDidLoad
        bindLoadingView()
    }
    
    private func bindLoadingView() {
        viewModel.$loading.sink { [weak self] (loading) in
            guard let strongSelf = self else { return }
            loading ? showLoadingView(presenter: strongSelf) : removeLoadingView(remover: strongSelf)
            strongSelf.tableView.reloadData()
        }.store(in: &disposables)
    }
    
    @IBAction func clear(_ sender: Any) {
        viewModel.clear()
        tableView.reloadData()
    }
    @IBAction func refresh(_ sender: Any) {
        viewModel.refresh()
        tableView.reloadData()
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "EventTableViewCell"
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        if let data = viewModel.data {
            cell.title.text = data[indexPath.section][indexPath.row].title
            cell.startTime.text = data[indexPath.section][indexPath.row].start
            cell.endTime.text = data[indexPath.section][indexPath.row].end
            cell.isConflict.isHidden = !data[indexPath.section][indexPath.row].isConflict
            return cell
        }
        cell.isHidden = true
        tableView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let list = viewModel.dateList {
            return list[section]
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let list = viewModel.dateList {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = viewModel.data  {
            return data[section].count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

