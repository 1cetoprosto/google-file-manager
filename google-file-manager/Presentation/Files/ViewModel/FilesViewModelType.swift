//
//  FilesViewModelType.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import Foundation

protocol FilesViewModelType {
    var isFolder: Bool { get set }
    var parent: String? { get }
    
    func getFiles(completion: @escaping() -> ())
    func updateFiles(entry: FilesModel, completion: @escaping() -> ())
    func deleteFiles() //completion: @escaping () -> ()
    func numberOfRowInSection(for section: Int) -> Int
    func cellViewModel(for indexPath: IndexPath) -> FilesItemViewModelType?
    func viewModelForSelectedRow() -> FilesViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
}
