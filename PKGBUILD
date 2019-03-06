# Maintainer: gym603 <gui_yuan_miao@163.com>

_realname=tensorflow
pkgbase=mingw-w64-${_realname}
pkgname=("${MINGW_PACKAGE_PREFIX}-${_realname}" "${MINGW_PACKAGE_PREFIX}-python2-${_realname}" "${MINGW_PACKAGE_PREFIX}-python3-${_realname}")
pkgver=1.10.0
pkgrel=1
pkgdesc="Open source software library for numerical computation using data flow graphs. (mingw-w64)"
arch=('any')

url="https://tensorflow.org"
license=('Apache 2.0')
_archive=${_realname}-${pkgver}
source=(${_archive}.tar.gz::https://github.com/tensorflow/tensorflow/archive/v${pkgver}.tar.gz
        0001-fix-tensorflow-contrib-cmake.patch
        0002-fix-tensorflow-core.patch
        0003-fix-tensorflow-__init__.py.patch
        0004-fix-tensorflow-python.patch
        do-patch.sh
        grpc.patch
        nsync.patch
        png.patch
        farmhash.patch
        gemmlowp.patch
        downloads.tar.gz)
sha256sums=('EE9CB98D9E0D8106F2F4ED52A38FE89399324AF303E1401567E5B64A9F86744B'
            '17CBEE172F9B374B485556F947D803C6E7C174F400A7A78E92E046A9ADCDAB1C'
            '2B18F1FE58888F7271A42B04C01C1384A03D90B322B1BF352C8D03ACA62F3B59'
            '202D181ABE517B5FB75EEA687EF63679B9A974AE425D9818AF81513B9DFA2541'
            '7F16CFC07CFF6FA7EF3BAF70B1BBDAFF564436567CE9B8D85E47927363422D84'
            'C8A80F51ECF5BC8DABD6F8D2017377CA9F155E0FCC07E2B4018FEE713401E2D0'
            '245D8BF7DBA8E93C3C158C797BD30FA374BFBCE28EB1FE3A045094C33CC3B7A2'
            '7EC822C85E9BE3EBD1B864CA1A8D88230A8AD77B800A80646F36C3EC75BB11BC'
            '6511B4EB2051FB4E1EC868C35556ACE1F6AC0474475B4E09C9AB3CB40AF30EAC'
            '71FD21B7C1B2F49F785BBE4530537E39A9BAD78A7074EFA802B84FCA8117B532'
            '132DB40B994F932695BE8B2D6B54026B1956F2789FAE22CE9E28B79CE8B31956'
            '56C8223245C8E5DCE17D0B1E47EDA13BF946146958DDD7BF5973B69BB1188C69')
noextract=(downloads.tar.gz)

