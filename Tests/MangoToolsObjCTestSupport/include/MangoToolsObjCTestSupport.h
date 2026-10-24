#ifndef MANGO_TOOLS_OBJC_TEST_SUPPORT_H
#define MANGO_TOOLS_OBJC_TEST_SUPPORT_H
#include <stdbool.h>

bool MangoToolsStringUtilitiesWork(void);
bool MangoToolsDateUtilitiesWork(void);
bool MangoToolsAttributedStringUtilitiesWork(void);
bool MangoToolsViewUtilitiesWork(void);
bool MangoToolsScopeUtilitiesWork(void);


bool MangoToolsStringBoundariesWork(void);
bool MangoToolsURLSchemesWork(void);
bool MangoToolsDateBoundariesWork(void);
bool MangoToolsAttributedSubrangesWork(void);
bool MangoToolsAttributedDefaultsWork(void);
bool MangoToolsBorderGeometryWorks(void);
bool MangoToolsAnchorPointPreservesOrigin(void);
bool MangoToolsGestureReplacementWorks(void);
bool MangoToolsLabelBoundariesWork(void);
bool MangoToolsImageRenderingWorks(void);
bool MangoToolsScopeExitOrderWorks(void);

#endif
