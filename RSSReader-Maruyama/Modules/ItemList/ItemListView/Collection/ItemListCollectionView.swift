//
//  ItemListCollectionView.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/13.
//

import UIKit

class ItemListCollectionView: UICollectionView, ItemListViewProtocol {
    var itemListDataSource: ItemListDataSource!
    var itemListDelegate: ItemListDelegate!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialSetting()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetting()
    }
    
    internal func initialSetting() {
        delegate   = self
        dataSource = self
        
        let cellNib = UINib(nibName: "ItemListCollectionCell", bundle: nil)
        register(cellNib, forCellWithReuseIdentifier: "cell")
        backgroundColor = .clear
    }
    
    func addFillConstraint(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

extension ItemListCollectionView: ItemListCollectionCellDelegate {
    func didPushReadLaterButton(with item: Item, indexPath: IndexPath) {
        guard let aDelegate = itemListDelegate else { return }
        if item.isReadLater {
            aDelegate.removeReadLaterAt(indexPath: indexPath)
        } else {
            aDelegate.addReadLaterAt(indexPath: indexPath)
        }
    }
}

extension ItemListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let aDataSource = itemListDataSource else {
            return 0
        }
        return aDataSource.numberOfItemInsection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemListCollectionCell
        let item = itemListDataSource.itemList(itemForRowAt: indexPath)
        cell.setContents(item: item, indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
}

extension ItemListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let aDelegate = itemListDelegate else { return }
        aDelegate.itemList(didSelectedRowAt: indexPath)
    }
}

extension ItemListCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: (width/3) )
    }
}
