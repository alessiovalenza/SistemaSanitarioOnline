package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaMedicoSpecialistaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.persistence.entities.Visita;
import it.unitn.disi.wp.progetto.persistence.entities.VisitaMedicoSpecialista;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JDBCVisitaMedicoSpecialistaDAO extends JDBCDAO<VisitaMedicoSpecialista, Long> implements VisitaMedicoSpecialistaDAO {

    public JDBCVisitaMedicoSpecialistaDAO(Connection con) {
        super(con);
    }

    @Override
    public boolean creaVisitaSpecilistica(long medicoBase , long paziente, long visita, Timestamp prescrizione) throws DAOException{
        boolean noErr = false;
        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO " +
                "visita_specialista (medicobase, paziente, visita, prescrizione) VALUES (?, ?, ?, ?);")){
            stm.setLong(1, medicoBase); // 1-based indexing
            stm.setLong(2, paziente); // 1-based indexing
            stm.setLong(3, visita); // 1-based indexing
            stm.setTimestamp(4, prescrizione); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }
        return noErr;
    }

    @Override
    public boolean erogaVisitaSpecialistica(long id, Timestamp erogazione, String anamnesi, long medicoSpecialista) throws DAOException {
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("UPDATE visita_specialista SET erogazione = ?, anamnesi = ?, medicospecialista = ? WHERE id = ?;")) {
            stm.setTimestamp(1, erogazione); // 1-based indexing
            stm.setString(2, anamnesi); // 1-based indexing
            stm.setLong(3, medicoSpecialista);
            stm.setLong(4, id);

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update ", ex);
        }

        return noErr;
    }

    @Override
    public List<VisitaMedicoSpecialista> getVisiteSpecByPaziente(long id, boolean soloErogate, boolean soloNonErogate, String suggestion) throws DAOException {
        if(soloErogate && soloNonErogate) {
            throw new DAOException("Non sense query");
        }

        List<VisitaMedicoSpecialista> visite = new ArrayList<>();

        String statement = "";

        String tutteStm = "SELECT * FROM visita_specialista v " +
                "LEFT JOIN utente ms ON v.medicospecialista = ms.id " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id " +
                "JOIN visita va ON v.visita = va.id " +
                "WHERE v.paziente = ? AND lower(va.nome) LIKE lower(?)";

        String soloErogateStm = " AND v.erogazione IS NOT NULL";

        String soloNonErogateStm = " AND v.erogazione IS NULL";

        if(soloNonErogate) {
            statement = tutteStm + soloNonErogateStm + ";";
        }
        else if(soloErogate) {
            statement = tutteStm + soloErogateStm + ";";
        }
        else {
            statement = tutteStm + ";";
        }

        try (PreparedStatement stm = CON.prepareStatement(statement)){
            stm.setLong(1, id); // 1-based indexing
            stm.setString(2, "%" + suggestion + "%"); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()){
                    VisitaMedicoSpecialista visita = makeVisitaSpecFromRs(rs);
                    visite.add(visita);
                }
            }

            return  visite;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM visita_specialista;");
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
    public VisitaMedicoSpecialista getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita_specialista v " +
                "LEFT JOIN utente ms ON v.medicospecialista = ms.id " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id " +
                "JOIN visita va ON v.visita = va.id " +
                "WHERE v.id = ?;")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                VisitaMedicoSpecialista visitaMedicoSpecialista = null;

                if(rs.next()) {
                    visitaMedicoSpecialista = makeVisitaSpecFromRs(rs);
                }

                return visitaMedicoSpecialista;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }


    @Override
    public List<VisitaMedicoSpecialista> getAll() throws DAOException {
        List<VisitaMedicoSpecialista> visite = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM visita_specialista v " +
                "LEFT JOIN utente ms ON v.medicospecialista = ms.id " +
                "JOIN utente m ON v.medicobase = m.id " +
                "JOIN utente p ON v.paziente = p.id " +
                "JOIN visita va ON v.visita = va.id " +
                "ORDER BY v.paziente")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    visite.add(makeVisitaSpecFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return visite;
    }

    private VisitaMedicoSpecialista makeVisitaSpecFromRs(ResultSet rs) throws SQLException {
        VisitaMedicoSpecialista visita = new VisitaMedicoSpecialista();
        visita.setId(rs.getLong(1));
        visita.setPrescrizione(rs.getTimestamp(6));
        visita.setErogazione(rs.getTimestamp(7));
        visita.setAnamnesi(rs.getString(8));

        Utente medicoSpec = null;
        long idMedicoSpec = rs.getLong(9);
        if(!rs.wasNull()) {
            medicoSpec = new Utente();
            medicoSpec.setId(idMedicoSpec);
            medicoSpec.setEmail(rs.getString(10));
            medicoSpec.setPassword(rs.getString(11));
            medicoSpec.setSalt(rs.getLong(12));
            medicoSpec.setProv(rs.getString(13));
            medicoSpec.setRuolo(rs.getString(14));
            medicoSpec.setNome(rs.getString(15));
            medicoSpec.setCognome(rs.getString(16));
            medicoSpec.setSesso((rs.getString(17)).charAt(0));
            medicoSpec.setDataNascita(rs.getDate(18));
            medicoSpec.setLuogoNascita(rs.getString(19));
            medicoSpec.setCodiceFiscale(rs.getString(20));
            medicoSpec.setIdMedicoBase(rs.getLong(21));
        }

        Utente medicoBase = new Utente();
        medicoBase.setId(rs.getLong(22));
        medicoBase.setEmail(rs.getString(23));
        medicoBase.setPassword(rs.getString(24));
        medicoBase.setSalt(rs.getLong(25));
        medicoBase.setProv(rs.getString(26));
        medicoBase.setRuolo(rs.getString(27));
        medicoBase.setNome(rs.getString(28));
        medicoBase.setCognome(rs.getString(29));
        medicoBase.setSesso(rs.getString(30).charAt(0));
        medicoBase.setDataNascita(rs.getDate(31));
        medicoBase.setLuogoNascita(rs.getString(32));
        medicoBase.setCodiceFiscale(rs.getString(33));
        medicoBase.setIdMedicoBase(rs.getLong(34));

        Utente paziente = new Utente();
        paziente.setId(rs.getLong(35));
        paziente.setEmail(rs.getString(36));
        paziente.setPassword(rs.getString(37));
        paziente.setSalt(rs.getLong(38));
        paziente.setProv(rs.getString(39));
        paziente.setRuolo(rs.getString(40));
        paziente.setNome(rs.getString(41));
        paziente.setCognome(rs.getString(42));
        paziente.setSesso(rs.getString(43).charAt(0));
        paziente.setDataNascita(rs.getDate(44));
        paziente.setLuogoNascita(rs.getString(45));
        paziente.setCodiceFiscale(rs.getString(46));
        paziente.setIdMedicoBase(rs.getLong(47));

        Visita visitaTipo = new Visita();
        visitaTipo.setId(rs.getLong(48));
        visitaTipo.setNome(rs.getString(49));

        visita.setMedicoSpecialista(Utilities.fromUtenteToUtenteView(medicoSpec));
        visita.setMedicoBase(Utilities.fromUtenteToUtenteView(medicoBase));
        visita.setPaziente(Utilities.fromUtenteToUtenteView(paziente));
        visita.setVisita(visitaTipo);

        return visita;
    }
}
