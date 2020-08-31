//
//  FacebookAlbumCollectionViewController.swift
//  FBSDKCoreKit
//
//  Created by Loi Tran on 8/31/20.
//

import UIKit

private let reuseIdentifier = "Cell"

class FacebookAlbumCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    /// MARK: Var
    
    private var cellSize: CGFloat?
    private let cellPerRow: CGFloat = FacebookImagePicker.pickerConfig.picturePerRow
    private let cellSpacing: CGFloat = FacebookImagePicker.pickerConfig.cellSpacing
    private var pictureCollection: UICollectionView?
    
    weak var delegate: FacebookAlbumPickerDelegate?
    private var albums: [FacebookAlbum]
    
    init(albums: [FacebookAlbum]) {
        self.albums = albums
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareViewController()
        self.prepareCollectionView()
    }

    // MARK: Prepare
    
    private func prepareViewController() {
        self.view.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
    }
    
    private func prepareCollectionView() {
        let layout = UICollectionViewFlowLayout()
        self.pictureCollection = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        guard let collectionView = self.pictureCollection else { return }
        collectionView.register(UINib(nibName: "AlbumCollectionViewCell", bundle: Bundle(for: AlbumCollectionViewCell.self)), forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.view.addSubview(collectionView)
        self.view.pinEdges(to: collectionView)
        self.cellSize = (collectionView.frame.width - (self.cellSpacing * (self.cellPerRow + 1.0))) / self.cellPerRow
    }

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.albums.count == 0 ? 0 : 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AlbumCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? AlbumCollectionViewCell else { return }
        cell.configure(album: albums[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let album = self.albums.get(at: indexPath.row) else { return }
        self.delegate?.didSelectAlbum(album: album)
    }
}

extension FacebookAlbumCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize ?? 0, height: self.cellSize == nil ? 0 : self.cellSize! + 40)
    }
}
