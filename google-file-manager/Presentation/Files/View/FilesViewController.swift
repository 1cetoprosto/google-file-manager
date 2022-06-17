//
//  ListViewController.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import UIKit

class FilesViewController: UIViewController {

    private(set) var viewModel: FilesViewModelType?
    
    private var listViewButton: UIBarButtonItem!
    private var gridViewButton: UIBarButtonItem!
    private var createNewFileButton: UIBarButtonItem!
    private var createNewFolderButton: UIBarButtonItem!
    
    private let idFilesTableViewCell = "idFilesTableViewCell"
    private let idFilesCollectionViewCell = "idFilesCollectionViewCell"
    
    private var isTableViewShowing: Bool = false
    
    private(set) var collectionView: UICollectionView!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.Main.background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
    
    private func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width/3)-4,
                                 height: (view.frame.size.width/3*1.1)-4)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear//UIColor.Main.background
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(FilesCollectionViewCell.self, forCellWithReuseIdentifier: idFilesCollectionViewCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = false
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Main.background
        
        createCollectionView()
        
        tableView.register(FilesTableViewCell.self, forCellReuseIdentifier: idFilesTableViewCell)
        
        
        configureNavBar()
        
        setConstraints()
        
        if viewModel == nil {
            viewModel = FilesViewModel()
        }
        
        viewModel?.getFiles { [weak self] in
            guard let self = self else { return }
            self.reloadData()
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
    
    private func reloadData() {
        if self.isTableViewShowing {
            self.collectionView?.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }else{
            self.tableView.isHidden = true
            self.collectionView?.isHidden = false
            self.collectionView?.reloadData()
        }
    }
    
    @objc func createNewFile() {
        let alert = UIAlertController(title: "Create new file", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter file name here"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let textField = alert.textFields![0] as UITextField
            guard textField.text != "" else{return}
            let parentUuid = self.viewModel?.parent ?? ""
            let newEntry = FilesModel(name: textField.text!,
                                      type: "f",
                                      parentUuid: parentUuid)
            
            self.viewModel?.updateFiles(entry: newEntry) { [weak self] in
                guard let self = self else { return }
                self.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func createNewFolder() {
        let alert = UIAlertController(title: "Create new folder", message: nil, preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = "Enter folder name here"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            let textField = alert.textFields![0] as UITextField
            guard textField.text != "" else{return}
            let parentUuid = self.viewModel?.parent ?? ""
            let newEntry = FilesModel(name: textField.text!,
                                      type: "d",
                                      parentUuid: parentUuid)
            
            self.viewModel?.updateFiles(entry: newEntry) { [weak self] in
                guard let self = self else { return }
                self.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let viewModel = viewModel else { return nil }
        viewModel.selectRow(atIndexPath: indexPath)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            viewModel.deleteFiles()
            viewModel.getFiles { [weak self] in
                guard let self = self else { return }
                self.reloadData()
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension FilesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (((self.collectionView?.frame.width)! - 42) / 3), height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        //print("qty collection row: \(viewModel.numberOfRowInSection(for: section))")
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
            
            let fileVC = FilesViewController()
            fileVC.isTableViewShowing = isTableViewShowing
            fileVC.viewModel = folderViewModel
            
            self.navigationController?.pushViewController(fileVC, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration?{
        guard let viewModel = viewModel else { return nil}
        viewModel.selectRow(atIndexPath: indexPath)
        
        let identifier = "\(indexPath.row)" as NSString

        return UIContextMenuConfiguration(identifier: identifier, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { (_) in
                viewModel.deleteFiles()
                viewModel.getFiles { [weak self] in
                    guard let self = self else { return }
                    self.reloadData()
                }
            }
            return UIMenu(title: "", image: nil, children: [deleteAction])
        }
    }
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
