## Progetto per il corso di Introduzione alla Programmazione per il Web - a.a. 2018-2019
### Membri del gruppo:
* Claudio Grisenti
* Davide Mazzali
* Francesco Pavanello
* Jacopo Sitran
* Luca Staboli
* Alessio Valenza

# Backend

## API
Il nostro backend è stato strutturato in modo che tutte le risorse da noi individuate come facenti parte del sistema fossero esposte tramite delle **API RESTful** implementate tramite **JAX-RS**. In questo modo abbiamo reso indipendente l'accesso alle risorse rispetto al frontend. Così abbiamo potuto separare sin da subito lo sviluppo frontend dal backend per poter lavorare in parallelo. Abbiamo fornito inoltre al frontend una documentazione in md (presente nella repo). L'utilizzo delle api porta il vantaggio di poter sviluppare anche una applicazione mobile sfruttando i servizi che abbiamo implementato. 
I servizi stateless ci hanno permesso di rendere la struttura del backend più semplice e coerente e di conseguenza sicura, mantenibile e scalabile.

## AUTHN & AUTHZ
Abbiamo gestito autenticazione e autorizzazione in due filtri separati. In particolare il primo filtro è quello di autenticazione, che controlla che l'utente sia loggato, altrimenti lo reindirizza sulla pagina di login. Se l'utente risulta autenticato viene passato il controllo al secondo filtro, di autorizzazione. Questo, mediante una lista di **capabilities** che associano ad ogni ruolo gli URL a cui può accedere (tramite regex), decide se autorizzare o meno tale utente. Nel caso un utente non sia autorizzato a visualizzare una risorsa, viene restituito un 404 anzichè un 403, per rendere la struttura del sistema trasparente rispetto ad un possibile attaccante.
Abbiamo deciso di utilizzare dei filtri in quanto permettono rendere (quasi del tutto) indipendenti i controlli dalle risorse: servlet e API possono così assumere che ogni richiesta arrivata sia legittima.
I ruoli che abbiamo individuato sono: medico di base, medico specialista, paziente, servizio sanitario provinciale, servizio sanitario nazionale. I medici quando si autenticano possono scegliere se essere pazienti o medici.

