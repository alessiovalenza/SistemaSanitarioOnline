package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.persistence.dao.FarmacoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Farmaco;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JDBCFarmacoDAO extends JDBCDAO<Farmaco, Long> implements FarmacoDAO{

    public JDBCFarmacoDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM farmaco");
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
    public Farmaco getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM farmaco WHERE id = ?")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                Farmaco farmaco = null;

                if(rs.next()) {
                    farmaco = makeFarmacoFromRs(rs);
                }

                return farmaco;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }


    @Override
    public List<Farmaco> getAll() throws DAOException {
        List<Farmaco> esami = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM farmaco ORDER BY nome")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    esami.add(makeFarmacoFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return esami;
    }

    @Override
    public List<Farmaco> getFarmaciBySuggestionNome(String suggestion) throws DAOException {
        List<Farmaco> listFarmaci = new ArrayList<>();

        if ((suggestion == null)) {
            throw new DAOException("Suggestion mandatory field", new NullPointerException("Suggestion is null"));
        }

        //è vulnerabile a SQL injection?
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM farmaco WHERE lower(nome) LIKE lower(?) " +
                "ORDER BY nome;")) {
            stm.setString(1, "%"+suggestion+"%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    listFarmaci.add(makeFarmacoFromRs(rs));
                }
            }

            return  listFarmaci;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    private Farmaco makeFarmacoFromRs(ResultSet rs) throws SQLException {
        Farmaco farmaco = new Farmaco();
        farmaco.setId(rs.getLong("id"));
        farmaco.setNome(rs.getString("nome"));
        farmaco.setDescrizione(rs.getString("descrizione"));
        farmaco.setPrezzo(rs.getDouble("prezzo"));

        return farmaco;
    }
}
