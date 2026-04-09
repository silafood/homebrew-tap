class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://runsteps.silafood.app"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.1/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "d09fe672ad9ff70477a52f7b172f4371652888d2c622734121173607384cba5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.1/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "a4b412faec0c7314207a4873be2e1c48fb7a7348fe2aa96d99d1e3fc4dc187a9"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.1/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c6ea57c8276b58327d5bd46f79f0e3db37ed37ab1ca11333f6116efa6dbe5ba"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.1/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a5efeefe6d686d293ab1b920688ad4fd70cc9617420ff769d6d93242734226b"
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
