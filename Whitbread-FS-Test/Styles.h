//
//  Styles.h
//  Whitbread-FS-Test
//
//  Created by Freddie on 01/04/2016.
//  Copyright © 2016 Freddie. All rights reserved.
//
#define RGB(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]

#define STYLE_COLOUR RGB(19.0, 146.0, 178.0)
#define STYLE_COLOUR_TRANS(x) RGBA(19.0, 146.0, 178.0, x)

#define MODAL_BG_COLOUR [UIColor colorWithWhite:0.2 alpha:0.7]

#define PRIMARY_FONT_FAMILY (@"HelveticaNeue")
#define PRIMARY_FONT_FAMILY_BOLD (@"HelveticaNeue-CondensedBold")