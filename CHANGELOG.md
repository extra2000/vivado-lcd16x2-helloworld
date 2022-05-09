# Changelog

## [3.0.0](https://github.com/extra2000/vivado-lcd16x2-helloworld/compare/v2.0.1...v3.0.0) (2022-05-09)


### ⚠ BREAKING CHANGES

* 8MHz clock generator has been removed

### Performance Improvements

* **timing:** improve timing ([c5e1c9a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/c5e1c9a356cc05f42952b11ab58edb4e6a5b4534))


### Styles

* remove spacing alignment ([8d1e12a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/8d1e12a8b5057d99249a55826d26767889387ce5))


### Code Refactoring

* remove 8MHz clock generator ([06e191d](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/06e191db37e39fb062202a5f3f2ac419683df419))
* **tcl:** recreate project with 8MHz clock generator removed ([12c4c7a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/12c4c7ac357abc8c3d04af4f74ca241e2c9793a6))
* **timing:** change input clock from 8MHz to 125MHz ([fdeeeb4](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/fdeeeb457926119f9f19e95f4da35aa416bd25e9))

### [2.0.1](https://github.com/extra2000/vivado-lcd16x2-helloworld/compare/v2.0.0...v2.0.1) (2022-05-06)


### Maintenance

* **lfs:** add LFS ([587761f](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/587761fd9dcfd319af9e3fd1de873290556ae07d))


### Documentations

* add schematic diagram ([5147953](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/5147953da9bda380b8125a074da4c88a92356d37))
* **README:** add Git LFS requirement ([3458c9a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/3458c9a02b7eabc569f57b8346ebf86d8236bad2))

## [2.0.0](https://github.com/extra2000/vivado-lcd16x2-helloworld/compare/v1.1.0...v2.0.0) (2022-05-06)


### ⚠ BREAKING CHANGES

* **constr:** constraint file has been changed into example file to allow user to customize pins assignment
* `lcd_data` has been renamed to `lcd_databus` and project must be recreated

### Styles

* **artyz7-20.xdc:** reorder `lcd_data` ports ([200004e](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/200004e97e9b5a50f48573246a52993fc078068f))


### Code Refactoring

* **artyz7-20.xdc:** re-arrange pins ([bd79321](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/bd793217c93125ffcd3a6b52067a2c8bfbfa30c1))
* **constr:** make constraints customizable ([e146567](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/e146567dafa77a69af8bb48ac081e81e58b8b475))
* **lcd16x2.v:** remove unused params and flags ([33e2656](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/33e2656298c0ed32f57c55ab16ab7dc8000e9d1f))
* rename `lcd_data` to `lcd_databus` ([6a79a2a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/6a79a2a2a71a539596d67be5102ec7110493245f))
* rename `lcd16x2_i` to `lcd16x2_inst` ([837bf6e](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/837bf6ebf2d26ef6acdf5f8b15260bf070df56d7))
* **sim:** remove unused `vivado/sim/lcd16x2_tb.v` ([3f99987](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/3f9998721c7887dcc7dce6124774cf138b01b162))


### Documentations

* **README:** add instruction to create constraint file ([006590d](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/006590dc835f3a9f022387228a7320c706676343))
* **verilog:** add header comments ([aaf7b2f](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/aaf7b2f7143d041802b522cbb5bc37ba0768e25f))

## [1.1.0](https://github.com/extra2000/vivado-lcd16x2-helloworld/compare/v1.0.1...v1.1.0) (2022-05-05)


### Features

* **lcd16x2.v:** add instruction state ([f2e6800](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/f2e68001a29e026985e00004a8e1d53f97404e1a))


### Code Refactoring

* **helloworld.v:** change "HELLO WORLD" to "HITACHI\nヒタチ" ([ce29a04](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/ce29a04f9e01c897d06992a8f2b3afb7f052238d))
* **helloworld:** simplify State Machine with array ([8f6f000](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/8f6f00051ff7ce142aa4cc74980912d741b42676))
* **lcd16x2.v:** go to state -1 instead of 15 for default case ([7ba23ae](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/7ba23ae684e1357082e776b98d25af8de4c238d0))


### Styles

* **lcd16x2.v:** align comments ([424d752](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/424d752b11b5de6eee0c2fceec12b9c51407bd88))

### [1.0.1](https://github.com/extra2000/vivado-lcd16x2-helloworld/compare/v1.0.0...v1.0.1) (2022-05-04)


### Code Refactoring

* **helloworld.v:** define "HELLO WORLD" into 8-bit array ([357f0b1](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/357f0b19c64e749434f8db1dd8c8737898411180))

## 1.0.0 (2022-05-02)


### Features

* initial implementations ([8031e7f](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/8031e7f839bbbc5abed58611afe740c89feeca55))


### Documentations

* **README:** update `README.md` ([4cf6d0a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/4cf6d0aeb8aa9393b3b22038f6723414443edac0))


### Continuous Integrations

* add AppVeyor with `semantic-release` ([6baee1a](https://github.com/extra2000/vivado-lcd16x2-helloworld/commit/6baee1af3cfa0183fa9ed19c1629347e6e3406b5))
