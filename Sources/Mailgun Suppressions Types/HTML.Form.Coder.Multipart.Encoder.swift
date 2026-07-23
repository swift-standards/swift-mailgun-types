import Foundation
import HTML_Form_Coder_Codable
import HTML_Standard
import RFC_2045
import RFC_2183
import RFC_7578

extension HTML.Form.Coder.Multipart.Encoder {
    static var csv: Self {
        Self(
            file: { value in
                guard let data = value as? Foundation.Data else { return nil }

                let filename: RFC_2183.Filename
                do throws(RFC_2183.Filename.Error) {
                    filename = try RFC_2183.Filename("import.csv")
                } catch {
                    return nil
                }

                do throws(RFC_7578.Form.Data.Error) {
                    return try RFC_7578.Form.Data.File(
                        fieldName: "file",
                        filename: filename,
                        contentType: RFC_2045.ContentType(
                            __unchecked: (),
                            type: "text",
                            subtype: "csv"
                        ),
                        content: [UInt8](data)
                    )
                } catch {
                    return nil
                }
            }
        )
    }
}
