CLTOOLS=/Library/Developer/CommandLineTools
CLBIN=$(CLTOOLS)/usr/bin
CXX=$(CLBIN)/c++
STRIP=$(CLBIN)/strip
SDK=$(CLTOOLS)/SDKs/MacOSX.sdk
PYBIND_INC=/Users/alec/.conan/data/pybind11/2.7.1/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include
PYROOT=/Users/alec/.pyenv/versions/3.8.11
PYBIND_INC_OLD=/Users/alec/.conan/data/pybind11/2.6.2/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include

all:
	$(CXX) -I. -stdlib=libc++ -arch arm64 -isysroot $(SDK) -fPIC -std=c++2a -o A.cpp.o -c A.cpp
	$(CXX) -stdlib=libc++ -arch arm64 -isysroot $(SDK) -dynamiclib -Wl,-headerpad_max_install_names -o libA.dylib -install_name @loader_path/libA.dylib A.cpp.o
	$(CXX) -I. -isystem $(PYBIND_INC) -isystem $(PYROOT)/include/python3.8 -arch arm64 -isysroot $(SDK) -fPIC -fvisibility=hidden -std=c++2a -MD -MT binder.cpp.o -MF binder.cpp.o.d -o binder.cpp.o -c binder.cpp
	$(CXX) -arch arm64 -isysroot $(SDK) -bundle -Wl,-headerpad_max_install_names -Xlinker -undefined -Xlinker dynamic_lookup -o A.cpython-38-darwin.so binder.cpp.o -L. -lA  $(PYROOT)/lib/libpython3.8.a
	$(STRIP) -x A.cpython-38-darwin.so

clean:
	rm -f *.o *.d *.so *.dylib

test: all
	$(PYROOT)/bin/python -c "from A import A"

oldway:
	$(CXX) -I. -stdlib=libc++ -arch arm64 -isysroot $(SDK) -fPIC -std=c++2a -o A.cpp.o -c A.cpp
	$(CXX) -stdlib=libc++ -arch arm64 -isysroot $(SDK) -dynamiclib -Wl,-headerpad_max_install_names -o libA.dylib -install_name @loader_path/libA.dylib A.cpp.o
	$(CXX) -I. -isystem $(PYBIND_INC_OLD) -isystem $(PYROOT)/include/python3.8 -arch arm64 -isysroot $(SDK) -fPIC -fvisibility=hidden -std=c++2a -MD -MT binder.cpp.o -MF binder.cpp.o.d -o binder.cpp.o -c binder.cpp
	$(CXX) -arch arm64 -isysroot $(SDK) -bundle -Wl,-headerpad_max_install_names -Xlinker -undefined -Xlinker dynamic_lookup -o A.cpython-38-darwin.so binder.cpp.o -L. -lA

testoldway: oldway
	$(PYROOT)/bin/python -c "from A import A"
