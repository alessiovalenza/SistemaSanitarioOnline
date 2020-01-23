package it.unitn.disi.wp.progetto.persistence.dao;

import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.ElemReportNazionale;
import it.unitn.disi.wp.progetto.persistence.entities.ElemReportProv;
import it.unitn.disi.wp.progetto.persistence.entities.Ricetta;

import java.sql.Timestamp;
import java.util.List;

public interface  RicettaDAO extends DAO<Ricetta, Long> {
    public static final double PREZZO_TICKET = 3.0;

    public List<Ricetta> getRicetteByPaziente(long id, boolean soloEvase, boolean soloNonEvase, String suggestion) throws DAOException;
    public boolean createRicetta(long farmaco, long medicoBase, long paziente, Timestamp emissione) throws DAOException;
    public boolean evadiRicetta(long id, long farmacia, Timestamp evasione) throws DAOException; //l'id è della ricetta
    public List<ElemReportProv> reportProvinciale(String idProvincia) throws DAOException;
    public List<ElemReportNazionale> reportNazionale() throws DAOException;
}
