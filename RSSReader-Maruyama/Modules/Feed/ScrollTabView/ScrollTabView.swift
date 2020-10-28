//
//  ScrollTabView.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//
//
//
//  表示するデータは dataSource: ScrollViewDataSource が呼ばれる。
//  管理するタブが押された時、 delagate: ScrollViewDataSource を呼ぶ。
//
//

import UIKit

class ScrollTabView: UIView {
    private var collectionView: UICollectionView!
    
    var delegate: ScrollTabViewDelegate?
    var dataSouce: ScrollTabViewDataSource?
        
    private let CELL_IDENTIFER: String = "cell"
    private var tabTitles: [String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = createCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionView = createCollectionView()
    }
    
    private func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear

        addSubview(collectionView)

        let cellNib = UINib(nibName: "ScrollTabViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: CELL_IDENTIFER)
        
        return collectionView
    }
        
    func reloadData() {
        collectionView.reloadData()
    }
    
    func set(_ titles: [String]) {
        tabTitles = titles
        collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    func selectCell(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Extension

extension ScrollTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let aDataSource = dataSouce else {
            return 0
        }
        tabTitles = aDataSource.scrollTabViewSetSubTitles()
        return tabTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScrollTabViewCell
        
        let title = tabTitles[indexPath.row]
        cell.textlabel.text = title
        
        if isSelectedCell(indexPath: indexPath) {
            cell.setTextColor(UIColor(named: "tab-text_highlight")!)
        } else {
            cell.setTextColor(UIColor(named: "tab-text")!)
        }
        
        return cell
    }
    
    func isSelectedCell(indexPath: IndexPath) -> Bool {
        let selectedItems = collectionView.indexPathsForSelectedItems
        
        guard let selectedIndex = selectedItems else {
            return false
        }
        if selectedIndex[0] != indexPath {
            return false
        }
        
        return true
    }
}

extension ScrollTabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ScrollTabViewCell
        cell.setTextColor(UIColor(named: "tab-text_highlight")!)
        
        guard let aDelegate = delegate else {
            return
        }
        aDelegate.scrollTabView(self, didSelectIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ScrollTabViewCell
        cell.setTextColor(UIColor(named: "tab-text")!)
    }
}

extension ScrollTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let textLabel = UILabel()
        textLabel.text = tabTitles[indexPath.row]
        textLabel.sizeToFit()
        
        let labelFrame = textLabel.frame
        return CGSize(width: labelFrame.width + 40.0, height: labelFrame.height +  20.0)
    }
}
