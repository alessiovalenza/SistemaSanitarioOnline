package it.unitn.disi.wp.progetto.servlets;

import it.unitn.disi.wp.progetto.persistence.dao.RicettaDAO;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOException;
import it.unitn.disi.wp.progetto.persistence.dao.exceptions.DAOFactoryException;
import it.unitn.disi.wp.progetto.persistence.dao.factories.DAOFactory;
import it.unitn.disi.wp.progetto.persistence.entities.ElemReportNazionale;
import it.unitn.disi.wp.progetto.persistence.entities.ElemReportProv;
import it.unitn.disi.wp.progetto.servlets.exceptions.SSOServletException;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.sl.usermodel.ColorStyle;
import org.apache.poi.ss.format.CellNumberStringMod;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "XLSReportNazServlet", urlPatterns = {"/docs/reportnazionale"})
public class XLSReportNazServlet extends HttpServlet {

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

        List<ElemReportNazionale> listReport = Collections.emptyList();

        response.setContentType("application/xls");
        String fileName = "report_nazionale.xls";
        response.addHeader("Content-Disposition", "inline; filename=" + fileName);

        try {
            listReport = ricettaDAO.reportNazionale(from, to);
        }
        catch (DAOException e) {
            throw new SSOServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    e.getMessage() + " - Errors occurred when accessing storage system");
        }

        Workbook workbook = new HSSFWorkbook();
        Sheet sheet = workbook.createSheet();

        CellStyle background = workbook.createCellStyle();
        background.setFillBackgroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        background.setFillPattern(FillPatternType.SOLID_FOREGROUND);

        int rowCount = -1;
        Row row_titoli = sheet.createRow(++rowCount);

        Cell cell_titoli = row_titoli.createCell(0);
        cell_titoli.setCellValue("PROVINCIA");
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
        cell_titoli.setCellValue("SPESA MEDICO");
        cell_titoli.setCellStyle(background);

        for (ElemReportNazionale report : listReport) {
            Row row = sheet.createRow(++rowCount);

            Cell cell = row.createCell(0);
            cell.setCellValue(report.getProvincia());

            cell = row.createCell(1);
            cell.setCellValue(report.getCfMedico());

            cell = row.createCell(2);
            cell.setCellValue(report.getNomeMedico());

            cell = row.createCell(3);
            cell.setCellValue(report.getCognomeMedico());

            cell = row.createCell(4);
            cell.setCellValue(String.format("%.2f", report.getSpesa()));
        }

/*
        for (int i=0 ; i<5 ; i++) {
            Row row = sheet.createRow(++rowCount);

            Cell cell = row.createCell(0);
            cell.setCellValue("ciaoffffffffffdsffafsdfff");

            cell = row.createCell(1);
            cell.setCellValue("Cd/r)m3s3333333m");

            cell = row.createCell(2);
            cell.setCellValue("13352345434534353$");

        }*/

        sheet.autoSizeColumn(0);
        sheet.autoSizeColumn(1);
        sheet.autoSizeColumn(2);
        sheet.autoSizeColumn(3);
        sheet.autoSizeColumn(4);

        workbook.write(response.getOutputStream());
    }
}
