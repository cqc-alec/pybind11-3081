CLTOOLS=/Library/Developer/CommandLineTools
CLBIN=$(CLTOOLS)/usr/bin
CXX=$(CLBIN)/c++
STRIP=$(CLBIN)/strip
SDKS=$(CLTOOLS)/SDKs
SDK=$(SDKS)/MacOSX.sdk
SDK113=$(SDKS)/MacOSX11.3.sdk
PYBIND_INC=/Users/alec/.conan/data/pybind11/2.7.1/_/_/package/5ab84d6acfe1f23c4fae0ab88f26e3a396351ac9/include
PYROOT=/Users/alec/.pyenv/versions/3.8.11

all:
	$(CXX) -I. -stdlib=libc++ -Wall -Wextra -Werror -Wunreachable-code -Wunused -Winconsistent-missing-override -Wloop-analysis -O3 -DNDEBUG -arch arm64 -isysroot $(SDK) -fPIC -std=c++2a -o A.cpp.o -c A.cpp
	$(CXX) -stdlib=libc++ -Wall -Wextra -Werror -Wunreachable-code -Wunused -Winconsistent-missing-override -Wloop-analysis -O3 -DNDEBUG -arch arm64 -isysroot $(SDK) -dynamiclib -Wl,-headerpad_max_install_names -o libA.dylib -install_name @loader_path/libA.dylib A.cpp.o
	$(CXX) -I. -isystem $(PYBIND_INC) -isystem $(PYROOT)/include/python3.8 -Wall -Wextra -Werror -O3 -DNDEBUG  -arch arm64 -isysroot $(SDK113) -fPIC -fvisibility=hidden -Os -Wno-register -Wno-deprecated-register -std=c++2a -MD -MT binder.cpp.o -MF binder.cpp.o.d -o binder.cpp.o -c binder.cpp
	$(CXX) -Wall -Wextra -Werror -O3 -DNDEBUG -arch arm64 -isysroot $(SDK113) -bundle -Wl,-headerpad_max_install_names -Xlinker -undefined -Xlinker dynamic_lookup -o A.cpython-38-darwin.so binder.cpp.o -L. -lA  $(PYROOT)/lib/libpython3.8.a
	$(STRIP) -x A.cpython-38-darwin.so

clean:
	rm -f *.o *.d *.so *.dylib

