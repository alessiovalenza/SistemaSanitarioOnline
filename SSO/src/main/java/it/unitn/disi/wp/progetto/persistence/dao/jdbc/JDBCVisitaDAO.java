package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.persistence.dao.VisitaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Foto;
import it.unitn.disi.wp.progetto.persistence.entities.Visita;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class JDBCVisitaDAO extends JDBCDAO<Visita, Long> implements VisitaDAO {
    public JDBCVisitaDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM visita");
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
    public Visita getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita WHERE id = ? ")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                Visita visita = null;
                if(rs.next()) {
                    visita = new Visita();
                    visita.setId(rs.getLong(1));
                    visita.setNome(rs.getString(2));
                }

                return visita;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    @Override
    public List<Visita> getAll() throws DAOException {
        List<Visita> visite = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita ORDER BY nome")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Visita visita = new Visita();
                    visita.setId(rs.getLong(1));
                    visita.setNome(rs.getString(2));
                    visite.add(visita);
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return visite;
    }

    @Override
    public List<Visita> getVisiteBySuggestionNome(String suggestion) throws DAOException {
        List<Visita> listVisite = new ArrayList<>();

        if ((suggestion == null)) {
            throw new DAOException("Suggestion mandatory field", new NullPointerException("Suggestion is null"));
        }

        //è vulnerabile a SQL injection?
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita WHERE lower(nome) LIKE lower(?) " +
                "ORDER BY nome;")) {
            stm.setString(1, "%"+suggestion+"%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    Visita visita = new Visita();
                    visita.setId(rs.getLong(1));
                    visita.setNome(rs.getString(2));
                    listVisite.add(visita);
                }
            }

            return  listVisite;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }
}
