# Documento di Ingegneria del Software - CodeFace4Smell

## Informazioni del Documento

| **Campo**          | **Valore**                                            |
| ------------------ | ----------------------------------------------------- |
| **Progetto**       | CodeFace4Smell - Sistema di Analisi Code Smell        |
| **Versione**       | 2.0 (Test Finali Definiti)                            |
| **Data**           | 21 Settembre 2025                                     |
| **Autori**         | Team IGES Project D'Auria-Santoro-Sorrentino          |
| **Tipo Documento** | Software Requirements Specification (SRS) & Test Plan |

---

## RIEPILOGO QUANTITATIVO

| **Categoria**            | **Numero** |
| ------------------------ | ---------- |
| **Requisiti Funzionali** | **13**     |
| **Test Case**            | **12**     |
| **Test d'Unità**         | **10**     |

---

## 1. REQUISITI FUNZIONALI

### 1.1 Categoria: Gestione Containerizzazione e Deploy

#### RF_CD_1 - Deploy Docker Compose

**Descrizione**: Il sistema deve supportare il deployment automatico di tutti i servizi attraverso Docker Compose con gestione delle dipendenze.  
**Priorità**: Alta  
**Test Associati**: TU_CD_1

#### RF_CD_2 - Installazione Automatica Librerie

**Descrizione**: Il sistema deve supportare l'installazione delle librerie necessarie al suo funzionamento.  
**Priorità**: Alta  
**Test Associati**: TC_CD_1, TU_CD_2, TU_CD_3

#### RF_CD_3 - Configurazione MySQL

**Descrizione**: Il sistema deve supportare l'installazione e la configurazione del database MySQL.  
**Priorità**: Alta  
**Test Associati**: TC_CD_2

### 1.2 Categoria: Analisi ed Elaborazione Dati

#### RF_AD_4 - Import Repository

**Descrizione**: Il sistema deve consentire l'import di repository da diverse sorgenti.  
**Priorità**: Alta  
**Test Associati**: TC_AD_1

#### RF_AD_5 - Analisi Multi-Release

**Descrizione**: Il sistema deve consentire l'analisi focalizzata su release e intervalli temporali specifici.  
**Priorità**: Alta  
**Test Associati**: TC_AD_2, TU_AD_1, TU_AD_2, TU_AD_3

#### RF_AD_6 - Rilevamento Community Smells

**Descrizione**: Il sistema deve implementare algoritmi per il rilevamento di community smell.  
**Priorità**: Alta  
**Test Associati**: TC_AD_3, TU_AD_3

#### RF_AD_7 - Analisi Temporale

**Descrizione**: Il sistema deve consentire l'analisi dei commit e tag nel tempo.  
**Priorità**: Alta  
**Test Associati**: TC_AD_4

#### RF_AD_8 - Clustering Sviluppatori

**Descrizione**: Il sistema deve generare gradi di clusterizzazione degli sviluppatori.  
**Priorità**: Alta  
**Test Associati**: TC_AD_5, TU_AD_4

#### RF_AD_9 - API REST

**Descrizione**: Il sistema deve esporre delle API REST per la fruizione dei dati.  
**Priorità**: Alta  
**Test Associati**: TC_AD_6

### 1.3 Categoria: Output e Visualizzazione

#### RF_OV_10 - Report Engine

**Descrizione**: Il sistema deve generare report completi.  
**Priorità**: Alta  
**Test Associati**: TC_OV_1

#### RF_OV_11 - Dashboard Web

**Descrizione**: Il sistema deve fornire una dashboard web per l'esplorazione dei risultati in tempo reale.  
**Priorità**: Media  
**Test Associati**: TC_OV_2, TU_OV_1

### 1.4 Categoria: Testing

#### RF_TE_12 - Esecuzione Test

**Descrizione**: Il sistema deve supportare l'attività di testing tramite comandi appositi.  
**Priorità**: Media  
**Test Associati**: TC_TE_1, TU_TE_1

#### RF_TE_13 - Logging

**Descrizione**: Il sistema dovrà produrre file di log dettagliati.  
**Priorità**: Media  
**Test Associati**: TC_TE_2

---

## 2. TEST CASE

