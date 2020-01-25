package it.unitn.disi.wp.progetto.persistence.dao;

import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.*;

import java.sql.Timestamp;
import java.util.List;

public interface UtenteDAO extends DAO<Utente, Long> {
    public static final String P = "p";
    public static final String MB = "mb";
    public static final String MS = "ms";
    public static final String F = "f";
    public static final String SSP = "ssp";
    public static final String SSN = "ssn";

    public Utente getUserByEmail(String email) throws DAOException;
    public Utente getUserByCodiceFiscale(String codiceFiscale) throws DAOException;
    public List<Utente> getPazientiByMedicoBase(long id, String suggestion) throws  DAOException; //l'id è del medico di base
    public boolean updatePassword(long id, String hashPw, long salt) throws  DAOException;  //id dell'user, password già hashata
    public boolean changeMedicoBase(long idPaziente, long idMedicoBase) throws  DAOException; // id del nuovo medico di base
    public List<Utente> getUsersBySuggestion(String suggestion, String provincia) throws DAOException;
    public List<Utente> getMediciBaseBySuggestionAndProvincia(String suggestion, String provincia) throws DAOException;
    public Utente getMedicoBaseByPaziente(long idPaziente) throws DAOException;
    public List<ElemPazienteMB> getPazientiDateMB(long idMedicoBase, String suggestion) throws DAOException;
}