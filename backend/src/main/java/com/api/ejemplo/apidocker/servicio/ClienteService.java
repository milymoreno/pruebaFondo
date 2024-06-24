package com.api.ejemplo.apidocker.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import com.api.ejemplo.apidocker.model.Cliente;
import com.api.ejemplo.apidocker.model.FondoSuscrito;
import com.api.ejemplo.apidocker.model.Transaccion;
import com.api.ejemplo.apidocker.repository.ClienteRepository;

@Service
public class ClienteService {

    private final ClienteRepository clienteRepository;

    public ClienteService(ClienteRepository clienteRepository) {
        this.clienteRepository = clienteRepository;
    }

    public Cliente crearCliente(Cliente cliente) {
        return clienteRepository.save(cliente);
    }

    public Optional<Cliente> obtenerCliente(String id) {
        return clienteRepository.findById(id);
    }

   

    public Cliente asociarFondos(String clienteId, List<FondoSuscrito> fondosSuscritos) {
        Cliente cliente = clienteRepository.findById(clienteId)
                                           .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));

        // Inicializar la lista de fondos suscritos del cliente si es null
        List<FondoSuscrito> fondos = cliente.getFondosSuscritos();
        if (fondos == null) {
            fondos = new ArrayList<>();
            cliente.setFondosSuscritos(fondos);
        }

        // Validar si la lista de nuevos fondos suscritos no es null
        if (fondosSuscritos != null) {
            fondos.addAll(fondosSuscritos);
        }

        // Guardar los cambios en DynamoDB
        return clienteRepository.save(cliente);
    }

    
    public Cliente realizarTransaccion(String clienteId, List<Transaccion> transacciones) {
        Cliente cliente = clienteRepository.findById(clienteId)
                                           .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));

        List<Transaccion> historialTransacciones = cliente.getHistorialTransacciones();
        if (historialTransacciones == null) {
            historialTransacciones = new ArrayList<>();
        }

        for (Transaccion transaccion : transacciones) {
            if ("apertura".equals(transaccion.getTipo())) {
                cliente.setSaldoActual(cliente.getSaldoActual() - transaccion.getMonto());
            } else if ("cancelacion".equals(transaccion.getTipo())) {
                cliente.setSaldoActual(cliente.getSaldoActual() + transaccion.getMonto());
            }

            historialTransacciones.add(transaccion);
        }

        cliente.setHistorialTransacciones(historialTransacciones);
        return clienteRepository.save(cliente);
    }

    public Cliente buscarPorNumeroIdentificacion(String numeroIdentificacion) {
        return clienteRepository.findByNumeroIdentificacion(numeroIdentificacion)
                .orElseThrow(() -> new RuntimeException("Cliente no encontrado"));
    }

    
}
