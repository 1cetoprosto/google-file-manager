//
//  ListViewController.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import UIKit

class FilesViewController: UIViewController {

     var viewModel: FilesViewModelType?
    
    var listViewButton: UIBarButtonItem!

    let idFilesCell = "idFilesCell"
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.Main.background
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
    }()
    
    let image: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    let lbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        viewModel = FilesViewModel(parent: "")
//        viewModel?.getFiles { [weak self] in
//            print(self?.viewModel?.numberOfRowInSection(for: 0))
//            self?.tableView.reloadData()
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Main.background
        title = "Sample"
        
        tableView.register(FilesTableViewCell.self, forCellReuseIdentifier: idFilesCell)
        tableView.dataSource = self
        tableView.delegate = self
        
//        // Button right
        //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
        //                                                            target: self,
        //                                                            action: #selector(performAdd(param:)))
        
        configureNavBar()
        
        setConstraints()
        
        if viewModel == nil {
            viewModel = FilesViewModel()
        }
        
        viewModel?.getFiles { [weak self] in
            //print(self?.viewModel?.numberOfRowInSection(for: 0))
            self?.tableView.reloadData()
        }
    }
    
    func configureNavBar(){
            title = "Sample"
//            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(didTapOnProfileImage))
//            createNewFileButton = UIBarButtonItem(image: UIImage(systemName: "note.text.badge.plus"), style: .plain, target: self, action: #selector(didTapOncreateNewFileButton))
//            createNewDirectoryButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(didTapOncreateNewDirectoryButton))
            //listViewButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(didTapOnswitchViewButton))
            //gridViewButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(didTapOnswitchViewButton))
            //navigationItem.rightBarButtonItems = [listViewButton] //, createNewDirectoryButton, createNewFileButton]
        }
    
//    @objc func didTapOnswitchViewButton(_ sender: UIBarButtonItem){
//            if !isTableViewShowing{
//                navigationItem.rightBarButtonItems = [gridViewButton, createNewDirectoryButton, createNewFileButton]
//                collectionView.isHidden = true
//                tableView.isHidden = false
//                tableView.reloadData()
//            }else{
//                navigationItem.rightBarButtonItems = [listViewButton, createNewDirectoryButton, createNewFileButton]
//                collectionView.isHidden = false
//                tableView.isHidden = true
//                collectionView.reloadData()
//            }
//            isTableViewShowing.toggle()
//        }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return viewModel?.numberOfSections() ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return viewModel?.titleForHeaderInSection(for: section)
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowInSection(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idFilesCell, for: indexPath) as? FilesTableViewCell
        guard let tableViewCell = cell,
        let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(for: indexPath)

        tableViewCell.viewModel = cellViewModel
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        
        if viewModel.isFolder {
            let folderViewModel = viewModel.viewModelForSelectedRow()
            //detailViewModel?.newModel = false
            
            let fileVC = FilesViewController()
            fileVC.viewModel = folderViewModel
            
            self.navigationController?.pushViewController(fileVC, animated: true)
        }
        
    }
    
//    func tableView(_ tableView: UITableView,
//                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        guard let viewModel = viewModel else { return nil }
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
//            viewModel.deleteSaleModel(atIndexPath: indexPath)
//
//            viewModel.getSales { [weak self] in
//                self?.tableView.reloadData()
//            }
//        }
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
}

// MARK: Constraints
extension FilesViewController {
    func setConstraints() {
        
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
