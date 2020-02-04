package it.unitn.disi.wp.progetto.persistence.dao.jdbc;

import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.ElemPazienteMB;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.persistence.entities.UtenteView;

import javax.xml.bind.DatatypeConverter;
import java.math.BigInteger;
import java.sql.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class JDBCUtenteDAO extends JDBCDAO<Utente, Long> implements UtenteDAO {

    public JDBCUtenteDAO(Connection con) {
        super(con);
    }

    @Override
    public Utente getUserByEmail(String email) throws DAOException {
        if ((email == null)) {
            throw new DAOException("Email is mandatory fields", new NullPointerException("email is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE email = lower(?);")) {
            stm.setString(1, email); // 1-based indexing
            try (ResultSet rs = stm.executeQuery()) {
                Utente user = null;
                if(rs.next()) {
                    user = makeUtenteFromRs(rs);
                }

                return user;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            throw new DAOException("Impossible to get the user by email", ex);
        }
    }

    @Override
    public Utente getUserByCodiceFiscale(String codiceFiscale) throws DAOException {
        if ((codiceFiscale == null)) {
            throw new DAOException("codiceFiscale is mandatory field", new NullPointerException("codiceFiscale is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE codicefiscale = upper(?);")) {
            stm.setString(1, codiceFiscale); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                Utente user = null;
                if(rs.next()) {
                    user = makeUtenteFromRs(rs);
                }

                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user by codiceFiscale", ex);
        }
    }

    @Override
    public List<Utente> getPazientiByMedicoBase(long id, String suggestion) throws DAOException {
        List<Utente> listOfPazienti = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente " +
                "WHERE medicobase = ?" +
                "AND (lower(cognome || ' ' || nome) LIKE lower(?) OR lower(nome || ' ' || cognome) LIKE lower(?)" +
                     "OR lower(email) LIKE lower(?) OR lower(codicefiscale) LIKE lower(?)) " +
                "ORDER BY nome, cognome;")) {
            stm.setLong(1, id); // 1-based indexing
            stm.setString(2, suggestion + "%");
            stm.setString(3, suggestion + "%");
            stm.setString(4, suggestion + "%");
            stm.setString(5, suggestion + "%");


            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()){
                    Utente user = makeUtenteFromRs(rs);
                    listOfPazienti.add(user);
                }

            }

            return  listOfPazienti;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public boolean updatePassword(long id, String hashPw, long salt) throws  DAOException {
        boolean noErr = false;

        if (hashPw == null) {
            throw new DAOException("Password is mandatory field", new NullPointerException("Password is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("UPDATE utente SET password = ?, salt = ? WHERE id = ?;")) {
            byte[] bytes = new BigInteger(hashPw, 16).toByteArray();
            if (bytes.length == 65){
                bytes = Arrays.copyOfRange(bytes, 1, bytes.length);
            }
            stm.setBytes(1, bytes); // 1-based indexing
            stm.setLong(2, salt); // 1-based indexing
            stm.setLong(3, id); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            throw new DAOException("Impossible to update", ex);
        }

        return noErr;
    }

    @Override
    public boolean changeMedicoBase(long idPaziente, long idMedicoBase) throws  DAOException{// nuovo id del medico di base
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("UPDATE utente SET medicobase = ? WHERE id = ?;")) {
            stm.setLong(1, idMedicoBase); // 1-based indexing
            stm.setLong(2, idPaziente); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update", ex);
        }

        return noErr;
    }

    @Override
    public List<Utente> getUsersBySuggestion(String suggestion, String provincia) throws DAOException{
        List<Utente> listPazienti = new ArrayList<>();

        if ((suggestion == null)) {
            throw new DAOException("Suggestion mandatory field", new NullPointerException("Suggestion is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente " +
                "WHERE (lower(cognome || ' ' || nome) LIKE lower(?) OR lower(nome || ' ' || cognome) LIKE lower(?) " +
                "OR lower(email) LIKE lower(?) OR lower(codicefiscale) LIKE lower(?)) " +
                "AND (ruolo = 'p' OR ruolo = 'mb' OR ruolo = 'ms')" + (provincia != null ? " AND idprovincia = ?" : "") + " " +
                "ORDER BY nome, cognome;")) {
            stm.setString(1, suggestion+"%"); // 1-based indexing
            stm.setString(2, suggestion+"%"); // 1-based indexing
            stm.setString(3, suggestion+"%"); // 1-based indexing
            stm.setString(4, suggestion+"%"); // 1-based indexing
            if(provincia != null) {
                stm.setString(5, provincia); // 1-based indexing
            }


            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    Utente user = makeUtenteFromRs(rs);
                    listPazienti.add(user);
                }
            }

            return  listPazienti;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }

    }

    @Override
    public List<Utente> getMediciBaseBySuggestionAndProvincia(String suggestion, String provincia) throws DAOException {
        List<Utente> listPazienti = new ArrayList<>();

        if (suggestion == null || provincia == null) {
            throw new DAOException("Suggestion and provincia are mandatory field", new NullPointerException("Suggestion is null"));
        }

        //è vulnerabile a SQL injection?
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente " +
                "WHERE (lower(cognome || ' ' || nome) LIKE lower(?) OR lower(nome || ' ' || cognome) LIKE lower(?)) " +
                "AND idprovincia = ? AND ruolo = 'mb' ORDER BY nome, cognome;")) {
            stm.setString(1, suggestion + "%"); // 1-based indexing
            stm.setString(2, suggestion + "%"); // 1-based indexing
            stm.setString(3, provincia); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                while(rs.next()){
                    Utente user = makeUtenteFromRs(rs);
                    listPazienti.add(user);
                }
            }

            return  listPazienti;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public Utente getMedicoBaseByPaziente(long idPaziente) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT m.* " +
                "FROM utente m JOIN utente p ON m.id = p.medicobase " +
                "WHERE p.id = ?;")) {
            stm.setLong(1, idPaziente); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                Utente user = null;
                if(rs.next()) {
                    user = makeUtenteFromRs(rs);
                }

                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get medicobase by paziente", ex);
        }
    }

    @Override
    public List<ElemPazienteMB> getPazientiDateMB(long idMedicoBase, String suggestion) throws DAOException {
        List<ElemPazienteMB> listOfPazienti = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT p.id, p.email, p.idprovincia, p.ruolo, p.nome, p.cognome, p.sesso, p.datanascita, p.luogonascita, p.codicefiscale, p.medicobase, max(r.emissione), max(v.erogazione) " +
                "FROM utente p LEFT JOIN ricetta r ON p.id = r.paziente LEFT JOIN visita_base v ON p.id = v.paziente " +
                "WHERE p.medicobase = ? " +
                "AND (lower(p.cognome || ' ' || p.nome) LIKE lower(?) OR lower(p.nome || ' ' || p.cognome) LIKE lower(?) " +
                "OR lower(p.email) LIKE lower(?) OR lower(p.codicefiscale) LIKE lower(?)) " +
                "GROUP BY p.id, p.email, p.idprovincia, p.ruolo, p.nome, p.cognome, p.sesso, p.datanascita, p.luogonascita, p.codicefiscale, p.medicobase " +
                "ORDER BY p.nome, p.cognome;")) {
            stm.setLong(1, idMedicoBase); // 1-based indexing
            stm.setString(2, suggestion + "%");
            stm.setString(3, suggestion + "%");
            stm.setString(4, suggestion + "%");
            stm.setString(5, suggestion + "%");

            try (ResultSet rs = stm.executeQuery()) {

                while(rs.next()){
                    ElemPazienteMB elemPazienteMB = makeElemPazienteMBFromRs(rs);
                    listOfPazienti.add(elemPazienteMB);
                }

            }

            return  listOfPazienti;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM utente");
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
    public Utente getByPrimaryKey(Long primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente WHERE id = ?")) {
            stm.setLong(1, primaryKey);

            try (ResultSet rs = stm.executeQuery()) {
                Utente user = null;
                if(rs.next()) {
                    user = makeUtenteFromRs(rs);
                }

                return user;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    @Override
    public List<Utente> getAll() throws DAOException {
        List<Utente> users = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM utente ORDER BY cognome")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Utente user = makeUtenteFromRs(rs);

                    users.add(user);
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }

        return users;
    }

    public static Utente makeUtenteFromRs(ResultSet rs) throws SQLException {
        byte [] hash = rs.getBytes("password");
        String hashString = DatatypeConverter.printHexBinary(hash).toLowerCase();

        Utente user = new Utente();
        user.setId(rs.getLong("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(hashString);
        user.setSalt(rs.getLong("salt"));
        user.setRuolo(rs.getString("ruolo"));

        if(user.getRuolo().equals(UtenteDAO.P) || user.getRuolo().equals(UtenteDAO.MB) || user.getRuolo().equals(UtenteDAO.MS)) {
            user.setProv(rs.getString("idprovincia"));
            user.setNome(rs.getString("nome"));
            user.setCognome(rs.getString("cognome"));
            user.setSesso(rs.getString("sesso").charAt(0));
            user.setDataNascita(rs.getDate("datanascita"));
            user.setLuogoNascita(rs.getString("luogonascita"));
            user.setCodiceFiscale(rs.getString("codicefiscale"));
            user.setIdMedicoBase(rs.getLong("medicobase"));
        }
        else if(user.getRuolo().equals(UtenteDAO.F)) {
            user.setProv(rs.getString("idprovincia"));
            user.setNome(rs.getString("nome"));
            user.setLuogoNascita(rs.getString("luogonascita"));
        }
        else if(user.getRuolo().equals(UtenteDAO.SSP))
        {
            user.setProv(rs.getString("idprovincia"));
        }

        return user;
    }

    private ElemPazienteMB makeElemPazienteMBFromRs(ResultSet rs) throws SQLException {
        ElemPazienteMB elemPazienteMB = new ElemPazienteMB();

        UtenteView paziente = new UtenteView();
        paziente.setId(rs.getLong(1));
        paziente.setEmail(rs.getString(2));
        paziente.setProv(rs.getString(3));
        paziente.setRuolo(rs.getString(4));
        paziente.setNome(rs.getString(5));
        paziente.setCognome(rs.getString(6));
        paziente.setSesso(rs.getString(7).charAt(0));
        paziente.setDataNascita(rs.getDate(8));
        paziente.setLuogoNascita(rs.getString(9));
        paziente.setCodiceFiscale(rs.getString(10));
        paziente.setIdMedicoBase(rs.getLong(11));

        elemPazienteMB.setPaziente(paziente);
        elemPazienteMB.setGetDataUltimaRicetta(rs.getTimestamp(12));
        elemPazienteMB.setDataUltimaVisitaBase(rs.getTimestamp(13));

        return elemPazienteMB;
    }
}
