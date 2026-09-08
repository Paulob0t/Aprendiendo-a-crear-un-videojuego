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

## 📁 Estructura del Proyecto

```text
idgs-1004-t-1/
├── modelos_videojuegos/
│   ├── aku_aku/                     # Mallas y texturas de la máscara Aku Aku
│   ├── crash_clasico_ps1/           # Modelo original de Crash Bandicoot PS1
│   ├── crash_nitro_kart_save_icon/  # Modelo de Memory Card CNK PS2
│   ├── crash_skeleton/              # Modelo Skeleton Suit Xbox 360
│   ├── crash_tag_team_racing/       # Modelo CTTR PS2
│   ├── katamari_icon/               # Modelo icono de Katamari Damacy PS2
│   └── trish_dmc1/                  # Modelo de Trish (Devil May Cry 1 PS2)
├── mundo.tscn                       # Escena 3D principal con todos los personajes, cámara y luz
├── project.godot                    # Configuración general del proyecto Godot 4
└── README.md                        # Documentación del proyecto
```

---

## ⚙️ Características Técnicas

* **Modelos y Mallas 3D:** Integración directa de archivos `.obj` como recursos `ArrayMesh`.
* **Materiales y Texturas:** Corrección de componentes de luz difusa (`Kd`) en archivos `.mtl` y mapeo en `StandardMaterial3D` con filtrado nítido para texturas retro.
* **Físicas y Colisiones:** Dimensionamiento de cápsulas de colisión a partir de las dimensiones del Bounding Box (AABB) escalado de cada modelo.
* **Escena Principal (`mundo.tscn`):**
  * `DirectionalLight3D` orientada para generar sombras y volumen tridimensional.
  * `Camera3D` con encuadre panorámico ajustado para mostrar la vitrina completa de personajes.

---

## 🚀 Cómo Ejecutar el Proyecto

1. Clona este repositorio o abre la carpeta en **Godot Engine 4.x** (compatible con Godot 4.7+).
2. Abre la escena principal `res://mundo.tscn`.
3. Presiona **F5** (o el botón *Play* en la esquina superior derecha) para ejecutar la simulación 3D.
