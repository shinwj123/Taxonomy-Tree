#Executable names:
#EXE = treemaker
#TEST = test

#Add all object files needed for compiling:

#EXE_OBJ = somethingdifferent.o
#OBJS =  main.o TreeMkr.o
#OBJS_TEST =  main.o TreeMkr.o cs225/catch/catchmain.o
#Use the cs225 makefile template:

#include cs225/make/cs225.mk
#CPP_FILES+= $(wildcard main/.cpp)
#CPP_FILES+= $(wildcard TreeMkr/.cpp)
#CPP_TEST+= $(wildcard TestCases/.cpp))
#CPP_TEST+= $(wildcard catch/catch/.cpp)
EXENAME = treemaker
OBJS = TreeMkr.o main.o

CXX = clang++
CXXFLAGS = $(CS225) -std=c++14 -stdlib=libc++ -c -g -O0 -Wall -Wextra -pedantic
LD = clang++
LDFLAGS = -std=c++14 -stdlib=libc++ -lc++abi -lm

# Custom Clang version enforcement Makefile rule:
ccred=$(shell echo -e "\033[0;31m")
ccyellow=$(shell echo -e "\033[0;33m")
ccend=$(shell echo -e "\033[0m")

IS_EWS=$(shell hostname | grep "ews.illinois.edu")
IS_CORRECT_CLANG=$(shell clang -v 2>&1 | grep "version 6")
ifneq ($(strip $(IS_EWS)),)
ifeq ($(strip $(IS_CORRECT_CLANG)),)
CLANG_VERSION_MSG = $(error $(ccred) On EWS, please run 'module load llvm/6.0.1' first when running CS225 assignments. $(ccend))
endif
else
CLANG_VERSION_MSG = $(warning $(ccyellow) Looks like you are not on EWS. Be sure to test on EWS before the deadline. $(ccend))
endif

.PHONY: all test clean output_msg

all : $(EXENAME)

output_msg: ; $(CLANG_VERSION_MSG)

$(EXENAME): output_msg $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $(EXENAME)

readFromFile.o: main.cpp TreeMkr.cpp
	$(CXX) $(CXXFLAGS) main.cpp TreeMkr.cpp

test: output_msg cs225/catch/catchmain.cpp TestCases.cpp TreeMkr.cpp
	$(LD) cs225/catch/catchmain.cpp TestCases.cpp TreeMkr.cpp $(LDFLAGS) -o test

clean:
	-rm -f *.o $(EXENAME) test
