//
//  ScrollTabView.swift
//  RSS-SelectFeeds
//
//  Created by 丸山翔 on 2020/10/07.
//
//
//
// 表示するデータは dataSource: ScrollViewDataSource が呼ばれる。
//  管理するタブが押された時、 delagate: ScrollViewDataSource を呼ぶ。
//
//

import UIKit

struct Tab {
    var id: Int
    var title: String
}


/// タブを表示するスクロール可能なview
/// collectionView: tabを表示する。
/// delegate: タブを選択された処理を委託する。
/// dataSource: 表示するタブのデータを委託する。
/// CELL_IDENTIFER: cell で使用するidentifier
/// tabTitles: 表示する
class ScrollTabView: UIView {
    private var collectionView: UICollectionView!
    
    var delegate: ScrollTabViewDelegate?
    var dataSouce: ScrollTabViewDataSource?
        
    private let CELL_IDENTIFER: String = "cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView = createCollectionView()
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        collectionView = createCollectionView()
        addSubview(collectionView)
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
        
        let cellNib = UINib(nibName: "ScrollTabViewCell", bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: CELL_IDENTIFER)

        return collectionView
    }
        
    func reloadData() {
        collectionView.reloadData()
    }
    
    func selectCell(at indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

// MARK: - Extensions

extension ScrollTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let aDataSource = dataSouce else {
            return 0
        }
        return aDataSource.scrollTabViewNumberOfTitles()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ScrollTabViewCell
        
        let title = dataSouce?.scrollTabView(self, titleForTabAt: indexPath)
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
        let title = dataSouce?.scrollTabView(self, titleForTabAt: indexPath)
        textLabel.text = title
        textLabel.sizeToFit()
        
        let labelFrame = textLabel.frame
        return CGSize(width: labelFrame.width + 40.0, height: labelFrame.height +  20.0)
    }
}
