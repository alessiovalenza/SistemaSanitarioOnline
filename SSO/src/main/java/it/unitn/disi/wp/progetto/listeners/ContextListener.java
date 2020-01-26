package it.unitn.disi.wp.progetto.listeners;

import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.dao.factories.jdbc.JDBCDAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class ContextListener implements ServletContextListener {

    public void contextInitialized(ServletContextEvent sce) {

        String url = sce.getServletContext().getInitParameter("dburl");
        String username = sce.getServletContext().getInitParameter("dbusername");
        String password = sce.getServletContext().getInitParameter("dbpassword");

        String url_alessio = "jdbc:postgresql://localhost:5432/postgres";
        String username_alessio = "alessio_valenza";
        String password_alessio = "admin";

        String url_davide = "jdbc:postgresql://localhost:5432/postgres";
        String username_davide = "postgres";
        String password_davide = "password";

        String url_luca = "jdbc:postgresql://localhost:5432/postgres";
        String username_luca = "postgres";
        String password_luca = "password";

        try {
            //JDBCDAOFactory.configure(url, username, password);
            //JDBCDAOFactory.configure(url_davide, username_davide, password_davide);
            JDBCDAOFactory.configure(url, username, password);

            DAOFactory daoFactory = JDBCDAOFactory.getInstance();

            sce.getServletContext().setAttribute("daoFactory", daoFactory);

            System.out.println("Server started - connected to database");
        } catch (DAOFactoryException ex) {
            Logger.getLogger(getClass().getName()).severe(ex.toString());
            throw new RuntimeException(ex);
        }
    }

    public void contextDestroyed(ServletContextEvent sce) {
        DAOFactory daoFactory = (DAOFactory) sce.getServletContext().getAttribute("daoFactory");

        if (daoFactory != null) {
            daoFactory.shutdown();
        }

        daoFactory = null;

        System.out.println("Server shutdown - disconnected from database");
    }
}
