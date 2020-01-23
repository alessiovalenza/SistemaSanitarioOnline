package it.unitn.disi.wp.progetto.persistence.dao;

import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.VisitaMedicoSpecialista;

import java.sql.Timestamp;
import java.util.List;

public interface  VisitaMedicoSpecialistaDAO extends DAO<VisitaMedicoSpecialista, Long> {
    public static final double PREZZO_TICKET = 50.0;

    public boolean creaVisitaSpecilistica(long medicoBase, long paziente, long visita, Timestamp prescrizione) throws DAOException;
    public boolean erogaVisitaSpecialistica(long id, Timestamp erogazione, String anamnesi, long medicoSpecialista) throws DAOException; //l'id è della visita specialistica
    public List<VisitaMedicoSpecialista> getVisiteSpecByPaziente(long id, boolean soloErogate, boolean soloNonErogate, String suggestion) throws  DAOException; //l'id è del paziente
}