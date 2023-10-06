#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "background-img" asset catalog image resource.
static NSString * const ACImageNameBackgroundImg AC_SWIFT_PRIVATE = @"background-img";

/// The "blue-dollar" asset catalog image resource.
static NSString * const ACImageNameBlueDollar AC_SWIFT_PRIVATE = @"blue-dollar";

/// The "buy-img" asset catalog image resource.
static NSString * const ACImageNameBuyImg AC_SWIFT_PRIVATE = @"buy-img";

/// The "ccl-dollar" asset catalog image resource.
static NSString * const ACImageNameCclDollar AC_SWIFT_PRIVATE = @"ccl-dollar";

/// The "crypto-dollar" asset catalog image resource.
static NSString * const ACImageNameCryptoDollar AC_SWIFT_PRIVATE = @"crypto-dollar";

/// The "mep-dollar" asset catalog image resource.
static NSString * const ACImageNameMepDollar AC_SWIFT_PRIVATE = @"mep-dollar";

/// The "oficial-dollar" asset catalog image resource.
static NSString * const ACImageNameOficialDollar AC_SWIFT_PRIVATE = @"oficial-dollar";

/// The "sale" asset catalog image resource.
static NSString * const ACImageNameSale AC_SWIFT_PRIVATE = @"sale";

/// The "sell-3" asset catalog image resource.
static NSString * const ACImageNameSell3 AC_SWIFT_PRIVATE = @"sell-3";

/// The "sell-img" asset catalog image resource.
static NSString * const ACImageNameSellImg AC_SWIFT_PRIVATE = @"sell-img";

/// The "solidario-dollar" asset catalog image resource.
static NSString * const ACImageNameSolidarioDollar AC_SWIFT_PRIVATE = @"solidario-dollar";

#undef AC_SWIFT_PRIVATE