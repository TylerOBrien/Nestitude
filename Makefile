NAME           := Nestitude
RESOURCES      := Nametable Palette
MODULES        := Buffer Chrono Game HUD Input Interrupt Nametable Palette Physics Player Random Stage System

MODULE_DIRS    := $(addprefix app/,$(MODULES))
RESOURCE_DIRS  := $(addprefix resources/,$(RESOURCES))
BUILD_DIRS     := $(addprefix build/,$(MODULE_DIRS) $(RESOURCE_DIRS))

MAIN_FILE      := app/main.asm
CONSTANTS_FILE := app/constants.inc
CHR_FILES      := $(wildcard resources/Pattern/*.chr)
MODULE_FILES   := $(foreach mdir,$(MODULE_DIRS),$(wildcard $(mdir)/*.asm))
MODULE_OBJS    := $(patsubst app/%.asm,build/app/%.o,$(MODULE_FILES))
RESOURCE_FILES := $(foreach rdir,$(RESOURCE_DIRS),$(wildcard $(rdir)/*.asm))
RESOURCE_OBJS  := $(patsubst resources/%.asm,build/resources/%.o,$(RESOURCE_FILES))

PY             := python
CC             := ca65
LD             := ld65

vpath %.asm $(MODULE_DIRS)
vpath %.asm $(RESOURCE_DIRS)

define cc-subdir
$1/%.o: %.asm $(CONSTANTS_FILE)
	$(CC) -o $$@ $$<
endef

all: prepare assets/chr/sprite.chr assets/chr/background.chr build/main.o $(MODULE_OBJS) $(RESOURCE_OBJS)
	$(LD) -C config/nes.cfg -o dist/$(NAME).nes build/main.o $(MODULE_OBJS) $(RESOURCE_OBJS)

prepare: $(BUILD_DIRS)

assets/chr/sprite.chr: assets/png/sprite.png
	@rm -f assets/chr/sprite.chr
	$(PY) tools/nes_chr_encode.py assets/png/sprite.png assets/chr/sprite.chr

assets/chr/background.chr: assets/png/background.png
	@rm -f assets/chr/background.chr
	$(PY) tools/nes_chr_encode.py assets/png/background.png assets/chr/background.chr

build/main.o: $(MAIN_FILE) $(CHR_FILES)
	$(CC) -o build/main.o $(MAIN_FILE)

$(BUILD_DIRS):
	@mkdir -p $@
	@mkdir -p assets/chr

clean:
	@rm -f assets/chr/sprite.chr assets/chr/background.chr
	@rm -rf build/main.o $(BUILD_DIRS)

$(foreach bdir,$(BUILD_DIRS),$(eval $(call cc-subdir,$(bdir))))