### 2.1 Gestione Containerizzazione e Deploy

#### TC_CD_1 - Installazione librerie necessarie

**Obiettivo**: Verificare che le librerie siano state installate correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_CD_2

**Input**: Dockerfile

**Azione**: Eseguire comando `docker build . -t codeface4smell` e verificare che all'interno dei log non vi siano errori

**Output atteso**: Tutte le librerie vengono correttamente installate

**Esito**: PASS se il sistema si avvia e le librerie sono installate

#### TC_CD_2 - Configuration MySQL

**Obiettivo**: Verificare che MySQL venga installato e configurato correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_CD_3

**Input**: Servizio MySQL, e schema del database

**Azione**: Eseguire lo script di configurazione MySQL, o procedere alla installazione manuale

**Output atteso**: Tutte le tabelle presenti nello schema vengono create correttamente

**Esito**: PASS se il database è popolato da tutte le tabelle

### 2.2 Analisi ed Elaborazione Dati

#### TC_AD_1 - Importazione di Repository

**Obiettivo**: Verificare le repository GIT siano importabili correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_4

**Input**: URL di un progetto GIT

**Azione**: Eseguire un comando `git clone` all'interno della cartella git-repos

**Output atteso**: Il progetto GIT viene correttamente importato

**Esito**: PASS se il database è popolato da tutte le tabelle

#### TC_AD_2 - Esecuzione Analisi

**Obiettivo**: Verificare che l'analisi venga eseguita correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_5

**Input**: Sistema correttamente installato, e file .conf

**Azione**: Eseguire il comando `codeface run -c config.conf -p project.conf repo-dir/ results-dir/`

**Output atteso**: File di output generati nella cartella specificata dal comando

**Esito**: PASS l'output viene generato ed è corretto

#### TC_AD_3 - Rilevamento code smells

**Obiettivo**: Verificare l'identificazione degli smells nel codice  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_6

**Input**: Codice con smell noti

**Azione**: Eseguire il modulo detect-smells

**Output atteso**: File di output generato contenente i code smells rilevati

**Esito**: PASS se gli smell sono rilevati correttamente

#### TC_AD_4 - Analisi delle revisioni nel tempo e dei tag

**Obiettivo**: Verificare che le revisioni e i tag vengano rilevati correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_7

**Input**: Repository GIT scaricato, file di configurazione .conf

**Azione**: Eseguire l'analisi completa del progetto

**Output atteso**: Lista completa dei dati rilevati dall'analisi dei tag e delle revisioni

**Esito**: PASS se le analisi vengono generate e sono corrette

#### TC_AD_5 - Generazione di Cluster

**Obiettivo**: Verificare che i cluster vengano generati correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_8

**Input**: Repository GIT scaricato, file di configurazione .conf

**Azione**: Eseguire l'analisi completa del progetto

**Output atteso**: Lista completa dei dati rilevati dall'analisi dei tag e delle revisioni

**Esito**: PASS se le analisi vengono generate e sono corrette

#### TC_AD_6 - Esposizione API REST

**Obiettivo**: Verificare che i servizi di API vengano esposti correttamente  
**Priorità**: Alta  
**Requisito Associato**: RF_AD_9

**Input**: Progetto funzionante, script id_service

**Azione**: Lanciare il comando `node id_service.js ../codeface_testing.conf`

**Output atteso**: Servizio API REST funzionante

**Esito**: PASS se le API sono funzionanti, e rispondono correttamente

### 2.3 Output e Visualizzazione

#### TC_OV_1 - Generazione Report

**Obiettivo**: Verificare che i report siano effettivamente visibili  
**Priorità**: Alta  
**Requisito Associato**: RF_OV_10

**Input**: Analisi completata e dati presenti

**Azione**: Eseguire il programma di generazione report

**Output atteso**: Report generati e visualizzabili correttamente

**Esito**: PASS se i report sono completi e visualizzabili

#### TC_OV_2 - Gestione Interfaccia Web

**Obiettivo**: Verificare che la dashboard sia attiva e funzionante  
**Priorità**: Media  
**Requisito Associato**: RF_OV_11

**Input**: Progetti analizzati già disponibili

