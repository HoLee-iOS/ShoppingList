//
//  ViewController.swift
//  ShoppingList
//
//  Created by 이현호 on 2022/10/20.
//

import UIKit
import SnapKit

struct shopping: Hashable {
    let id = UUID().uuidString
    let content: String
    var check: Bool
}

class ViewController: UIViewController {

    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        return bar
    }()
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.delegate = self
        return view
    }()
    
    var list: [shopping] = []
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, shopping>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //뷰에 추가
        [searchBar, collectionView].forEach { view.addSubview($0) }
        
        //레이아웃
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(0)
        }
        
        configureDataSource()
    }
    
    @objc func checkButtonClicked(_ sender: UIButton) {
        list[sender.tag].check.toggle()
        list[sender.tag].check ? sender.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("😊")
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        list.append(shopping(content: searchBar.text!, check: false))
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([shopping(content: searchBar.text!, check: false)])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ViewController {
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
    
    private func configureDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<ShoppingListCollectionViewCell, shopping> { cell, indexPath, itemIdentifier in
            
            cell.configure()
            cell.setConstraints()
            
            cell.contentLabel.text = itemIdentifier.content
            cell.tag = indexPath.item
            
            cell.checkButton.addTarget(self, action: #selector(self.checkButtonClicked), for: .touchUpInside)
            itemIdentifier.check ? cell.checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal) : cell.checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, shopping>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)
    }
}

