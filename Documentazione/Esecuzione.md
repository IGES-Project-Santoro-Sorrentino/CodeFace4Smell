# CodeFace4Smell - Checklist Post-Avvio

Questa checklist contiene i passaggi necessari per eseguire un'analisi completa di un progetto con CodeFace4Smell dopo aver avviato il sistema.

## 📋 Preparazione Ambiente

- [ ] **Verificare la struttura delle directory**

  Assicurarsi che le seguenti cartelle esistano nella root del progetto:

  - `mldir/` - per le mailing list (file `.mbox`)
  - `results/` - per i risultati delle analisi
  - `git-repos/` - per le repository Git clonate

  Se non esistono, crearle:
  mkdir -p mldir results git-repos

  - [ ] **Verificare l'accesso al container Docker**

  Accedere al container in esecuzione:
  docker exec -it codeface4smell /bin/bash

  ## 🔧 Configurazione Progetto

- [ ] **Scegliere o creare il file di configurazione del progetto**

  I file di configurazione si trovano in `conf/`. Per QEMU è disponibile `conf/qemu.conf`.
  Per altri progetti, consultare `conf/CONFIGURATIONS.md` o creare un nuovo file di configurazione.

- [ ] **Clonare la repository del progetto da analizzare**

  Clonare la repository nella cartella `git-repos/`:

  cd git-repos/
  git clone <URL_REPOSITORY>
  cd ..
  **Nota:** Per QEMU, la repository potrebbe essere già presente. Verificare prima di clonare.

## 📊 Esecuzione Analisi

- [ ] **Eseguire l'analisi principale del progetto**

  Lanciare il comando di analisi completa:

  codeface -j8 run -c codeface.conf -p conf/qemu.conf results/ git-repos/

  **Parametri:**

  - `-j8` - numero di processi paralleli (regolabile in base alle risorse disponibili)
  - `-c codeface.conf` - file di configurazione generale
  - `-p conf/qemu.conf` - file di configurazione del progetto specifico
  - `results/` - directory di output dei risultati
  - `git-repos/` - directory contenente le repository

  ⏱️ **Tempo stimato:** Questa operazione può richiedere molto tempo a seconda della dimensione del progetto.

- [ ] **Preparare le mailing list (opzionale)**

  Se si desidera eseguire l'analisi delle mailing list:

  - [ ] Scaricare i file `.mbox` delle mailing list del progetto
  - [ ] Posizionare i file nella cartella `mldir/`

  **Esempio per QEMU:**

  - File: `mldir/gmane.comp.emulators.qemu.mbox`

  ⚠️ **Nota:** I file devono avere estensione `.mbox` e il nome deve corrispondere a quello specificato nel file di configurazione del progetto.

- [ ] **Eseguire l'analisi delle mailing list (opzionale)**

  Una volta preparati i file delle mailing list:
  codeface ml -c codeface.conf -p conf/qemu.conf -m gmane.comp.emulators.qemu results/qemu/ml mldir/
  **Parametri:**

  - `ml` - sottomando per l'analisi delle mailing list
  - `-m gmane.comp.emulators.qemu` - nome della mailing list (specificato nel file di configurazione)
  - `results/qemu/ml` - directory di output per i risultati dell'analisi mailing list
  - `mldir/` - directory contenente i file `.mbox`

- [ ] **Eseguire l'analisi socio-tecnica (opzionale)**

  Dopo aver completato l'analisi principale:
  codeface st -c codeface.conf -p conf/qemu.conf results/qemu/
  **Parametri:**

  - `st` - sottomando per l'analisi socio-tecnica
  - `results/qemu/` - directory contenente i risultati dell'analisi principale

## 📈 Visualizzazione Risultati

- [ ] **Verificare che i servizi siano attivi**

  Assicurarsi che server e dashboard siano in esecuzione:

  ./start-server.sh
  ./start-dashboard.sh

- [ ] **Accedere alla dashboard web**

  Aprire il browser e navigare a: [locahost][localhost]

[localhost]: http://localhost:8081
