//
//  FilesItemViewModelType.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import Foundation

protocol FilesItemViewModelType: AnyObject {
    var name: String { get }
    var type: String { get }
    //var image: String { get }
}
