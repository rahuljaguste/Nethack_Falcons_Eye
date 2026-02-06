# Contributing to NetHack Falcon's Eye

Thanks for your interest in contributing! This project ports NetHack Falcon's Eye to modern platforms, including the browser via Emscripten/WebAssembly.

## Getting Started

### Prerequisites

**Native build (Unix/Linux/macOS):**
- GCC or Clang
- SDL2 and SDL2_mixer development libraries
- Make

**Browser build (Emscripten):**
- Everything above (native build is needed first to generate data files)
- [Emscripten SDK](https://emscripten.org/docs/getting_started/)

### Building

```bash
# 1. Set up Makefiles
sh sys/unix/setup.sh

# 2. Build native (compiles utilities and generates game data)
make all
make install

# 3. Build for browser
cd build-web
make -f ../sys/emscripten/Makefile.em

# 4. Test locally (pick one)
node server.js        # http://localhost:3000
python3 server.py     # http://localhost:8081
```

## How to Contribute

### Reporting Bugs

Open an issue with:
- What you expected to happen
- What actually happened
- Browser and OS (for browser issues)
- Steps to reproduce

### Submitting Changes

1. Fork the repository
2. Create a branch from `main` (`git checkout -b my-feature`)
3. Make your changes
4. Test both native and browser builds if your changes touch shared code
5. Commit with a clear message describing what and why
6. Push to your fork and open a pull request

### Code Guidelines

- This is a C codebase from 2001 -- match the existing style (K&R-ish, tabs for indentation)
- Guard platform-specific code with `#ifdef`:
  - `__EMSCRIPTEN__` for browser-only code
  - `USE_SDL_SYSCALLS` for SDL2-specific code
  - `UNIX` for Unix/Linux
  - `MSDOS` for DOS
- Don't break existing platform builds when adding browser features
- Keep changes minimal and focused

### Areas Where Help is Needed

- **Browser compatibility** -- testing and fixing issues across browsers
- **Mobile/touch support** -- adapting the mouse-driven UI for touchscreens
- **Save file persistence** -- IndexedDB integration for browser saves
- **Performance** -- optimizing rendering for lower-end devices
- **Sound** -- improving MIDI playback in the browser
- **Documentation** -- improving build instructions and game docs

Check the [issues](https://github.com/rahuljaguste/Nethack_Falcons_Eye/issues) page for tasks labeled `good first issue` or `help wanted`.

## Project Structure

| Directory | Description |
|-----------|-------------|
| `src/` | Core NetHack game logic |
| `include/` | Header files |
| `win/jtp/` | Falcon's Eye graphics interface |
| `sys/unix/` | Unix-specific code |
| `sys/emscripten/` | Emscripten/WebAssembly build files |
| `dat/` | Game data files |
| `util/` | Build utilities |
| `build-web/` | Browser build output and dev servers |

## License

NetHack has its own license -- see `dat/license`. By contributing, you agree that your changes fall under the same terms.
