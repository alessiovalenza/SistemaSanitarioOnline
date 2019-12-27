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
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
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
            } catch (DAOFactoryException ex) {
                throw new ServletException("Impossible to get dao factory for storage system");
            }
        }
        else {
            throw new ServletException("Impossible to get dao factory for storage system");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String id = request.getParameter("idrovincia");

        if(id == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }

        List<ElemReportProv> listReport = Collections.emptyList();

        try {
            if(provinciaDAO.getByPrimaryKey(id) == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "The specified id is not valid");
                return;
            }

            listReport = ricettaDAO.reportProvinciale(id);
        } catch (DAOException e) {
            e.printStackTrace();
        }

        response.setContentType("application/xls");
        String fileName = "report_prov_" + id + ".xls";
        response.addHeader("Content-Disposition", "inline; filename=" + fileName);

        Workbook workbook = new HSSFWorkbook();
        Sheet sheet = workbook.createSheet();

        int rowCount = 0;

        for (ElemReportProv report : listReport) {
            Row row = sheet.createRow(++rowCount);

            Cell cell = row.createCell(1);
            cell.setCellValue(report.getEmissione());

            cell = row.createCell(2);
            cell.setCellValue(report.getFarmaco());

            cell = row.createCell(3);
            cell.setCellValue(report.getFarmacia());

            cell = row.createCell(4);
            cell.setCellValue(report.getCfMedico());

            cell = row.createCell(5);
            cell.setCellValue(report.getCfPaziente());

            cell = row.createCell(6);
            cell.setCellValue(report.getPrezzo());
        }

        workbook.write(response.getOutputStream());
    }

}
