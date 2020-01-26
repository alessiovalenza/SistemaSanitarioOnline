package it.unitn.disi.wp.progetto.api;

import it.unitn.disi.wp.progetto.api.exceptions.ApiException;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.FotoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.TokenRememberMeDAO;
import it.unitn.disi.wp.progetto.persistence.dao.UtenteDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.entities.Foto;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Timestamp;
import java.util.List;

import static it.unitn.disi.wp.progetto.commons.Utilities.*;

@Path("utenti")
public class UtenteApi extends Api {

    @GET
    @Path("{idutente}/foto")
    @Produces(MediaType.APPLICATION_JSON)
    public Response getFoto(@PathParam("idutente") long idUtente) {

        Response res;

        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente utente = utenteDAO.getByPrimaryKey(idUtente);

            if(utente != null) {
                FotoDAO fotoDAO = daoFactory.getDAO(FotoDAO.class);
                List<Foto> foto = fotoDAO.getFotoByUtente(idUtente);
                String jsonResult = gson.toJson(foto);
                res = Response.ok(jsonResult).build();
            }
            else {
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Utente with such an id not found");
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

    @POST
    @Path("{idutente}/foto")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    public Response addNuovaFoto(@PathParam("idutente") long idUtente,
                                 @FormDataParam("foto") InputStream fotoIS,
                                 @FormDataParam("foto") FormDataContentDisposition fotoDetail) {
        if(fotoIS == null || fotoDetail == null) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the photo to upload");
        }

        Response res;
        if(fotoDetail.getFileName().toLowerCase().matches(Utilities.USER_IMAGE_EXT_REGEX)) {
            try {
                UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
                Utente utente = utenteDAO.getByPrimaryKey(idUtente);

                if(utente != null) {
                    FotoDAO fotoDAO = daoFactory.getDAO(FotoDAO.class);
                    fotoDAO.addNewFoto(idUtente, new Timestamp(System.currentTimeMillis()));

                    List<Foto> fotoUtente = fotoDAO.getFotoByUtente(idUtente);
                    long maxFound = 0;
                    for (Foto foto : fotoUtente) {
                        if (foto.getId() > maxFound) {
                            maxFound = foto.getId();
                        }
                    }

                    String pathBase = context.getRealPath(File.separator);

                    String pathSrc = new File(pathBase).getParent();
                    pathSrc = new File(pathSrc).getParent();
                    pathSrc = pathSrc + Utilities.WEBAPP_REL_DIR + Utilities.USER_IMAGES_FOLDER + File.separator + idUtente + File.separator + maxFound + "." + Utilities.USER_IMAGE_EXT;
                    System.out.println(pathSrc);

                    String pathTarget = pathBase + Utilities.USER_IMAGES_FOLDER + File.separator + idUtente + File.separator + maxFound + "." + Utilities.USER_IMAGE_EXT;;
                    System.out.println(pathTarget);

                    try {
                        BufferedImage inFoto = ImageIO.read(fotoIS);

                        int width = inFoto.getWidth();
                        int height = inFoto.getHeight();

                        if(width > USER_IMAGES_WIDTH_MAX || height > USER_IMAGES_HEIGHT_MAX) {
                            float scale = Math.max(width / USER_IMAGES_WIDTH_MAX, height / USER_IMAGES_HEIGHT_MAX);
                            width /= scale;
                            height /= scale;
                        }

                        BufferedImage outFoto = new BufferedImage(width, height, inFoto.getType());
                        Graphics2D g2d = outFoto.createGraphics();
                        g2d.drawImage(inFoto, 0, 0, width, height, null);
                        g2d.dispose();
                        ImageIO.write(outFoto, Utilities.USER_IMAGE_EXT, new File(pathSrc));
                        ImageIO.write(outFoto, Utilities.USER_IMAGE_EXT, new File(pathTarget));
                        fotoIS.close();
                        res = CREATED_RESPONSE;
                    } catch (IOException e) {
                        fotoDAO.deleteFoto(maxFound);
                        throw new ApiException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                                e.getMessage() + " - Errors occurred while saving photo");
                    }
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Utente with such an id not found");
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
            throw new ApiException(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, "The photo must be a jpg file");
        }

        return res;
    }

    @PUT
    @Path("{idutente}/password")
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response changePassword(@PathParam("idutente") long idUtente,
                                   @FormParam("vecchiapassword") String vecchiaPassword,
                                   @FormParam("nuovapassword") String nuovaPassword) {
        if(vecchiaPassword == null || nuovaPassword == null) {
            throw new ApiException(HttpServletResponse.SC_BAD_REQUEST, "You must provide the old and the new password");
        }

        Response res;
        try {
            UtenteDAO utenteDAO = daoFactory.getDAO(UtenteDAO.class);
            Utente utente = utenteDAO.getByPrimaryKey(idUtente);

            if(utente != null) {
                String hashVecchia = Utilities.sha512(vecchiaPassword, utente.getSalt());
                if(hashVecchia.equals(utente.getPassword())) {
                    String hashNuova = Utilities.sha512(nuovaPassword, utente.getSalt());
                    utenteDAO.updatePassword(idUtente, hashNuova, utente.getSalt());
                    HttpSession session = request.getSession(false);
                    if (session != null) {
                        session.setAttribute("utente", utenteDAO.getByPrimaryKey(utente.getId()));
                    }
                    res = EMPTY_RESPONSE;

                    TokenRememberMeDAO tokenDAO = daoFactory.getDAO(TokenRememberMeDAO.class);
                    tokenDAO.deleteTokenByUtente(utente.getId());
                }
                else {
                    throw new ApiException(HttpServletResponse.SC_UNAUTHORIZED, "Old password is incorrect");
                }
            }
            else {
                throw new ApiException(HttpServletResponse.SC_NOT_FOUND, "Utente with such an id not found");
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
}
