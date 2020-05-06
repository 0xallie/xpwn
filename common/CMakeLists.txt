add_library(common abstractfile.c base64.c)
set_property(TARGET common PROPERTY POSITION_INDEPENDENT_CODE ON)
