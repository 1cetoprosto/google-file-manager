//
//  FilesTableViewCell.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import UIKit

class FilesTableViewCell: UITableViewCell {

    let backgroundViewCell: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.TableView.cellBackground
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    lazy var cellImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        
        return img
    }()
    
    lazy var filesName: UILabel = {
        let label = UILabel()
        label.text = "files name"
        //label.font = .
        label.textColor = UIColor.TableView.cellLabel
        label.textAlignment = .left
        //label.adjustsFontSizeToFitWidth = true
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = UIColor.TableView.cellBackground

        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var viewModel: FilesItemViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            filesName.text = viewModel.name
            if viewModel.type == "d" {
                cellImageView.image = UIImage(systemName: "folder")
                accessoryType = .disclosureIndicator
            } else {
                cellImageView.image = UIImage(systemName: "newspaper")
                accessoryType = .none
            }
        }
    }

    func setConstraints() {

        self.addSubview(backgroundViewCell)
        NSLayoutConstraint.activate([
            backgroundViewCell.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            backgroundViewCell.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            backgroundViewCell.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            backgroundViewCell.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
        ])

        self.addSubview(cellImageView)
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: backgroundViewCell.centerYAnchor, constant: 0),
            cellImageView.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 5),
            cellImageView.widthAnchor.constraint(equalToConstant: 20),
            cellImageView.heightAnchor.constraint(equalToConstant: 20)
                ])

        self.addSubview(filesName)
        NSLayoutConstraint.activate([
            filesName.centerYAnchor.constraint(equalTo: backgroundViewCell.centerYAnchor, constant: 0),
            filesName.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 5),
            filesName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            filesName.heightAnchor.constraint(equalToConstant: 20)
        ])

//        
//        let filesStackView = UIStackView(arrangedSubviews: [cellImageView, filesName])
//        filesStackView.axis = .horizontal
//        filesStackView.spacing = 5
//        filesStackView.distribution = .fillEqually
//
//        self.addSubview(filesStackView)
//        NSLayoutConstraint.activate([
//            filesStackView.bottomAnchor.constraint(equalTo: backgroundViewCell.bottomAnchor, constant: 0),
//            filesStackView.leadingAnchor.constraint(equalTo: backgroundViewCell.leadingAnchor, constant: 5),
//            filesStackView.trailingAnchor.constraint(equalTo: backgroundViewCell.trailingAnchor, constant: -30),
//            filesStackView.heightAnchor.constraint(equalToConstant: 60)
//        ])
    }
}

