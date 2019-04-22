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
    static let aluWriteBackOnCorrect = "aluWriteBackOnCorrect"
}

struct CorrectnessMapKeys {
    //MARK: - IF Correctness Map Keys
    static let ifMuxToPc = "ifMuxToPc"
    static let ifPcToAlu = "ifPcToAlu"
    static let ifPcToIm = "ifPcToIm"
    static let ifFourToAlu = "ifFourToAlu"
    static let ifAluToMux = "ifAluToMux"
    static let ifImToId = "ifImToId"
    static let ifAluToId = "ifAluToId"
    
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
    
    //MARK: - WB Correctness Map Keys
    static let wbMemReadDataToMux = "wbMemReadDataToMux"
    static let wbMemAddressToMux = "wbMemAddressToMux"
    static let wbMuxToIfWriteData = "wbMuxToIfWriteData"
    static let wbMemToIfWriteAddress = "wbMemtoIfWriteAddress"
}

struct TouchPointNames {
    //MARK: - IF Touch Point Names
    static let ifMuxToPcStart = "ifMuxToPcStart"
    static let ifPcToAluStart = "ifPcToAluStart"
    static let ifMuxToPcEnd = "ifMuxToPcEnd"
    static let ifPcToAluEnd = "ifPcToAluEnd"
    static let ifPcToImEnd = "ifPcToImEnd"
    static let ifFourToAluStart = "ifFourToAluStart"
    static let ifFourToAluEnd = "ifFourToAluEnd"
    static let ifAluToMuxStart = "ifAluToMuxStart"
    static let ifAluToMuxEnd = "ifAluToMuxEnd"
    static let ifImToIdStart = "ifImToIdStart"
    static let ifImToIdEnd = "ifImToIdEnd"
    static let ifAluToIdEnd = "ifAluToIdEnd"
    
    //MARK: - ID Touch Point Names
    static let idExcecuteToWriteDataEnd = "idExcecuteToWriteDataEnd"
    static let idFetchToReadAddress1End = "idFetchToReadAddress1End"
    static let idFetchToReadAddress2End = "idFetchToReadAddress2End"
    static let idFetchToMux0End = "idFetchToMux0End"
    static let idFetchToMux1End = "idFetchToMux1End"
    static let idFetchToSignExtendEnd = "idFetchToSignExtendEnd"
    static let idMuxToWriteAddressStart = "idMuxToWriteAddressStart"
    static let idMuxToWriteAddressEnd = "idMuxToWriteAddressEnd"
    static let idReadData1ToExStart = "idReadData1ToExStart"
    static let idReadData2ToExStart = "idReadData2ToExStart"
    static let idSignExtendToExecuteStart = "idSignExtendToExecuteStart"
    
    //MARK: - WB Touch Point Names
    static let wbMemReadDataToMuxStart = "wbMemReadDataToMuxStart"
    static let wbMemReadDataToMuxEnd = "wbMemReadDataToMuxEnd"
    static let wbMemAddressToMuxStart = "wbMemAddressToMuxStart"
    static let wbMemAddressToMuxEnd = "wbMemAddressToMuxEnd"
    static let wbMuxToIfWriteDataStart = "wbMuxToIfWriteDataStart"
    static let wbMuxToIfWriteDataEnd = "wbMuxToIfWriteDataEnd"
    static let wbMemToIfWriteAddressStart = "wbMemToIfWriteAddressStart"
    static let wbMemToIfWriteAddressEnd = "wbMemToIfWriteAddressEnd"
}
