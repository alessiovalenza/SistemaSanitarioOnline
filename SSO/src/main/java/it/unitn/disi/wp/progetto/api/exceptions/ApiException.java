package it.unitn.disi.wp.progetto.api.exceptions;

public class ApiException extends RuntimeException {
    private int statusErrorCode;

    public ApiException(int statusErrorCode, String message) {
        super(message);
        this.statusErrorCode = statusErrorCode;
    }

    public int getStatusErrorCode() {
        return statusErrorCode;
    }
}
