package it.unitn.disi.wp.progetto.api;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.*;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.entities.*;

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
    public Response getUtentiSuggestion(@QueryParam("term") String term,
                                        @QueryParam("idprovincia") String idProvincia) {
        Response res;

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            List<Utente> utenti;
            List<UtenteView> utentiView;

            utenti = utenteDAO.getUsersBySuggestion(term == null ? "" : term, idProvincia);

            if(utenti.size() <= MAX_RESULTS) {
                utentiView = new ArrayList<>();
                for (Utente utente : utenti) {
                    utentiView.add(Utilities.fromUtenteToUtenteView(utente));
                }
                String jsonResult = gson.toJson(utentiView);
                res = Response.ok(jsonResult).build();
            }
            else {
                throw new ApiException(TOO_MANY_RESULTS, "Please type more characters to lower the number of matches");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        return res;
    }

    @GET
    @Path("{idpaziente}/esamiprescritti")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getEsamiPrescritti(@PathParam("idpaziente") Long idPaziente,
                                       @QueryParam("erogationly") Boolean erogatiOnly,
                                       @QueryParam("nonerogationly") Boolean nonErogatiOnly,
                                       @QueryParam("term") String term) {
        Response res;

        if(erogatiOnly == null || nonErogatiOnly == null || (nonErogatiOnly && erogatiOnly)) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST,
                    "You must specificy both erogationly and nonerogationly parameters, " +
                            "with possible pair values (false, false), (false, true), or (true, false)");
        }

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

            if(paziente != null) {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<EsamePrescritto> esami = esamePrescrittoDAO.getEsamiPrescrittiByPaziente(idPaziente, erogatiOnly, nonErogatiOnly, term == null ? "" : term);
                String jsonResult = gson.toJson(esami);
                res = Response.ok(jsonResult).build();;
            }
            else {
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        return res;
    }

    @GET
    @Path("{idpaziente}/ricette")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getRicette(@PathParam("idpaziente") Long idPaziente,
                               @QueryParam("evaseonly") Boolean evaseOnly,
                               @QueryParam("nonevaseonly") Boolean nonEvaseOnly,
                               @QueryParam("term") String term) {
        
        HttpSession session = request.getSession(false);
        Response res;

        if(evaseOnly == null || nonEvaseOnly == null || (nonEvaseOnly && evaseOnly)) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST,
                    "You must specificy both evaseonly and nonevaseonly parameters, " +
                            "with possible pair values (false, false), (false, true), or (true, false)");
        }

        if(session == null || session.getAttribute("utente") == null || !( ((Utente)session.getAttribute("utente")).getRuolo().equals(Utilities.FARMACIA_RUOLO) && !nonEvaseOnly )) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                    List<Ricetta> ricette = ricettaDAO.getRicetteByPaziente(idPaziente, evaseOnly, nonEvaseOnly, term == null ? "" : term);
                    String jsonResult = gson.toJson(ricette);
                    res = Response.ok(jsonResult).build();;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. Farmacia can only access nonevaseonly ricette");
        }
        return res;
    }

    @GET
    @Path("{idpaziente}/visitespecialistiche")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getVisiteSpec(@PathParam("idpaziente") Long idPaziente,
                                  @QueryParam("erogateonly") Boolean erogateOnly,
                                  @QueryParam("nonerogateonly") Boolean nonErogateOnly,
                                  @QueryParam("term") String term) {
        if(erogateOnly == null || nonErogateOnly == null || (nonErogateOnly && erogateOnly)) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST,
                    "You must specificy both erogateonly and nonerogateonly parameters, " +
                            "with possible pair values (false, false), (false, true), or (true, false)");
        }

        Response res;
        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

            if(paziente != null) {
                VisitaMedicoSpecialistaDAO visitaSpecDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
                List<VisitaMedicoSpecialista> visite = visitaSpecDAO.getVisiteSpecByPaziente(idPaziente, erogateOnly, nonErogateOnly, term == null ? "" : term);
                String jsonResult = gson.toJson(visite);
                res = Response.ok(jsonResult).build();
            }
            else {
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the id of the new medico di base");
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
                        Utente pazienteOriginale = (Utente)session.getAttribute("utente");
                        if(pazienteOriginale.getId() == paziente.getId()) {
                            pazienteUpdated.setRuolo(pazienteOriginale.getRuolo());
                            session.setAttribute("utente", pazienteUpdated);
                        }
                    }

                    String jsonResult = gson.toJson(Utilities.fromUtenteToUtenteView(pazienteUpdated));
                    res = Response.ok(jsonResult).build();
                } else {
                    throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                            "Request forbidden due to unauthorized request. " +
                                    "You can only have a medico di base who operates in your provincia and who is not yourself. " +
                                    "Oh, almost forget to say that your medico di base must be an actual medico di base");
                }
            }
            else {
                if(paziente == null) {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
                }
                else { //medicoBase == null
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Medico di base with such an id not found");
                }
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the esito of the esame");
        }

        try {
            EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
            EsamePrescritto esamePrescritto = esamePrescrittoDAO.getByPrimaryKey(idEsamePrescr);

            if(esamePrescritto != null && esamePrescritto.getPaziente().getId() == idPaziente) {
                if(esamePrescritto.getErogazione() == null) {
                    esamePrescrittoDAO.erogaEsamePrescritto(idEsamePrescr, new Timestamp(System.currentTimeMillis()), esito);
                    Utilities.sendEmailRisultatoEsame(esamePrescritto);
                    res = EMPTY_RESPONSE;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_FORBIDDEN, "You cannot edit an esame prescritto that has already been made");
                }
            }
            else {
                if(esamePrescritto == null) {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Esame prescritto with such an id not found");
                }
                else { //esamePrescritto.getPaziente().getId() != idPaziente
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "This esame prescritto is not of the specified paziente");
                }
            }
        } catch (DAOFactoryException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Impossible to get dao interface for storage system");
        } catch (DAOException e) {
            throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the id of the farmacia");
        }

        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null ||
                ( (Utente)session.getAttribute("utente") ).getId() == idFarmacia) {

            try {
                RicettaDAO ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                Ricetta ricetta = ricettaDAO.getByPrimaryKey(idRicetta);

                if(ricetta != null && ricetta.getPaziente().getId() == idPaziente) {
                    if(ricetta.getEvasione() == null) {
                        ricettaDAO.evadiRicetta(idRicetta, idFarmacia, new Timestamp(System.currentTimeMillis()));
                        res = EMPTY_RESPONSE;
                    }
                    else {
                        throw new ApiException(HttpServletResponse.SC_FORBIDDEN, "You cannot edit a ricetta that has already been used");
                    }
                }
                else {
                    if(ricetta == null) {
                        throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Ricetta with such an id not found");
                    }
                    else { //ricetta.getPaziente().getId() != idPaziente
                        throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "This ricetta is not of the specified paziente");
                    }
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party that consumes the ricetta, " +
                            "indeed you must be a farmacia");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specifiy the " +
                    "the range of ages involved (infeta and supeta), the id of the provincia and the id of the esame");
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null ||
                ((Utente)session.getAttribute("utente")).getProv().equals(idProvincia)) {
            try {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<Utente> richiamati = esamePrescrittoDAO.richiamoRangeEta(infEta, supEta, idProvincia, idEsame, new Timestamp(System.currentTimeMillis()));

                res = CREATED_RESPONSE;
                Utilities.sendEmailRichiamo(idProvincia, idEsame, richiamati, daoFactory);
            } catch (DAOFactoryException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            } catch (DAOException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        else {
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. You can only specifiy your provincia");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specifiy the " +
                    "the minimum age, the id of the provincia and the id of the esame");
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null ||
                ( (Utente)session.getAttribute("utente") ).getProv().equals(idProvincia)) {
            try {
                EsamePrescrittoDAO esamePrescrittoDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                List<Utente> richiamati = esamePrescrittoDAO.richiamoSuccessivoMinEta(infEta, idProvincia, idEsame, new Timestamp(System.currentTimeMillis()));
                res = CREATED_RESPONSE;

                Utilities.sendEmailRichiamo(idProvincia, idEsame, richiamati, daoFactory);
            } catch (DAOFactoryException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            } catch (DAOException e) {
                throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        else {
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. You can only specifiy your provincia");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the anamnesi and the id of the medico specialista");
        }

        Response res;
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("utente") == null || ( (Utente)session.getAttribute("utente") ).getId() == idMedicoSpec) {

            try {
                VisitaMedicoSpecialistaDAO visitaMedicoSpecialistaDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
                VisitaMedicoSpecialista visitaMedicoSpecialista = visitaMedicoSpecialistaDAO.getByPrimaryKey(idVisitaSpec);

                if (visitaMedicoSpecialista != null && visitaMedicoSpecialista.getPaziente().getId() == idPaziente) {
                    if(visitaMedicoSpecialista.getErogazione() == null) {
                        visitaMedicoSpecialistaDAO.erogaVisitaSpecialistica(idVisitaSpec, new Timestamp(System.currentTimeMillis()), anamnesi, idMedicoSpec);
                        Utilities.sendEmailRisultatoVisita(visitaMedicoSpecialista);
                        res = EMPTY_RESPONSE;
                    }
                    else {
                        throw new ApiException(HttpServletResponse.SC_FORBIDDEN, "You cannot edit a visita specialistica that has already been made");
                    }
                }
                else {
                    if(visitaMedicoSpecialista == null) {
                        throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Visita specialistica with such an id not found");
                    }
                    else { //visitaMedicoSpecialista.getPaziente().getId() != idPaziente
                        throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "This visita specialistica is not of the specified paziente");
                    }
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party making the visita, " +
                            "indeed you must be a medico specialista");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specify the id of the esame and the id of the medico di base");
        }

        Response res;
        HttpSession session = request.getSession(false);

        if(session == null || session.getAttribute("utente") == null ||
                ( (Utente)session.getAttribute("utente") ).getId() == idMedicoBase) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente paziente = utenteDAO.getByPrimaryKey(idPaziente);

                if(paziente != null) {
                    EsamePrescrittoDAO esamePrescrittoDao = daoFactory.getDAO(EsamePrescrittoDAO.class);
                    esamePrescrittoDao.creaEsamePrescritto(idEsame, idMedicoBase, idPaziente, new Timestamp(System.currentTimeMillis()));

                    Utilities.sendEmailPrescrizioneEsame(idEsame, paziente, daoFactory);
                    res = CREATED_RESPONSE;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party creating the visita, " +
                            "indeed you must be a medico di base");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specify the id of the farmaco and the id of the medico di base");
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
                    res = CREATED_RESPONSE;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party creating the ricetta, " +
                            "indeed you must be a medico di base");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the anamnesi and the id of the medico di base");
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
                    res = CREATED_RESPONSE;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party making the visita di base, " +
                            "indeed you must be a medico di base");
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
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must specify the id of the visita and the id of the medico di base");
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
                    res = CREATED_RESPONSE;
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Paziente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_FORBIDDEN,
                    "Request forbidden due to unauthorized request. " +
                            "You can only specifiy your id as the party making the visita specialistica, " +
                            "indeed you must be a medico di base");
        }

        return res;
    }
}
