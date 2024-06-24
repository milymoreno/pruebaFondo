#!/bin/sh

# Crear tabla Clientes en DynamoDB con _id como UUID generado automáticamente
aws dynamodb create-table \
    --table-name Clientes \
    --attribute-definitions \
		AttributeName=Id,AttributeType=S \
    --key-schema AttributeName=Id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://localhost:4566 \
	
sleep 2
	
aws dynamodb create-table \
    --table-name Fondos \
    --attribute-definitions \
        AttributeName=fondoId,AttributeType=S \
    --key-schema AttributeName=fondoId,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://localhost:4566 \
	
sleep 2
	
	
aws dynamodb create-table \
    --table-name Transacciones \
    --attribute-definitions \
        AttributeName=TransaccionId,AttributeType=S \
		AttributeName=clienteId,AttributeType=S \
    --key-schema AttributeName=TransaccionId,KeyType=HASH AttributeName=clienteId,KeyType=RANGE  \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://localhost:4566 \

sleep 2
	
	
aws dynamodb put-item \
    --table-name Clientes \
    --item '{
        "Id": {"S": "unique_client_id"},
        "Nombres": {"S": "Nombres del Cliente"},
        "Apellidos": {"S": "Apellidos del Cliente"},
        "tipoIdentificacion": {"S": "Tipo identificacion del Cliente"},
        "numeroIdentificacion": {"S": "Numero de identificacion del Cliente"},
        "Email": {"S": "cliente@example.com"},
        "Telefono": {"S": "123456789"},
        "saldoActual": {"N": "500000"},
        "fondosSuscritos": {"L": [
            {"M": {
                "fondoId": {"S": "unique_fund_id"},
                "montoSuscrito": {"N": "500000"},
                "fechaSuscripcion": {"S": "2024-06-21T10:00:00Z"}
            }}
        ]},
        "historialTransacciones":{"L": [
            {"M": {
                "transactionId": {"S": "transaction_id_1"},
				"fondoId": {"S": "unique_fund_id_1"},
                "tipo": {"S": "apertura"},
                "monto": {"N": "500000"},
                "fecha": {"S": "2024-06-21T10:00:00Z"}
            }}
        ]},
        "preferenciaNotificacion": {"S": "email"}
    }' \
    --endpoint-url http://localhost:4566 \
	
sleep 2

aws dynamodb put-item \
    --table-name Clientes \
    --item '{
        "Id": {"S": "unique_client_id_generated_automatically"},
        "Nombres": {"S": "Nombres del Cliente"},
        "Apellidos": {"S": "Apellidos del Cliente"},
        "tipoIdentificacion": {"S": "Tipo identificacion del Cliente"},
        "numeroIdentificacion": {"S": "1020846521"},
        "Email": {"S": "cliente@example.com"},
        "Telefono": {"S": "123456789"},
        "saldoActual": {"N": "500000"},
        "preferenciaNotificacion": {"S": "email"}
    }' \
    --endpoint-url http://localhost:4566 \
	
sleep 2

aws dynamodb update-item \
    --table-name Clientes \
    --key '{"Id": {"S": "unique_client_id_generated_automatically"}}' \
    --update-expression "SET fondosSuscritos = :fondos" \
    --expression-attribute-values '{
        ":fondos": {"L": [
            {"M": {
                "fondoId": {"S": "unique_fund_id_1"},
                "montoSuscrito": {"N": "500000"},
                "fechaSuscripcion": {"S": "2024-06-21T10:00:00Z"}
            }},
            {"M": {
                "fondoId": {"S": "unique_fund_id_2"},
                "montoSuscrito": {"N": "300000"},
                "fechaSuscripcion": {"S": "2024-06-22T12:00:00Z"}
            }}
        ]}
    }' \
    --endpoint-url http://localhost:4566 \

sleep 2

aws dynamodb update-item \
    --table-name Clientes \
    --key '{"Id": {"S": "unique_client_id_generated_automatically"}}' \
    --update-expression "SET historialTransacciones = list_append(if_not_exists(historialTransacciones, :empty_list), :transacciones)" \
    --expression-attribute-values '{
        ":transacciones": {"L": [
            {"M": {
                "transactionId": {"S": "transaction_id_1"},
				"fondoId": {"S": "unique_fund_id_1"},
                "tipo": {"S": "apertura"},
                "monto": {"N": "500000"},
                "fecha": {"S": "2024-06-21T10:00:00Z"}
            }}
        ]},
        ":empty_list": {"L": []}
    }' \
    --endpoint-url http://localhost:4566 \
	
sleep 2
	aws dynamodb put-item \
    --table-name Fondos \
    --item '{
        "fondoId": {"S": "unique_fund_id_2"},        
        "nombreFondo": {"S": "Fondo Ejemplo 2"},
        "descripcion": {"S": "Descripción del Fondo Ejemplo 2"},
        "montoSuscrito": {"N": "100000"},
        "fechaSuscripcion": {"S": "2024-06-21T10:00:00Z"}
    }' \
    --endpoint-url http://localhost:4566  \
	
sleep 2
	
	aws dynamodb put-item \
    --table-name HistorialTransacciones \
    --item '{
        "TransaccionId": {"S": "transaction_id_1"},
        "fondoId": {"S": "unique_fund_id_1"},
		"clienteId": {"S": "unique_client_id_generated_automatically"},
        "tipo": {"S": "apertura"},
        "monto": {"N": "500000"},
        "fecha": {"S": "2024-06-21T10:00:00Z"}
    }' \
    --endpoint-url http://localhost:4566 \