**Azione**: Accedere alla dashboard web con indirizzo localhost:8081

**Output atteso**: La dashboard è correttamente funzionante e visualizza i progetti

**Esito**: PASS se la dashboard viene raggiunta, e i progetti sono presenti

### 2.4 Gestione Testing

#### TC_TE_1 - Funzione comando di Testing

**Obiettivo**: Verificare che il comando di testing funzioni  
**Priorità**: Media  
**Requisito Associato**: RF_TE_12

**Input**: Sistema pronto all'uso

**Azione**: Tramite la CLI di codeface, lanciare il comando `codeface test`

**Output atteso**: Dashboard correttamente funzionante e visualizza i progetti

**Esito**: PASS se la dashboard viene raggiunta, e i progetti sono presenti

#### TC_TE_2 - Gestione logs di sistema

**Obiettivo**: Verificare che i log vengano correttamente visualizzati e salvati  
**Priorità**: Media  
**Requisito Associato**: RF_TE_13

**Input**: Sistema pronto all'uso

**Azione**: Dopo la scansione di uno o più progetti, verificare che i log di sistema vengano correttamente popolati

**Output atteso**: Log completi e coerenti

**Esito**: PASS se i log descrivono correttamente l'attività

---

## 3. TEST D'UNITÀ

### 3.1 Gestione Containerizzazione e Deploy

#### TU_CD_1 - Testing avvio della macchina

**Obiettivo**: Testare la configurazione e l'avvio della macchina  
**Requisito Associato**: RF_CD_1

**Input**: Dockerfile configurato correttamente

**Azione**: Eseguire comando `docker build . -t codeface4smell` e verificare il corretto avvio del sistema

**Output atteso**: Il sistema si avvia correttamente

**Esito**: PASS se il sistema si avvia ed è pronto all'uso

#### TU_CD_2 - Testing configurazione del sistema

**Obiettivo**: Testare la configurazione del sistema  
**Requisito Associato**: RF_CD_2

**Input**: File di testing test_configuration.py

**Azione**: Eseguire lo script in input

**Output atteso**: L'ambiente è configurato correttamente

**Esito**: PASS se lo script ritorna OK

#### TU_CD_3 - Testing librerie R

**Obiettivo**: Testare il corretto funzionamento delle librerie R  
**Requisito Associato**: RF_CD_2

**Input**: File di testing analyse_ts.r

**Azione**: Eseguire lo script in input

**Output atteso**: File e grafici in output

**Esito**: PASS se i file vengono prodotti correttamente

### 3.2 Analisi ed Elaborazione Dati

#### TU_AD_1 - Testing CppStats

**Obiettivo**: Verificare che le analisi cppstats funzionino  
**Requisito Associato**: RF_AD_5

**Input**: File da analizzare e script test_cppstats_works.py

**Azione**: Eseguire lo script test_cppstats_works.py

**Output atteso**: File .csv con metriche cppstats

**Esito**: PASS se il file viene prodotto correttamente

#### TU_AD_2 - Rilevamento Revisioni/Tag

**Obiettivo**: Validare l'esecuzione dell'analisi  
**Requisito Associato**: RF_AD_5

**Input**: Script test_batchjob.py

**Azione**: Eseguire lo script test_batchjob.py

**Output atteso**: Revisioni e tag vengono correttamente rilevati

**Esito**: PASS se l'analisi viene portata a termine

#### TU_AD_3 - Test CLI Codeface

**Obiettivo**: Verificare che la CLI di Codeface funzioni correttamente  
**Requisito Associato**: RF_AD_5, RF_AD_6

**Input**: Script test_cli.py

**Azione**: Eseguire lo script test_cli.py

**Output atteso**: Tabella con le possibili opzioni

**Esito**: PASS se le feature sono correttamente mostrate

#### TU_AD_4 - Test clustering

**Obiettivo**: Verificare la corretta generazione di cluster  
**Requisito Associato**: RF_AD_8

**Input**: File di configurazione e script test_cluster.py

**Azione**: Eseguire lo script test_cluster.py

**Output atteso**: Vengono generati file con gruppi di sviluppatori

