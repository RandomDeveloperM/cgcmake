set(3DSMAX_VERSION "2015" CACHE STRING "3ds max version")
set(3DSMAX_VERSIONS "2009;2010;2011;2012;2013;2014;2015")
set_property(CACHE 3DSMAX_VERSION PROPERTY STRINGS ${3DSMAX_VERSIONS})

set(3DSMAX_ROOT "C:/Program Files/Autodesk/3ds Max ${3DSMAX_VERSION}" CACHE STRING "3ds max install root")
set(3DSMAX_PLUGIN_PATH "${3DSMAX_ROOT}/plugins" CACHE STRING "3ds max plugins path")

set(3DSMAX_${3DSMAX_VERSION}_PLUGIN_PATH ${3DSMAX_PLUGIN_PATH})

if(WITH_CUSTOM_3DSMAX)
	set(3DSMAX_INCPATH ${WITH_3DSMAX_INCPATH})
	set(3DSMAX_LIBPATH ${WITH_3DSMAX_LIBPATH})
else()
	set(3DSMAX_INCPATH
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/include
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/mentalray/include
		# We've relocated mentalray includes - this fixes relative paths in some headers
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/include/mentalray
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/include/mentalray/shared_src
	)

	set(3DSMAX_LIBPATH
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/${ARCH}/lib
		${SDK_ROOT}/3dsmax/${3DSMAX_VERSION}/mentalray/lib/${ARCH}
	)
endif()

set(3DSMAX_DEFINITIONS
	-D_LIB
	-D_WINDLL
	-D_WIN32
)

if(3DSMAX_VERSION GREATER 2012)
	list(APPEND 3DSMAX_DEFINITIONS
		-DUNICODE
		-D_UNICODE
		-Dend_pb=p_end
	)
else()
	list(APPEND 3DSMAX_DEFINITIONS
		-D_MBCS
		-Dend_pb=end
	)
endif()

if(3DSMAX_VERSION STREQUAL 2009)
	set(MSVC_COMPILER 2005)
elseif(3DSMAX_VERSION STREQUAL 2010)
	set(MSVC_COMPILER 2008)
elseif(3DSMAX_VERSION STREQUAL 2011)
	set(MSVC_COMPILER 2008)
elseif(3DSMAX_VERSION STREQUAL 2012)
	set(MSVC_COMPILER 2008)
elseif(3DSMAX_VERSION STREQUAL 2013)
	set(MSVC_COMPILER 2010)
elseif(3DSMAX_VERSION STREQUAL 2014)
	set(MSVC_COMPILER 2010)
elseif(3DSMAX_VERSION STREQUAL 2018)
	set(MSVC_COMPILER 2015)
else()
	set(MSVC_COMPILER 2012)
endif()

if(3DSMAX_VERSION VERSION_GREATER 2008)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2009)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2009)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2010)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2010)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2011)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2011)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2012)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2012)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2013)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2013)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2014)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2014)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2015)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2015)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2016)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2016)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2017)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2017)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2018)
endif()
if(3DSMAX_VERSION VERSION_GREATER 2018)
	list(APPEND 3DSMAX_DEFINITIONS -DMAX2019)
endif()

set(3DSMAX_LIBS
	bmm
	gfx
	mesh
	maxutil
	maxscrpt
	paramblk2
	core
	geom
)

if(3DSMAX_VERSION GREATER 2009)
	list(APPEND 3DSMAX_LIBS
		assetmanagement
	)
endif()

if(3DSMAX_VERSION GREATER 2011)
	list(APPEND 3DSMAX_LIBS
		GraphicsDriver
		DataBridge
	)
endif()

if(3DSMAX_VERSION VERSION_LESS 2011)
	set(MENTALRAY_SHADER_PATH "${3DSMAX_ROOT}/mentalray/shaders_autoload/shaders")
	set(MENTALRAY_MI_PATH     "${3DSMAX_ROOT}/mentalray/shaders_autoload/include")
elseif(3DSMAX_VERSION VERSION_LESS 2013)
	set(MENTALRAY_SHADER_PATH "${3DSMAX_ROOT}/mentalimages/shaders_autoload/mentalray/shaders")
	set(MENTALRAY_MI_PATH     "${3DSMAX_ROOT}/mentalimages/shaders_autoload/mentalray/include")
else()
	set(MENTALRAY_SHADER_PATH "${3DSMAX_ROOT}/Plugins/NVIDIA/Shaders/shaders_autoload/mentalray/shaders")
	set(MENTALRAY_MI_PATH     "${3DSMAX_ROOT}/Plugins/NVIDIA/Shaders/shaders_autoload/mentalray/include")
endif()

file(TO_CMAKE_PATH "${MENTALRAY_SHADER_PATH}" MENTALRAY_SHADER_PATH)
file(TO_CMAKE_PATH "${MENTALRAY_MI_PATH}" MENTALRAY_MI_PATH)
file(TO_CMAKE_PATH "${3DSMAX_INCPATH}" 3DSMAX_INCPATH)
file(TO_CMAKE_PATH "${3DSMAX_LIBPATH}" 3DSMAX_LIBPATH)

# NOTE: This must be called before project().
link_directories(${3DSMAX_LIBPATH})

macro(link_with_3dsmax _target _suffix)
	message_array("Using 3dsmax SDK include path" 3DSMAX_INCPATH)
	message_array("Using 3dsmax SDK library path" 3DSMAX_LIBPATH)

	message(STATUS "MentalRay install path: ${MENTALRAY_MI_PATH}")

	set_target_properties(${_target} PROPERTIES SUFFIX ${_suffix})

	target_include_directories(${_target} PRIVATE ${3DSMAX_INCPATH})
	target_compile_definitions(${_target} PRIVATE ${3DSMAX_DEFINITIONS})

	target_link_libraries(${_target} ${3DSMAX_LIBS})
endmacro()
