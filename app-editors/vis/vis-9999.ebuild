# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
EGIT_REPO_URI="https://github.com/martanne/vis.git"
LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="+ncurses selinux test tre"
RESTRICT="!test? ( test )"

# - Known to also work with NetBSD curses
# - ::lua package done for using >=dev-lang/lua-5.2
# which is needed for syntax highlighting and settings but masked in ::gentoo
DEPEND="dev-libs/libtermkey
	ncurses? ( sys-libs/ncurses:0= )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

src_prepare() {
	sed -i 's|STRIP?=.*|STRIP=true|' Makefile || die
	sed -i 's|${DOCPREFIX}/vis|${DOCPREFIX}|' Makefile || die
	sed -i 's|DOCUMENTATION = LICENSE|DOCUMENTATION =|' Makefile || die

	default
}

src_configure() {
	./configure \
		--prefix="${EPREFIX}"/usr \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre) || die
}

update_symlinks() {
	einfo "Calling eselect vi update --if-unset"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
}
