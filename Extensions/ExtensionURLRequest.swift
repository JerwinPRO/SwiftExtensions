extension URLRequest {

    func bodySteamAsJSON() -> Any? {

        guard let bodyStream = self.httpBodyStream else { return nil }

        bodyStream.open()

        // Will read 16 chars per iteration. Can use bigger buffer if needed
        let bufferSize: Int = 16

        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)

        var dat = Data()

        while bodyStream.hasBytesAvailable {

            let readDat = bodyStream.read(buffer, maxLength: bufferSize)
            dat.append(buffer, count: readDat)
        }

        buffer.deallocate()

        bodyStream.close()

        do {
            return try JSONSerialization.jsonObject(with: dat, options: JSONSerialization.ReadingOptions.allowFragments)
        } catch {

            print(error.localizedDescription)

            return nil
        }
    }
}