# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="Assembly statistics (min, max, sum, N50, N90, count gaps and Ns)"
HOMEPAGE="https://github.com/martinghunt/assembly-stats"
EGIT_REPO_URI="https://github.com/martinghunt/assembly-stats.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-cpp/gtest-1.7.0"
RDEPEND="${DEPEND}"

# TODO: should not even try to compile bundled gtest
src_prepare(){
	eapply_user
	sed -e "s#/usr/local/bin#${EPREFIX}/usr/bin#" -i CMakeLists.txt || die
}

src_install(){
	default
	mv "${D}"/usr/bin/assembly-stats "${D}"/"${EPREFIX}"/usr/bin/ || die
	rmdir "${D}"/usr/bin || die
}
