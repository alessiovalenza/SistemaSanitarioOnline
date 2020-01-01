package it.unitn.disi.wp.progetto.api;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.entities.ElemPazienteMB;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.persistence.entities.UtenteView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;

import static it.unitn.disi.wp.progetto.commons.Utilities.*;

@Path("medicibase")
public class MedicoBaseApi extends Api {

    @GET
    @Path("{idmedico}/pazienti")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPazientiByMedicoBase(@PathParam("idmedico") long idMedicoBase,
                                            @QueryParam("datericettavisita") Boolean dateRicVis) {
        Response res;

        if(dateRicVis == null || dateRicVis == false) {

            try {

                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente medico = utenteDAO.getByPrimaryKey(idMedicoBase);

                if (medico != null) {
                    List<Utente> list = utenteDAO.getPazientiByMedicoBase(idMedicoBase);
                    ArrayList<UtenteView> jsonList = new ArrayList<>();
                    for (Utente user : list) {
                        jsonList.add(Utilities.fromUtenteToUtenteView(user));
                    }
                    String jsonResult = gson.toJson(jsonList);
                    res = Response.ok(jsonResult).build();
                } else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Medico with such an id not found");
                }
            } catch (DAOFactoryException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            } catch (DAOException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        else {
            try {

                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente medico = utenteDAO.getByPrimaryKey(idMedicoBase);

                if (medico != null) {
                    List<ElemPazienteMB> list = utenteDAO.getPazientiDateMB(idMedicoBase);
                    String jsonResult = gson.toJson(list);
                    res = Response.ok(jsonResult).build();
                } else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Medico with such an id not found");
                }
            } catch (DAOFactoryException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            } catch (DAOException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }

        return res;
    }
}
