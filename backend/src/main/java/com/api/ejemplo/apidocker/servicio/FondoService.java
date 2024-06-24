package com.api.ejemplo.apidocker.servicio;

import java.util.List;
import java.util.Optional;

//import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.api.ejemplo.apidocker.model.Fondo;
import com.api.ejemplo.apidocker.repository.FondoRepository;

@Service
public class FondoService {

    private final FondoRepository fondoRepository;

    //@Autowired
    public FondoService(FondoRepository fondoRepository) {
        this.fondoRepository = fondoRepository;
    }

    public Fondo crearFondo(Fondo fondo) {
        return fondoRepository.save(fondo);
    }

    public Optional<Fondo> obtenerFondo(String fondoId) {
        return fondoRepository.findById(fondoId);
    }

    public List<Fondo> obtenerTodosLosFondos() {
        return (List<Fondo>) fondoRepository.findAll();
    }

    public Fondo buscarPorNombreFondo(String nombreFondo) {
        return fondoRepository.findByNombreFondo(nombreFondo).orElse(null);
    }
}
