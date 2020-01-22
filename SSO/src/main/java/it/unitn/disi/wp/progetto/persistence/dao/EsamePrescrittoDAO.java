package it.unitn.disi.wp.progetto.persistence.dao;

import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.EsamePrescritto;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;

import java.sql.Timestamp;
import java.util.List;

public interface EsamePrescrittoDAO extends DAO<EsamePrescritto, Long> {
    public static final double PREZZO_TICKET = 11.0;

    public boolean creaEsamePrescritto(long esame, long medicoBase, long paziente, Timestamp prescriz) throws DAOException;
    public List<EsamePrescritto> getEsamiPrescrittiByPaziente(long id, boolean soloErogati, boolean soloNonErogati, String suggestion) throws  DAOException; //l'id è del paziente
    public boolean erogaEsamePrescritto(long id, Timestamp erogazione, String esito) throws DAOException; //l'id è dell'esame prescritto
    public List<Utente> richiamoRangeEta(int infEta, int supEta, String idProvincia, long esame, Timestamp prescriz) throws DAOException; //estremi inclusi
    public List<Utente> richiamoSuccessivoMinEta(int infEta, String idProvincia, long esame, Timestamp prescriz) throws DAOException; //estremo incluso
}
