# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_STANDARD=90
PYTHON_COMPAT=python2_7
inherit eutils cmake-utils versionator python-single-r1

MAJOR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Utilities for processing and plotting neutron scattering data"
HOMEPAGE="http://www.mantidproject.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${MAJOR_PV}/${P}-Source.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc opencl paraview shared-libs tcmalloc test"
RESTRICT="test" # Testing requires sample data and X11 access

RDEPEND="
	${PYTHON_DEPS}
	>=sci-libs/nexus-4.2[${PYTHON_USEDEP}]
	>=dev-libs/poco-1.4.2
	dev-libs/boost[python,${PYTHON_USEDEP}]
	opencl?		( virtual/opencl )
	tcmalloc?	( dev-util/google-perftools )
	paraview?	( >=sci-visualization/paraview-4[python,${PYTHON_USEDEP}] )
	virtual/opengl
	dev-qt/qthelp
	x11-libs/qscintilla
	x11-libs/qwt:5
	x11-libs/qwtplot3d
	dev-python/PyQt4[${PYTHON_USEDEP}]
	sci-libs/gsl
	dev-python/ipython[qt4,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-cpp/muParser
	dev-libs/jsoncpp
	dev-libs/openssl
	sci-libs/opencascade[qt4]
"

DEPEND="${RDEPEND}
	dev-python/sphinx
	doc?	( app-doc/doxygen[dot]
		  dev-python/sphinx[${PYTHON_USEDEP}]
		  dev-python/sphinx-bootstrap-theme[${PYTHON_USEDEP}] )
	test?	( dev-util/cppcheck )
"

S="${WORKDIR}/${P}-Source"

src_prepare() {
	epatch	"${FILESDIR}/${P}-FindOpenCascade.patch" \
		"${FILESDIR}/${P}-minigzip-OF.patch"
}

src_configure() {
	export CPPFLAGS="-DHAVE_IOSTREAM -DHAVE_LIMITS -DHAVE_IOMANIP ${CPPFLAGS}"
	mycmakeargs=(	$(cmake-utils_use_enable doc QTASSISTANT)
			$(cmake-utils_use_use doc DOT)
			$(cmake-utils_use opencl OPENCL_BUILD)
			$(cmake-utils_use_build shared-libs SHARED_LIBS)
			$(cmake-utils_use_use tcmalloc TCMALLOC)
			$(cmake-utils_use paraview MAKE_VATES)
			$(cmake-utils_use_build test TESTING)
		)
	cmake-utils_src_configure
}

src_test() {
	# Tests are not built by default
	emake AllTests
	cmake-utils_src_test
}
