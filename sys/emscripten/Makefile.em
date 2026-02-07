#	NetHack Makefile for Emscripten (Web Build)
#	SCCS Id: @(#)Makefile.em	3.3	2024/01/01

# Emscripten compiler
CC = emcc
CXX = em++
AR = emar
RANLIB = emranlib

# Build configuration
SHELL = /bin/sh
GAME = nethack

# Directories (relative to build-web at project root)
SRCDIR = ../src
INCDIR = ../include
UTILDIR = ../util
SYSDIR = ../sys/share
UNIXDIR = ../sys/unix
WINJTPDIR = ../win/jtp
WINTTYDIR = ../win/tty
GAMEDATADIR = ../win/jtp/gamedata

# Emscripten-specific flags
EMFLAGS = -s USE_SDL=2 -s USE_SDL_MIXER=2
ASYNCIFY_FLAGS = -s ASYNCIFY -s ASYNCIFY_STACK_SIZE=524288 -s ASYNCIFY_IMPORTS=['emscripten_sleep','SDL_Delay']
MEMORY_FLAGS = -s INITIAL_MEMORY=67108864 -s ALLOW_MEMORY_GROWTH=1
FILESYSTEM_FLAGS = -s FORCE_FILESYSTEM=1
EXPORT_FLAGS = -s EXPORTED_RUNTIME_METHODS=['ccall','cwrap','FS']

# Preload game data files
# Falcon's Eye data (graphics, sound) and NetHack data files (levels, dungeon, etc.)
# These MUST be separate paths to avoid filename conflicts (both have config/, defaults.nh, etc.)
NHDATADIR = ../compiled/games/lib/nethackdir
PRELOAD_FLAGS = --preload-file $(GAMEDATADIR)@/gamedata --preload-file $(NHDATADIR)@/nhdata

# Compiler flags
CFLAGS = -O2 -DEMSCRIPTEN -I$(INCDIR) -I$(SRCDIR) $(EMFLAGS)
SHELLFILE = ../sys/emscripten/shell.html
LDFLAGS = $(EMFLAGS) $(ASYNCIFY_FLAGS) $(MEMORY_FLAGS) $(FILESYSTEM_FLAGS) $(EXPORT_FLAGS) $(PRELOAD_FLAGS) --shell-file $(SHELLFILE)

# System sources for Emscripten (based on Unix but modified)
SYSSRC = $(SYSDIR)/ioctl.c $(SYSDIR)/unixtty.c $(UNIXDIR)/unixmain.c \
	$(UNIXDIR)/unixunix.c
SYSOBJ = ioctl.o unixtty.o unixmain.o unixunix.o

# Falcon's Eye window sources (no TTY for Emscripten - graphics only)
WINJTPSRC = $(WINJTPDIR)/jtp_def.c $(WINJTPDIR)/jtp_gen.c $(WINJTPDIR)/jtp_gfl.c \
	$(WINJTPDIR)/jtp_gra.c $(WINJTPDIR)/jtp_keys.c $(WINJTPDIR)/jtp_mou.c \
	$(WINJTPDIR)/jtp_sdl.c $(WINJTPDIR)/jtp_txt.c $(WINJTPDIR)/jtp_win.c \
	$(WINJTPDIR)/winjtp.c
WINJTPOBJ = jtp_def.o jtp_gen.o jtp_gfl.o jtp_gra.o jtp_keys.o jtp_mou.o \
	jtp_sdl.o jtp_txt.o jtp_win.o winjtp.o

WINSRC = $(WINJTPSRC)
WINOBJ = $(WINJTPOBJ)

