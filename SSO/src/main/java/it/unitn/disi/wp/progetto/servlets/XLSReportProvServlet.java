package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.persistence.dao.EsamePrescrittoDAO;
import it.unitn.disi.wp.progetto.persistence.dao.ProvinciaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.VisitaMedicoSpecialistaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.ElemReportProv;
import it.unitn.disi.wp.progetto.persistence.entities.Provincia;
import it.unitn.disi.wp.progetto.persistence.entities.Utente;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "XLSReportProvServlet", urlPatterns = {"/docs/reportprov"})
public class XLSReportProvServlet extends HttpServlet {

    private RicettaDAO ricettaDAO;
    private ProvinciaDAO provinciaDAO;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory != null) {
            try {
                ricettaDAO = daoFactory.getDAO(RicettaDAO.class);
                provinciaDAO = daoFactory.getDAO(ProvinciaDAO.class);
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

        String id = request.getParameter("idprovincia");
        Timestamp from;
        Timestamp to;
        try {
            from = Timestamp.valueOf(request.getParameter("fromDay") + " 00:00:00");
            to = Timestamp.valueOf(request.getParameter("toDay") + " 23:59:59");
        }
        catch (IllegalArgumentException e) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST,
                    "The dates you specified are in a wrong format or you have not specified them at all");
        }

        if(id == null) {
            throw new SSOServletException(HttpServletResponse.SC_BAD_REQUEST,
                    "You must specify the id of the provincia and the span of time for the report");
        }

        List<ElemReportProv> listReport = Collections.emptyList();

        try {

            if(provinciaDAO.getByPrimaryKey(id) == null) {
                throw new SSOServletException(HttpServletResponse.SC_NOT_FOUND, "Provincia not found");
            }

            HttpSession session = request.getSession(false);
            if(session != null && session.getAttribute("utente") != null && !((Utente)session.getAttribute("utente")).getProv().equals(id)) {
                throw new SSOServletException(HttpServletResponse.SC_FORBIDDEN, "You are trying to access another provincia's data");
            }

            listReport = ricettaDAO.reportProvinciale(id, from, to);

        }
        catch (DAOException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        response.setContentType("application/xls");
        String fileName = "report_prov_" + id + ".xls";
        response.addHeader("Content-Disposition", "inline; filename=" + fileName);

        Workbook workbook = new HSSFWorkbook();
        Sheet sheet = workbook.createSheet();

        CellStyle background = workbook.createCellStyle();
        background.setFillBackgroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        background.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        int rowCount = -1;
        Row row_titoli = sheet.createRow(++rowCount);

        Cell cell_titoli = row_titoli.createCell(0);
        cell_titoli.setCellValue("EMISSIONE");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(1);
        cell_titoli.setCellValue("CF MEDICO");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(2);
        cell_titoli.setCellValue("NOME MEDICO");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(3);
        cell_titoli.setCellValue("COGNOME MEDICO");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(4);
        cell_titoli.setCellValue("CF PAZIENTE");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(5);
        cell_titoli.setCellValue("NOME PAZIENTE");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(6);
        cell_titoli.setCellValue("COGNOME PAZIENTE");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(7);
        cell_titoli.setCellValue("FARMACO");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(8);
        cell_titoli.setCellValue("PREZZO");
        cell_titoli.setCellStyle(background);

        cell_titoli = row_titoli.createCell(9);
        cell_titoli.setCellValue("FARMACIA");
        cell_titoli.setCellStyle(background);

        for (ElemReportProv report : listReport) {
            Row row = sheet.createRow(++rowCount);

            Cell cell = row.createCell(0);
            cell.setCellValue(report.getEmissione());

            cell = row.createCell(1);
            cell.setCellValue(report.getCfMedico());

            cell = row.createCell(2);
            cell.setCellValue(report.getNomeMedico());

            cell = row.createCell(3);
            cell.setCellValue(report.getCognomeMedico());

            cell = row.createCell(4);
            cell.setCellValue(report.getCfPaziente());

            cell = row.createCell(5);
            cell.setCellValue(report.getNomePaziente());

            cell = row.createCell(6);
            cell.setCellValue(report.getCognomePaziente());

            cell = row.createCell(7);
            cell.setCellValue(report.getFarmaco());

            cell = row.createCell(8);
            cell.setCellValue(report.getPrezzo());

            cell = row.createCell(9);
            cell.setCellValue(report.getFarmacia());
        }

        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
        sheet.autoSizeColumn(2);
        sheet.autoSizeColumn(3);
        sheet.autoSizeColumn(4);
        sheet.autoSizeColumn(5);
        sheet.autoSizeColumn(6);
        sheet.autoSizeColumn(7);
        sheet.autoSizeColumn(8);
        sheet.autoSizeColumn(9);
        workbook.write(response.getOutputStream());
    }

}
