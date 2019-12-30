package it.unitn.disi.wp.progetto.api;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.EsameDAO;
import it.unitn.disi.wp.progetto.persistence.dao.FarmacoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.entities.*;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;

import static it.unitn.disi.wp.progetto.commons.Utilities.*;

@Path("general")
public class GeneralApi extends Api{

    @GET
    @Path("visite")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getVisiteSuggestion(@QueryParam("term") String term) {
        Response res;
        try {
            VisitaDAO visitaDAO = daoFactory.getDAO(VisitaDAO.class);
            List<Visita> visite = visitaDAO.getVisiteBySuggestionNome(term == null ? "" : term);
            String jsonResult = gson.toJson(visite);
            res = Response.ok(jsonResult).build();
        }
        catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        return res;
    }

    @GET
    @Path("esami")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getEsamiSuggestion(@QueryParam("term") String term) {
        Response res;

        try {
            EsameDAO esameDAO = daoFactory.getDAO(EsameDAO.class);
            List<Esame> esami = esameDAO.getEsamiBySuggestionNome(term == null ? "" : term);
            String jsonResult = gson.toJson(esami);
            res = Response.ok(jsonResult).build();
        }
        catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        return res;
    }

    @GET
    @Path("farmaci")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getFarmaciSuggestion(@QueryParam("term") String term) {
        Response res;

        try {
            FarmacoDAO farmacoDAO = daoFactory.getDAO(FarmacoDAO.class);
            List<Farmaco> farmaci = farmacoDAO.getFarmaciBySuggestionNome(term == null ? "" : term);
            String jsonResult = gson.toJson(farmaci);
            res = Response.ok(jsonResult).build();
        }
        catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        return res;
    }

    @GET
    @Path("medicibase")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMediciBaseSuggestion(@QueryParam("idprovincia") String idProvincia,
                                            @QueryParam("term") String term) {
        if(idProvincia == null) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specify id of the provincia");
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null ||
                !(((Utente)session.getAttribute("utente")).getRuolo().equals(Utilities.PAZIENTE_RUOLO) &&
                        !idProvincia.equals(((Utente)session.getAttribute("utente")).getProv()))) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                List<Utente> mediciBase = utenteDAO.getMediciBaseBySuggestionAndProvincia(term == null ? "" : term, idProvincia);
                List<UtenteView> mediciBaseView = new ArrayList<>();
                for (Utente medico: mediciBase) {
                    mediciBaseView.add(Utilities.fromUtenteToUtenteView(medico));
                }
                String jsonResult = gson.toJson(mediciBaseView);
                res = Response.ok(jsonResult).build();
            }
            catch (DAOFactoryException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            } catch (DAOException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        else {
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN, "You are trying to access another provincia's data");
        }

        return res;
    }
}