**Esito**: PASS se i cluster vengono generati correttamente

### 3.3 Output e Visualizzazione

#### TU_OV_1 - Testing Dashboard

**Obiettivo**: Verificare il corretto funzionamento della dashboard  
**Requisito Associato**: RF_OV_11

**Input**: Script test_dashboard.py

**Azione**: Eseguire lo script test_dashboard.py

**Output atteso**: La dashboard funziona correttamente

**Esito**: PASS se la dashboard funziona correttamente

### 3.4 Testing

#### TU_TE_1 - Test generazione Log

**Obiettivo**: Verificare che vengano correttamente generati i file di log  
**Requisito Associato**: RF_TE_12

**Input**: Script test_logger.py

**Azione**: Eseguire lo script test_logger.py

**Output atteso**: Log completi delle azioni del sistema

**Esito**: PASS se i log descrivono correttamente le attività

---

## 4. MATRICE DI TRACCIABILITÀ

### 4.1 Mapping Completo Requisiti-Test

| **Requisito** | **Descrizione Breve**    | **Test Case Associati** | **Test Unità Associati**  |
| ------------- | ------------------------ | ----------------------- | ------------------------- |
| RF_CD_1       | Deploy Docker Compose    | -                       | TU_CD_1                   |
| RF_CD_2       | Installazione Automatica | TC_CD_1                 | TU_CD_2, TU_CD_3          |
| RF_CD_3       | Configurazione MySQL     | TC_CD_2                 | -                         |
| RF_AD_4       | Import Repository        | TC_AD_1                 | -                         |
| RF_AD_5       | Analisi Multi-Release    | TC_AD_2                 | TU_AD_1, TU_AD_2, TU_AD_3 |
| RF_AD_6       | Community Smells         | TC_AD_3                 | TU_AD_3                   |
| RF_AD_7       | Analisi Temporale        | TC_AD_4                 | -                         |
| RF_AD_8       | Clustering Sviluppatori  | TC_AD_5                 | TU_AD_4                   |
| RF_AD_9       | API REST                 | TC_AD_6                 | -                         |
| RF_OV_10      | Report Engine            | TC_OV_1                 | -                         |
| RF_OV_11      | Dashboard Web            | TC_OV_2                 | TU_OV_1                   |
| RF_TE_12      | Esecuzione Test          | TC_TE_1                 | TU_TE_1                   |
| RF_TE_13      | Logging                  | TC_TE_2                 | -                         |

### 4.2 Coverage Analysis

| **Categoria**                   | **Requisiti Totali** | **Test Case** | **Test Unità** | **Coverage TC** | **Coverage TU** |
| ------------------------------- | -------------------- | ------------- | -------------- | --------------- | --------------- |
| **Containerizzazione e Deploy** | 3                    | 2             | 3              | 67%             | 100%            |
| **Analisi ed Elaborazione**     | 6                    | 6             | 4              | 100%            | 67%             |
| **Output e Visualizzazione**    | 2                    | 2             | 1              | 100%            | 50%             |
| **Testing**                     | 2                    | 2             | 1              | 100%            | 50%             |
| **TOTALE**                      | **13**               | **12**        | **10**         | **92%**         | **77%**         |

---

## 5. CRITERI DI ACCETTAZIONE GLOBALI

### 5.1 Criteri Infrastructure e Deploy

- ✅ Docker build successful senza errori
- ✅ Tutte le dipendenze Python e R installate
- ✅ MySQL configurato con schema completo
- ✅ Sistema avviato e pronto all'uso

### 5.2 Criteri Analisi e Elaborazione

- ✅ Import repository Git successful
- ✅ Command `codeface run` genera output corretto
- ✅ Community smell detection funzionante
- ✅ API REST esposte e responsive

### 5.3 Criteri Output e Visualizzazione

- ✅ Report generati e visualizzabili
- ✅ Dashboard web accessibile su localhost:8081
- ✅ Progetti visualizzati correttamente nella dashboard

### 5.4 Criteri Testing e Quality Assurance

- ✅ Command `codeface test` funzionante
- ✅ Log di sistema completi e coerenti
- ✅ Tutti i script di test eseguibili senza errori

**Fine Documento**
