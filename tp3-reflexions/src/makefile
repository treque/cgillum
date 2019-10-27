CONTEXT=sdl2
#CONTEXT=glfw3

CXXFLAGS += -DFENETRE_$(CONTEXT)
CXXFLAGS += -g -W -Wall -Wno-unused-parameter -Wno-deprecated-declarations -Wvla # -pedantic -std=c++11
ifeq "$(shell uname)" "Darwin"
CXXFLAGS += -Wno-c++11-extensions
endif
CXXFLAGS += $(shell pkg-config --cflags glew)
CXXFLAGS += $(shell pkg-config --cflags $(CONTEXT))

LDFLAGS += -g
LDFLAGS += $(shell pkg-config --libs glew)
LDFLAGS += $(shell pkg-config --libs $(CONTEXT))

ifeq "$(shell uname)" "Darwin"
  LDFLAGS += -framework OpenGL
  ifeq "$(CONTEXT)" "glfw3"
    LDFLAGS += -lobjc -framework Foundation -framework Cocoa
  endif
endif

TP="tp3"
SRC=main

exe : $(SRC).exe
run : exe
	./$(SRC).exe
demo : exe
	DEMO=1 ./$(SRC).exe
$(SRC).exe : *.cpp *.h
	$(CXX) $(CXXFLAGS) -o$@ *.cpp $(LDFLAGS)

clean :
	rm -rf *.o *.exe *.exe.dSYM

remise zip :
	make clean
	rm -f INF2705_remise_$(TP).zip
	zip -r INF2705_remise_$(TP).zip *.cpp *.h *.glsl makefile *.txt textures
