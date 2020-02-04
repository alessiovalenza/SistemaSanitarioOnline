package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.EsamePrescrittoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Esame;
import it.unitn.disi.wp.progetto.persistence.entities.EsamePrescritto;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JDBCEsamePrescrittoDAO extends JDBCDAO<EsamePrescritto, Long> implements EsamePrescrittoDAO{

    public JDBCEsamePrescrittoDAO(Connection con) {
        super(con);
    }

    public List<EsamePrescritto> getEsamiPrescrittiByPaziente(long id, boolean soloErogati, boolean soloNonErogati, String suggestion) throws DAOException {
        if(soloErogati && soloNonErogati) {
            throw new DAOException("Non sense query");
        }

        List<EsamePrescritto> listOfEsamePrescritto = new ArrayList<>();

        String statement = "";

        String tuttiStm = "SELECT * FROM esame_prescritto ep " +
                "JOIN esame e ON ep.esame = e.id " +
                "LEFT JOIN utente m ON ep.medicobase = m.id " +
                "JOIN utente p ON ep.paziente = p.id " +
                "WHERE ep.paziente = ? AND lower(e.nome) LIKE lower(?)";

        String soloErogatiStm = " AND ep.erogazione IS NOT NULL";

        String soloNonErogatiStm = " AND ep.erogazione IS NULL";

        if(soloNonErogati) {
            statement = tuttiStm + soloNonErogatiStm + " ORDER BY ep.prescrizione DESC;";
        }
        else if(soloErogati) {
            statement = tuttiStm + soloErogatiStm + " ORDER BY ep.prescrizione DESC;";
        }
        else {
            statement = tuttiStm + " ORDER BY ep.prescrizione DESC;";
        }

        try (PreparedStatement stm = CON.prepareStatement(statement)) {
            stm.setLong(1, id); // 1-based indexing
            stm.setString(2, "%" + suggestion + "%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()) {
                    EsamePrescritto esamePrescritto = makeEsamePrescrittoFromRs(rs);
                    listOfEsamePrescritto.add(esamePrescritto);
                }
            }

            return  listOfEsamePrescritto;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public boolean erogaEsamePrescritto(long id, Timestamp erogazione, String esito) throws DAOException {
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("UPDATE esame_prescritto SET erogazione = ?, esito = ? WHERE id = ?;")) {
            stm.setTimestamp(1, erogazione); // 1-based indexing
            stm.setString(2, esito); // 1-based indexing
            stm.setLong(3, id); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update ", ex);
        }

        return noErr;
    }

    @Override
    public List<Utente> richiamoRangeEta(int infEta, int supEta, String idProvincia, long esame, Timestamp prescriz) throws DAOException {
        List<Utente> richiamati = new ArrayList<>();
        List<Utente> richiamatiRes = null;


        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente " +
                "WHERE date_part('year', age(datanascita)) >= ? AND date_part('year', age(datanascita)) <= ? AND idprovincia = ?; ")) {
            stm.setInt(1, infEta); // 1-based indexing
            stm.setInt(2, supEta); // 1-based indexing
            stm.setString(3, idProvincia); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    richiamati.add(JDBCUtenteDAO.makeUtenteFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO esame_prescritto (paziente, esame, prescrizione)" +
                "SELECT id, ?, ? FROM utente " +
                "WHERE date_part('year', age(utente.datanascita)) >= ? AND date_part('year', age(utente.datanascita)) <= ? AND utente.idprovincia = ?; ")) {
            stm.setLong(1, esame); // 1-based indexing
            stm.setTimestamp(2, prescriz); // 1-based indexing
            stm.setInt(3, infEta); // 1-based indexing
            stm.setInt(4, supEta); // 1-based indexing
            stm.setString(5, idProvincia); // 1-based indexing

            stm.executeUpdate();
            richiamatiRes = richiamati;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }

        return richiamatiRes;
    }

    @Override
    public List<Utente> richiamoSuccessivoMinEta(int infEta, String idProvincia, long esame, Timestamp prescriz) throws DAOException {
        List<Utente> richiamati = new ArrayList<>();
        List<Utente> richiamatiRes = null;

        try (PreparedStatement stm = CON.prepareStatement("SELECT u.* FROM utente u JOIN esame_prescritto e ON u.id = e.paziente " +
                "WHERE date_part('year', age(u.datanascita)) >= ? " +
                "AND u.idprovincia = ? AND e.esame = ? AND e.medicobase IS NULL; ")) {
            stm.setInt(1, infEta); // 1-based indexing
            stm.setString(2, idProvincia); // 1-based indexing
            stm.setLong(3, esame); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    richiamati.add(JDBCUtenteDAO.makeUtenteFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO esame_prescritto (paziente, esame, prescrizione) " +
                "SELECT u.id, ?, ? FROM utente u JOIN esame_prescritto e ON u.id = e.paziente " +
                "WHERE date_part('year', age(u.datanascita)) >= ? " +
                "AND u.idprovincia = ? AND e.esame = ? AND e.medicobase is NULL; ")) { //medicobase = NULL significa che è un richiamo
            stm.setLong(1, esame); // 1-based indexing
            stm.setTimestamp(2, prescriz); // 1-based indexing
            stm.setInt(3, infEta); // 1-based indexing
            stm.setString(4, idProvincia); // 1-based indexing
            stm.setLong(5, esame); // 1-base indexing

            stm.executeUpdate();
            richiamatiRes = richiamati;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }

        return richiamatiRes;
    }

    @Override
    public boolean creaEsamePrescritto(long esame, long medicoBase, long paziente, Timestamp prescriz) throws DAOException{
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO esame_prescritto" +
                "(esame, medicobase, paziente, prescrizione) VALUES (?,?,?,?);")){
            stm.setLong(1, esame); // 1-based indexing
            stm.setLong(2, medicoBase); // 1-based indexing
            stm.setLong(3, paziente); // 1-based indexing
            stm.setTimestamp(4, prescriz); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }

        return noErr;
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM esame_prescritto");
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
    public EsamePrescritto getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM esame_prescritto ep " +
                "JOIN esame e ON ep.esame = e.id " +
                "LEFT JOIN utente m ON ep.medicobase = m.id " +
                "JOIN utente p ON ep.paziente = p.id " +
                "WHERE ep.id = ? ")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                EsamePrescritto esamePrescritto = null;

                if(rs.next()) {
                    esamePrescritto = makeEsamePrescrittoFromRs(rs);
                }

                return esamePrescritto;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }


    @Override
    public List<EsamePrescritto> getAll() throws DAOException {
        List<EsamePrescritto> esami = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM esame_prescritto ep " +
                "JOIN esame e ON ep.esame = e.id " +
                "LEFT JOIN utente m ON ep.medicobase = m.id " +
                "JOIN utente p ON ep.paziente = p.id " +
                "ORDER BY ep.prescrizione")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    esami.add(makeEsamePrescrittoFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return esami;
    }

    private EsamePrescritto makeEsamePrescrittoFromRs(ResultSet rs) throws SQLException {
        EsamePrescritto esamePrescritto = new EsamePrescritto();
        esamePrescritto.setId(rs.getLong(1));
        esamePrescritto.setPrescrizione(rs.getTimestamp(5));
        esamePrescritto.setErogazione(rs.getTimestamp(6));
        esamePrescritto.setEsito(rs.getString(7));

        Esame esame = new Esame();
        esame.setId(rs.getLong(8));
        esame.setNome(rs.getString(9));
        esame.setDescrizione(rs.getString(10));

        Utente medicoBase = null;
        long idMedicoBase = rs.getLong(11);
        if(!rs.wasNull()) {
            medicoBase = new Utente();
            medicoBase.setId(idMedicoBase);
            medicoBase.setEmail(rs.getString(12));
            medicoBase.setPassword(rs.getString(13));
            medicoBase.setSalt(rs.getLong(14));
            medicoBase.setProv(rs.getString(15));
            medicoBase.setRuolo(rs.getString(16));
            medicoBase.setNome(rs.getString(17));
            medicoBase.setCognome(rs.getString(18));
            medicoBase.setSesso(rs.getString(19).charAt(0));
            medicoBase.setDataNascita(rs.getDate(20));
            medicoBase.setLuogoNascita(rs.getString(21));
            medicoBase.setCodiceFiscale(rs.getString(22));
            medicoBase.setIdMedicoBase(rs.getLong(23));
        }

        Utente paziente = new Utente();
        paziente.setId(rs.getLong(24));
        paziente.setEmail(rs.getString(25));
        paziente.setPassword(rs.getString(26));
        paziente.setSalt(rs.getLong(27));
        paziente.setProv(rs.getString(28));
        paziente.setRuolo(rs.getString(29));
        paziente.setNome(rs.getString(30));
        paziente.setCognome(rs.getString(31));
        paziente.setSesso(rs.getString(32).charAt(0));
        paziente.setDataNascita(rs.getDate(33)); // NON SO SE FUNZIONA
        paziente.setLuogoNascita(rs.getString(34));
        paziente.setCodiceFiscale(rs.getString(35));
        paziente.setIdMedicoBase(rs.getLong(36));

        esamePrescritto.setEsame(esame);
        esamePrescritto.setMedicoBase(Utilities.fromUtenteToUtenteView(medicoBase));
        esamePrescritto.setPaziente(Utilities.fromUtenteToUtenteView(paziente));

        return esamePrescritto;
    }
}
