//
//  Constants.swift
//  cs3339-proj-proto
//
//  Created by Connor Reid on 4/3/19.
//  Copyright © 2019 Connor Reid. All rights reserved.
//

import UIKit

struct LineAttributes {
    static let red: CGFloat = 0.0
    static let green: CGFloat = 0.0
    static let blue: CGFloat = 0.0
    static let alpha: CGFloat = 1.0
    static let brushWidth: CGFloat = 3.0
    static let opacity: CGFloat = 1.0
    static let lineCap: CGLineCap = CGLineCap.butt
    static let blendMode: CGBlendMode = CGBlendMode.normal
}

struct Events {
    static let aluFetchOnCorrect = "aluFetchOnCorrect"
}

struct CompleteKeys {
    static let ifComplete = "ifComplete"
}

struct CorrectnessMapKeys {
    //MARK: - IF Correctness Map Keys
    static let ifMuxToPc = "ifMuxToPc"
    static let ifPcToAlu = "ifPcToAlu"
    static let ifPcToIm = "ifPcToIm"
    static let ifFourToAlu = "ifFourToAlu"
    static let ifAluToMux = "ifAluToMux"
    
    //MARK: - ID Correctness Map Keys
    static let idFetchToReadAddress1 = "idFetchToReadAddress1"
    static let idFetchToReadAddress2 = "idFetchToReadAddress2"
    static let idFetchToMux1 = "idFetchToMux1"
    static let idFetchToMux0 = "idFetchToMux0"
    static let idMuxToWriteAddress = "idMuxToWriteAddress"
    static let idExecuteToWriteData = "idExecuteToWriteData"
    static let idFetchToSignExtend = "idFetchToSignExtend"
    static let idSignExtendToExecute = "idSignExtendToExecute"
    static let idReadData1ToExecute = "idReadData1ToExecute"
    static let idReadData2ToExecute = "idReadData2ToExecute"
}

struct TouchPointNames {
    static let ifMuxToPcStart = "ifMuxToPcStart"
    static let ifPcToAluStart = "ifPcToAluStart"
    static let ifMuxToPcEnd = "ifMuxToPcEnd"
    static let ifPcToAluEnd = "ifPcToAluEnd"
    static let ifPcToImEnd = "ifPcToImEnd"
    static let ifFourToAluStart = "ifFourToAluStart"
    static let ifFourToAluEnd = "ifFourToAluEnd"
    static let ifAluToMuxStart = "ifAluToMuxStart"
    static let ifAluToMuxEnd = "ifAluToMuxEnd"
}
