/*
 * Created by Ubique Innovation AG
 * https://www.ubique.ch
 * Copyright (c) 2020. All rights reserved.
 */

import UIKit

extension UIColor {
    // primary color
    public static var ns_primary = UIColor(ub_hexString: "#F05300")!
    public static var ns_secondary = UIColor(ub_hexString: "#535353")!

    // background of views
    public static var ns_background = UIColor.white
    public static var ns_background_secondary = UIColor(ub_hexString: "#f7f7f7")!
    public static var ns_background_highlighted = UIColor(ub_hexString: "#f9f9f9")!

    // text color
    public static var ns_text = UIColor(ub_hexString: "#535263")!
    public static var ns_text_secondary = UIColor(ub_hexString: "#e6e6e6")!

    public static var ns_error = UIColor(ub_hexString: "#ff6584")!

    public static var ns_light_gray = UIColor(ub_hexString: "#707070")!
    public static var ns_lighter_gray = UIColor(ub_hexString: "#B4B4B4")!
    public static var ns_gray = UIColor(ub_hexString: "#D8D8D8")
    public static var ns_black = UIColor(ub_hexString: "#1C1C1C")

    public static var ns_orange = UIColor(ub_hexString: "#FF7300")

    public static var homescreen_text = UIColor(ub_hexString: "#1c1c1c")!
    public static var homescreen_green_background = UIColor(ub_hexString: "0B8875")!.withAlphaComponent(0.1)
    public static var homescreen_error_background = UIColor(ub_hexString: "A5365D")!
    public static var homescreen_title_circle = UIColor(ub_hexString: "6CFF72")!
}
