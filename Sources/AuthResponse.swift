/**
 Copyright IBM Corporation 2016
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */
import Socket
import Foundation

public struct AuthResponse: Request {
    
    let token: Int
    public let flags: Byte
    public let identifier: UInt16

    public var description: String {
        return "Auth Response with token \(token)"
    }

    init(token: Int, flags: Byte = 0x00){
        self.flags = flags
        self.token = token
        
        identifier = UInt16(random: true)
    }
    
    public func write(writer: SocketWriter) throws {
        var body = Data(capacity: 32)
        var header = Data(capacity: 32)

        header.append(config.version)
        header.append(flags)
        header.append(identifier.bigEndian.data)
        header.append(Opcode.authResponse.rawValue.data)

        body.append(token.data)

        header.append(body.count.data)
        header.append(body)
        
        try writer.write(from: header)
    }
}
