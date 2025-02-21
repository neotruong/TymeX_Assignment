import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    // MARK: - Input
    enum Input {
        case onAppear(username: String)
    }
    
    func apply(_ input: Input) {
        switch input {
        case .onAppear(let username):
            onAppearSubject.send(username)
        }
    }
    
    private let onAppearSubject = PassthroughSubject<String, Never>()
    
    // MARK: - Output
    @Published var isLoading = true
    @Published var userDetail: UserDetail?
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var cancellables: Set<AnyCancellable> = []
    private let userService: NetworkProtocol
    
    init(userService: NetworkProtocol = NetworkService()) {
        self.userService = userService
        bindInputs()
    }
    
    private func bindInputs() {
        onAppearSubject
            .flatMap { [userService] username in
                userService.fetchData(as: UserDetail?.self, endpoint: UserService.fetchUserDetail(username: username))
                    .catch { [weak self] error -> Just<UserDetail?> in
                        self?.handleError(error)
                        return Just(nil)
                    }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] userDetail in
                self?.isLoading = false
                self?.userDetail = userDetail
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Output Handling
    private func handleError(_ error: Error) {
        self.errorMessage = "Error loading user details: \(error.localizedDescription)"
    }
}
