//
//  WaveformView.swift
//  storyboard-editor-front
//
//  Created by José Puma on 25-02-24.
//
import SwiftUI
import AVFoundation

class WaveformView {
    
    public var valuesFft : [CGPoint] = []
    private var audioURL: URL
    private var waveWidth: CGFloat = 1
    private var waveSpacing: CGFloat
    
    init(audioURL: URL, waveWidth: CGFloat = 1, waveSpacing: CGFloat = 2) {
        self.audioURL = audioURL
        self.waveWidth = waveWidth
        self.waveSpacing = waveSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getPoints() -> [CGPoint]{
        return self.valuesFft
    }

    func generateWaveImage(
                           waveWidth: CGFloat = 1,      // Width of each wave
                           waveSpacing: CGFloat = 2) -> [CGPoint] {
           let samples = readBuffer(self.audioURL)
          if samples.isEmpty {
               return []
           }
           let middleY = 240.0
           
           let maxAmplitude = samples.max() ?? 0
           let heightNormalizationFactor = Float(480) / maxAmplitude / 2
           
           var x: CGFloat = 0.0
           let samplesCount = samples.count
           let sizeWidth = 854
           var index = 0
           var sampleAtIndex = samples.item(at: index * samplesCount / sizeWidth)
        /*readBuffer(audioUrl) { samples in
            guard let samples = samples else {
                completion([])
                return
            }
            
            autoreleasepool {
                   
                let middleY = 240.0
                
                //context.setFillColor(backgroundColor.cgColor)
                //context.setAlpha(1.0)
                //context.fill(CGRect(origin: .zero, size: imageSize))
                //context.setLineWidth(waveWidth)
                //context.setLineJoin(.round)
                //context.setLineCap(.round)
                
                let maxAmplitude = samples.max() ?? 0
                let heightNormalizationFactor = Float(480) / maxAmplitude / 2
                
                var x: CGFloat = 0.0
                let samplesCount = samples.count
                let sizeWidth = 854
                var index = 0
                var sampleAtIndex = samples.item(at: index * samplesCount / sizeWidth)
                //let chunked = Array(samples).chunked(into: samples.count / samplesCount)
                
                /*for row in chunked {
                    print("for?")
                    var accumulator: Float = 0
                    let newRow = row.map{ $0 * $0 }
                    accumulator = newRow.reduce(0, +)
                    let power: Float = accumulator / Float(row.count)
                    let decibles = 10 * log10f(power)
                    
                    //print(x, decibles)
                    x += waveSpacing + waveWidth
                    index += 1
                }*/
                while sampleAtIndex != nil {
                    
                    sampleAtIndex = samples.item(at: index * samplesCount / sizeWidth)
                    
                    let normalizedSample = CGFloat(sampleAtIndex ?? 0) * CGFloat(heightNormalizationFactor)
                    let waveHeight = normalizedSample * middleY

                    //context.move(to: CGPoint(x: x, y: middleY - waveHeight))
                    //context.addLine(to: CGPoint(x: x, y: middleY + waveHeight))
                    let startY = middleY - waveHeight
                    let endY = middleY + waveHeight
                    
                    let decibles = 10 * log10f(Float(waveHeight))
                    
                    //print(x, decibles.isNaN || decibles.isInfinite ? 5 : decibles)
                    self.valuesFft.append(CGPoint(x: x, y: CGFloat(decibles.isNaN || decibles.isInfinite ? 5.0 : decibles)))
                    x += waveSpacing + waveWidth
                    
                    index += 1
                }
                completion(self.valuesFft)
                    
                
            }
        }*/
        return self.valuesFft
    }
    
    private func readBuffer(_ audioUrl: URL) -> UnsafeBufferPointer<Float> {
           let file = try? AVAudioFile(forReading: audioUrl)
           let audioFormat = file!.processingFormat
           let audioFrameCount = UInt32(file!.length)
           guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
           else { return UnsafeBufferPointer<Float>(_empty: ()) }
           do {
               try file!.read(into: buffer)
               let floatArray = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
               return floatArray
           } catch {
               print(error)
           }
       
        return UnsafeBufferPointer<Float>(_empty: ())
    }

    /*private func readBuffer(_ audioUrl: URL,completion:@escaping (_ wave:UnsafeBufferPointer<Float>?)->Void) {
        DispatchQueue.global(qos: .utility).async {
               guard let file = try? AVAudioFile(forReading: audioUrl) else {
                   completion(nil)
                   return
               }
               let audioFormat = file.processingFormat
               let audioFrameCount = UInt32(file.length)
               guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
               else { return completion(UnsafeBufferPointer<Float>(_empty: ())) }
               do {
                   try file.read(into: buffer)
               } catch {
                   print(error)
               }
               
               let floatArray = UnsafeBufferPointer(start: buffer.floatChannelData![0], count: Int(buffer.frameLength))
               
               DispatchQueue.main.sync {
                   completion(floatArray)
               }
           }
    }*/
}

extension UnsafeBufferPointer {
    func item(at index: Int) -> Element? {
        if index >= self.count {
            return nil
        }
        
        return self[index]
    }
}