_mock=('mock' 'pbr' 'funcsigs')
_deps=('numpy' 'protobuf' 'absl-py' ${_mock[@]} 'wheel')
makedepends=("git"
             "patch"
             "${MINGW_PACKAGE_PREFIX}-cmake"
             "make"
             "${MINGW_PACKAGE_PREFIX}-gcc"
             ${_deps[@]/#/${MINGW_PACKAGE_PREFIX}-python2-}
             ${_deps[@]/#/${MINGW_PACKAGE_PREFIX}-python3-}
             "${MINGW_PACKAGE_PREFIX}-swig")
_deps2=(absl-py astor gast numpy six protobuf setuptools termcolor grpcio wheel mock backports.weakref enum34) # tensorboard
_deps3=(absl-py astor gast numpy six protobuf setuptools termcolor grpcio wheel)                               # tensorboard

# Helper macros to help make tasks easier #
apply_patch_with_msg() {
  for _patch in "$@"
  do
    msg2 "Applying ${_patch}"
    patch -Nbp1 -i "${srcdir}/${_patch}"
  done
}

prepare() {
  rm -rf "${srcdir}/${_archive}.orig"
  cp -rp "${srcdir}/${_archive}" "${srcdir}/${_archive}.orig"
  cd "${srcdir}/${_archive}"
  apply_patch_with_msg \
    0001-fix-tensorflow-contrib-cmake.patch \
    0002-fix-tensorflow-core.patch \
    0003-fix-tensorflow-__init__.py.patch \
    0004-fix-tensorflow-python.patch
  cp -up ${srcdir}/{grpc,nsync,png,farmhash,gemmlowp}.patch tensorflow/contrib/cmake/patches
  cp -up ${srcdir}/do-patch.sh tensorflow/contrib/cmake/patches
}

build() {
  cd "${srcdir}"
  
  # rm -rf python{2,3}-build
  for builddir in python{2,3}-build; do
    msg2 "Building for ${CARCH} ${builddir%-build} ..."
    mkdir -p ${builddir}
    pushd $builddir
    
    rm -rf ${srcdir}/${_archive}/{api_init_files_list.txt,estimator_api_init_files_list.txt}
    # rm -rf ${srcdir}/${_archive}/tensorflow/core/util/version_info.cc{,.tmp}
    
    bsdtar -xf ${srcdir}/downloads.tar.gz
    # find . -type f -name '*-patch' -delete
    # make clean
    # rm -f CMakeCache.txt
    
    rm -rf tf_python
    
    ${MINGW_PREFIX}/bin/cmake -G "MSYS Makefiles" \
          -Dtensorflow_BUILD_SHARED_LIB=OFF \
          -Dtensorflow_BUILD_CC_EXAMPLE=ON \
          -Dtensorflow_BUILD_CC_TESTS=OFF \
          -Dtensorflow_BUILD_PYTHON_BINDINGS=ON \
          -Dtensorflow_BUILD_PYTHON_TESTS=OFF \
          -DPYTHON_EXECUTABLE=${MINGW_PREFIX}/bin/${builddir%-build} \
          ../${_archive}/tensorflow/contrib/cmake
    # make -sj1 all
    make -sj1 tf_python_build_pip_package
    
    #--- test commands when fail ---
    # rm -rf tf_python \
    # && cmake . \
    # && if [ -f libpywrap_tensorflow_internal.dll   ]; then cp libpywrap_tensorflow_internal.dll   tf_python/tensorflow/python/_pywrap_tensorflow_internal.pyd; fi \
    # && if [ -f libpywrap_tensorflow_internal.dll.a ]; then cp libpywrap_tensorflow_internal.dll.a tf_python/tensorflow/python/; fi \
    # && make -sj1 tf_python_build_pip_package
    
    popd
  done
  
  # make tf_build_all_tests
  # make test
}

package_tensorflow() {
  cd "${srcdir}/python3-build"
  
  # make install/fast
  cmake -DCMAKE_INSTALL_PREFIX:PATH="${pkgdir}${MINGW_PREFIX}" -P cmake_install.cmake

  install -Dm644 ${srcdir}/${_archive}/LICENSE "${pkgdir}${MINGW_PREFIX}/share/licenses/${_realname}/LICENSE"
}

package_python3-tensorflow() {
  depends=("${MINGW_PACKAGE_PREFIX}-python3" "${_deps3[@]/#/${MINGW_PACKAGE_PREFIX}-python3-}")

  local _mingw_prefix=$(cygpath -am ${MINGW_PREFIX})

  cd "${srcdir}/python3-build/tf_python"
  MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
    ${MINGW_PREFIX}/bin/python3 setup.py --quiet install --prefix=${MINGW_PREFIX} --root="${pkgdir}" -O1

  local PREFIX_WIN=$(cygpath -wm ${MINGW_PREFIX})
  # fix python command in files
  for _f in "${pkgdir}${MINGW_PREFIX}"/bin/*.py; do
    sed -e "s|/usr/bin/env |${MINGW_PREFIX}|g" \
        -e "s|${PREFIX_WIN}|${MINGW_PREFIX}|g" -i ${_f}
  done

  for f in freeze_graph saved_model_cli tensorboard tflite_convert toco toco_from_protos ; do
    mv "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,3}.exe
    if [ -f "${pkgdir}${MINGW_PREFIX}"/bin/${f}.exe.manifest ]; then
      mv "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,3}.exe.manifest
      sed -e "s|${f}|${f}3|g" -i "${pkgdir}${MINGW_PREFIX}"/bin/${f}3.exe.manifest
    fi
    mv "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,3}-script.py
  done

  install -Dm644 ${srcdir}/${_archive}/LICENSE "${pkgdir}${MINGW_PREFIX}/share/licenses/python3-${_realname}/LICENSE"
}

package_python2-tensorflow() {
  depends=("${MINGW_PACKAGE_PREFIX}-python2" "${_deps2[@]/#/${MINGW_PACKAGE_PREFIX}-python2-}")

  cd "${srcdir}/python2-build/tf_python"
  MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
    ${MINGW_PREFIX}/bin/python2 setup.py --quiet install --prefix=${MINGW_PREFIX} --root="${pkgdir}" -O1

  local PREFIX_WIN=$(cygpath -wm ${MINGW_PREFIX})
  # fix python command in files
  for _f in "${pkgdir}${MINGW_PREFIX}"/bin/*.py; do
    sed -e "s|/usr/bin/env |${MINGW_PREFIX}|g" \
        -e "s|${PREFIX_WIN}|${MINGW_PREFIX}|g" -i ${_f}
  done

  for f in freeze_graph saved_model_cli tensorboard tflite_convert toco toco_from_protos ; do
    cp "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,2}.exe
    if [ -f "${pkgdir}${MINGW_PREFIX}"/bin/${f}.exe.manifest ]; then
      cp "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,2}.exe.manifest
      sed -e "s|${f}|${f}2|g" -i "${pkgdir}${MINGW_PREFIX}"/bin/${f}2.exe.manifest
    fi
    cp "${pkgdir}${MINGW_PREFIX}"/bin/${f}{,2}-script.py
  done

  install -Dm644 ${srcdir}/${_archive}/LICENSE "${pkgdir}${MINGW_PREFIX}/share/licenses/python2-${_realname}/LICENSE"
}

package_mingw-w64-i686-tensorflow() {
  package_${_realname}
}

package_mingw-w64-x86_64-tensorflow() {
  package_${_realname}
}

package_mingw-w64-i686-python2-tensorflow() {
  install=${CARCH}-python2-${_realname}.install
  package_python2-${_realname}
}

package_mingw-w64-i686-python3-tensorflow() {
  install=${CARCH}-python3-${_realname}.install
  package_python3-${_realname}
}

package_mingw-w64-x86_64-python2-tensorflow() {
  install=${CARCH}-python2-${_realname}.install
  package_python2-${_realname}
}

package_mingw-w64-x86_64-python3-tensorflow() {
  install=${CARCH}-python3-${_realname}.install
  package_python3-${_realname}
}
