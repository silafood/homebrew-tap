class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://runsteps.silafood.app"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.3/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "2837ddd54e6e665fd837a4fa1c14e53bb02a9f3456798158525e0e113a7ef5fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.3/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "9c3820186911d73b10f424de3d717c24e210e94dc2261027234f488359539ee8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.3/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8662663063dfe6a05d538c8bf7d35747708280888c11b66bf22d23ce99e123cd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.3/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f2f8aee4b1ef752824e46d81679d50bea923131debfde7f92a76d4a4ce17a96e"
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
