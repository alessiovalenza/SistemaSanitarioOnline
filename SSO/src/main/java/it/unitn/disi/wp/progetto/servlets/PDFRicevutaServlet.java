package it.unitn.disi.wp.progetto.servlets;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.element.Text;
import com.itextpdf.layout.property.HorizontalAlignment;
import com.itextpdf.layout.property.VerticalAlignment;
import it.unitn.disi.wp.progetto.persistence.dao.EsamePrescrittoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaMedicoSpecialistaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.*;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

@WebServlet(name = "PDFDetrazioneServlet", urlPatterns = {"/docs/ricevute"})
public class PDFRicevutaServlet extends HttpServlet {
    private final String RICETTA = "ricetta";
    private final String ESAME = "esame";
    private final String VISITA = "visita";

    private RicettaDAO ricettaDAO;
    private EsamePrescrittoDAO esameDAO;
    private VisitaMedicoSpecialistaDAO visitaDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory != null) {
            try {
                ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                esameDAO = daoFactory.getDAO(EsamePrescrittoDAO.class);
                visitaDAO = daoFactory.getDAO(VisitaMedicoSpecialistaDAO.class);
            }
            catch (DAOFactoryException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Impossible to get dao interface for storage system");
            }
        }
        else {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Impossible to get dao factory for storage system");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tipo = request.getParameter("tipo");
        String idStr = request.getParameter("id");

        if(tipo == null || idStr == null) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters, you must specify type and id");
        }

        if(!tipo.equals(RICETTA) && !tipo.equals(ESAME) && !tipo.equals(VISITA)) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "The type must be either \"ricetta\" or \"esame\" or \"visita\"");
        }

        try {
            long id = Long.parseLong(idStr);

            HttpSession session = request.getSession(false);

            try {
                if(checkBadRequest(tipo, id)) {
                    throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Id not found");
                }

                if (session != null && session.getAttribute("utente") != null && !checkAuthZ(tipo, id, (Utente) session.getAttribute("utente"))) {
                    throw new SSOServletException(HttpServletResponse.SC_FORBIDDEN, "You are trying to access someone else's data");
                }

                response.setContentType("application/pdf");
                String fileName = "ricevuta_" + tipo + "_" + id + ".pdf";
                response.addHeader("Content-Disposition", "inline; filename=" + fileName);

                PdfDocument pdfDocument = new PdfDocument(new PdfWriter(response.getOutputStream()));
                Document document = new Document(pdfDocument);

                PdfFont font = PdfFontFactory.createFont(StandardFonts.HELVETICA);
                document.setFont(font);

                Paragraph header = new Paragraph();
                Text headerText = new Text("Sistema sanitario nazionale - Repubblica Italiana");
                headerText.setHorizontalAlignment(HorizontalAlignment.CENTER);
                headerText.setFontSize(24);
                headerText.setBold();
                header.add(headerText);

                document.add(header);

                Paragraph subtitle = new Paragraph();
                Text subtitleText = new Text("Ricevuta fiscale per pagamento ticket " + tipo);
                subtitleText.setHorizontalAlignment(HorizontalAlignment.CENTER);
                subtitleText.setFontSize(16);
                headerText.setBold();
                subtitleText.setFontColor(ColorConstants.DARK_GRAY);
                subtitle.add(subtitleText);

                document.add(subtitle);

                UtenteView paziente;
                float[] colWidths = {100, 200};
                Table table;

                String pattern = "dd/MM/yyyy";
                DateFormat dateFormat = new SimpleDateFormat(pattern);

                switch (tipo) {
                    case RICETTA:
                        Ricetta ricetta = ricettaDAO.getByPrimaryKey(id);

                        if(ricetta.getEvasione() == null) {
                            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You can have a ricevuta only for a ricettta that you already paid for");
                        }

                        paziente = ricetta.getPaziente();

                        table = new Table(colWidths).useAllAvailableWidth();

                        table.addCell(new Cell().add(new Paragraph(new Text("Cognome e nome dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCognome() + " " + paziente.getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Codice fiscale dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCodiceFiscale())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Farmaco evaso").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(ricetta.getFarmaco().getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Prezzo ticket").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(String.format("€ %.2f", Double.parseDouble(getServletContext().getInitParameter("ticketricetta"))))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Data evasione").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(dateFormat.format(ricetta.getEvasione()))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Beneficiario").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(ricetta.getFarmacia().getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        document.add(table);
                        break;
                    case ESAME:
                        EsamePrescritto esame = esameDAO.getByPrimaryKey(id);
                        paziente = esame.getPaziente();

                        if(esame.getErogazione() == null) {
                            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You can have a ricevuta only for an esame prescritto that you already paid for");
                        }

                        table = new Table(colWidths).useAllAvailableWidth();

                        table.addCell(new Cell().add(new Paragraph(new Text("Cognome e nome dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCognome() + " " + paziente.getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Codice fiscale dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCodiceFiscale())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Esame erogato").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(esame.getEsame().getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Prezzo ticket").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        Double prezzo = (esame.getMedicoBase() == null ? 0.00 : EsamePrescrittoDAO.PREZZO_TICKET);
                        table.addCell(new Cell().add(new Paragraph(new Text(String.format("€ %.2f", prezzo))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Data erogazione").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(dateFormat.format(esame.getErogazione()))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Beneficiario").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text("SSP " + paziente.getProv())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        document.add(table);
                        break;
                    case VISITA:
                        VisitaMedicoSpecialista visita = visitaDAO.getByPrimaryKey(id);
                        paziente = visita.getPaziente();

                        if(visita.getErogazione() == null) {
                            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You can have a ricevuta only for a visita specialistica that you already paid for");
                        }

                        table = new Table(colWidths).useAllAvailableWidth();

                        table.addCell(new Cell().add(new Paragraph(new Text("Cognome e nome dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCognome() + " " + paziente.getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Codice fiscale dell'assitito").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(paziente.getCodiceFiscale())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Visita erogata").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(visita.getVisita().getNome())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Prezzo ticket").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(String.format("€ %.2f", Double.parseDouble(getServletContext().getInitParameter("ticketvisita"))))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Data erogazione").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text(dateFormat.format(visita.getErogazione()))))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        table.addCell(new Cell().add(new Paragraph(new Text("Beneficiario").setBold()))
                                .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.LEFT)
                                .setHeight(24));
                        table.addCell(new Cell().add(new Paragraph(new Text("SSP " + paziente.getProv())))
                                .setVerticalAlignment(VerticalAlignment.MIDDLE)
                                .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                        document.add(table);
                        break;
                }

                document.close();
            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        catch (NumberFormatException e) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You must specify an id");
        }
    }

    private boolean checkBadRequest(String tipo, long id) throws DAOException {
        boolean res = true;

        switch(tipo) {
            case RICETTA:
                Ricetta ricetta = ricettaDAO.getByPrimaryKey(id);
                if(ricetta != null) {
                    res = false;
                }
                break;
            case ESAME:
                EsamePrescritto esamePrescritto = esameDAO.getByPrimaryKey(id);
                if(esamePrescritto != null) {
                    res = false;
                }
                break;
            case VISITA:
                VisitaMedicoSpecialista visitaMedicoSpecialista = visitaDAO.getByPrimaryKey(id);
                if(visitaMedicoSpecialista != null) {
                    res = false;
                }
                break;
        }

        return res;
    }

    private boolean checkAuthZ(String tipo, long id, Utente paziente) throws DAOException {
        boolean res = false;

        switch(tipo) {
            case RICETTA:
                Ricetta ricetta = ricettaDAO.getByPrimaryKey(id);
                if(ricetta != null && ricetta.getPaziente().getId() == paziente.getId()) {
                    res = true;
                }
                break;
            case ESAME:
                EsamePrescritto esamePrescritto = esameDAO.getByPrimaryKey(id);
                if(esamePrescritto != null && esamePrescritto.getPaziente().getId() == paziente.getId()) {
                    res = true;
                }
                break;
            case VISITA:
                VisitaMedicoSpecialista visitaMedicoSpecialista = visitaDAO.getByPrimaryKey(id);
                if(visitaMedicoSpecialista != null && visitaMedicoSpecialista.getPaziente().getId() == paziente.getId()) {
                    res = true;
                }
                break;
        }

        return res;
    }
}