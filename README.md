# TechMarket CI/CD Templates

**Versión:** v1.0.0 | **Asignatura:** AUY1104 - Ciclo de vida del Software II

---

## Descripción General

Este repositorio contiene plantillas reutilizables de CI/CD diseñadas para estandarizar los pipelines de **TechMarket**, una empresa de tecnología que requiere consistencia operativa entre múltiples equipos de desarrollo.

Las plantillas cubren las tres etapas principales del ciclo de vida del software:

- `template_build.yml` — Construcción de la aplicación
- `template_test.yml` — Pruebas automatizadas con cobertura
- `template_deploy.yml` — Despliegue en AWS (ECR + ECS)

---

## Estructura de Carpetas

```
.github/
└── workflows/
    ├── pipeline.yml                  ← Orquestador principal
    └── templates/
        ├── template_build.yml        ← Plantilla de Build (v1.0.0)
        ├── template_test.yml         ← Plantilla de Test (v1.0.0)
        └── template_deploy.yml       ← Plantilla de Deploy (v1.0.0)
```

---

## Cómo Usar las Plantillas

### Uso desde otro workflow del equipo

```yaml
jobs:
  build:
    uses: ./.github/workflows/templates/template_build.yml
    with:
      node-version: "18"
      environment: "staging"
      artifact-name: "mi-proyecto-build"

  test:
    needs: build
    uses: ./.github/workflows/templates/template_test.yml
    with:
      coverage-threshold: "80"
      environment: "staging"

  deploy:
    needs: [build, test]
    uses: ./.github/workflows/templates/template_deploy.yml
    with:
      environment: "staging"
      aws-region: "us-east-1"
    secrets:
      AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
      AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      AWS_SESSION_TOKEN: ${{ secrets.AWS_SESSION_TOKEN }}
      AWS_ACCOUNT_ID: ${{ secrets.AWS_ACCOUNT_ID }}
```

---

## Parámetros Configurables

### template_build.yml

| Input | Tipo | Por defecto | Descripción |
|-------|------|-------------|-------------|
| `node-version` | string | `"18"` | Versión de Node.js |
| `working-directory` | string | `"."` | Directorio del proyecto |
| `artifact-name` | string | `"build-artifact"` | Nombre del artefacto |
| `environment` | string | `"dev"` | Entorno (dev/staging/prod) |

### template_test.yml

| Input | Tipo | Por defecto | Descripción |
|-------|------|-------------|-------------|
| `node-version` | string | `"18"` | Versión de Node.js |
| `coverage-threshold` | string | `"80"` | % mínimo de cobertura |
| `run-integration-tests` | boolean | `false` | Activar pruebas de integración |
| `environment` | string | `"dev"` | Entorno de ejecución |

### template_deploy.yml

| Input | Tipo | Por defecto | Descripción |
|-------|------|-------------|-------------|
| `environment` | string | **requerido** | Entorno de despliegue |
| `aws-region` | string | `"us-east-1"` | Región AWS |
| `ecr-repository` | string | `"techmarket-app"` | Repositorio ECR |
| `ecs-cluster` | string | `"techmarket-cluster"` | Cluster ECS |
| `image-tag` | string | `"latest"` | Tag de imagen Docker |

> **Cómo modificar parámetros sin alterar la plantilla base:** Simplemente pasa los `inputs` desde el workflow que invoca la plantilla. Nunca edites directamente los archivos en `templates/`. Esto garantiza que todos los equipos sigan usando la misma versión base.

---

## Acciones Externas Utilizadas

| Acción | Versión | Plantilla | Justificación |
|--------|---------|-----------|---------------|
| `actions/checkout` | v4 | Build, Test, Deploy | Acción oficial de GitHub. Clonado seguro y eficiente del repositorio. |
| `actions/setup-node` | v4 | Build, Test | Gestión de versiones de Node.js con caché automático de npm. |
| `actions/upload-artifact` | v4 | Build, Test | Persiste artefactos entre jobs sin recompilación. |
| `actions/download-artifact` | v4 | Test, Deploy | Descarga artefactos generados en etapas previas. |
| `aws-actions/configure-aws-credentials` | v4 | Deploy | Configuración segura de credenciales AWS. Evita exposición de claves. |
| `aws-actions/amazon-ecr-login` | v2 | Deploy | Autenticación Docker con ECR de forma segura y automatizada. |

