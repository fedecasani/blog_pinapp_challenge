import Foundation

class CommentService {
    static func fetchComments(for postId: Int, completion: @escaping ([[String: Any]]?, Error?) -> Void) {
        let urlString = "https://jsonplaceholder.typicode.com/comments?postId=\(postId)"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "InvalidURL", code: 400, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "NoData", code: 404, userInfo: nil))
                return
            }

            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    completion(jsonArray, nil)
                } else {
                    completion(nil, NSError(domain: "InvalidJSON", code: 500, userInfo: nil))
                }
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
}
