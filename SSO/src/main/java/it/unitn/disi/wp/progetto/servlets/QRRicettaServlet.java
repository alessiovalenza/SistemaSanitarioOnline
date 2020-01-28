package it.unitn.disi.wp.progetto.servlets;

import com.itextpdf.io.font.constants.StandardFonts;
import com.itextpdf.io.image.ImageData;
import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.colors.ColorConstants;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.*;
import com.itextpdf.layout.property.HorizontalAlignment;
import com.itextpdf.layout.property.VerticalAlignment;
import it.unitn.disi.wp.progetto.commons.Utilities;
import it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.Ricetta;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.persistence.entities.UtenteView;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;

@WebServlet(name = "QRRicettaServlet", urlPatterns = {"/docs/ricette"})
public class QRRicettaServlet extends HttpServlet {
    private RicettaDAO ricettaDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory != null) {
            try {
                ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
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
        String idStr = request.getParameter("id");

        if(idStr == null) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You must specify an id");
        }

        try {
            long id = Long.parseLong(idStr);

            try {
                Ricetta ricetta = ricettaDAO.getByPrimaryKey(id);
                if(ricetta == null) {
                    throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Id not found");
                }

                HttpSession session = request.getSession(false);
                if(session != null && session.getAttribute("utente") != null && ((Utente)session.getAttribute("utente")).getId() != ricetta.getPaziente().getId()) {
                    throw new SSOServletException(HttpServletResponse.SC_FORBIDDEN, "You are trying to access someone else's data");
                }

                File fileQR = new File(getServletContext().getRealPath(File.separator + Utilities.TEMP_FOLDER + File.separator + (Utilities.tempFileCount++) + ".jpg"));
                FileOutputStream streamQR = new FileOutputStream(fileQR);

                String content = ricetta.getMedicoBase().getId() + "-" +
                        ricetta.getPaziente().getCodiceFiscale() + "-" +
                        ricetta.getEmissione() + "-" +
                        ricetta.getId() +"-" +
                        ricetta.getFarmaco().getDescrizione();

                ByteArrayOutputStream qrOut = QRCode.from(content).to(ImageType.JPG).stream();
                qrOut.writeTo(streamQR);

                response.setContentType("application/pdf");
                String fileName = "ricetta_" + id + ".pdf";
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
                Text subtitleText = new Text("Ricetta farmaceutica");
                subtitleText.setHorizontalAlignment(HorizontalAlignment.CENTER);
                subtitleText.setFontSize(16);
                headerText.setBold();
                subtitleText.setFontColor(ColorConstants.DARK_GRAY);
                subtitle.add(subtitleText);

                document.add(subtitle);

                UtenteView paziente;
                float[] colWidths = {100, 200};
                Table table;

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

                table.addCell(new Cell().add(new Paragraph(new Text("Farmaco prescritto").setBold()))
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

                table.addCell(new Cell().add(new Paragraph(new Text("Data prescrizione").setBold()))
                        .setBackgroundColor(ColorConstants.LIGHT_GRAY)
                        .setVerticalAlignment(VerticalAlignment.MIDDLE)
                        .setHorizontalAlignment(HorizontalAlignment.LEFT)
                        .setHeight(24));
                table.addCell(new Cell().add(new Paragraph(new Text(ricetta.getEmissione().toString())))
                        .setVerticalAlignment(VerticalAlignment.MIDDLE)
                        .setHorizontalAlignment(HorizontalAlignment.RIGHT));

                document.add(table);

                ImageData qrData = ImageDataFactory.create(fileQR.getAbsolutePath());
                Image qrImage = new Image(qrData);

                document.add(qrImage);

                document.close();

            }
            catch (DAOException e) {
                throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        e.getMessage() + " - Errors occurred when accessing storage system");
            }
        }
        catch(NumberFormatException e) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST, "You must specify an id");
        }
    }
}