# Main NetHack sources
HACKCSRC = $(SRCDIR)/allmain.c $(SRCDIR)/alloc.c $(SRCDIR)/apply.c \
	$(SRCDIR)/artifact.c $(SRCDIR)/attrib.c $(SRCDIR)/ball.c \
	$(SRCDIR)/bones.c $(SRCDIR)/botl.c $(SRCDIR)/cmd.c \
	$(SRCDIR)/dbridge.c $(SRCDIR)/decl.c $(SRCDIR)/detect.c \
	$(SRCDIR)/dig.c $(SRCDIR)/display.c $(SRCDIR)/dlb.c $(SRCDIR)/do.c \
	$(SRCDIR)/do_name.c $(SRCDIR)/do_wear.c $(SRCDIR)/dog.c \
	$(SRCDIR)/dogmove.c $(SRCDIR)/dokick.c $(SRCDIR)/dothrow.c \
	$(SRCDIR)/drawing.c $(SRCDIR)/dungeon.c $(SRCDIR)/eat.c \
	$(SRCDIR)/end.c $(SRCDIR)/engrave.c $(SRCDIR)/exper.c \
	$(SRCDIR)/explode.c $(SRCDIR)/extralev.c $(SRCDIR)/files.c \
	$(SRCDIR)/fountain.c $(SRCDIR)/hack.c $(SRCDIR)/hacklib.c \
	$(SRCDIR)/invent.c $(SRCDIR)/light.c $(SRCDIR)/lock.c \
	$(SRCDIR)/mail.c $(SRCDIR)/makemon.c $(SRCDIR)/mcastu.c \
	$(SRCDIR)/mhitm.c $(SRCDIR)/mhitu.c $(SRCDIR)/minion.c \
	$(SRCDIR)/mklev.c $(SRCDIR)/mkmap.c $(SRCDIR)/mkmaze.c \
	$(SRCDIR)/mkobj.c $(SRCDIR)/mkroom.c $(SRCDIR)/mon.c \
	$(SRCDIR)/mondata.c $(SRCDIR)/monmove.c $(SRCDIR)/monst.c \
	$(SRCDIR)/mplayer.c $(SRCDIR)/mthrowu.c $(SRCDIR)/muse.c \
	$(SRCDIR)/music.c $(SRCDIR)/o_init.c $(SRCDIR)/objects.c \
	$(SRCDIR)/objnam.c $(SRCDIR)/options.c $(SRCDIR)/pager.c \
	$(SRCDIR)/pickup.c $(SRCDIR)/pline.c $(SRCDIR)/polyself.c \
	$(SRCDIR)/potion.c $(SRCDIR)/pray.c $(SRCDIR)/priest.c \
	$(SRCDIR)/quest.c $(SRCDIR)/questpgr.c $(SRCDIR)/read.c \
	$(SRCDIR)/rect.c $(SRCDIR)/region.c $(SRCDIR)/restore.c \
	$(SRCDIR)/rip.c $(SRCDIR)/rnd.c $(SRCDIR)/role.c \
	$(SRCDIR)/rumors.c $(SRCDIR)/save.c $(SRCDIR)/shk.c \
	$(SRCDIR)/shknam.c $(SRCDIR)/sit.c $(SRCDIR)/sounds.c \
	$(SRCDIR)/sp_lev.c $(SRCDIR)/spell.c $(SRCDIR)/steal.c \
	$(SRCDIR)/steed.c $(SRCDIR)/teleport.c $(SRCDIR)/timeout.c \
	$(SRCDIR)/topten.c $(SRCDIR)/track.c $(SRCDIR)/trap.c \
	$(SRCDIR)/u_init.c $(SRCDIR)/uhitm.c $(SRCDIR)/vault.c \
	$(SRCDIR)/version.c $(SRCDIR)/vision.c $(SRCDIR)/weapon.c \
	$(SRCDIR)/were.c $(SRCDIR)/wield.c $(SRCDIR)/windows.c \
	$(SRCDIR)/wizard.c $(SRCDIR)/worm.c $(SRCDIR)/worn.c \
	$(SRCDIR)/write.c $(SRCDIR)/zap.c

HACKOBJ = allmain.o alloc.o apply.o artifact.o attrib.o ball.o \
	bones.o botl.o cmd.o dbridge.o decl.o detect.o dig.o display.o \
	dlb.o do.o do_name.o do_wear.o dog.o dogmove.o dokick.o dothrow.o \
	drawing.o dungeon.o eat.o end.o engrave.o exper.o explode.o \
	extralev.o files.o fountain.o hack.o hacklib.o invent.o light.o \
	lock.o mail.o makemon.o mcastu.o mhitm.o mhitu.o minion.o mklev.o \
	mkmap.o mkmaze.o mkobj.o mkroom.o mon.o mondata.o monmove.o \
	monst.o mplayer.o mthrowu.o muse.o music.o o_init.o objects.o \
	objnam.o options.o pager.o pickup.o pline.o polyself.o potion.o \
	pray.o priest.o quest.o questpgr.o read.o rect.o region.o \
	restore.o rip.o rnd.o role.o rumors.o save.o shk.o shknam.o sit.o \
	sounds.o sp_lev.o spell.o steal.o steed.o teleport.o timeout.o \
	topten.o track.o trap.o u_init.o uhitm.o vault.o version.o \
	vision.o vis_tab.o weapon.o were.o wield.o windows.o wizard.o \
	worm.o worn.o write.o zap.o monstr.o

ALLOBJ = $(HACKOBJ) $(SYSOBJ) $(WINOBJ)

# Targets
all: $(GAME).html

