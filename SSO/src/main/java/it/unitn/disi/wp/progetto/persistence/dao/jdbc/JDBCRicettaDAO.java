package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JDBCRicettaDAO extends JDBCDAO<Ricetta, Long> implements RicettaDAO{

    public JDBCRicettaDAO(Connection con) {
        super(con);
    }

    @Override
    public List<Ricetta> getRicetteByPaziente(long id, boolean soloEvase, boolean soloNonEvase, String suggestion) throws DAOException {
        if(soloEvase && soloNonEvase) {
            throw new DAOException("Non sense query");
        }

        List<Ricetta> listOfRicetta = new ArrayList<>();

        String statement = "";

        String tutteStm = "SELECT * FROM ricetta r " +
                "JOIN farmaco fm ON r.farmaco = fm.id " +
                "JOIN utente m ON r.medicobase = m.id " +
                "JOIN utente p ON r.paziente = p.id " +
                "LEFT JOIN utente fc ON r.farmacia = fc.id " +
                "WHERE r.paziente = ? AND lower(fm.nome) LIKE lower(?)";

        String soloEvaseStm = " AND r.evasione IS NOT NULL";

        String soloNonEvaseStm = " AND r.evasione IS NULL";

        if(soloNonEvase) {
            statement = tutteStm + soloNonEvaseStm + ";";
        }
        else if(soloEvase) {
            statement = tutteStm + soloEvaseStm + ";";
        }
        else {
            statement = tutteStm + ";";
        }

        try (PreparedStatement stm = CON.prepareStatement(statement)){
            stm.setLong(1, id); // 1-based indexing
            stm.setString(2, "%" + suggestion + "%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()){
                    Ricetta ricetta = makeRicettaFromRs(rs);
                    listOfRicetta.add(ricetta);
                }
            }

            return  listOfRicetta;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public boolean createRicetta(long farmaco, long medicoBase, long paziente, Timestamp emissione) throws DAOException{
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO ricetta" +
                "(farmaco, medicobase, paziente, emissione) VALUES(?,?,?,?);")){
            stm.setLong(1, farmaco); // 1-based indexing
            stm.setLong(2, medicoBase); // 1-based indexing
            stm.setLong(3, paziente); // 1-based indexing
            stm.setTimestamp(4, emissione); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }
        return noErr;
    }

    @Override
    public boolean evadiRicetta(long id, long farmacia, Timestamp evasione) throws DAOException {
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("UPDATE ricetta SET farmacia = ?, evasione = ? WHERE id = ?;")) {
            stm.setLong(1, farmacia); // 1-based indexing
            stm.setTimestamp(2, evasione); // 1-based indexing
            stm.setLong(3, id); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update ", ex);
        }

        return noErr;
    }

    @Override
    public List<ElemReportProv> reportProvinciale(String idProvincia, Timestamp from, Timestamp to) throws DAOException {
        List<ElemReportProv> report = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT r.emissione, m.codicefiscale, m.nome, m.cognome, p.codicefiscale, p.nome, p.cognome, fo.nome, fo.prezzo, fa.nome " +
                "FROM ricetta r " +
                "JOIN utente p ON r.paziente = p.id " +
                "JOIN utente m ON r.medicobase = m.id " +
                "JOIN utente fa ON r.farmacia = fa.id " +
                "JOIN farmaco fo ON r.farmaco = fo.id " +
                "WHERE p.idprovincia = ? AND r.emissione >= ? AND r.emissione <= ? " +
                "ORDER BY r.emissione;")){
            stm.setString(1, idProvincia); // 1-based indexing
            stm.setTimestamp(2, from); // 1-based indexing
            stm.setTimestamp(3, to); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    ElemReportProv elem = new ElemReportProv();
                    elem.setEmissione(rs.getTimestamp(1));
                    elem.setCfMedico(rs.getString(2));
                    elem.setNomeMedico(rs.getString(3));
                    elem.setCognomeMedico(rs.getString(4));
                    elem.setCfPaziente(rs.getString(5));
                    elem.setNomePaziente(rs.getString(6));
                    elem.setCognomePaziente(rs.getString(7));
                    elem.setFarmaco(rs.getString(8));
                    elem.setPrezzo(rs.getDouble(9));
                    elem.setFarmacia(rs.getString(10));

                    report.add(elem);
                }
            }

            return  report;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public List<ElemReportNazionale> reportNazionale(Timestamp from, Timestamp to) throws DAOException {
        List<ElemReportNazionale> report = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT m.idprovincia, m.codicefiscale, m.nome, m.cognome, sum(f.prezzo) " +
                "FROM ricetta r " +
                "JOIN utente m ON r.medicobase = m.id " +
                "JOIN farmaco f ON r.farmaco = f.id " +
                "WHERE r.farmacia IS NOT NULL AND r.emissione >= ? AND r.emissione <= ? " +
                "GROUP BY m.idprovincia, m.id, m.codicefiscale, m.nome, m.cognome;")){
            stm.setTimestamp(1, from); // 1-based indexing
            stm.setTimestamp(2, to); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    ElemReportNazionale elem = new ElemReportNazionale();
                    elem.setProvincia(rs.getString(1));
                    elem.setCfMedico(rs.getString(2));
                    elem.setNomeMedico(rs.getString(3));
                    elem.setCognomeMedico(rs.getString(4));
                    elem.setSpesa(rs.getDouble(5));

                    report.add(elem);
                }
            }

            return  report;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM ricetta");
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
    public Ricetta getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ricetta r " +
                "JOIN farmaco fm ON r.farmaco = fm.id " +
                "JOIN utente m ON r.medicobase = m.id " +
                "JOIN utente p ON r.paziente = p.id " +
                "LEFT JOIN utente fc ON r.farmacia = fc.id " +
                "WHERE r.id = ?")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                Ricetta ricetta = null;

                if(rs.next()) {
                    ricetta = makeRicettaFromRs(rs);
                }

                return ricetta;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }


    @Override
    public List<Ricetta> getAll() throws DAOException {
        List<Ricetta> ricette = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM ricetta r " +
                "JOIN farmaco fm ON r.farmaco = fm.id " +
                "JOIN utente m ON r.medicobase = m.id " +
                "JOIN utente p ON r.paziente = p.id " +
                "LEFT JOIN utente fc ON r.farmacia = fc.id " +
                "ORDER BY r.paziente")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ricette.add(makeRicettaFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return ricette;
    }

    private Ricetta makeRicettaFromRs(ResultSet rs) throws SQLException {
        Ricetta ricetta = new Ricetta();
        ricetta.setId(rs.getLong(1));
        ricetta.setEmissione(rs.getTimestamp(6));
        ricetta.setEvasione(rs.getTimestamp(7));

        Farmaco farmaco = new Farmaco();
        farmaco.setId(rs.getLong(8));
        farmaco.setNome(rs.getString(9));
        farmaco.setDescrizione(rs.getString(10));
        farmaco.setPrezzo(rs.getDouble(11));

        Utente medicoBase = new Utente();
        medicoBase.setId(rs.getLong(12));
        medicoBase.setEmail(rs.getString(13));
        medicoBase.setPassword(rs.getString(14));
        medicoBase.setSalt(rs.getLong(15));
        medicoBase.setProv(rs.getString(16));
        medicoBase.setRuolo(rs.getString(17));
        medicoBase.setNome(rs.getString(18));
        medicoBase.setCognome(rs.getString(19));
        medicoBase.setSesso(rs.getString(20).charAt(0));
        medicoBase.setDataNascita(rs.getDate(21));
        medicoBase.setLuogoNascita(rs.getString(22));
        medicoBase.setCodiceFiscale(rs.getString(23));
        medicoBase.setIdMedicoBase(rs.getLong(24));

        Utente paziente = new Utente();
        paziente.setId(rs.getLong(25));
        paziente.setEmail(rs.getString(26));
        paziente.setPassword(rs.getString(27));
        paziente.setSalt(rs.getLong(28));
        paziente.setProv(rs.getString(29));
        paziente.setRuolo(rs.getString(30));
        paziente.setNome(rs.getString(31));
        paziente.setCognome(rs.getString(32));
        paziente.setSesso(rs.getString(33).charAt(0));
        paziente.setDataNascita(rs.getDate(34));
        paziente.setLuogoNascita(rs.getString(35));
        paziente.setCodiceFiscale(rs.getString(36));
        paziente.setIdMedicoBase(rs.getLong(37));

        Utente farmacia = null;
        long idFarmacia = rs.getLong(38);
        if(!rs.wasNull())
        {
            farmacia = new Utente();
            farmacia.setId(idFarmacia);
            farmacia.setEmail(rs.getString(39));
            farmacia.setPassword(rs.getString(40));
            farmacia.setSalt(rs.getLong(41));
            farmacia.setProv(rs.getString(42));
            farmacia.setRuolo(rs.getString(43));
            farmacia.setNome(rs.getString(44));
            farmacia.setLuogoNascita(rs.getString(48));
        }

        ricetta.setFarmaco(farmaco);
        ricetta.setMedicoBase(Utilities.fromUtenteToUtenteView(medicoBase));
        ricetta.setPaziente(Utilities.fromUtenteToUtenteView(paziente));
        ricetta.setFarmacia(Utilities.fromUtenteToUtenteView(farmacia));

        return ricetta;
    }
}
