package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.persistence.dao.EsameDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Esame;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JDBCEsameDAO  extends JDBCDAO<Esame, Long> implements EsameDAO {

    public JDBCEsameDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM esame");
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1); // 1-based indexing
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count users", ex);
        }

        return 0L;
    }

    @Override
    public Esame getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM esame WHERE id = ?")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                Esame esame = null;
                if(rs.next()) {
                    esame = makeEsameFromRs(rs);
                }

                return esame;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }


    @Override
    public List<Esame> getAll() throws DAOException {
        List<Esame> esami = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM esame ORDER BY nome")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    esami.add(makeEsameFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return esami;
    }

    @Override
    public List<Esame> getEsamiBySuggestionNome(String suggestion) throws DAOException {
        List<Esame> listEsami = new ArrayList<>();

        if ((suggestion == null)) {
            throw new DAOException("Suggestion mandatory field", new NullPointerException("Suggestion is null"));
        }

        //è vulnerabile a SQL injection?
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM esame WHERE lower(nome) LIKE lower(?) " +
                "ORDER BY nome;")) {
            stm.setString(1, "%"+suggestion+"%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    Esame esame = makeEsameFromRs(rs);
                    listEsami.add(esame);
                }
            }

            return  listEsami;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    private Esame makeEsameFromRs(ResultSet rs) throws SQLException {
        Esame esame = new Esame();
        esame.setId(rs.getLong("id"));
        esame.setNome(rs.getString("nome"));
        esame.setDescrizione(rs.getString("descrizione"));

        return esame;
    }
}