## SERVLET
Abbiamo utilizzato delle servlet per gestire le funzioni che non ci sembrava corretto implementare come API, ovvero per quelle funzionalità non modellabili come semplice accesso a risorse. In particolare, abbiamo implementato altre servlet per:
* scaricare i documenti dell'SSP e SSN, ricevute e ricette dei pazienti: questi documenti vengono generati a runtime da delle servlet e restituiti al client senza salvarli sul server. Per questa funzionalità abbiamo usato servlet invece che API perché questa funzionalità non serve effettuare operazioni CRUD sulle entità del sistema, ma a combinare dati in modo sintetica e presentarle in documenti fruibili dall'utente finale.
* recuperare la password: questa è incorporata in una servlet che gestisce la logica di tutte le fasi coinvolte in questa procedura (controlli di coerenza sulla nuova password, validità del token utilizzato, disauntenticare l'utente da altri dispositivi). Essendo questa una funzionalità, più che una risorsa, non ci è sembrato opportuno implementarla tramite servlet.
* mantenere lo stato della sezione visitata da un utente durante una sessione. Si tratta di un servizio che ha il solo scopo di migliorare la UX del sito. Serve infatti per fare in modo che ricaricando la pagina l'utente torni sulla stessa sezione su cui era prima del reload. Pertanto abbiamo ritenuto che implementarla come servlet fosse la scelta più opportuna.

## ECCEZIONI ED ERRORI
Per gestire i casi di errori, abbiamo definito ApiException e SSOServletException, sollevate quando si verificano degli errori rispettiavamente nelle API o nelle servlet. Abbiamo associato a queste eccezioni delle jsp per ritornare una risposta HTTP contente JSON o HTML. Il codice e il messaggio di errore e vengono settati nel costruttore delle eccezioni.
In questo modo la gestione degli errori è uniforme in tutto il backend e semplice da usare.

## PERSISTENCE LAYER
Per implementare il persistence layer abbiamo seguito il **pattern DAO** combinato con il **pattern Factory**. In questo modo abbiamo potuto definire interfacce di accesso ai dati indipendenti dal driver e dal DBMS usati. Ogni accesso al database passa attraverso queste interfacce.
Il DBMS che abbiamo scelto è Postgresql perché è uno dei più supportati ed utilizzati al momento.

## GESTIONE FOTO PAZIENTI
Abbiamo creato una cartella per ogni paziente, il cui nome è l'id del paziente. All'interno di questa cartella troviamo le foto di quel paziente.

# Frontend

## GRAFICA
Per la parte di grafica del sito ci siamo basati su **Bootstrap**, per avere un sito responsive e mobile-first. Nonostante ciò abbiamo riscritto i css di diversi elementi (specialmente form e table) perchè non ci soddisfavano graficamente.

## CARICAMENTO DATI REMOTI
Per la parte di caricamento dei dati nelle pagine in modo dinamico ci siamo basati su **Select2** e **Datatables**, sfruttando i dati  che vengono forniti dalle **API RESTful**, chiamate tramite ajax.

## STRUTTURA GENERALE
Dopo il login ogni utente entra nella propria dashboard gestita come una **single page application** basata su una singola jsp, in cui in ogni momento viene mostrata solo la sezione richiesta, nascondendo le altre. Questo dal punto di vista dell'utente rende il sito estremamente più responsive. Infatti, una volta che l'utente è arrivato alla sua home, le successive richieste al server servono solo per lo scambio di dati puri, dato che il codice per il resto della pagina è già presente sul browser, garantendo un'esperienza d'uso scrovole e reattiva. Inoltre nel caso di utilizzo di funzioni time demanding l'utente potrà usare altre funzionalità senza che le altre si blocchino dato che continueranno a processare in background.
Dal punto di vista del codice questo approccio ci ha permesso di ridurre al minimo il numero di jsp, così da avere meno codice duplicato e tenere il tutto più mantenibile, nonché di avere un struttura complessiva più semplice, con un workflow più gestibile.

## MAPPE
Per la visualizzazione delle Mappe per il paziente abbiamo preferito **HereMaps** a Google Maps per la non necessità di inserire i dati della carta di credito per l'utilizzo delle API. La posizione delle farmacie mostrate non sono salvate nel database ma ci vengono fornite da HereMaps a runtime, avendo così dati reali e garantendo l'indipendenza dal database. Quando un utente con una ricetta da poter utilizzare si trova vicino ad una farmacia esso riceve una mail e una notifica push.

## INTERNAZIONALIZZAZIONE
Il sito può essere visualizzato in inglese, italiano e francese, il default è l'italiano. Se l'utente non esplicita una preferenza tramite gli appositi pulsanti (presenti in ogni pagina), la si valutano le preferenze del browser del client, cercando una delle lingue supportate. Se nessuna delle lingue del browser è supportata, allora il sito viene mostrato nella lingua di deafult.


| Funzione | Tecnologia usata | Motivazione |
|-------------------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| IDE | Intellij |  E' presente un'ottima integrazione con git che ha facilitato enormemente il merge tra codice scritto da membri diversi del gruppo |
| Database | PostgreSQL |  Attualmente è probabilmente uno dei migliori Database relazionali opensource in circolazione. Inoltre è il database che abbiamo studiato al corso di Database, pertanto conosciamo già il dialetto SQL di PostgreSQL. Inoltre PostgresSQL consente sempre di ritornare ad uno stato del database consistente in caso di problemi |
| Libreria interfaccia | Bootstrap | Probabilmente la più famosa, supportata ed usata libreria grafica responsive Mobile-first in circolazione |
| Struttura del backend | API RESTful implementate con JAX-RS chiamate tramite ajax |  Gestire il backend tramite api ci ha permesso di restire il sito più facilmente espandibile perchè in questo modo le risorse del sistemi sono   accessibili in modo indipendete dall'architettura usata per rappresentarle. Inoltre così abbiamo ridotto drasticamente il numero di servlet necessario per la gestione del backend del sito |
| Librerie per il caricamento dinamico dei dati | DataTables e Select2 |  Abbiamo usato Datables e Select2 perchè si prestavano bene a sfruttare le nostre API e a gestire i dati ricevuti. Inoltre supportano numerosissime funzionalità, estensioni ed opzioni, che le rendono facilmente adattabili a molti casi d'uso |


