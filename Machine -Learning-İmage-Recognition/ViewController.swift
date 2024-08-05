import UIKit
import PhotosUI
import CoreML
import Vision

class ViewController: UIViewController, PHPickerViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var translatedLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    var chosenImage = CIImage()
    
    override func viewDidLoad() {
        
        
       
        
        resultLabel.numberOfLines = 0
        resultLabel.lineBreakMode = .byWordWrapping
        
        translatedLabel.numberOfLines = 0
        translatedLabel.lineBreakMode = .byWordWrapping
        
        
        super.viewDidLoad()
        print("View did load")
        
        // Hata ayıklama mesajları
        if changeButton == nil {
            print("changeButton is nil")
        }
        if imageView == nil {
            print("imageView is nil")
        }
        if resultLabel == nil {
            print("resultLabel is nil")
        }
        if translatedLabel == nil {
            print("translatedLabel is nil")
        }
    }

    @IBAction func changeClicked(_ sender: Any) {
        print("Change button clicked")
        
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
   
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("Did finish picking")
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else {
            print("No result found")
            return
        }
        
        let itemProvider = result.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.imageView.image = image
                        if let ciImage = CIImage(image: image) {
                            self?.chosenImage = ciImage
                            self?.recognizeImage(image: ciImage)
                        }
                    }
                }
            }
        } else {
            print("Cannot load object of class UIImage")
        }
    }

    func recognizeImage(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: MobileNetV2().model) else {
            print("Error loading model")
            return
        }
        
        let request = VNCoreMLRequest(model: model) { [weak self] vnrequest, error in
            if let result = vnrequest.results as? [VNClassificationObservation],
               let topResult = result.first {
                DispatchQueue.main.async {
                    let confidenceLevel = (topResult.confidence) * 100
                    let rounded = Int(confidenceLevel * 100) / 100
                    let identifier = topResult.identifier
                    self?.resultLabel.text = "\(rounded)% it's \(identifier)"
                    self?.translate(text: identifier)
                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print("Error performing request: \(error)")
            }
        }
    }
    
    func translate(text: String) {
        let headers = [
            "x-rapidapi-key": "2b377c5311msh5167a0b402e0210p127dabjsn69aae958db97",
            "x-rapidapi-host": "google-translate113.p.rapidapi.com",
            "Content-Type": "application/json"
        ]

        let parameters: [String: Any] = [
            "from": "en",
            "to": "tr",
            "json": ["text": text]
        ]
        
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error serializing JSON")
            return
        }

        let url = URL(string: "https://google-translate113.p.rapidapi.com/api/v1/translator/json")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let trans = json["trans"] as? [String: Any],
                   let translatedText = trans["text"] as? String {
                    DispatchQueue.main.async {
                        self?.translatedLabel.text = translatedText
                    }
                } else {
                    print("Unexpected JSON format: \(String(describing: String(data: data, encoding: .utf8)))")
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }

        dataTask.resume()
    }
}
