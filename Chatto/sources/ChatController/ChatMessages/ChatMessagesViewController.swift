//
// Copyright (c) Badoo Trading Limited, 2010-present. All rights reserved.
//

import UIKit

protocol ChatMessagesViewControllerDelegate: AnyObject {

}

public final class ChatMessagesViewController: UICollectionViewController {

    private let layout: UICollectionViewLayout & ChatCollectionViewLayoutProtocol
    private let messagesAdapter: ChatMessageCollectionAdapterProtocol
    private let presenterFactory: ChatItemPresenterFactoryProtocol
    private let style: Style

    private var layoutModel = ChatCollectionViewLayoutModel.createModel(0, itemsLayoutData: [])

    weak var delegate: ChatMessagesViewControllerDelegate?

    public init(layout: UICollectionViewLayout & ChatCollectionViewLayoutProtocol,
                messagesAdapter: ChatMessageCollectionAdapterProtocol,
                presenterFactory: ChatItemPresenterFactoryProtocol,
                style: Style) {
        self.layout = layout
        self.messagesAdapter = messagesAdapter
        self.presenterFactory = presenterFactory
        self.style = style

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.configureMessageAdapter()
        self.configurePresenterFactory()
        self.configureStyle()
        self.configureView()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.messagesAdapter.onViewDidAppear()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.messagesAdapter.onViewDidDisappear()
    }

    private func configureMessageAdapter() {
        self.collectionView.delegate = self
        self.messagesAdapter.setup(in: self.collectionView)
    }

    private func configureStyle() {
        self.collectionView.collectionViewLayout = self.layout
        self.collectionView.allowsSelection = false
        self.collectionView.alwaysBounceVertical = self.style.alwaysBounceVertical
        self.collectionView.backgroundColor = self.style.backgroundColor
        self.collectionView.contentInset = self.style.contentInsets
        self.collectionView.keyboardDismissMode = self.style.keyboardDismissMode
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.showsVerticalScrollIndicator = self.style.shouldShowVerticalScrollView
        self.collectionView.scrollIndicatorInsets = self.style.scrollIndicatorInsets
    }

    private func configurePresenterFactory() {
        self.presenterFactory.configure(withCollectionView: self.collectionView)
    }

    private func configureView() {
        self.collectionView.chatto_setContentInsetAdjustment(enabled: false, in: self)
        self.collectionView.chatto_setAutomaticallyAdjustsScrollIndicatorInsets(false)
        self.collectionView.chatto_setIsPrefetchingEnabled(false)
    }
}

public extension ChatMessagesViewController {
    struct Style {
        public var alwaysBounceVertical: Bool
        public var backgroundColor: UIColor
        public var contentInsets: UIEdgeInsets
        public var keyboardDismissMode: UIScrollView.KeyboardDismissMode
        public var scrollIndicatorInsets: UIEdgeInsets
        public var shouldShowVerticalScrollView: Bool

        public init(alwaysBounceVertical: Bool,
                    backgroundColor: UIColor,
                    contentInsets: UIEdgeInsets,
                    keyboardDismissMode: UIScrollView.KeyboardDismissMode,
                    scrollIndicatorInsets: UIEdgeInsets,
                    shouldShowVerticalScrollView: Bool) {
            self.alwaysBounceVertical = alwaysBounceVertical
            self.backgroundColor = backgroundColor
            self.contentInsets = contentInsets
            self.keyboardDismissMode = keyboardDismissMode
            self.scrollIndicatorInsets = scrollIndicatorInsets
            self.shouldShowVerticalScrollView = shouldShowVerticalScrollView
        }
    }
}

extension ChatMessagesViewController.Style {
    static var `default`: Self {
        return .init(
            alwaysBounceVertical: true,
            backgroundColor: .clear,
            contentInsets: .init(
                top: 10,
                left: 0,
                bottom: 10,
                right: 0
            ),
            keyboardDismissMode: .interactive,
            scrollIndicatorInsets: .zero,
            shouldShowVerticalScrollView: true
        )
    }
}
