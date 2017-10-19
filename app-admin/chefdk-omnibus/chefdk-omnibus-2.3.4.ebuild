# Blatently stolen from https://github.com/lxmx/gentoo-overlay

EAPI="4"

DESCRIPTION="Omnibus installation of ChefDK"
HOMEPAGE="http://www.opscode.com/chefdk/install/"
#SRC_URI="https://packages.chef.io/stable/ubuntu/12.04/chefdk_${PV}-1_amd64.deb"
SRC_URI="https://packages.chef.io/files/stable/chefdk/${PV}/ubuntu/16.04/chefdk_${PV}-1_amd64.deb"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
  unpack ${A} ./data.tar.gz
}

src_install() {

  local dest="${D}/opt"
  mkdir -p "$dest"

  # cleanup .git folders, any idea why they are in the package?
  find "$dest" -type d -name ".git" | xargs  rm -rf

  cp -pR ./opt/* "$dest"

  # link executables
  binaries="berks chef chef-apply chef-shell chef-solo chef-zero delivery fauxhai foodcritic kitchen knife ohai push-apply pushy-client pushy-service-manager rubocop cookstyle chef-client chef-vault print_execution_environment inspec dco"
  for binary in $binaries; do
    dosym "$dest/chefdk/bin/$binary" "/usr/bin/$binary" || die "Cannot link $binary to /usr/bin"
  done

}
