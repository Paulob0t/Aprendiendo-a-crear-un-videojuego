# 🎮 Aprendiendo a Crear un Videojuego - IDGS 1004 (Godot 4 3D)

Proyecto 3D desarrollado en **Godot Engine 4.7** enfocado en la importación de modelos y mallas 3D (`MeshInstance3D`), estructuración de personajes mediante `CharacterBody3D`, asignación de colisiones calculadas a medida (`CollisionShape3D`), iluminación y configuración de cámaras 3D.

---

## 👥 Personajes y Mallas 3D

Cada personaje está estructurado como un `CharacterBody3D` independiente que contiene su respectivo `MeshInstance3D` y su volumen de colisión `CollisionShape3D` (cápsula) ajustado a su altura y proporciones:

| Personaje | Origen | Nodo Raíz | Tipo de Malla | Colisión (`CapsuleShape3D`) |
| :--- | :--- | :--- | :--- | :--- |
| **Crash Bandicoot Clásico** | PlayStation 1 | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.62 m` \| Radio: `0.45 m` |
| **Trish** | *Devil May Cry 1* (PS2) | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.68 m` \| Radio: `0.35 m` |
| **Crash Traje Esqueleto** | *Crash of the Titans* (Xbox 360) | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.55 m` \| Radio: `0.45 m` |
| **Príncipe de Katamari** | *Katamari Damacy* (PS2) | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.17 m` \| Radio: `0.42 m` |
| **Crash Tag Team Racing** | *Crash Tag Team Racing* (PS2) | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.72 m` \| Radio: `0.45 m` |
| **Crash Nitro Kart Save Icon** | *Crash Nitro Kart* (PS2) | `CharacterBody3D` | Wavefront OBJ (`ArrayMesh`) | Altura: `1.70 m` \| Radio: `0.40 m` |

---

## Estructura del Proyecto

```text
idgs-1004-t-1/
├── controlador_personaje.gd         # Script de físicas, movimiento (WASD/Flechas), salto, apuntar y disparar
├── mundo.gd                         # Script gestor de selección de personajes, UI y cámara dinámica
├── modelos_videojuegos/
│   ├── aku_aku/                     # Mallas y texturas de la máscara Aku Aku
│   ├── crash_clasico_ps1/           # Modelo original de Crash Bandicoot PS1
│   ├── crash_nitro_kart_save_icon/  # Modelo de Memory Card CNK PS2
│   ├── crash_skeleton/              # Modelo Skeleton Suit Xbox 360
│   ├── crash_tag_team_racing/       # Modelo CTTR PS2
│   ├── katamari_icon/               # Modelo icono de Katamari Damacy PS2
│   └── trish_dmc1/                  # Modelo de Trish (Devil May Cry 1 PS2)
├── mundo.tscn                       # Escena 3D principal con menú UI, piso y personajes
├── project.godot                    # Configuración del proyecto e Input Map (WASD, Flechas, Clics)
└── README.md                        # Documentación del proyecto
```

---

## Características Técnicas

* **Modelos y Mallas 3D:** Integración directa de archivos `.obj` como recursos `ArrayMesh`.
* **Físicas y Colisiones:** `CharacterBody3D` con `CapsuleShape3D` personalizadas para cada personaje y `move_and_slide()`.
* **Sistema de Movimiento:** Control con WASD / Flechas, aceleración, frenado suave, rotación automática hacia la dirección de avance y salto.
* **Acciones de Acción:** Soporte para apuntar (Clic Derecho) y disparar (Clic Izquierdo).
* **Menú de Selección de Personajes:** Interfaz interactiva mediante `CanvasLayer` con botones accesibles y atajos de teclado del 1 al 6.
* **Cámara de Seguimiento:** Interpolación suave (`lerp`) que sigue dinámicamente al personaje activo.

---

## Cómo Ejecutar el Proyecto y Controles

1. Abre la carpeta del proyecto en **Godot Engine 4.x**.
2. Presiona **F5** para ejecutar `res://mundo.tscn`.
3. **Controles:**
   * **Moverse:** `W` `A` `S` `D` o `Flechas del teclado`
   * **Saltar:** `Espacio`
   * **Apuntar:** `Clic Derecho`
   * **Disparar:** `Clic Izquierdo`
   * **Cambiar de personaje:** Clic en los botones del menú superior o teclas `1` al `6`.