$(GAME).html: $(ALLOBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(GAME).html $(ALLOBJ)

# Generated source files (need to be built with host compiler first)
monstr.o: $(SRCDIR)/monstr.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/monstr.c

vis_tab.o: $(SRCDIR)/vis_tab.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/vis_tab.c

# Main NetHack object files
allmain.o: $(SRCDIR)/allmain.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/allmain.c

alloc.o: $(SRCDIR)/alloc.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/alloc.c

apply.o: $(SRCDIR)/apply.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/apply.c

artifact.o: $(SRCDIR)/artifact.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/artifact.c

attrib.o: $(SRCDIR)/attrib.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/attrib.c

ball.o: $(SRCDIR)/ball.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/ball.c

bones.o: $(SRCDIR)/bones.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/bones.c

botl.o: $(SRCDIR)/botl.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/botl.c

cmd.o: $(SRCDIR)/cmd.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/cmd.c

dbridge.o: $(SRCDIR)/dbridge.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dbridge.c

decl.o: $(SRCDIR)/decl.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/decl.c

detect.o: $(SRCDIR)/detect.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/detect.c

dig.o: $(SRCDIR)/dig.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dig.c

display.o: $(SRCDIR)/display.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/display.c

dlb.o: $(SRCDIR)/dlb.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dlb.c

do.o: $(SRCDIR)/do.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/do.c

do_name.o: $(SRCDIR)/do_name.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/do_name.c

do_wear.o: $(SRCDIR)/do_wear.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/do_wear.c

dog.o: $(SRCDIR)/dog.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dog.c

dogmove.o: $(SRCDIR)/dogmove.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dogmove.c

dokick.o: $(SRCDIR)/dokick.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dokick.c

dothrow.o: $(SRCDIR)/dothrow.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dothrow.c

drawing.o: $(SRCDIR)/drawing.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/drawing.c

dungeon.o: $(SRCDIR)/dungeon.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/dungeon.c

eat.o: $(SRCDIR)/eat.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/eat.c

end.o: $(SRCDIR)/end.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/end.c

engrave.o: $(SRCDIR)/engrave.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/engrave.c

exper.o: $(SRCDIR)/exper.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/exper.c

explode.o: $(SRCDIR)/explode.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/explode.c

extralev.o: $(SRCDIR)/extralev.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/extralev.c

files.o: $(SRCDIR)/files.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/files.c

fountain.o: $(SRCDIR)/fountain.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/fountain.c

hack.o: $(SRCDIR)/hack.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/hack.c

hacklib.o: $(SRCDIR)/hacklib.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/hacklib.c

invent.o: $(SRCDIR)/invent.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/invent.c

light.o: $(SRCDIR)/light.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/light.c

lock.o: $(SRCDIR)/lock.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/lock.c

mail.o: $(SRCDIR)/mail.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mail.c

makemon.o: $(SRCDIR)/makemon.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/makemon.c

mcastu.o: $(SRCDIR)/mcastu.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mcastu.c

mhitm.o: $(SRCDIR)/mhitm.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mhitm.c

mhitu.o: $(SRCDIR)/mhitu.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mhitu.c

minion.o: $(SRCDIR)/minion.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/minion.c

mklev.o: $(SRCDIR)/mklev.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mklev.c

mkmap.o: $(SRCDIR)/mkmap.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mkmap.c

mkmaze.o: $(SRCDIR)/mkmaze.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mkmaze.c

mkobj.o: $(SRCDIR)/mkobj.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mkobj.c

mkroom.o: $(SRCDIR)/mkroom.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mkroom.c

mon.o: $(SRCDIR)/mon.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mon.c

mondata.o: $(SRCDIR)/mondata.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mondata.c

monmove.o: $(SRCDIR)/monmove.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/monmove.c

monst.o: $(SRCDIR)/monst.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/monst.c

mplayer.o: $(SRCDIR)/mplayer.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mplayer.c

mthrowu.o: $(SRCDIR)/mthrowu.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/mthrowu.c

muse.o: $(SRCDIR)/muse.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/muse.c

music.o: $(SRCDIR)/music.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/music.c

o_init.o: $(SRCDIR)/o_init.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/o_init.c

objects.o: $(SRCDIR)/objects.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/objects.c

objnam.o: $(SRCDIR)/objnam.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/objnam.c

options.o: $(SRCDIR)/options.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/options.c

pager.o: $(SRCDIR)/pager.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/pager.c

pickup.o: $(SRCDIR)/pickup.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/pickup.c

pline.o: $(SRCDIR)/pline.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/pline.c

polyself.o: $(SRCDIR)/polyself.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/polyself.c

potion.o: $(SRCDIR)/potion.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/potion.c

pray.o: $(SRCDIR)/pray.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/pray.c

priest.o: $(SRCDIR)/priest.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/priest.c

quest.o: $(SRCDIR)/quest.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/quest.c

questpgr.o: $(SRCDIR)/questpgr.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/questpgr.c

read.o: $(SRCDIR)/read.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/read.c

rect.o: $(SRCDIR)/rect.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/rect.c

region.o: $(SRCDIR)/region.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/region.c

restore.o: $(SRCDIR)/restore.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/restore.c

rip.o: $(SRCDIR)/rip.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/rip.c

rnd.o: $(SRCDIR)/rnd.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/rnd.c

role.o: $(SRCDIR)/role.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/role.c

rumors.o: $(SRCDIR)/rumors.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/rumors.c

save.o: $(SRCDIR)/save.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/save.c

shk.o: $(SRCDIR)/shk.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/shk.c

shknam.o: $(SRCDIR)/shknam.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/shknam.c

sit.o: $(SRCDIR)/sit.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/sit.c

sounds.o: $(SRCDIR)/sounds.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/sounds.c

sp_lev.o: $(SRCDIR)/sp_lev.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/sp_lev.c

spell.o: $(SRCDIR)/spell.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/spell.c

steal.o: $(SRCDIR)/steal.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/steal.c

steed.o: $(SRCDIR)/steed.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/steed.c

teleport.o: $(SRCDIR)/teleport.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/teleport.c

timeout.o: $(SRCDIR)/timeout.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/timeout.c

topten.o: $(SRCDIR)/topten.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/topten.c

track.o: $(SRCDIR)/track.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/track.c

trap.o: $(SRCDIR)/trap.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/trap.c

u_init.o: $(SRCDIR)/u_init.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/u_init.c

uhitm.o: $(SRCDIR)/uhitm.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/uhitm.c

vault.o: $(SRCDIR)/vault.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/vault.c

version.o: $(SRCDIR)/version.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/version.c

vision.o: $(SRCDIR)/vision.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/vision.c

weapon.o: $(SRCDIR)/weapon.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/weapon.c

were.o: $(SRCDIR)/were.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/were.c

wield.o: $(SRCDIR)/wield.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/wield.c

windows.o: $(SRCDIR)/windows.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/windows.c

wizard.o: $(SRCDIR)/wizard.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/wizard.c

worm.o: $(SRCDIR)/worm.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/worm.c

worn.o: $(SRCDIR)/worn.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/worn.c

write.o: $(SRCDIR)/write.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/write.c

zap.o: $(SRCDIR)/zap.c
	$(CC) $(CFLAGS) -c $(SRCDIR)/zap.c

# System object files
ioctl.o: $(SYSDIR)/ioctl.c
	$(CC) $(CFLAGS) -c $(SYSDIR)/ioctl.c

unixtty.o: $(SYSDIR)/unixtty.c
	$(CC) $(CFLAGS) -c $(SYSDIR)/unixtty.c

unixmain.o: $(UNIXDIR)/unixmain.c
	$(CC) $(CFLAGS) -c $(UNIXDIR)/unixmain.c

unixunix.o: $(UNIXDIR)/unixunix.c
	$(CC) $(CFLAGS) -c $(UNIXDIR)/unixunix.c

# TTY window object files
getline.o: $(WINTTYDIR)/getline.c
	$(CC) $(CFLAGS) -c $(WINTTYDIR)/getline.c

termcap.o: $(WINTTYDIR)/termcap.c
	$(CC) $(CFLAGS) -c $(WINTTYDIR)/termcap.c

topl.o: $(WINTTYDIR)/topl.c
	$(CC) $(CFLAGS) -c $(WINTTYDIR)/topl.c

wintty.o: $(WINTTYDIR)/wintty.c
	$(CC) $(CFLAGS) -c $(WINTTYDIR)/wintty.c

# Falcon's Eye window object files
jtp_def.o: $(WINJTPDIR)/jtp_def.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_def.c

jtp_gen.o: $(WINJTPDIR)/jtp_gen.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_gen.c

jtp_gfl.o: $(WINJTPDIR)/jtp_gfl.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_gfl.c

jtp_gra.o: $(WINJTPDIR)/jtp_gra.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_gra.c

jtp_keys.o: $(WINJTPDIR)/jtp_keys.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_keys.c

jtp_mou.o: $(WINJTPDIR)/jtp_mou.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_mou.c

jtp_sdl.o: $(WINJTPDIR)/jtp_sdl.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_sdl.c

jtp_txt.o: $(WINJTPDIR)/jtp_txt.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_txt.c

jtp_win.o: $(WINJTPDIR)/jtp_win.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/jtp_win.c

winjtp.o: $(WINJTPDIR)/winjtp.c
	$(CC) $(CFLAGS) -DUSE_SDL_SYSCALLS -c $(WINJTPDIR)/winjtp.c

# Clean up
clean:
	rm -f *.o $(GAME).html $(GAME).js $(GAME).wasm $(GAME).data

# Phony targets
.PHONY: all clean
