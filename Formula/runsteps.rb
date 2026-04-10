class Runsteps < Formula
  desc "Interactive config-driven task runner"
  homepage "https://runsteps.silafood.app"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.5/runsteps-aarch64-apple-darwin.tar.xz"
      sha256 "140398339400d17eae3d28c9af13b7a636aebc41bfa69725bf53c52d79974a0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.5/runsteps-x86_64-apple-darwin.tar.xz"
      sha256 "91c152b2c9378805c946e723c54a7907e546d8f5e5323403a5602aa1bcd88a37"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.5/runsteps-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2b4f0b5f51fe4c4a9e671667b2f3f11b4026c609427f661974717591a0a0ef02"
    end
    if Hardware::CPU.intel?
      url "https://github.com/silafood/runsteps/releases/download/v0.1.5/runsteps-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a26479705d96003e269a0f28d7bc99f001f796bec06de6d370bc73a4d3778dc"
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
