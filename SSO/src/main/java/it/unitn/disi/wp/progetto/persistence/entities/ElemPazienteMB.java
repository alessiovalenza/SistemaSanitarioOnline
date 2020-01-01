package it.unitn.disi.wp.progetto.persistence.entities;

import java.sql.Timestamp;

public class ElemPazienteMB {
    private UtenteView paziente;
    private Timestamp dataUltimaVisitaBase;
    private Timestamp getDataUltimaRicetta;

    public UtenteView getPaziente() {
        return paziente;
    }

    public void setPaziente(UtenteView paziente) {
        this.paziente = paziente;
    }

    public Timestamp getDataUltimaVisitaBase() {
        return dataUltimaVisitaBase;
    }

    public void setDataUltimaVisitaBase(Timestamp dataUltimaVisitaBase) {
        this.dataUltimaVisitaBase = dataUltimaVisitaBase;
    }

    public Timestamp getGetDataUltimaRicetta() {
        return getDataUltimaRicetta;
    }

    public void setGetDataUltimaRicetta(Timestamp getDataUltimaRicetta) {
        this.getDataUltimaRicetta = getDataUltimaRicetta;
    }
}