---

## Versionamiento Semántico

Este proyecto sigue la convención [Semantic Versioning 2.0.0](https://semver.org/lang/es/):

- **v1.0.0** — Versión inicial con plantillas de build, test y deploy.
- **v1.1.0** — (Próxima) Soporte para pruebas de integración y matrix builds.

El versionamiento se aplica en:
- Tags de Git: `git tag v1.0.0`
- Comentarios de versión en cada plantilla YAML
- Releases en GitHub con changelog documentado

---

## Entornos de Despliegue

| Rama | Entorno | Build | Test | Deploy |
|------|---------|-------|------|--------|
| `develop` | dev | ✅ | ✅ | ❌ |
| `staging` | staging | ✅ | ✅ (+ integración) | ✅ |
| `main` | prod | ✅ | ✅ (+ integración) | ✅ |

---

## Impacto en el Negocio — TechMarket

### Beneficios de la Estandarización

**1. Reducción de errores:** Al centralizar la lógica de CI/CD en plantillas únicas, se elimina la duplicación de configuraciones. Un error corregido en la plantilla se propaga automáticamente a todos los equipos que la usan.

**2. Aceleración de entregas:** Los nuevos proyectos pueden configurar su pipeline completo en menos de 10 líneas YAML, invocando las plantillas existentes. Antes de la estandarización, configurar un pipeline desde cero tomaba días.

**3. Consistencia entre equipos:** Todos los equipos de TechMarket (frontend, backend, microservicios) usan las mismas versiones de herramientas, las mismas acciones externas y los mismos criterios de calidad, garantizando uniformidad operativa.

### Cómo las plantillas reducen el tiempo de configuración

Un equipo nuevo solo necesita crear un archivo `pipeline.yml` de ~50 líneas que invoque las tres plantillas. Sin esta abstracción, necesitaría replicar ~200 líneas de YAML por proyecto, con alta probabilidad de errores.

### Parametrización y escalabilidad

La parametrización permite que las mismas plantillas funcionen en entornos de desarrollo, staging y producción con simples cambios en los `inputs`. No se requiere mantener tres versiones distintas del pipeline.

### Integración de acciones externas

El uso de acciones oficiales de GitHub y AWS reduce el tiempo de mantenimiento: cuando GitHub actualiza `actions/checkout@v4`, todos los pipelines heredan las mejoras de seguridad sin modificación manual.

### Conclusiones

Las plantillas diseñadas para TechMarket no son solo una mejora técnica, sino una decisión estratégica. Reducen el **time-to-market** de nuevos servicios, estandarizan la calidad del código a través de umbrales de cobertura automatizados, y permiten que los equipos DevOps enfoquen su tiempo en innovación en lugar de mantenimiento de infraestructura de CI/CD.

---

## Citas y Referencias

Kaufmann, M., Dohmke, T., & Brown, D. (2022). *Accelerate DevOps with GitHub: Enhance software delivery performance with GitHub Issues, Projects, Actions, and Advanced Security*. Packt Publishing. https://www.oreilly.com/library/view/accelerate-devops-with/9781801813358/

GitHub, Inc. (2024). *Reusing workflows*. GitHub Docs. https://docs.github.com/en/actions/using-workflows/reusing-workflows

Amazon Web Services. (2024). *GitHub Actions for AWS*. https://github.com/aws-actions

---

## Declaración de Uso de Inteligencia Artificial

Este trabajo utilizó herramientas de inteligencia artificial como apoyo en la estructuración de los archivos YAML y la redacción de la documentación. Todo el contenido fue revisado, validado y adaptado por el/la estudiante de acuerdo con los contenidos del curso AUY1104 - Ciclo de vida del Software II.
