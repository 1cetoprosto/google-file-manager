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
    var gridViewButton: UIBarButtonItem!
    var createNewFileButton: UIBarButtonItem!
    var createNewFolderButton: UIBarButtonItem!
    
    let idFilesTableViewCell = "idFilesTableViewCell"
    let idFilesCollectionViewCell = "idFilesCollectionViewCell"
    
    var isTableViewShowing: Bool = false
    
    private var collectionView: UICollectionView?
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.Main.background
        tableView.translatesAutoresizingMaskIntoConstraints = false

        return tableView
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
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4,
                                 height: (view.frame.size.width/3*1.1)-4)
        
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        if let collectionView = collectionView {
            collectionView.backgroundColor = .clear//UIColor.Main.background
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            collectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: idFilesCollectionViewCell)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isHidden = false
            view.addSubview(collectionView)
            collectionView.frame = view.bounds
        }
        
        tableView.register(FilesTableViewCell.self, forCellReuseIdentifier: idFilesTableViewCell)
        tableView.dataSource = self
        tableView.delegate = self
        
        configureNavBar()
        
        setConstraints()
        
        if viewModel == nil {
            viewModel = FilesViewModel()
        }
        
        viewModel?.getFiles { [weak self] in
//            self?.tableView.reloadData()
//            self?.collectionView?.reloadData()
            guard let self = self else { return }
            if self.isTableViewShowing {
                //self.navigationItem.rightBarButtonItems = [self.gridViewButton, self.createNewFolderButton, self.createNewFileButton]
                self.collectionView?.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }else{
                //self.navigationItem.rightBarButtonItems = [self.listViewButton, self.createNewFolderButton, self.createNewFileButton]
                self.tableView.isHidden = true
                self.collectionView?.isHidden = false
                self.collectionView?.reloadData()
            }
        }
    }
    
    func configureNavBar(){
        title = "Sample"
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.NavBar.background
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(login))
        createNewFileButton = UIBarButtonItem(image: UIImage(systemName: "doc.badge.plus"), style: .plain, target: self, action: #selector(createNewFile))
        createNewFolderButton = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(createNewFolder))
        listViewButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(switchView))
        gridViewButton = UIBarButtonItem(image: UIImage(systemName: "square.grid.2x2"), style: .plain, target: self, action: #selector(switchView))
        
        if isTableViewShowing {
        navigationItem.rightBarButtonItems = [gridViewButton, createNewFolderButton, createNewFileButton]
        } else {
            navigationItem.rightBarButtonItems = [listViewButton, createNewFolderButton, createNewFileButton]
        }
    }
    
    @objc func login() {
        let signInViewController = SignInViewController()
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }
    
    @objc func createNewFile() {
        
    }
    
    @objc func createNewFolder() {
        
    }
    
    @objc func switchView() {
        if !isTableViewShowing{
            navigationItem.rightBarButtonItems = [gridViewButton, createNewFolderButton, createNewFileButton]
            collectionView?.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }else{
            navigationItem.rightBarButtonItems = [listViewButton, createNewFolderButton, createNewFileButton]
            tableView.isHidden = true
            collectionView?.isHidden = false
            collectionView?.reloadData()
        }
        isTableViewShowing.toggle()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FilesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRowInSection(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idFilesTableViewCell, for: indexPath) as? FilesTableViewCell
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
            fileVC.isTableViewShowing = isTableViewShowing
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (((self.collectionView?.frame.width)! - 42) / 3), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        print("qty collection row: \(viewModel.numberOfRowInSection(for: section))")
        return viewModel.numberOfRowInSection(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idFilesCollectionViewCell, for: indexPath) as? FilesCollectionViewCell
        
        guard let collectionViewCell = cell,
              let viewModel = viewModel else { return UICollectionViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(for: indexPath)
        
        collectionViewCell.viewModel = cellViewModel
        
        return collectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        
        if viewModel.isFolder {
            let folderViewModel = viewModel.viewModelForSelectedRow()
            //detailViewModel?.newModel = false
            
            let fileVC = FilesViewController()
            fileVC.isTableViewShowing = isTableViewShowing
            fileVC.viewModel = folderViewModel
            
            self.navigationController?.pushViewController(fileVC, animated: true)
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
//        let index = indexPath.row
//        let identifier = "\(index)" as NSString
//
//        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
//            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
//                print("delete")
//                if let index = sheetData.firstIndex(of: self.mainData[indexPath.row]) {
//                    print("Found peaches at index \(index)")
//                    self.callDeleteFiles(index: index)
//                }
//            }
//            return UIMenu(title: "", image: nil, children: [deleteAction])
//        }
//    }
//
    
}

// MARK: Constraints
extension FilesViewController {
    func setConstraints() {
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: 0)
        ])
        
    }
}
