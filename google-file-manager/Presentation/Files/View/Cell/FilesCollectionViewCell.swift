//
//  FilesCollectionViewCell.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 14.06.2022.
//

import UIKit

class FilesCollectionViewCell: UICollectionViewCell {
   
    //static let identifier = "FilesCollectionViewCell"
    
    let backgroundViewCell: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.TableView.cellBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var cellImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        //img.backgroundColor = .yellow
        
        return img
    }()
    
    lazy var filesName: UILabel = {
        let label = UILabel()
        label.text = "files name"
        label.textColor = UIColor.TableView.cellLabel
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.backgroundColor = .green

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = .systemRed
//        cellImageView.image = UIImage(systemName: "house")
//        filesName.text = "Text test"
        contentView.addSubview(backgroundViewCell)
        contentView.addSubview(cellImageView)
        contentView.addSubview(filesName)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundViewCell.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
        
        filesName.frame = CGRect(x: 5,
                                 y: contentView.frame.size.height-50,
                                 width: contentView.frame.size.width-10,
                                 height: 50)
        
        cellImageView.frame = CGRect(x: 5,
                                     y: 0,
                                     width: contentView.frame.size.width-10,
                                     height: contentView.frame.size.height-50)
    }
    
    weak var viewModel: FilesItemViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            filesName.text = viewModel.name
            if viewModel.type == "d" {
                cellImageView.image = UIImage(systemName: "folder")
                //accessoryType = .disclosureIndicator
            } else {
                cellImageView.image = UIImage(systemName: "newspaper")
                //accessoryType = .none
            }
        }
    }
    
}
    
    
