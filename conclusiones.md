---
layout: default
title: 11. Conclusiones
nav_order: 11
---

# Conclusiones

El desarrollo realizado hasta el momento permitió comprobar experimentalmente conceptos fundamentales del control moderno mediante la plataforma QUBE-Servo 3.

El modelo linealizado mostró que el sistema presenta un polo localizado en el semiplano derecho, confirmando matemáticamente la naturaleza inestable del equilibrio correspondiente al péndulo invertido.

El análisis de controlabilidad produjo un rango igual al número de estados del modelo, demostrando que el sistema puede ser controlado mediante la entrada disponible.

A partir de este resultado fue posible diseñar un controlador LQR utilizando matrices de ponderación $Q$ y $R$.

La ganancia obtenida fue posteriormente implementada en Simulink y llevada al sistema físico.

Durante las pruebas experimentales se observó que, al colocar el péndulo suficientemente cerca de la posición vertical, el controlador es capaz de generar los movimientos necesarios del brazo para compensar las perturbaciones y conservar el equilibrio.

Esto permite validar la correspondencia entre el modelo matemático, el diseño realizado en MATLAB y la implementación experimental.

Como continuación del proyecto se desarrollará un observador de estados, se analizará el error entre variables medidas y estimadas y se completará el análisis de la respuesta en frecuencia.

La integración de estas etapas permitirá disponer de una implementación más completa del sistema de control del péndulo invertido.
