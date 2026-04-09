class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://zeroows.github.io/runsteps"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/zeroows/runsteps/releases/download/v0.1.0/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "c063b00224dc4a43c67bb8c8ce3cae6f2dedf4cb0efe0d939bf0ceb062f86c0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zeroows/runsteps/releases/download/v0.1.0/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "4cc8981f12bba69690099bc73ea196ffed19998558e8cd693c1934afc1d9e44c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/zeroows/runsteps/releases/download/v0.1.0/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "46643ce5bfab4901a5b60616cc4d0d4eac89fb2ab4d9512c5aaed4a6d980e5cf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/zeroows/runsteps/releases/download/v0.1.0/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "48b5b2909fcf7a47219657e8f06ed594217294b37fddeb3b27d7c3d975352480"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "runsteps" if OS.mac? && Hardware::CPU.arm?
    bin.install "runsteps" if OS.mac? && Hardware::CPU.intel?
    bin.install "runsteps" if OS.linux? && Hardware::CPU.arm?
    bin.install "runsteps" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
