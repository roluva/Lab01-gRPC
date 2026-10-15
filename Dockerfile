FROM python:3.10-slim-bullseye

WORKDIR /app

# Instalar dependencias desactivando la barra de progreso
RUN python -m pip install --no-cache-dir --progress-bar off grpcio grpcio-tools protobuf

# Copiar las carpetas necesarias del proyecto
COPY proto/ ./proto/
COPY servidor/ ./servidor/

# Crear carpeta generated y compilar el archivo .proto
RUN mkdir -p generated && \
    python -m grpc_tools.protoc -I./proto --python_out=./generated --grpc_python_out=./generated ./proto/calculadora.proto

# Configurar PYTHONPATH como indica el Paso 4 del README
ENV PYTHONPATH="/app:/app/generated"

# Exponer el puerto 50051
EXPOSE 50051

# Paso 5 del README: Ejecutar el servidor
CMD ["python", "-u", "servidor/server.py"]
