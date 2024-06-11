//
//  URLImage.swift
//
//
//  Created by Sultan Irkaliyev on 09.06.2024.
//

import SwiftUI

fileprivate enum Constants {
    enum Text {
        static let resume = "Resume"
        static let pause = "Pause"
        static let stop = "Stop"
        static let download = "Download"
    }
    enum Icon {
        static let noImagePlaceholder = "photo"
        static let play = "play.circle.fill"
        static let pause = "pause.circle.fill"
        static let stop = "stop.circle.fill"
        static let download = "arrow.down.circle.fill"
    }
}

final public class URLImageViewModel: ObservableObject {
    
    // MARK: - Properties -
    @Published var image: UIImage?
    @Published var progress: Double = 0.0
    @Published var isLoading: Bool = false
    @Published var isFailed: Bool = false
    @Published var isPaused: Bool = false
    
    private let imageLoader = ImageLoader.shared
    
    func startDownload(url: URL) {
        resetProgress()
        isLoading = true
        imageLoader.loadImage(from: url) { progress in
            DispatchQueue.main.async {
                self.progress = progress
            }
        } completion: { result in
            DispatchQueue.main.async {
                self.isLoading = false                
                switch result {
                case .success(let loadedImage):
                    self.image = loadedImage
                case .failure(let error):
                    self.isFailed = true
                }
            }
        }
    }
    
    func resumeDownload(url: URL) {
        isPaused = false
        imageLoader.pauseLoad(for: url)
    }
    
    func pauseDownload(url: URL) {
        isPaused = true
        imageLoader.pauseLoad(for: url)
    }
    
    func stopDownload(url: URL) {
        isLoading = false
        imageLoader.cancelLoad(for: url)
    }
    
    func resetProgress() {
        isPaused = false
        progress = 0.0
    }
}

public struct URLImage<Content: View, Progress: View, Placeholder: View, ErrorPlaceholder: View>: View {
    
    // MARK: - Properties -
    let url: URL
    let automaticDownload: Bool
    let content: (UIImage) -> Content
    let progressView: ((Double) -> Progress)?
    let placeholderView: (() -> Placeholder)?
    let errorPlaceholderView: (() -> ErrorPlaceholder)?
    
    @State private var imageID = UUID()
    @StateObject var viewModel: URLImageViewModel
    
    public var body: some View {
        VStack {
            if let image = viewModel.image {
                content(image)
            } else {
                if viewModel.isLoading {
                    if let progressView = progressView {
                        progressView(viewModel.progress)
                    } else if let placeholderView = placeholderView {
                        placeholderView()
                    }
                } else if viewModel.isFailed {
                    if let errorPlaceholderView = errorPlaceholderView {
                        errorPlaceholderView()
                    } else if let placeholderView = placeholderView {
                        placeholderView()
                    }
                } else if let placeholderView = placeholderView {
                    placeholderView()
                } else {
                    Text(String())
                }
            }
            
            if !automaticDownload {
                ImageLoadingControls(isLoading: viewModel.isLoading, startAction: {
                    viewModel.startDownload(url: url)
                }, pauseAction: {
                    viewModel.pauseDownload(url: url)
                }, resumeAction: {
                    viewModel.resumeDownload(url: url)
                }, stopAction: {
                    viewModel.stopDownload(url: url)
                })
            }
        }
        .onAppear {
            if automaticDownload && viewModel.image == nil {
                viewModel.startDownload(url: url)
            }
        }
        .id(imageID)
    }
    
    @ViewBuilder
    func ImageLoadingControls(isLoading: Bool,
                              startAction: @escaping () -> Void,
                              pauseAction: @escaping () -> Void,
                              resumeAction: @escaping () -> Void,
                              stopAction: @escaping () -> Void) -> some View {
        if viewModel.image == nil {
            HStack(spacing: 20) {
                if isLoading {
                    if viewModel.isPaused {
                        ButtonBlock(title: Constants.Text.resume, icon: Constants.Icon.play)
                            .onTapGesture {
                                resumeAction()
                            }
                    } else {
                        ButtonBlock(title: Constants.Text.pause, icon: Constants.Icon.pause)
                            .onTapGesture {
                                pauseAction()
                            }
                    }
                    
                    ButtonBlock(title: Constants.Text.stop, icon: Constants.Icon.stop)
                        .onTapGesture {
                            stopAction()
                        }
                } else if !isLoading {
                    DownloadButton()
                        .onTapGesture {
                            startAction()
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func ButtonBlock(title: String, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 24, height: 24)
            Text(title)
        }
    }
    
    @ViewBuilder
    func DownloadButton() -> some View {
        VStack(alignment: .center) {
            Image(systemName: Constants.Icon.noImagePlaceholder)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            HStack {
                Text(Constants.Text.download)
                Image(systemName: Constants.Icon.download)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

public extension URLImage {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder progressView: @escaping (Double) -> Progress, @ViewBuilder placeholderView: @escaping () -> Placeholder, @ViewBuilder errorPlaceholderView: @escaping () -> ErrorPlaceholder) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = progressView
        self.placeholderView = placeholderView
        self.errorPlaceholderView = errorPlaceholderView
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Progress == EmptyView, Placeholder == EmptyView, ErrorPlaceholder == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = nil
        self.placeholderView = nil
        self.errorPlaceholderView = nil
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Placeholder == EmptyView, ErrorPlaceholder == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder progressView: @escaping (Double) -> Progress) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = progressView
        self.placeholderView = nil
        self.errorPlaceholderView = nil
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Placeholder == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder progressView: @escaping (Double) -> Progress, @ViewBuilder errorPlaceholderView: @escaping () -> ErrorPlaceholder) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = progressView
        self.placeholderView = nil
        self.errorPlaceholderView = errorPlaceholderView
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Progress == EmptyView, ErrorPlaceholder == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder placeholderView: @escaping () -> Placeholder) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = nil
        self.placeholderView = placeholderView
        self.errorPlaceholderView = nil
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Progress == EmptyView, Placeholder == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder errorPlaceholderView: @escaping () -> ErrorPlaceholder) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = nil
        self.placeholderView = nil
        self.errorPlaceholderView = errorPlaceholderView
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}

public extension URLImage where Progress == EmptyView {
    init(url: URL, automaticDownload: Bool = true, @ViewBuilder content: @escaping (UIImage) -> Content, @ViewBuilder placeholderView: @escaping () -> Placeholder, @ViewBuilder errorPlaceholderView: @escaping () -> ErrorPlaceholder) {
        self.url = url
        self.automaticDownload = automaticDownload
        self.content = content
        self.progressView = nil
        self.placeholderView = placeholderView
        self.errorPlaceholderView = errorPlaceholderView
        _viewModel = StateObject(wrappedValue: ImageViewModelStore.shared.viewModel(for: url))
    }
}
