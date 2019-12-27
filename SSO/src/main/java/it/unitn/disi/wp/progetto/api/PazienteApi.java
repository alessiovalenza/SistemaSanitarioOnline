package it.unitn.disi.wp.progetto.api;

import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.*;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.entities.*;
import jdk.jshell.execution.Util;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import static it.unitn.disi.wp.progetto.commons.Utilities.*;

@Path("pazienti")
public class PazienteApi extends Api {

    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response getUtentiSuggestion(@QueryParam("term") String term) {
        Response res;

        /* parameter consistency check */
        if(term == null) {
            return badRequestResponse;
        }

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            List<Utente> utenti;
            List<UtenteView> utentiView;

            utenti = utenteDAO.getUsersBySuggestion(term);
            utentiView = new ArrayList<>();
            for (Utente utente : utenti) {
                utentiView.add(Utilities.fromUtenteToUtenteView(utente));
            }
            String jsonResult = gson.toJson(utentiView);
            res = Response.ok(jsonResult).build();
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }
    
    @GET
    @Path("{idpaziente}")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getPaziente(@PathParam("idpaziente") Long idPaziente) {
        Response res;

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);
            String jsonResult;

            if(paziente != null) {
                jsonResult = gson.toJson(Utilities.fromUtenteToUtenteView(paziente));
                res = Response.ok(jsonResult).build();
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    @GET
    @Path("{idpaziente}/esamiprescritti")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getEsamiPrescritti(@PathParam("idpaziente") Long idPaziente,
                                       @QueryParam("erogationly") Boolean erogatiOnly,
                                       @QueryParam("nonerogationly") Boolean nonErogatiOnly) {
        Response res;

        if(erogatiOnly == null || nonErogatiOnly == null || (nonErogatiOnly && erogatiOnly)) {
            return notFoundResponse;
        }

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

            if(paziente != null) {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<EsamePrescritto> esami = esamePrescrittoDAO.getEsamiPrescrittiByPaziente(idPaziente, erogatiOnly, nonErogatiOnly);
                String jsonResult = gson.toJson(esami);
                res = Response.ok(jsonResult).build();;
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    @GET
    @Path("{idpaziente}/visitebase")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getVisiteBase(@PathParam("idpaziente") Long idPaziente) {
        Response res;

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

            if(paziente != null) {
                VisitaMedicoBaseDAO visitaBaseDAO = daoFactory.getDAO(VisitaMedicoBaseDAO.class);
                List<VisitaMedicoBase> visite = visitaBaseDAO.getVisiteBaseByPaziente(idPaziente);
                String jsonResult = gson.toJson(visite);
                res = Response.ok(jsonResult).build();;
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    // da rivedere con davide
    @GET
    @Path("{idpaziente}/ricette")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRicette(@PathParam("idpaziente") Long idPaziente,
                               @QueryParam("evaseonly") Boolean evaseOnly,
                               @QueryParam("nonevaseonly") Boolean nonEvaseOnly) {
        
        HttpSession session = request.getSession(false);
        Response res;
        
        if(session == null || session.getAttribute("utente") == null || !( ((Utente)session.getAttribute("utente")).getRuolo().equals(Utilities.FARMACIA_RUOLO) && !nonEvaseOnly )) {
            if(evaseOnly == null || nonEvaseOnly == null || (nonEvaseOnly && evaseOnly)) {
                return badRequestResponse;
            }

            

            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                    List<Ricetta> ricette = ricettaDAO.getRicetteByPaziente(idPaziente, evaseOnly, nonEvaseOnly);
                    String jsonResult = gson.toJson(ricette);
                    res = Response.ok(jsonResult).build();;
                }
                else {
                    //404
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) { //500
                res = daoFactoryErrorResponse;
            } catch (DAOException e) { //500
                res = daoErrorResponse;
            }
        }
        else {
            //403
            return requestForbiddenResponse;
        }
        return res;
    }

    @GET
    @Path("{idpaziente}/visitespecialistiche")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getVisiteSpec(@PathParam("idpaziente") Long idPaziente,
                                  @QueryParam("erogateonly") Boolean erogateOnly,
                                  @QueryParam("nonerogateonly") Boolean nonErogateOnly) {
        if(erogateOnly == null || nonErogateOnly == null || (nonErogateOnly && erogateOnly)) {
            return badRequestResponse;
        }

        Response res;
        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

            if(paziente != null) {
                VisitaMedicoSpecialistaDAO visitaSpecDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
                List<VisitaMedicoSpecialista> visite = visitaSpecDAO.getVisiteSpecByPaziente(idPaziente, erogateOnly, nonErogateOnly);
                String jsonResult = gson.toJson(visite);
                res = Response.ok(jsonResult).build();
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) { //500
            res = daoErrorResponse;
        }

        return res;
    }

    @GET
    @Path("{idpaziente}/medicobase")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getMedicoBase(@PathParam("idpaziente") Long idPaziente) {
        Response res;

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente mb = utenteDAO.getMedicoBaseByPaziente(idPaziente);
            String jsonResult = gson.toJson(Utilities.fromUtenteToUtenteView(mb));
            if (mb != null){
                res = Response.ok(jsonResult).build();
            }else{
                res = Response.status(404, String.format("user %d not found", idPaziente)).build();
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    @PUT
    @Path("{idpaziente}/medicobase")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @Produces(MediaType.APPLICATION_JSON)
    public Response changeMedicoBase(@PathParam("idpaziente") Long idPaziente,
                                     @FormParam("idmedicobase") Long idMedicoBase) {
        Response res;

        if(idMedicoBase == null ) {
            return badRequestResponse;
        }

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);
            Utente medicoBase = utenteDAO.getByPrimaryKey(idMedicoBase);

            if(paziente != null && medicoBase != null) {

                if (paziente.getProv().equals(medicoBase.getProv()) &&
                    medicoBase.getRuolo().equals(Utilities.MEDICO_BASE_RUOLO) &&
                    idPaziente != idMedicoBase) {

                    utenteDAO.changeMedicoBase(idPaziente, idMedicoBase);
                    Utente pazienteUpdated = utenteDAO.getByPrimaryKey(idPaziente);

                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.setAttribute("utente", pazienteUpdated);
                    }

                    String jsonResult = gson.toJson(Utilities.fromUtenteToUtenteView(pazienteUpdated));
                    res = Response.ok(jsonResult).build();
                } else {
                    res = requestForbiddenResponse;
                }
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    @PUT
    @Path("{idpaziente}/esamiprescritti/{idesameprescritto}")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response erogaEsame(@PathParam("idpaziente") Long idPaziente,
                               @PathParam("idesameprescritto") Long idEsamePrescr,
                               @FormParam("esito") String esito) {
        Response res;

        if(esito == null) {
            return badRequestResponse;
        }

        try {
            EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
            EsamePrescritto esamePrescritto = esamePrescrittoDAO.getByPrimaryKey(idEsamePrescr);

            if(esamePrescritto != null && esamePrescritto.getPaziente().getId() == idPaziente) {
                esamePrescrittoDAO.erogaEsamePrescritto(idEsamePrescr, new Timestamp(System.currentTimeMillis()), esito);
                Utilities.sendEmailRisultatoEsame(esamePrescritto);
                res = noContentResponse;
            }
            else {
                res = notFoundResponse;
            }
        } catch (DAOFactoryException e) {
            res = daoFactoryErrorResponse;
        } catch (DAOException e) {
            res = daoErrorResponse;
        }

        return res;
    }

    @PUT
    @Path("{idpaziente}/ricette/{idricetta}")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response evadiRicetta(@PathParam("idpaziente") Long idPaziente,
                                 @PathParam("idricetta") Long idRicetta,
                                 @FormParam("idfarmacia") Long idFarmacia) {
        Response res;

        if(idFarmacia == null) {
            return badRequestResponse;
        }

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idFarmacia) {

            try {
                RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                Ricetta ricetta = ricettaDAO.getByPrimaryKey(idRicetta);

                if(ricetta != null && ricetta.getPaziente().getId() == idPaziente) {
                    ricettaDAO.evadiRicetta(idRicetta, idFarmacia, new Timestamp(System.currentTimeMillis()));
                    res = noContentResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            return requestForbiddenResponse;
        }

        return res;
    }

    @POST
    @Path("richiamo1")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doRichiamo1(@FormParam("infeta") Integer infEta,
                                @FormParam("supeta") Integer supEta,
                                @FormParam("idprovincia") String idProvincia,
                                @FormParam("idesame") Long idEsame) {
        if(infEta == null || supEta == null || idProvincia == null || idEsame == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null ||
                ((Utente)session.getAttribute("utente")).getProv().equals(idProvincia)) {
            try {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<Utente> richiamati = esamePrescrittoDAO.richiamoRangeEta(infEta, supEta, idProvincia, idEsame, new Timestamp(System.currentTimeMillis()));

                res = createdResponse;
                Utilities.sendEmailRichiamo(idProvincia, idEsame, richiamati, daoFactory);
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }

    @POST
    @Path("richiamo2")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response doRichiamo2(@FormParam("infeta") Integer infEta,
                                @FormParam("idprovincia") String idProvincia,
                                @FormParam("idesame") Long idEsame) {
        if(infEta == null || idProvincia == null || idEsame == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getProv().equals(idProvincia)) {
            try {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<Utente> richiamati = esamePrescrittoDAO.richiamoSuccessivoMinEta(infEta, idProvincia, idEsame, new Timestamp(System.currentTimeMillis()));
                res = createdResponse;

                Utilities.sendEmailRichiamo(idProvincia, idEsame, richiamati, daoFactory);
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }

    @PUT
    @Path("{idpaziente}/visitespecialistiche/{idvisitaspecialistica}")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response erogaVisitaSpecialistica(@PathParam("idpaziente") Long idPaziente,
                                             @PathParam("idvisitaspecialistica") Long idVisitaSpec,
                                             @FormParam("anamnesi") String anamnesi,
                                             @FormParam("idmedicospec") Long idMedicoSpec) {
        if(anamnesi == null || idMedicoSpec == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idMedicoSpec) {

            try {
                VisitaMedicoSpecialistaDAO visitaMedicoSpecialistaDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
                VisitaMedicoSpecialista visitaMedicoSpecialista = visitaMedicoSpecialistaDAO.getByPrimaryKey(idVisitaSpec);

                if (visitaMedicoSpecialista != null && visitaMedicoSpecialista.getPaziente().getId() == idPaziente) {
                    visitaMedicoSpecialistaDAO.erogaVisitaSpecialistica(idVisitaSpec, new Timestamp(System.currentTimeMillis()), anamnesi, idMedicoSpec);
                    Utilities.sendEmailRisultatoVisita(visitaMedicoSpecialista);
                    res = noContentResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }
        return res;
    }

    @POST
    @Path("{idpaziente}/esamiprescritti")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response creaEsamePrescritto(@PathParam("idpaziente") Long idPaziente,
                                        @FormParam("idmedicobase") Long idMedicoBase,
                                        @FormParam("idesame") Long idEsame) {

        if(idMedicoBase == null || idEsame == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idMedicoBase) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    EsamePrescrittoDAO esamePrescrittoDao = daoFactory.getDAO(EsamePrescrittoDAO.class);
                    esamePrescrittoDao.creaEsamePrescritto(idEsame, idMedicoBase, idPaziente, new Timestamp(System.currentTimeMillis()));

                    Utilities.sendEmailPrescrizioneEsame(idEsame, paziente, daoFactory);
                    res = createdResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }

    @POST
    @Path("{idpaziente}/ricette")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response creaRicetta(@PathParam("idpaziente") Long idPaziente,
                                @FormParam("idmedicobase") Long idMedicoBase,
                                @FormParam("idfarmaco") Long idFarmaco) {

        if(idMedicoBase == null || idFarmaco == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idMedicoBase) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                    ricettaDAO.createRicetta(idFarmaco, idMedicoBase, idPaziente, new Timestamp(System.currentTimeMillis()));
                    Utilities.sendEmailPrescrizioneRicetta(idFarmaco, paziente, daoFactory);
                    res = createdResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }

    @POST
    @Path("{idpaziente}/visitebase")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response creaVisitaMedicoBase(@PathParam("idpaziente") Long idPaziente,
                                         @FormParam("idmedicobase") Long idMedicoBase,
                                         @FormParam("anamnesi") String anamnesi) {
        if(idMedicoBase == null || anamnesi == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null ||
                ((Utente)session.getAttribute("utente")).getId() == idMedicoBase) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    VisitaMedicoBaseDAO visitaMedicoBaseDAO = daoFactory.getDAO(VisitaMedicoBaseDAO.class);
                    visitaMedicoBaseDAO.creaVisitaMedicoBase(idMedicoBase, idPaziente, new Timestamp(System.currentTimeMillis()), anamnesi);
                    res = createdResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }

    @POST
    @Path("{idpaziente}/visitespecialistiche")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response creaVisitaSpecialistica(@PathParam("idpaziente") Long idPaziente,
                                            @FormParam("idmedicobase") Long idMedicoBase,
                                            @FormParam("idvisita") Long idVisita) {
        if(idMedicoBase == null || idVisita == null) {
            return badRequestResponse;
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idMedicoBase) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    VisitaMedicoSpecialistaDAO visitaMedicoSpecialistaDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
                    visitaMedicoSpecialistaDAO.creaVisitaSpecilistica(idMedicoBase, idPaziente, idVisita, new Timestamp(System.currentTimeMillis()));

                    Utilities.sendEmailPrescrizioneVisitaSpec(idVisita, paziente, daoFactory);
                    res = createdResponse;
                }
                else {
                    res = notFoundResponse;
                }
            } catch (DAOFactoryException e) {
                res = daoFactoryErrorResponse;
            } catch (DAOException e) {
                res = daoErrorResponse;
            }
        }
        else {
            res = requestForbiddenResponse;
        }

        return res;
    }
}
