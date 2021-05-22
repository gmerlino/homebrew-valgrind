# typed: false
# frozen_string_literal: true

class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "http://www.valgrind.org/"

  head do
    url "https://github.com/Echelon9/valgrind.git", branch: "feature/v3.14/macos-mojave-support-v2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Valgrind needs vcpreload_core-*-darwin.so to have execute permissions.
  # See #2150 for more information.
  skip_clean "lib/valgrind"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    #    args << "--enable-only64bit" << "--build=amd64-darwin"
    args << "--enable-only64bit"

    system "./autogen.sh" if build.head?

    # Look for headers in the SDK on Xcode-only systems: https://bugs.kde.org/show_bug.cgi?id=295084
    #    unless MacOS::CLT.installed?
    inreplace "coregrind/Makefile.in", %r{(\s)(?=/usr/include/mach/)}, "\\1#{MacOS.sdk_path}"
    #    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/valgrind", "ls", "-l"
  end
end
