import UIKit
import Kingfisher
import AVFoundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var movies : [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.becomeFirstResponder()
    }
}

class ResultCell : UICollectionViewCell {
    @IBOutlet weak var thumnailImageView: UIImageView!
}

extension SearchViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell else { return UICollectionViewCell() }
        
        let movie = movies[indexPath.item]
        
        //imagepath는 url -> image 로 바꾸는 작업 필요
        //Kingfisher 오픈 라이브러리를 사용해 간단히 바꿨습니다~~
        let url = URL(string: movie.thumnailPath)
        cell.thumnailImageView.kf.setImage(with: url)
        cell.backgroundColor = .red
        return cell
    }
    
}

extension SearchViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 플레이어 창을 뜨워야한다.
        let sb = UIStoryboard(name: "Player", bundle: nil) // 스토리 보드 선택
        guard let vc =  sb.instantiateViewController(identifier: "PlayerViewController") as? PlayerViewController else { return } // 선택된 스토리보드 커스텀 클래스 연결
        vc.modalPresentationStyle = .fullScreen // 뜨워졌을시전체 화면으로 설정
        
        
        //선택한 인덱스를 바탕으로 플레이한 인스턴스 뽑기
        let movie = movies[indexPath.item]
        let url = URL(string: movie.previewURL) // 재생할 비디오 url
        
        let item = AVPlayerItem(url: url!)
        
        //player에 재생할 아이템 넣기
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: false, completion: nil) // 컨트롤러와 연결된 스토리 보드 뜨위기
        
    }
}

extension SearchViewController : UICollectionViewDelegateFlowLayout {
    // 셀 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin : CGFloat = 8.0
        let itemsSpacing : CGFloat = 10.0
        
        let width = (collectionView.bounds.width - (margin * 2) -  (itemsSpacing * 2)) / 3
        let height = width * 10 / 7
        //        10: 7 비율
        
        return  CGSize(width: width, height: height)
    }
}

// searchBar 델리게이트 설정
extension SearchViewController : UISearchBarDelegate {
    private func dismissKeyBoard() -> Void {
        searchBar.resignFirstResponder() // 키보드 내려 버리기
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //검색 시작이 동작 시작됨
        
        // 키보드 올라와 있을때 , 내려 버리기 결과있을때 바꿔주기위해
        dismissKeyBoard()
        
        // 검색어가 있는지 확인
        guard let searchTerm = searchBar.text , searchTerm.isEmpty == false else { return }
    
        // 서치텀에서 예외로 리턴되게 되면 서버와의 네트워킹은 필요없다 아래와 같은 내용은 조용하것지~~
        print("--> 검색어 : \(searchBar.text)")
        
        //네트워킹을 통한 검색
        // - 목표 : 서치텀을 가지고 네트워크 영화 검색
        // - 검색 API 가 필요
        SearchAPI.search(searchTerm) { movies in
            // collectionView로 표현하기
            print("몇개 넘어옴??? \(movies.count)개")
            
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData()
            }
        }
        // - 검색을 받아올 모델 Movie , Response
        // - 결과를 받아서 , CollectionView로 표현해주자
    }
}

class SearchAPI {
    static func search(_ term : String , completion : @escaping ([Movie]) -> Void) {
        let session = URLSession(configuration: .default)

        //URL
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        
        urlComponents?.queryItems?.append(mediaQuery)
        urlComponents?.queryItems?.append(entityQuery)
        urlComponents?.queryItems?.append(termQuery)
        
        let requsetURL = urlComponents?.url!
        
        print(requsetURL)
        
        let dataTask = session.dataTask(with: requsetURL!) { data, respone, error in
            let sucessRange = 200..<300
            
            guard error == nil , let statusCode = (respone as? HTTPURLResponse)?.statusCode , sucessRange.contains(statusCode) else {
                completion([])
                return
            }
            guard let resultData = data else {
                completion([])
                return
            }
            
            //data -> [Movie]
            // JSON Parsing
            let string  = String(data: resultData, encoding: .utf8)
            
            // movie 리스트 초기화 및 컴플리션에 바인딩
            //let movies: [Movie]
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies)
            
            print("--> resultData: \(string)")
            
        }
        dataTask.resume()
    }
    
    static func parseMovies (_ data : Data) -> [Movie] {
        
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch {
            print("--> Parsing error \(error.localizedDescription)")
            return []
        }
    }
}

struct Response : Codable {
    let resultCount : Int
    let movies : [Movie]
    
    enum CodingKeys : String , CodingKey {
        case resultCount
        case movies = "results"
    }
}

struct Movie : Codable {
    let title : String
    let director : String
    let thumnailPath : String
    let previewURL : String // 맛보기 URL 로 보여줄 예정
    
    
    enum CodingKeys : String , CodingKey { // A type that can be used as a key for encoding and decoding.
        case title = "trackName"
        case director = "artistName"
        case thumnailPath = "artworkUrl100"
        case previewURL = "previewUrl" // api상에서의 변수명을 우리가 원하는 객체 프로퍼티 형태로 바꾸기 위함
        
    }
}

