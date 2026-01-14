# System Requirements & Installation Guide

While this configuration uses `mason.nvim` to automatically manage most Language Servers (LSP), some tools are better installed via system package managers due to complexity, dependencies, or system integration.

## Windows (Scoop)

### 1. Essential Tools
Ensure you have the `extras` and `nerd-fonts` buckets added to Scoop:
```powershell
scoop bucket add extras
scoop bucket add nerd-fonts
```

*   **Compiler (Required by Treesitter)**
    *   Command: `scoop install gcc`

*   **Git & Search Tools**
    *   Command: `scoop install git lazygit ripgrep fd`

*   **Fonts**
    *   Command: `scoop install JetBrainsMono-NF`

### 2. Language Servers (System Install)

*   **Dart / Flutter**
    *   LSP is part of the Flutter SDK.
    *   Command: `scoop install flutter`

*   **Rust (`rust_analyzer`)**
    *   Highly recommended to manage via `rustup` on Windows.
    *   Command: `scoop install rustup` then `rustup component add rust-analyzer`

*   **Swift / OCaml / Haskell**
    *   **Swift**: Install Swift for Windows (Official Installer).
    *   **Haskell**: `scoop install ghc` or use `ghcup`.
    *   **OCaml**: Recommended to use **WSL2** for OCaml development, as native Windows support is limited.

## macOS (Homebrew)

### 1. Essential (Mason may fail or is not recommended)

*   **Swift (`sourcekit-lsp`)**
    *   Included with **Xcode** or **Command Line Tools**.
    *   No extra installation needed if Xcode is set up.

*   **Haskell (`hls`)**
    *   Depends heavily on the GHC version.
    *   Command: `brew install haskell-language-server`
    *   Alternative: Use `ghcup`.

*   **OCaml (`ocamllsp`)**
    *   Requires OCaml environment.
    *   Command: `brew install opam` then `opam install ocaml-lsp-server`

*   **Dart / Flutter**
    *   LSP is part of the Flutter SDK.
    *   Command: `brew install --cask flutter`

### 2. Optional (Stable Alternatives to Mason)

*   **C/C++ (`clangd`)**
    *   System `clangd` often integrates better with macOS headers.
    *   Command: `brew install llvm`

*   **Rust (`rust_analyzer`)**
    *   Recommended to manage via `rustup`.
    *   Command: `rustup component add rust-analyzer`

## Auto-Sync Configuration

For other tools (JavaScript/TypeScript, Lua, JSON, HTML, CSS, etc.), this configuration uses **Declarative Sync**.
Just ensure `lua/lsp/setup.lua` and `lua/plugins/nvim-treesitter.lua` are up to date, and Neovim will auto-install them.
