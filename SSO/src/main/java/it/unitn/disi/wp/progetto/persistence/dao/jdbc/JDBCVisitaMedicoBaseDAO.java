package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaMedicoBaseDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.persistence.entities.VisitaMedicoBase;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class JDBCVisitaMedicoBaseDAO extends JDBCDAO<VisitaMedicoBase, Long> implements VisitaMedicoBaseDAO{

    public JDBCVisitaMedicoBaseDAO(Connection con) {
        super(con);
    }

    @Override
    public boolean creaVisitaMedicoBase(long medicoBase, long paziente, Timestamp erogaz, String anamnesi) throws DAOException{
        boolean noErr = false;
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO visita_base (medicobase, paziente, erogazione, anamnesi) VALUES (?, ?, ?, ?);")){
            stm.setLong(1, medicoBase); // 1-based indexing
            stm.setLong(2, paziente); // 1-based indexing
            stm.setTimestamp(3, erogaz); // 1-based indexing
            stm.setString(4, anamnesi); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }
        return noErr;
    }

    @Override
    public List<VisitaMedicoBase> getVisiteBaseByPaziente(long id) throws DAOException {
        List<VisitaMedicoBase> visite = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita_base v " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id WHERE v.paziente = ? " +
                "ORDER BY v.erogazione DESC;")){
            stm.setLong(1, id); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()){
                    VisitaMedicoBase visita = makeVisitaBaseFromRs(rs);
                    visite.add(visita);
                }
            }

            return  visite;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM visita_base");
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
    public VisitaMedicoBase getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita_base v " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id " +
                "WHERE v.id = ? ")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                VisitaMedicoBase visitaMedicoBase = null;

                if(rs.next()) {
                    visitaMedicoBase = makeVisitaBaseFromRs(rs);
                }

                return visitaMedicoBase;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    @Override
    public List<VisitaMedicoBase> getAll() throws DAOException {
        List<VisitaMedicoBase> visite = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita_base v " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id " +
                "ORDER BY v.paziente")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    visite.add(makeVisitaBaseFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return visite;
    }

    private VisitaMedicoBase makeVisitaBaseFromRs(ResultSet rs) throws SQLException {
        VisitaMedicoBase visita = new VisitaMedicoBase();
        visita.setId(rs.getLong(1));
        visita.setErogazione(rs.getTimestamp(4));
        visita.setAnamnesi(rs.getString(5));

        Utente medicoBase = new Utente();
        medicoBase.setId(rs.getLong(6));
        medicoBase.setEmail(rs.getString(7));
        medicoBase.setPassword(rs.getString(8));
        medicoBase.setSalt(rs.getLong(9));
        medicoBase.setProv(rs.getString(10));
        medicoBase.setRuolo(rs.getString(11));
        medicoBase.setNome(rs.getString(12));
        medicoBase.setCognome(rs.getString(13));
        medicoBase.setSesso(rs.getString(14).charAt(0));
        medicoBase.setDataNascita(rs.getDate(15));
        medicoBase.setLuogoNascita(rs.getString(16));
        medicoBase.setCodiceFiscale(rs.getString(17));
        medicoBase.setIdMedicoBase(rs.getLong(18));

        Utente paziente = new Utente();
        paziente.setId(rs.getLong(19));
        paziente.setEmail(rs.getString(20));
        paziente.setPassword(rs.getString(21));
        paziente.setSalt(rs.getLong(22));
        paziente.setProv(rs.getString(23));
        paziente.setRuolo(rs.getString(24));
        paziente.setNome(rs.getString(25));
        paziente.setCognome(rs.getString(26));
        paziente.setSesso(rs.getString(27).charAt(0));
        paziente.setDataNascita(rs.getDate(28));
        paziente.setLuogoNascita(rs.getString(29));
        paziente.setCodiceFiscale(rs.getString(30));
        paziente.setIdMedicoBase(rs.getLong(31));

        visita.setMedicoBase(Utilities.fromUtenteToUtenteView(medicoBase));
        visita.setPaziente(Utilities.fromUtenteToUtenteView(paziente));

        return visita;
    }
}
