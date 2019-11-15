# project name
NAME=colorbound
# paths to godot and butler executables
GODOT=godot
BUTLER=$(HOME)/bin/butler/butler
# paths to project source and project build folder
PROJECT=./project.godot
OUT=$(HOME)/bin/colorbound
# itch.io URL for publising builds
ITCH_URL=zeroji/colorbound

SCENES=$(shell find -name '*.tscn')

all: html windows linux
html: $(OUT)/$(NAME)_html.zip
windows: $(OUT)/$(NAME)_win.zip
linux: $(OUT)/$(NAME)_linux.zip

$(OUT)/$(NAME)_html.zip: $(SCENES)
	@mkdir -p $(OUT)/html
	$(GODOT) --path $(PROJECT) --export "HTML5" $(OUT)/html/index.html
	zip -r $@ $(OUT)/html/index.*

$(OUT)/$(NAME)_win.zip: $(SCENES)
	$(GODOT) --path $(PROJECT) --export "Windows Desktop" $(OUT)/$(NAME).exe
	zip -r $@ $(OUT)/$(NAME).exe $(OUT)/$(NAME).pck

$(OUT)/$(NAME)_linux.zip: $(SCENES)
	$(GODOT) --path $(PROJECT) --export "Linux/X11" $(OUT)/$(NAME).x86_64
	zip -r $@ $(OUT)/$(NAME).x86_64 $(OUT)/$(NAME).pck

publish_html: html
	$(BUTLER) push $(OUT)/$(NAME)_html.zip $(ITCH_URL):html
publish_windows: windows
	$(BUTLER) push $(OUT)/$(NAME)_win.zip $(ITCH_URL):windows
publish_linux: linux
	$(BUTLER) push $(OUT)/$(NAME)_linux.zip $(ITCH_URL):linux
publish_all: publish_html publish_windows publish_linux

clean:
	rm $(OUT)/$(NAME)_*.zip
	rm $(OUT)/$(NAME).*
	rm $(OUT)/html/index.*