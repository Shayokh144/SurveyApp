//
//  ImageDownloadManager.swift
//  SurveyApp
//
//  Created by Asif on 21/3/22.
//

import Foundation

final class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    
    private var cachedImages: [String: Data]
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    
    let serialQueueForImages = DispatchQueue(label: "images.queue", attributes: .concurrent)
    let serialQueueForDataTasks = DispatchQueue(label: "dataTasks.queue", attributes: .concurrent)
    
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
        //print("ImageDownloadManager called")
    }
    
    func downloadImage(with imageUrlString: String?,
                       completionHandler: @escaping (Data?, Bool, String?) -> Void){
        
        guard let imageUrlString = imageUrlString else {
            completionHandler(nil, false, imageUrlString)
            return
        }
        
        if let image = getCachedImageFrom(urlString: imageUrlString) {
            completionHandler(image, true, imageUrlString)
        } else {
            guard let url = URL(string: imageUrlString + "l") else {
                completionHandler(nil, true, imageUrlString)
                return
            }
            
            if let _ = getDataTaskFrom(urlString: imageUrlString) {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    return
                }
                
                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(nil, true, imageUrlString)
                    }
                    return
                }
                
                self.serialQueueForImages.sync(flags: .barrier) {
                    self.cachedImages[imageUrlString] = data
                }
                
                _ = self.serialQueueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrlString)
                }
                
                DispatchQueue.main.async {
                    completionHandler(data, false, imageUrlString)
                }
            }
            
            self.serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks[imageUrlString] = task
            }
            
            task.resume()
        }
    }
    
    private func cancelPreviousTask(with urlString: String?) {
        if let urlString = urlString, let task = getDataTaskFrom(urlString: urlString) {
            task.cancel()
            _ = serialQueueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks.removeValue(forKey: urlString)
            }
        }
    }
    
    private func getCachedImageFrom(urlString: String) -> Data? {
        serialQueueForImages.sync {
            return cachedImages[urlString]
        }
    }
    
    private func getDataTaskFrom(urlString: String) -> URLSessionTask? {
        serialQueueForDataTasks.sync {
            return imagesDownloadTasks[urlString]
        }
    }
}
