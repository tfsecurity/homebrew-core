class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://github.com/istio/istio"
  url "https://github.com/istio/istio.git",
      :tag      => "1.6.2",
      :revision => "70f86ede30e826dd18542e95d856255e9780a24f"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "6bfe45d629c898f4957d8c73cae1c0ac64c71084d83748933548cde141684b4c" => :catalina
    sha256 "6bfe45d629c898f4957d8c73cae1c0ac64c71084d83748933548cde141684b4c" => :mojave
    sha256 "6bfe45d629c898f4957d8c73cae1c0ac64c71084d83748933548cde141684b4c" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TAG"] = version.to_s
    ENV["ISTIO_VERSION"] = version.to_s
    ENV["HUB"] = "docker.io/istio"
    ENV["BUILD_WITH_CONTAINER"] = "0"

    srcpath = buildpath/"src/istio.io/istio"
    outpath = srcpath/"out/darwin_amd64"
    srcpath.install buildpath.children

    cd srcpath do
      system "make", "gen-charts", "istioctl", "istioctl.completion"
      prefix.install_metafiles
      bin.install outpath/"istioctl"
      bash_completion.install outpath/"release/istioctl.bash"
      zsh_completion.install outpath/"release/_istioctl"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/istioctl version --remote=false")
  end
end
