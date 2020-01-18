# Documentazione 

- [Documentazione](#documentazione)
  * [medici base](#medici-base)
    + [getPazientiByMedicoBase](#getpazientibymedicobase)
  * [general](#general)
    + [getVisiteSuggestion](#getvisitesuggestion)
    + [getEsamiSuggestion](#getesamisuggestion)
    + [getFarmaciSuggestion](#getfarmacisuggestion)
    + [getMediciBaseSuggestion](#getmedicibasesuggestion)
  * [pazienti](#pazienti)
    + [getUtentiSuggestion](#getutentisuggestion)
    + [getPaziente](#getpaziente)
    + [getEsamiPrescritti](#getesamiprescritti)
    + [getVisiteBase](#getvisitebase)
    + [getRicette](#getricette)
    + [getVisiteSpec](#getvisitespec)
    + [getMedicoBase](#getmedicobase)
    + [changeMedicoBase](#changemedicobase)
    + [erogaEsame](#erogaesame)
    + [evadiRicetta](#evadiricetta)
    + [doRichiamo1](#dorichiamo1)
    + [doRichiamo2](#dorichiamo2)
    + [erogaVisitaSpecialistica](#erogavisitaspecialistica)
    + [creaEsamePrescritto](#creaesameprescritto)
    + [creaRicetta](#crearicetta)
    + [creaVisitaMedicoBase](#creavisitamedicobase)
    + [creaVisitaSpecialistica](#creavisitaspecialistica)
  * [utenti](#utenti)
    + [getFoto](#getfoto)
    + [addNuovaFoto](#addnuovafoto)
    + [changePassword](#changepassword)

## medici base

### getPazientiByMedicoBase
* *Description:* restituisce i pazienti di un medico base
* *Method:* `GET`
* *Path:* `/api/medicibase/<idmedico>/pazienti?datericettavisita=<boolean>&term=<string>`
* *Notes:* `se il parametro datericettavisita è omesso o settato a false, viene semplicemente mostrata la lista di pazienti del medico di base; se è settato a true, viene ritornato l'elenco dei pazienti e per ognuno la data dell'ultima ricetta e visita di base`
* *Notes 2: `il parametro term serve per fare ricerche by suggestion, può essere omesso`
* *Consumes:* `nothing`
* *Produces:* `JSON`
* *Output Example:* 

```
//con datericettavisita omesso o false

[
    {
        "id": 5,
        "email": "gianni.castagnoli@tiscali.it",
        "prov": "MN",
        "ruolo": "mb",
        "nome": "Gianni",
        "cognome": "Castagnoli",
        "sesso": "M",
        "dataNascita": "1959-08-06 12:00:00.0",
        "luogoNascita": "Canneto Sull'Oglio",
        "codiceFiscale": "CSTGNN59M06B612X",
        "idMedicoBase": 4
    }
]

// con datericettavisita = true

[
    {
        "paziente": {
            "id": 36,
            "email": "oder.dimarco@yahoo.com",
            "prov": "RE",
            "ruolo": "ms",
            "nome": "Oder",
            "cognome": "Di Marco",
            "sesso": "M",
            "dataNascita": "1985-05-05 12:00:00.0",
            "luogoNascita": "Creazzo",
            "codiceFiscale": "DMRDRO85E05D136P",
            "idMedicoBase": 16
        },
        "dataUltimaVisitaBase": "2020-01-01 07:35:17.637",
        "getDataUltimaRicetta": "2020-01-01 07:35:42.111"
    },
    {
        "paziente": {
            "id": 51,
            "email": "bino.filipek@libero.it",
            "prov": "RE",
            "ruolo": "p",
            "nome": "Bino",
            "cognome": "Filipek",
            "sesso": "M",
            "dataNascita": "1963-10-14 12:00:00.0",
            "luogoNascita": "Manduria",
            "codiceFiscale": "FLPBNI63R14E882Y",
            "idMedicoBase": 16
        }
    }
]
```

## general

### getVisiteSuggestion
* *Description:* restituisce le visite nel cui nome è presente \<term\>. Per Select2.
* *Method:* `GET`
* *Path:* `/api/general/visite/?term=<term>`
* *Consumes:* `QueryParam term: termine da cercare`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
      "id": 56,
      "nome": "Visita dermatologica"
    },
    {
      "id": 57,
      "nome": "Visita dermatologica di controllo"
    }
]
```


### getEsamiSuggestion
* *Description:* restituisce gli esami nel cui nome è presente \<term\>. Per Select2.
* *Method:* `GET`
* *Path:* `/api/general/esami/?term=<term>`
* *Consumes:* `QueryParam term: termine da cercare`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 21,
        "nome": "Derotazione del funicolo e del testicolo",
        "descrizione": "DEROTAZIONE DEL FUNICOLO E DEL TESTICOLO; Manuale; Escluso: quella associata ad orchidopessi "
    },
    {
        "id": 26,
        "nome": "Lisi di aderenze della mano [dito a scatto]",
        "descrizione": "LISI DI ADERENZE DELLA MANO [Dito a scatto] Se eventualmente effettuati sono inclusi:Visita anestesiologica ed anestesia, esami pre intervento, intervento, medicazioni, rimozione punti, visita di controllo "
    }
]
```


### getFarmaciSuggestion
* *Description:* restituisce i farmaci nel cui nome è presente \<term\>. Per Select2.
* *Method:* `GET`
* *Path:* `/api/general/farmaci/?term=<term>`
* *Consumes:* `QueryParam term: termine da cercare`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 9,
        "nome": "Amoxicillina Germed",
        "descrizione": "Amoxicillina - 12 unita' 1000 mg - uso orale",
        "prezzo": 3.27
    },
    {
        "id": 10,
        "nome": "Amoxicillina E Acido Clavulanico Ratiopharm Italia",
        "descrizione": "Amoxicillina + acido clavulanico - 12 unita' (875+125) mg - uso orale",
        "prezzo": 7.9
    }
]
```

### getMediciBaseSuggestion
* *Description:* restituisce i medici base della provincia \<idprovincia\> nel cui nome/cognome è presente \<term\>. Per Select2.
* *Method:* `GET`
* *Path:* `/api/general/farmaci/?idprovincia=<idprovincia>&term=<term>`
* *Consumes:* `QueryParam idprovincia: provincia in cui cercare
QueryParam term: termine da cercare`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 4,
        "email": "paziente.destefano@sasas.com",
        "prov": "MN",
        "ruolo": "mb",
        "nome": "Paziente",
        "cognome": "De Stefano",
        "sesso": "M",
        "dataNascita": "1966-12-18 12:00:00.0",
        "luogoNascita": "Zane'",
        "codiceFiscale": "DSTPNT66T18M145V",
        "idMedicoBase": 6
    },
    {
        "id": 6,
        "email": "defendi.lombardi@gmail.com",
        "prov": "MN",
        "ruolo": "mb",
        "nome": "Defendi",
        "cognome": "Lombardi",
        "sesso": "M",
        "dataNascita": "1980-11-01 12:00:00.0",
        "luogoNascita": "Felonica",
        "codiceFiscale": "LMBDND80S01D529I",
        "idMedicoBase": 5
    }
]
```

## pazienti

### getUtentiSuggestion 
* *Description:* restituisce gli utenti nel cui nome/cognome/email/codice fiscale è presente \<term\>. Per Select2.
* *Method:* `GET`
* *Path:* `/api/pazienti/?term=<term>`
* *Consumes:* `QueryParam term: termine da cercare`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 4,
        "email": "paziente.destefano@sasas.com",
        "prov": "MN",
        "ruolo": "mb",
        "nome": "Paziente",
        "cognome": "De Stefano",
        "sesso": "M",
        "dataNascita": "1966-12-18 12:00:00.0",
        "luogoNascita": "Zane'",
        "codiceFiscale": "DSTPNT66T18M145V",
        "idMedicoBase": 6
    }
]
```

### getPaziente
* *Description:* restituisce il paziente con id <idpaziente>
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>`
* *Consumes:* `nothing`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 4,
        "email": "paziente.destefano@sasas.com",
        "prov": "MN",
        "ruolo": "mb",
        "nome": "Paziente",
        "cognome": "De Stefano",
        "sesso": "M",
        "dataNascita": "1966-12-18 12:00:00.0",
        "luogoNascita": "Zane'",
        "codiceFiscale": "DSTPNT66T18M145V",
        "idMedicoBase": 6
    }
]
```

### getEsamiPrescritti
* *Description:* restituisce gli esami prescritti di un paziente.
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>/esamiprescritti/?erogationly=<erogationly>&nonerogationly=<nonerogationly>`
* *Consumes:* `QueryParam erogationly: (boolean) true per ricevere SOLO gli esami erogati
QueryParam nonerogationly: (boolean) true per ricevere SOLO gli esami non erogati `
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 9,
        "esame": {
            "id": 4,
            "nome": "Osteoclasia",
            "descrizione": "OSTEOCLASIA; Manuale o strumentale"
        },
        "medicoBase": {
            "id": 6,
            "email": "defendi.lombardi@gmail.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Defendi",
            "cognome": "Lombardi",
            "sesso": "M",
            "dataNascita": "1980-11-01 12:00:00.0",
            "luogoNascita": "Felonica",
            "codiceFiscale": "LMBDND80S01D529I",
            "idMedicoBase": 5
        },
        "paziente": {
            "id": 58,
            "email": "restituto.lazar@hotmail.com",
            "prov": "MN",
            "ruolo": "p",
            "nome": "Restituto",
            "cognome": "Lazar",
            "sesso": "M",
            "dataNascita": "1969-10-13 12:00:00.0",
            "luogoNascita": "Correggio",
            "codiceFiscale": "LZRRTT69R13D037V",
            "idMedicoBase": 6
        },
        "prescrizione": "2019-12-22 11:37:16.631"
    }
]
```
### getVisiteBase
* *Description:* restituisce le visite base di un paziente
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>/visitebase`
* *Consumes:* `nothing`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 1,
        "medicoBase": {
            "id": 6,
            "email": "defendi.lombardi@gmail.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Defendi",
            "cognome": "Lombardi",
            "sesso": "M",
            "dataNascita": "1980-11-01 12:00:00.0",
            "luogoNascita": "Felonica",
            "codiceFiscale": "LMBDND80S01D529I",
            "idMedicoBase": 5
        },
        "paziente": {
            "id": 58,
            "email": "restituto.lazar@hotmail.com",
            "prov": "MN",
            "ruolo": "p",
            "nome": "Restituto",
            "cognome": "Lazar",
            "sesso": "M",
            "dataNascita": "1969-10-13 12:00:00.0",
            "luogoNascita": "Correggio",
            "codiceFiscale": "LZRRTT69R13D037V",
            "idMedicoBase": 6
        },
        "erogazione": "2019-12-22 11:13:20.610",
        "anamnesi": "al ga an po ad fardur àù````^^~#@[°°Æ"
    }
]
```
### getRicette
* *Description:* restituisce le ricette di un paziente
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>/ricette/?evaseonly=<evaseonly>&nonevaseonly=<nonevaseonly>`
* *Consumes:* `QueryParam evaseonly: (boolean) true per ricevere SOLO le ricette evase
QueryParam nonevaseonly: (boolean) true per ricevere SOLO le ricette non evase`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 2,
        "farmaco": {
            "id": 50,
            "nome": "Esomeprazolo Doc",
            "descrizione": "Esomeprazolo - 14 unita' 40 mg - uso orale",
            "prezzo": 7.64
        },
        "medicoBase": {
            "id": 6,
            "email": "defendi.lombardi@gmail.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Defendi",
            "cognome": "Lombardi",
            "sesso": "M",
            "dataNascita": "1980-11-01 12:00:00.0",
            "luogoNascita": "Felonica",
            "codiceFiscale": "LMBDND80S01D529I",
            "idMedicoBase": 5
        },
        "paziente": {
            "id": 58,
            "email": "restituto.lazar@hotmail.com",
            "prov": "MN",
            "ruolo": "p",
            "nome": "Restituto",
            "cognome": "Lazar",
            "sesso": "M",
            "dataNascita": "1969-10-13 12:00:00.0",
            "luogoNascita": "Correggio",
            "codiceFiscale": "LZRRTT69R13D037V",
            "idMedicoBase": 6
        },
        "emissione": "2019-12-22 11:27:13.907"
    }
]
```
### getVisiteSpec
* *Description:* restituisce le visite specialistiche di un paziente
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>/visitespecialistiche/?erogateonly=<erogateonly>&nonerogateonly=<nonerogateonly>`
* *Consumes:* `QueryParam erogateonly: (boolean) true per ricevere SOLO le visite spec erogate
QueryParam nonerogateonly: (boolean) true per ricevere SOLO le visite spec non erogate`
* *Produces:* `JSON`
* *Output Example:* 

```
[
    {
        "id": 5,
        "medicoSpecialista": {
            "id": 25,
            "email": "giovancarla.ferro@libero.it",
            "prov": "MN",
            "ruolo": "ms",
            "nome": "Giovancarla",
            "cognome": "Ferro",
            "sesso": "F",
            "dataNascita": "1952-10-27 12:00:00.0",
            "luogoNascita": "Pescantina",
            "codiceFiscale": "FRRGNC52R67G481F",
            "idMedicoBase": 5
        },
        "medicoBase": {
            "id": 6,
            "email": "defendi.lombardi@gmail.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Defendi",
            "cognome": "Lombardi",
            "sesso": "M",
            "dataNascita": "1980-11-01 12:00:00.0",
            "luogoNascita": "Felonica",
            "codiceFiscale": "LMBDND80S01D529I",
            "idMedicoBase": 5
        },
        "paziente": {
            "id": 58,
            "email": "restituto.lazar@hotmail.com",
            "prov": "MN",
            "ruolo": "p",
            "nome": "Restituto",
            "cognome": "Lazar",
            "sesso": "M",
            "dataNascita": "1969-10-13 12:00:00.0",
            "luogoNascita": "Correggio",
            "codiceFiscale": "LZRRTT69R13D037V",
            "idMedicoBase": 6
        },
        "prescrizione": "2019-12-22 11:27:37.237",
        "erogazione": "2019-12-22 11:30:18.930",
        "anamnesi": "di cal vaga a laurà",
        "visita": {
            "id": 4,
            "nome": "Consulenza anatomopatologica per revisione diagnostica di preparati allestiti in altra sede (prescrivibile una sola volta per lo stesso episodio patologico)"
        }
    }
]
```

### getMedicoBase
* *Description:* restituisce il medico base di un paziente
* *Method:* `GET`
* *Path:* `/api/pazienti/<idpaziente>/medicobase`
* *Consumes:* `nothing`
* *Produces:* `JSON`
* *Output Example:* 

```
{
    "id": 6,
    "email": "defendi.lombardi@gmail.com",
    "prov": "MN",
    "ruolo": "mb",
    "nome": "Defendi",
    "cognome": "Lombardi",
    "sesso": "M",
    "dataNascita": "1980-11-01 12:00:00.0",
    "luogoNascita": "Felonica",
    "codiceFiscale": "LMBDND80S01D529I",
    "idMedicoBase": 5
}
```

### changeMedicoBase
* *Description:* cambia il medico base di un paziente
* *Method:* `PUT`
* *Path:* `/api/pazienti/<idpaziente>/medicobase`
* *Consumes:* `FormParam idmedicobase: (long) id del nuovo medico`
* *Produces:* `JSON`
* *Output Example:* 

```
{
    "id": 6,
    "email": "defendi.lombardi@gmail.com",
    "prov": "MN",
    "ruolo": "mb",
    "nome": "Defendi",
    "cognome": "Lombardi",
    "sesso": "M",
    "dataNascita": "1980-11-01 12:00:00.0",
    "luogoNascita": "Felonica",
    "codiceFiscale": "LMBDND80S01D529I",
    "idMedicoBase": 5
}
```

### erogaEsame
* *Description:* eroga (post esecuzione) un esame per un dato paziente
* *Method:* `PUT`
* *Path:* `/api/pazienti/<idpaziente>/esamiprescritti/<idesameprescritto>/`
* *Consumes:* `FormParam esito: (String) esito dell'esame erogato`
* *Produces:* `nothing`

### evadiRicetta
* *Description:* evadi una ricetta ad un dato paziente
* *Method:* `PUT`
* *Path:* `/api/pazienti/<idpaziente>/ricette/<idricetta>/`
* *Consumes:* `FormParam idfarmacia: (long) id della farmacia che evade la ricetta`
* *Produces:* `nothing`

### doRichiamo1
* *Description:* prescrive il richiamo 1 
* *Method:* `POST`
* *Path:* `/api/pazienti/richiamo1`
* *Consumes:* `FormParam infeta: (int) limite inferiore dell'eta
FormParam supeta: (int) limite inferiore dell'eta
FormParam idprovincia: (String)
FormParam idesame: (long) id dell'esame del richiamo`
* *Produces:* `nothing`

### doRichiamo2
* *Description:* prescrive il richiamo 2 
* *Method:* `POST`
* *Path:* `/api/pazienti/richiamo2`
* *Consumes:* `FormParam infeta: (int) limite inferiore dell'eta
FormParam idprovincia: (String)
FormParam idesame: (long) id dell'esame del richiamo`
* *Produces:* `nothing`

### erogaVisitaSpecialistica
* *Description:* eroga una visita specialistica 
* *Method:* `PUT`
* *Path:* `/api/pazienti/<idpaziente>/visitespecialistiche/<idvisitaspecialistica>`
* *Consumes:* `FormParam anamnesi: (String) anamnesi della visita
FormParam idmedicospec: (long) id del medico specialista che eroga la visita`
* *Produces:* `nothing`

### creaEsamePrescritto
* *Description:* prescrivi un esame ad un dato paziente
* *Method:* `POST`
* *Path:* `/api/pazienti/<idpaziente>/esamiprescritti`
* *Consumes:* `FormParam idmedicobase: (long) id del medico base che prescrive l'esame
FormParam idesame: (long) id dell'esame prescritto`
* *Produces:* `nothing`

### creaRicetta
* *Description:* prescrive una ricetta ad un dato paziente
* *Method:* `POST`
* *Path:* `/api/pazienti/<idpaziente>/ricette`
* *Consumes:* `FormParam idmedicobase: (long) id del medico base che prescrive il farmaco
FormParam idfarmaco: (long) id del farmaco prescritto`
* *Produces:* `nothing`

### creaVisitaMedicoBase
* *Description:* crea una visita presso un medico base
* *Method:* `POST`
* *Path:* `/api/pazienti/<idpaziente>/visitebase`
* *Consumes:* `FormParam idmedicobase: (long) id del medico base che ha fatto la visita
FormParam anamnesi: (String) anamnesi della visita`
* *Produces:* `nothing`

### creaVisitaSpecialistica
* *Description:* crea una visita specialistica
* *Method:* `POST`
* *Path:* `/api/pazienti/<idpaziente>/visitespecialistiche`
* *Consumes:* `FormParam idmedicobase: (long) id del medico base che prescrive la visita
FormParam idvisita: (long) id della visita`
* *Produces:* `nothing`

## utenti

### getFoto
* *Description:* restituisce le foto di un utente
* *Method:* `GET`
* *Path:* `/api/utenti/<idutente>/foto`
* *Consumes:* `nothing`
* *Produces:* `JSON`
* *Output Example:* 
```
[
    {
        "id": 10,
        "caricamento": "2019-05-17 12:00:00.0",
        "paziente": {
            "id": 4,
            "email": "paziente.destefano@sasas.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Paziente",
            "cognome": "De Stefano",
            "sesso": "M",
            "dataNascita": "1966-12-18 12:00:00.0",
            "luogoNascita": "Zane'",
            "codiceFiscale": "DSTPNT66T18M145V",
            "idMedicoBase": 6
        }
    },
    {
        "id": 11,
        "caricamento": "2019-12-01 12:00:00.0",
        "paziente": {
            "id": 4,
            "email": "paziente.destefano@sasas.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Paziente",
            "cognome": "De Stefano",
            "sesso": "M",
            "dataNascita": "1966-12-18 12:00:00.0",
            "luogoNascita": "Zane'",
            "codiceFiscale": "DSTPNT66T18M145V",
            "idMedicoBase": 6
        }
    },
    {
        "id": 12,
        "caricamento": "2019-04-10 12:00:00.0",
        "paziente": {
            "id": 4,
            "email": "paziente.destefano@sasas.com",
            "prov": "MN",
            "ruolo": "mb",
            "nome": "Paziente",
            "cognome": "De Stefano",
            "sesso": "M",
            "dataNascita": "1966-12-18 12:00:00.0",
            "luogoNascita": "Zane'",
            "codiceFiscale": "DSTPNT66T18M145V",
            "idMedicoBase": 6
        }
    }
]
```

### addNuovaFoto
* *Description:* inserisce una nuova foto all'utente specificato (salva foto sul server e entry nel db)
* *Method:* `POST`
* *Path:* `/api/utenti/<idutente>/foto`
* *Consumes:* `mutlipart form data; FormDataParam foto: il file della foto da caricare`
* *Produces:* `nothing`

### changePassword
* *Description:* cambia la password di un utente
* *Method:* `PUT`
* *Path:* `/api/utenti/<idutente>/password`
* *Consumes:* `FormParam password: (String) nuova password`
* *Produces:* `nothing`

