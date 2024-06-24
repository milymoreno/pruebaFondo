package com.api.ejemplo.apidocker.model;

//import lombok.Data;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAutoGeneratedKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;


@DynamoDBTable(tableName = "Fondos")
public class Fondo {

    private String fondoId;
    private String nombreFondo;
    private String descripcion;
    private double montoSuscrito; // Este campo podría ser parte de los fondos suscritos si necesitas llevar un registro específico

    @DynamoDBAutoGeneratedKey
    @DynamoDBHashKey(attributeName = "fondoId")
    public String getFondoId() {
        return fondoId;
    }

    public void setFondoId(String fondoId) {
        this.fondoId = fondoId;
    }

    @DynamoDBAttribute(attributeName = "nombreFondo")
    public String getNombreFondo() {
        return nombreFondo;
    }

    public void setNombreFondo(String nombreFondo) {
        this.nombreFondo = nombreFondo;
    }

    @DynamoDBAttribute(attributeName = "descripcion")
    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @DynamoDBAttribute(attributeName = "montoSuscrito")
    public double getMontoSuscrito() {
        return montoSuscrito;
    }

    public void setMontoSuscrito(double montoSuscrito) {
        this.montoSuscrito = montoSuscrito;
    }

    // Otros atributos y métodos según sea necesario
}