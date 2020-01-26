package it.unitn.disi.wp.progetto.persistence.dao.jdbc;


import it.unitn.disi.wp.progetto.persistence.dao.TokenRememberMeDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.entities.TokenPsw;
import it.unitn.disi.wp.progetto.persistence.entities.TokenRememberMe;

import java.math.BigInteger;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class JDBCTokenRememberMeDAO extends JDBCDAO<TokenRememberMe, String> implements TokenRememberMeDAO {

    public JDBCTokenRememberMeDAO(Connection con) {
        super(con);
    }

    @Override
    public Long getCount() throws DAOException {
        PreparedStatement stmt = null;
        try {
            stmt = CON.prepareStatement("SELECT count(*) FROM token_remember_me;");
            ResultSet counter = stmt.executeQuery();
            if (counter.next()) {
                return counter.getLong(1); // 1-based indexing
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count tokens", ex);
        }

        return 0L;
    }

    @Override
    public List<TokenRememberMe> getAll() throws DAOException {
        List<TokenRememberMe> tokenRememberMe = new ArrayList<>();

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM token_psw;")) {

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    tokenRememberMe.add(makeTokenFromRs(rs));
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list", ex);
        }

        return tokenRememberMe;
    }

    @Override
    public boolean creaToken(String token, long idUtente) throws DAOException{
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO token_remember_me" +
                "(token, idutente) VALUES (?,?);")){
            byte[] bytes = new BigInteger(token, 16).toByteArray();
            if (bytes.length == 65){
                bytes = Arrays.copyOfRange(bytes, 1, bytes.length);
            }
            stm.setBytes(1, bytes); // 1-based indexing
            stm.setLong(2, idUtente); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert", ex);
        }

        return noErr;

    }

    @Override
    public TokenRememberMe getByPrimaryKey(String Token) throws DAOException{
        if ((Token == null)) {
            throw new DAOException("Token is mandatory fields", new NullPointerException("token is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM token_remember_me WHERE token = ?;")) {

            byte[] bytes = new BigInteger(Token, 16).toByteArray();
            if (bytes.length == 65){
                bytes = Arrays.copyOfRange(bytes, 1, bytes.length);
            }
            stm.setBytes(1, bytes); // 1-based indexing

            try (ResultSet rs = stm.executeQuery()) {
                TokenRememberMe tokenRememberMe = null;
                if(rs.next()) {
                    tokenRememberMe = makeTokenFromRs(rs);
                }

                return tokenRememberMe;
            }
        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
            throw new DAOException("Impossible to get the token by token", ex);
        }

    }

    @Override
    public boolean deleteToken(String token) throws DAOException{
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM token_remember_me WHERE token=?")){
            byte[] bytes = new BigInteger(token, 16).toByteArray();
            if (bytes.length == 65){
                bytes = Arrays.copyOfRange(bytes, 1, bytes.length);
            }
            stm.setBytes(1, bytes); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete", ex);
        }

        return noErr;
    }

    @Override
    public boolean deleteTokenByUtente(long idUtente) throws DAOException {
        boolean noErr = false;

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM token_remember_me WHERE idutente = ?")) {
            stm.setLong(1, idUtente); // 1-based indexing

            stm.executeUpdate();
            noErr = true;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete", ex);
        }

        return noErr;
    }

    private TokenRememberMe makeTokenFromRs(ResultSet rs) throws SQLException {
        TokenRememberMe tokenRememberMe= new TokenRememberMe();
        tokenRememberMe.setToken(rs.getString(1));
        tokenRememberMe.setIdUtente(rs.getLong(2));
        tokenRememberMe.setLastEdit(rs.getTimestamp(3));

        return tokenRememberMe;
    }
}
