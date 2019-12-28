package it.unitn.disi.wp.progetto.servlets.exceptions;

public class SSOServletException extends RuntimeException {
    private int statusErrorCode;

    public SSOServletException(int statusErrorCode, String message) {
        super(message);
        this.statusErrorCode = statusErrorCode;
    }

    public int getStatusErrorCode() {
        return statusErrorCode;
    }
}
