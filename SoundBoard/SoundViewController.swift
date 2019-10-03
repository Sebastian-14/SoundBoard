//
//  SoundViewController.swift
//  SoundBoard
//
//  Created by Sebastian on 10/3/19.
//  Copyright © 2019 Sebastian. All rights reserved.
//

import UIKit
import AVFoundation

class SoundViewController: UIViewController {

    //Outlet
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    var audioRecoder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    var audioURL : URL?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
        playButton.isEnabled = false
        addButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func setupRecorder(){
        do{
            // Creando una sesión de audio
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSession.Category.playAndRecord)
            try session.overrideOutputAudioPort(.speaker)
            try session.setActive(true)
            
            // Creando una dirección para el archivo de audio
            let basePath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            /*
            print("*****************")
            print(audioURL)
            print("*****************")
            */
            
            // Crear opciones par grabar el audio
            var settings : [String:AnyObject] = [:]
            settings[AVFormatIDKey]  = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            // Crear el objeto de grabación de audio
            audioRecoder = try AVAudioRecorder(url:audioURL!, settings: settings)
            audioRecoder!.prepareToRecord()
            
        }catch let error as NSError {
            print(error)
        }
    }
    

    
    
    //Action
    
    @IBAction func recordTapped(_ sender: Any) {
        if audioRecoder!.isRecording{
            //Detener grabación
            audioRecoder?.stop()
            //Cambiar el texto del botón grabar
            recordButton.setTitle("Record", for: .normal)
            playButton.isEnabled = true
            addButton.isEnabled = true
        }else{
            //empezar a grabar
            audioRecoder?.record()
            //Cambiar el título del botón detener
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    
    @IBAction func playTapped(_ sender: Any) {
        do{
            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
            audioPlayer!.play()
        }catch{
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sound = Sound(context: context)
        sound.name = nameTextField.text
        sound.audio = NSData(contentsOf: audioURL!) as Data?
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
