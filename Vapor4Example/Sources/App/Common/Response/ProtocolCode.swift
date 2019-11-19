enum ProtocolCode: Int, Codable {
    case unknown = 0
    
    case success = 200
    
    case failParamError = 400
    case failTokenInvalid = 401
    
    case failInternalError = 500
    
    case failSignIn = 10000
    case failAccountHasExisted = 10001
    case failAccountNoExisted = 10002
    
    func getMsg() -> String {
        return "\(self)"
    }
    
    func getCode() -> Int {
        return self.rawValue
    }
    
}

