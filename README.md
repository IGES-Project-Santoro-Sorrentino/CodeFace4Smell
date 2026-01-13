# CodeFace4Smell - Guida all'Installazione e Utilizzo

<div align="center">
  
  ### Progetto Universitario

  📚 **Università degli Studi di Salerno**
  
  **Sviluppato da:**
  - **Gabriele Santoro**
  - **Pasquale Sorrentino**
  
  🎓 **Corso di Laurea Magistrale in Informatica (L-18)**
  
  📖 **Esame:** Ingegneria, Gestione ed Evoluzione del Software
  
</div>

---

## Indice

- [Requisiti](#requisiti)
- [Installazione](#installazione)
- [Configurazione e Avvio](#configurazione-e-avvio)
- [Analisi di un Progetto](#analisi-di-un-progetto)
- [Analisi Aggiuntive](#analisi-aggiuntive)
- [Testing](#testing)
- [Visualizzazione dei Risultati](#visualizzazione-dei-risultati)
- [Gestione del Container Docker](#gestione-del-container-docker)

## Requisiti

Prima di iniziare, assicurati di avere installato sul tuo sistema:

- **Python 3**
- **Docker**

## Installazione

### Passo 1: Clonare la Repository

Clona la repository del progetto dal repository GitHub:

```bash
git clone https://github.com/IGES-Project-Santoro-Sorrentino/CodeFace4Smell
cd CodeFace4Smell
```

### Passo 2: Build dell'Immagine Docker

⚠️ **IMPORTANTE**: Questo passaggio è necessario **solo al primo avvio**. Una volta completata la build, non sarà più necessario ripeterla.

Costruisci l'immagine Docker del progetto. Questo processo potrebbe richiedere diversi minuti:

```bash
docker build . -t codeface4smell
```

Questo comando:

- `docker build .` - costruisce un'immagine Docker dalla directory corrente (che contiene il Dockerfile)
- `-t codeface4smell` - assegna il tag "codeface4smell" all'immagine creata

### Passo 3: Avvio del Container Docker

**Per il primo avvio** e **per tutti gli avvii successivi**, utilizza questo comando:

```bash
docker run -dit --name codeface4smell -p 8080:8081 -p 8081:8081 -p 22:22 codeface4smell
```

Spiegazione dei parametri:

- `-dit` - esegue il container in modalità detached (background), interattiva e con terminale
- `--name codeface4smell` - assegna il nome "codeface4smell" al container
- `-p 8080:8081` - mappa la porta 8081 del container sulla porta 8080 dell'host (necessaria per il server)
- `-p 8081:8081` - mappa la porta 8081 del container sulla porta 8081 dell'host (necessaria per il server)
- `-p 22:22` - mappa la porta 22 per l'accesso SSH alla macchina
- `codeface4smell` - nome dell'immagine da utilizzare

💡 **Nota**: Dopo il primo avvio, se hai fermato il container, puoi riavviarlo semplicemente con:

```bash
docker start codeface4smell
```

### Passo 4: Accesso al Container

Connettiti al container Docker in esecuzione:

```bash
docker exec -it codeface4smell /bin/bash
```

Questo comando:

- `docker exec` - esegue un comando in un container in esecuzione
- `-it` - modalità interattiva con terminale
- `codeface4smell` - nome del container
- `/bin/bash` - avvia una shell bash all'interno del container

## Configurazione e Avvio

Una volta all'interno del container, è necessario avviare i servizi necessari.

### Passo 5: Avvio del Server

Avvia il server con:

```bash
./start-server.sh
```

### Passo 6: Avvio della Dashboard

Avvia la dashboard web con:

```bash
./start-dashboard.sh
```

## Analisi di un Progetto

### Passo 7: Configurazione del Progetto

CodeFace4Smell include già alcuni file di configurazione predefiniti nella cartella `conf/`. Puoi utilizzarne uno esistente o crearne uno nuovo per decidere quale progetto analizzare.

I file di configurazione si trovano in:

- `codeface.conf` - configurazione generale di CodeFace
- `conf/` - directory con le configurazioni specifiche dei progetti (es. `conf/qemu.conf`)

### Passo 8: Clonare il Progetto da Analizzare

Clona la repository del progetto che desideri analizzare. Esiste già una cartella predisposta chiamata `git-repos/`, ma puoi utilizzare qualsiasi altra directory:

```bash
cd git-repos/
git clone <url-della-repository-del-progetto>
cd ..
```

### Passo 9: Esecuzione dell'Analisi Principale

Dalla directory principale di CodeFace, lancia il comando di analisi:

```bash
codeface -j8 run -c codeface.conf -p conf/qemu.conf results/ git-repos/
```

**Spiegazione dettagliata dei parametri:**

- `codeface` - comando principale del tool
- `-j8` - specifica il numero di processi paralleli da utilizzare (in questo caso 8). Aumentare questo valore velocizza l'analisi ma richiede più risorse; diminuirlo la rallenta ma richiede meno risorse
- `run` - sottomando per eseguire l'analisi completa del progetto
- `-c codeface.conf` - specifica il file di configurazione generale di CodeFace da utilizzare (già predefinito nel progetto)
- `-p conf/qemu.conf` - indica il file di configurazione specifico del progetto da analizzare (in questo esempio QEMU)
- `results/` - directory in cui verranno salvati i risultati dell'analisi
- `git-repos/` - directory contenente la repository clonata del progetto da analizzare

## Analisi Aggiuntive

Una volta completata l'analisi principale, puoi eseguire due tipi di analisi aggiuntive:

### Analisi della Mailing List

L'analisi della mailing list richiede l'importazione manuale delle mailing list del progetto.

**Passo 1:** Scarica le mailing list del progetto e inseriscile manualmente nella cartella `mldir/`:

⚠️ **IMPORTANTE**: Le mailing list devono avere l'estensione `.mbox`

```bash
# Esempio: posiziona i file .mbox nella directory mldir/
# mldir/gmane.comp.emulators.qemu.mbox
```

**Passo 2:** Esegui l'analisi della mailing list:

```bash
codeface ml -c codeface.conf -p conf/qemu.conf git-repos/ mldir/
```

**Spiegazione dei parametri:**

- `ml` - sottomando per l'analisi delle mailing list
- `-c codeface.conf` - file di configurazione generale di CodeFace
- `-p conf/qemu.conf` - file di configurazione del progetto specifico
- `git-repos/` - directory contenente la repository del progetto
- `mldir/` - directory contenente le mailing list scaricate

### Analisi Socio-Tecnica

L'analisi socio-tecnica esamina le relazioni tra gli aspetti sociali (sviluppatori) e tecnici (codice) del progetto:

```bash
codeface st -c codeface.conf -p conf/qemu.conf results/
```

**Spiegazione dei parametri:**

- `st` - sottomando per l'analisi socio-tecnica (socio-technical)
- `-c codeface.conf` - file di configurazione generale di CodeFace
- `-p conf/qemu.conf` - file di configurazione del progetto specifico
- `results/` - directory contenente i risultati dell'analisi principale (da cui verranno estratti i dati per l'analisi socio-tecnica)

## Testing

CodeFace4Smell include una suite di test per verificare il corretto funzionamento del sistema. Per eseguire i test, è necessario avviare il server in modalità test.

### Passo 1: Avviare il Server in Modalità Test

Prima di eseguire i test, è necessario avviare il server in modalità test con il seguente comando:

```bash
./start-server.sh test
```

Questo comando:

- Avvia il server con le configurazioni specifiche per l'ambiente di testing
- Prepara il sistema per l'esecuzione dei test automatizzati

### Passo 2: Eseguire i Test

Una volta che il server è stato avviato in modalità test, esegui la suite di test con:

```bash
codeface test -c codeface_testing.conf
```

**Spiegazione dei parametri:**

- `test` - sottomando per eseguire la suite di test
- `-c codeface_testing.conf` - file di configurazione specifico per il testing (contiene impostazioni e parametri ottimizzati per l'ambiente di test)

### Passo 3: Attendere il Completamento

Attendi che tutti i test vengano eseguiti. Durante l'esecuzione, verranno visualizzate informazioni sui test in corso e sui loro risultati. Al termine, verifica che tutti i test siano stati completati con successo.

### Tornare alla Modalità Normale

⚠️ **IMPORTANTE**: Dopo aver completato i test, se desideri tornare a eseguire analisi normali, devi riavviare il server **senza** il parametro `test`:

```bash
./start-server.sh
```

Questo riporterà il server alla modalità di produzione, permettendoti di eseguire nuovamente le analisi sui progetti.

## Visualizzazione dei Risultati

### Passo 10: Accesso alla Dashboard

Una volta completate le analisi, puoi visualizzare i risultati attraverso la dashboard web.

Apri il tuo browser e vai all'indirizzo:

```
http://localhost:8081
```

Dalla dashboard potrai:

- Visualizzare tutti i progetti analizzati
- Esplorare le metriche raccolte
- Analizzare i risultati delle diverse analisi eseguite
- Visualizzare grafici e statistiche dettagliate

## Gestione del Container Docker

### Fermare il Container

Quando hai terminato di lavorare con CodeFace4Smell, è importante fermare correttamente il container per liberare risorse di sistema.

Per fermare il container in esecuzione:

```bash
docker stop codeface4smell
```

Questo comando:

- `docker stop` - invia un segnale di terminazione al container
- `codeface4smell` - nome del container da fermare

Il container verrà fermato in modo sicuro, preservando tutti i dati e le configurazioni.

### Riavviare il Container

Dopo aver fermato il container, puoi riavviarlo in qualsiasi momento senza dover rifare la build:

```bash
docker start codeface4smell
```

Successivamente, accedi nuovamente al container con:

```bash
docker exec -it codeface4smell /bin/bash
```

E riavvia i servizi necessari (server e dashboard).

### Rimuovere Completamente il Container

Se desideri rimuovere completamente il container (ad esempio per crearne uno nuovo con configurazioni diverse), devi prima fermarlo e poi rimuoverlo:

**Passo 1:** Ferma il container (se è in esecuzione):

```bash
docker stop codeface4smell
```

**Passo 2:** Rimuovi il container:

```bash
docker rm codeface4smell
```

Questo comando:

- `docker rm` - rimuove il container specificato
- `codeface4smell` - nome del container da rimuovere

⚠️ **ATTENZIONE**: La rimozione del container eliminerà **tutti i dati** contenuti al suo interno, inclusi i risultati delle analisi. Assicurati di aver salvato tutti i dati importanti prima di procedere.

### Rimuovere l'Immagine Docker

Se vuoi liberare ulteriore spazio disco, puoi anche rimuovere l'immagine Docker:

```bash
docker rmi codeface4smell
```

💡 **Nota**: Dopo aver rimosso l'immagine, sarà necessario rifare la build (Passo 2) quando vorrai utilizzare nuovamente CodeFace4Smell.

### Comandi Docker Utili

Ecco alcuni comandi utili per gestire Docker:

- **Verificare i container in esecuzione:**

  ```bash
  docker ps
  ```

- **Verificare tutti i container (anche quelli fermati):**

  ```bash
  docker ps -a
  ```

- **Verificare le immagini disponibili:**

  ```bash
  docker images
  ```

- **Visualizzare i log del container:**

  ```bash
  docker logs codeface4smell
  ```

- **Visualizzare l'utilizzo delle risorse:**
  ```bash
  docker stats codeface4smell
  ```

## Note Aggiuntive

- Il parametro `-j` nel comando di analisi principale può essere regolato in base alle risorse disponibili sul tuo sistema
- I file di configurazione dei progetti nella directory `conf/` possono essere modificati o duplicati per adattarli alle tue esigenze
- Assicurati che le porte 8080, 8081 e 22 siano disponibili sul tuo sistema prima di avviare il container
- La build dell'immagine Docker è necessaria **solo una volta**; successivamente potrai riutilizzare la stessa immagine

## Troubleshooting

Se incontri problemi durante l'installazione o l'esecuzione:

1. Verifica che Docker sia in esecuzione: `docker ps`
2. Controlla i log del container: `docker logs codeface4smell`
3. Assicurati che le porte necessarie non siano già in uso
4. Verifica di avere spazio sufficiente su disco per la build e l'analisi
5. Se il container non si avvia, prova a rimuoverlo completamente e ricrearlo

## Supporto

Per ulteriori informazioni o supporto, consulta la repository del progetto:
https://github.com/IGES-Project-Santoro-Sorrentino/CodeFace4Smell
