//
//  ItemsViewController.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class ItemsViewController: UIViewController {

    // Normally I'd use an enum for categories, but I made the assumption
    // that they are dynamically assigned by the end-user
    private var currentCategory = "All"
    var items = [Item]()
    var sortedItems = [Item]() {
        didSet {
            self.collectionView.reloadData()
        }
    }

    private var currentCategoryItems: [Item] {
        get {
            if self.currentCategory == "All" {
                return self.items
            } else {
                return self.items.filter({$0.category == self.currentCategory })
            }
        }
    }
    
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    let reuseIdentifier = "itemCellIdentifier"
    let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        OmniWebManager.shared.getItems { (items, error) in
            self.items = items ?? [Item]()
            self.sortedItems = self.items
            self.setupMenu()
        }
        
        setupCollectionView()
        setupSearchController()
    }

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)
        searchController.searchBar.barTintColor = OMNI_RED
        searchController.searchBar.tintColor = .white
        
        searchController.searchBar.layer.borderWidth = 1
        searchController.searchBar.layer.borderColor = searchController.searchBar.barTintColor?.cgColor
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)

        view.addSubview(searchController.searchBar)
    }
    
    private func setupMenu() {
        var categorySet = Set<String>()
        categorySet.insert("All")
        for item in items {
            if let cat = item.category { categorySet.insert(cat) }
        }
        
        let categories = categorySet.sorted() as [AnyObject]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController!, containerView: self.navigationController!.view, title: "All", items: categories)
        menuView.menuTitleColor = .white
        menuView.cellTextLabelColor = .white
        menuView.selectedCellTextLabelColor = .white
        menuView.cellBackgroundColor = OMNI_RED
        menuView.cellSelectionColor = OMNI_RED
        
        self.navigationItem.titleView = menuView
        menuView.didSelectItemAtIndexHandler = {[weak self] (indexPath: Int) -> () in
            guard let strongSelf = self else { return }
            if let cat = categories[indexPath] as? String {
                strongSelf.currentCategory = cat
                strongSelf.sortedItems = strongSelf.currentCategoryItems
            }
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: - Action
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == DID_SELECT_ITEM_SEGUE {
            if let vc = segue.destination as? SingleItemViewController {
                vc.item = sender as? Item
            }
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText == "" {
            sortedItems = currentCategoryItems
        } else {
            sortedItems = currentCategoryItems.filter { item in
                return (item.title ?? "").lowercased().contains(searchText.lowercased())
            }
        }
    }
}

// MARK: - Scroll View Delegate

extension ItemsViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}


// MARK: - UICollectionView delegate, data source, flow layout

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: DID_SELECT_ITEM_SEGUE, sender: sortedItems[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        cell.item = sortedItems[indexPath.item]
        return cell
    }
}

// MARK: - Search Controller Delegate

extension ItemsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
