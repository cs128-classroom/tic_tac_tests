CXX := clang++
INCLUDES := -Iincludes/

CXXFLAGS := -std=c++20 \
            -O0 \
            -gdwarf-4 \
            -Wall -Wextra -Werror -pedantic \
            -fsanitize=address,undefined,implicit-conversion,local-bounds \
            -fno-omit-frame-pointer \
            -fno-optimize-sibling-calls \
            -fsanitize-address-use-after-return=always \
            -Wno-error=unused-parameter \
            $(INCLUDES)

ARCH := $(shell uname -m)

ifeq ($(ARCH),x86_64)
    OBJDIR := ./x86_64
else ifeq ($(ARCH),arm64)
    OBJDIR := ./arm64
else ifeq ($(ARCH),aarch64)
    OBJDIR := ./aarch64
else
    $(error Unsupported architecture: $(ARCH))
endif

SOLUTION_GOOD_OBJ := $(OBJDIR)/impl-good.o
SOLUTION_1_BAD_OBJ := $(OBJDIR)/impl-1-bad.o
SOLUTION_2_BAD_OBJ := $(OBJDIR)/impl-2-bad.o
SOLUTION_3_BAD_OBJ := $(OBJDIR)/impl-3-bad.o
SOLUTION_4_BAD_OBJ := $(OBJDIR)/impl-4-bad.o
SOLUTION_5_BAD_OBJ := $(OBJDIR)/impl-5-bad.o
SOLUTION_6_BAD_OBJ := $(OBJDIR)/impl-6-bad.o

.DEFAULT_GOAL := exec

.PHONY: clean exec tests test1 test2 test3 test4 test5 test6 test7

exec: bin/exec

tests: bin/test1 bin/test2 bin/test3 bin/test4 bin/test5 bin/test6 bin/test7

test1: bin/test1
test2: bin/test2
test3: bin/test3
test4: bin/test4
test5: bin/test5
test6: bin/test6
test7: bin/test7

bin:
	mkdir -p bin

# Main executable
bin/exec: ./src/driver.cc | bin
	$(CXX) $(CXXFLAGS) $< -o $@

# Test executables (sanitizers MUST be present at link time)
bin/test1: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_1_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_1_BAD_OBJ) -o $@

bin/test2: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_2_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_2_BAD_OBJ) -o $@

bin/test3: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_3_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_3_BAD_OBJ) -o $@

bin/test4: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_4_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_4_BAD_OBJ) -o $@

bin/test5: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_5_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_5_BAD_OBJ) -o $@

bin/test6: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_6_BAD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_6_BAD_OBJ) -o $@

bin/test7: ./includes/solution.hpp ./tests/tests.cc $(SOLUTION_GOOD_OBJ) | bin
	$(CXX) $(CXXFLAGS) ./tests/tests.cc $(SOLUTION_GOOD_OBJ) -o $@

clean:
	rm -rf bin