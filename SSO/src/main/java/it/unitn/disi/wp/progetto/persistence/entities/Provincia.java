package it.unitn.disi.wp.progetto.persistence.entities;

import java.io.Serializable;

public class Provincia implements Serializable {
    private String id;
    private String nome;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }
}
