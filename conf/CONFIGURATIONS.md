## Configurazioni Disponibili

Tabella riepilogativa di tutte le configurazioni presenti in `conf/`, con la cartella/repository attesa e il link da usare per il clone.

| File                | Progetto      | Repository (cartella) | URL clone consigliata                          | Descrizione                                                        |
| ------------------- | ------------- | --------------------- | ---------------------------------------------- | ------------------------------------------------------------------ |
| `allura.conf`       | allura        | `allura`              | https://github.com/apache/allura.git           | Apache Allura Software Forge                                       |
| `apache_httpd.conf` | apache_httpd  | `httpd`               | https://github.com/apache/httpd.git            | Apache HTTP Server                                                 |
| `bootstrap.conf`    | bootstrap     | `bootstrap`           | https://github.com/twbs/bootstrap.git          | Twitter Bootstrap                                                  |
| `busybox.conf`      | busybox       | `busybox`             | https://git.busybox.net/busybox                | Busybox                                                            |
| `coreutils.conf`    | coreutils     | `coreutils`           | https://github.com/coreutils/coreutils.git     | GNU Coreutils collection                                           |
| `d.conf`            | dmd           | `d`                   | https://github.com/dlang/dmd.git               | DMD - D Programming Language compiler                              |
| `embb.conf`         | embb          | `embb`                | https://github.com/siemens/embb.git            | Embedded Multi-Core Building Blocks                                |
| `git.conf`          | git           | `git`                 | https://github.com/git/git.git                 | Git revision control system                                        |
| `ivy.conf`          | ivy           | `ant-ivy`             | https://github.com/apache/ant-ivy.git          | Apache Ivy, an agile dependency manager                            |
| `jailhouse.conf`    | jailhouse     | `jailhouse`           | https://github.com/siemens/jailhouse.git       | Jailhouse Hypervisor                                               |
| `jquery.conf`       | jquery        | `jquery`              | https://github.com/jquery/jquery.git           | jQuery core project                                                |
| `libressl.conf`     | libressl      | `libressl`            | https://github.com/libressl/portable.git       | LibreSSL crypto library - Official portable version                |
| `linux-kernel.conf` | linux         | `linux`               | https://github.com/torvalds/linux.git          | Linux kernel                                                       |
| `linuxptp.conf`     | linuxptp      | `linuxptp`            | https://github.com/richardcochran/linuxptp.git | linuxptp time synchronisation daemon                               |
| `llvm-project.conf` | llvm-project  | `clang`               | https://github.com/llvm/llvm-project.git       | The LLVM Project - Modular compiler and toolchain technologies     |
| `openssl.conf`      | openssl       | `openssl`             | https://github.com/openssl/openssl.git         | OpenSSL crypto library                                             |
| `php.conf`          | php           | `php-src`             | https://github.com/php/php-src.git             | PHP hypertext processor                                            |
| `qemu.conf`         | qemu          | `qemu`                | https://github.com/qemu/qemu.git               | qemu                                                               |
| `qt.conf`           | qt            | `qt`                  | https://code.qt.io/qt/qt5.git                  | Qt UI framework - Cross-platform application development framework |
| `rails.conf`        | rails         | `rails`               | https://github.com/rails/rails.git             | Ruby on Rails                                                      |
| `rtems.conf`        | rtems         | `rtems`               | https://github.com/RTEMS/rtems.git             | RTEMS - Real-Time Executive for Multiprocessor Systems             |
| `samba.conf`        | samba         | `samba`               | https://github.com/samba-team/samba.git        | Samba                                                              |
| `sqlite.conf`       | sqlite        | `sqlite`              | https://github.com/sqlite/sqlite.git           | sqlite database library                                            |
| `thrift.conf`       | Apache_Thrift | `thrift`              | https://github.com/apache/thrift.git           | Apache_Thrift                                                      |
| `toybox.conf`       | toybox        | `toybox`              | https://github.com/landley/toybox.git          | Toybox                                                             |
| `u-boot.conf`       | u-boot        | `u-boot`              | https://source.denx.de/u-boot/u-boot.git       | U-Boot bootloader                                                  |

## Configurazioni Obsolete (Non Più Valide)

Le seguenti configurazioni sono state sostituite o aggiornate e **non devono essere utilizzate** per nuove analisi. Sono mantenute solo per riferimento storico.

| File Obsoleto       | Nuova Configurazione | Motivo dell'Obsolescenza                                                                                                                                                                                                                                                                                                                                            |
| ------------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `clang_old.conf`    | `llvm-project.conf`  | **Clang è stato integrato nel monorepo LLVM** (llvm-project). Clang non ha più una repository separata. Il formato dei tag è cambiato (da `v3.x` a `llvmorg-X.Y.Z`). L'issue tracker è passato da Bugzilla (`http://llvm.org/bugs`) a GitHub Issues. La vecchia configurazione puntava a versioni obsolete (v3.0-v3.3) mentre attualmente LLVM è alla versione 21+. |
| `d_old.conf`        | `d.conf`             | **Versioni obsolete**: La configurazione vecchia utilizzava tag DMD v1.x.x (v1.0.0 - v1.8.2), mentre il progetto è ora alla versione 2.x (v2.100+). DMD v2.0 è stato rilasciato come versione stabile e le versioni v1.x sono obsolete. Il formato dei tag RC è cambiato (da `v1.x-rc0/rc1` a `v2.x.x-rc.1`).                                                       |
| `libressl_old.conf` | `libressl.conf`      | **Formato tag obsoleto e versioni vecchie**: La configurazione vecchia utilizzava il formato `libressl-v2.x.x` (v2.1.2 - v2.3.0), mentre LibreSSL ora usa il formato standard `vX.Y.Z` ed è alla versione 3.x e 4.x (v3.7+ e v4.0+). Il formato dei tag è cambiato e le versioni nella vecchia configurazione sono molto obsolete.                                  |
| `qt_old.conf`       | `qt.conf`            | **Versioni obsolete**: La configurazione vecchia utilizzava Qt 4.x (v4.5.1 - v4.8.4), mentre Qt è ora alla versione 6.x (v6.5+). Qt 5 è stato rilasciato nel 2012 e Qt 6 nel 2020. Le versioni Qt 4 sono obsolete e non più supportate. Il formato dei tag RC è cambiato (da `v4.x-rc1` a `v6.x.x-rc1`).                                                            |
