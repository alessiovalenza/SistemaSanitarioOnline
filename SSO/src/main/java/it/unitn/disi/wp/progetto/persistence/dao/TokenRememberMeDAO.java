package it.unitn.disi.wp.progetto.persistence.dao;

import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.*;

public interface TokenRememberMeDAO extends DAO<TokenRememberMe, String> {
    public boolean creaToken(String token, long idUtente) throws DAOException;
    public boolean deleteToken(String token) throws DAOException;
    public boolean deleteTokenByUtente(long idUtente) throws DAOException;
}