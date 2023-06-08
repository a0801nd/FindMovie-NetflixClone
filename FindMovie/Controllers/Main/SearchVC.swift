import UIKit

class SearchVC: UIViewController {
    
    private var titles: [Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Seach for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        fetchDiscoverMovies()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies() {
        /*
         1. Функция `fetchDiscoverMovies()` вызывается для получения списка открытых фильмов.
         2. `APICaller.shared` является объектом, предположительно, класса `APICaller`, который имеет метод `getDiscoverMovie()`. Этот метод, вероятно, выполняет запрос к серверу или API для получения списка фильмов.
         3. Возвращаемый результат этого запроса обрабатывается в замыкании, переданном методу `getDiscoverMovie()`.
         4. Замыкание имеет параметр `results`, который является результатом запроса. Ожидается, что `results` будет содержать тип `Result<[String], Error>`, где `[String]` - это список заголовков фильмов, а `Error` - ошибка, если запрос не удался.
         5. Внутри замыкания используется конструкция `switch` для обработки результатов запроса. Если запрос успешен, то код выполняет следующие действия:
            - Значение `titles` (список заголовков фильмов) присваивается свойству `self?.titles`, где `self` является слабой ссылкой (weak reference) на текущий объект. Это сделано для предотвращения утечек памяти.
            - Затем вызывается метод `reloadData()` для объекта `discoverTable`. Предполагается, что `discoverTable` является таблицей или списком, который должен быть обновлен с новыми данными.
         6. Если запрос не удался и была получена ошибка, то ошибка выводится с помощью `print(error.localizedDescription)`.

         Этот код вызывает метод `getDiscoverMovie()` для получения списка заголовков фильмов, и если запрос успешен, то обновляет таблицу `discoverTable` новыми данными. Если запрос не удался, то выводит ошибку в консоль.
        */
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Extensions

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleVM(titleName: title.original_name ?? title.original_title ?? "Unknown", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else { return }
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewVM(title: titleName, youtubeVideo: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchVC: UISearchResultsUpdating, SearchResultsVCDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsVC else { return }
        
        resultsController.delegate = self
        
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func searchResultsVCDelegateDidTapItem(_ viewModel: TitlePreviewVM) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
