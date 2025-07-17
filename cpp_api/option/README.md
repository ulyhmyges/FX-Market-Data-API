
## Try to compile Quantlib


### configure

```shell
./configure --with-boost-include=/opt/homebrew/include/ --prefix=${HOME}/local/ CXXFLAGS='-O2 -stdlib=libc++ -mmacosx-version-min=10.9' LDFLAGS='-stdlib=libc++ -mmacosx-version-min=10.9'
```

```sh
make
sudo make install
```

