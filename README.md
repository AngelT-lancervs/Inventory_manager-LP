# Inventory_manager-LP
# README - Aplicación Móvil para Inventarios de "Mágico Mundo Nintendo"

## Título del Proyecto
**Aplicación móvil para realizar inventarios para el local de Ceibos de la franquicia de tiendas "Mágico Mundo Nintendo"**

## Integrantes del Grupo
- **Andrés Amador**
- **Andrés Cornejo**
- **Angel Tomalá**

## 1. Problemática a Resolver
La actividad de realizar inventarios en negocios con muchos productos puede ser complicada y consumir mucho tiempo. Usando métodos tradicionales como Excel, existe el riesgo de perder registros o cometer errores de conteo, lo que puede llevar a desorganización y dificultades en la corrección de estos errores. Un mal inventariado puede traducirse en pérdidas económicas y malas decisiones administrativas.

## 2. Objetivos Propuestos

### Objetivo General
Desarrollar una aplicación móvil que permita la creación de inventarios para el local de Ceibos de la franquicia "Mágico Mundo Nintendo", facilitando la actividad y minimizando errores.

### Objetivos Específicos
- **Modificar el stock actual**: Implementar una pantalla que muestre una lista de productos y permita la modificación del stock actual de los productos incluidos en un archivo (Excel o JSON).
- **Generar reportes**: Crear un reporte legible para el usuario con todos los datos de los productos actualizados, mediante una conversión de datos de JSON a Excel.
- **Sistema de borradores**: Agregar un sistema para guardar borradores con la información actualizada durante la sesión.

## 3. Alcance del Proyecto
El proyecto cubrirá las funciones básicas necesarias para realizar inventarios, incluyendo la visualización del stock anterior, el nombre del producto, y su ID. No se contemplará la actualización en tiempo real en la base de datos, ya que la app solo generará un reporte con los stocks actuales de los productos. El servidor se levantará de manera local.

## 4. Características de la Solución
La aplicación contará con las siguientes características clave:
- **Pantalla de login**: Acceso solo a personas autorizadas.
- **Gestión de inventarios**: Crear nuevos inventarios o cargar borradores existentes.
- **Actualización de productos**: Visualización de la lista de productos, con opción de actualizar su stock y agregar nuevos productos.
- **Manejo de borradores**: Guardar y actualizar borradores, marcarlos como completados, y eliminarlos según sea necesario. Los borradores guardados se mostrarán en una pantalla específica.
- **Barra de búsqueda y filtros**: Facilitar la localización de productos en la lista, con opción de filtrar por productos revisados y no revisados.
- **Pantalla de detalles de inventario**: Mostrar información detallada del inventario, como quién lo creó y la fecha de creación.
- **Generación de reportes**: Exportar un Excel con todos los productos actualizados y un PDF con los productos que tienen diferencias en stock.
- **Pantalla Home**: Opción para iniciar un inventario nuevo o continuar un borrador existente.
- **Usuarios predefinidos**: No se implementará una funcionalidad de registro, ya que los usuarios serán predefinidos para evitar accesos no autorizados.

## 5. Requerimientos Funcionales Asignados
- **Andrés Amador**: Requerimientos funcionales 2, 9, 10, 13, 15.
- **Andrés Cornejo**: Requerimientos funcionales 4, 5, 6, 8.
- **Angel Tomalá**: Requerimientos funcionales 3, 11, 12, 7.

Los demás requerimientos se irán asignando conforme avance el proyecto.

## 6. Implementación
La implementación de la aplicación seguirá una estructura modular, con cada integrante encargado de los requerimientos asignados. Se utilizarán metodologías ágiles para garantizar la entrega de cada módulo en el tiempo previsto. Las funcionalidades desarrolladas serán integradas y testeadas en conjunto para asegurar la coherencia y robustez de la solución final.

## 7. Instrucciones de Instalación
1. **Clonar el repositorio**: Clonar el proyecto desde el repositorio utilizando `git clone [URL del repositorio]`.
2. **Configurar el entorno**: Instalar las dependencias necesarias ejecutando `npm install` (o el gestor de paquetes correspondiente).
3. **Levantar el servidor local**: Configurar y ejecutar el servidor local con los datos de ejemplo proporcionados.
4. **Ejecutar la aplicación**: Iniciar la aplicación en un emulador o dispositivo móvil real para realizar pruebas.

## 8. Uso de la Aplicación
1. **Crear un nuevo inventario**: Desde la pantalla Home, seleccionar "Nuevo Inventario" para comenzar.
2. **Modificar productos**: Seleccionar un producto de la lista para actualizar su stock.
3. **Guardar borradores**: Guardar el progreso como borrador si no se completa el inventario.
4. **Generar reportes**: Al finalizar, generar un reporte en Excel o PDF con los datos actualizados.

## 9. Contribución
Si deseas contribuir al proyecto, por favor sigue las directrices de contribución incluidas en el archivo `CONTRIBUTING.md`. Asegúrate de hacer pruebas exhaustivas antes de enviar una pull request.

## 10. Licencia
Este proyecto está bajo la Licencia MIT. Consulta el archivo `LICENSE` para más detalles.

---

Este archivo README ofrece una visión general del proyecto y proporciona las instrucciones necesarias para su instalación y uso. Si tienes alguna pregunta adicional, no dudes en ponerte en contacto con nosotros. ¡Gracias por tu interés en nuestra aplicación móvil de inventarios!
