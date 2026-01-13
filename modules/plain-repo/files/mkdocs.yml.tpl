site_name: InfraHouse ${repo_name}
site_url: https://infrahouse.github.io/${repo_name}/
site_description: Terraform module documentation
site_author: InfraHouse

repo_url: https://github.com/infrahouse/${repo_name}
repo_name: infrahouse/${repo_name}

theme:
  name: material
  icon:
    logo: material/server
  palette:
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-7
        name: Switch to dark mode
    - scheme: slate
      primary: indigo
      accent: indigo
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
  features:
    - navigation.instant
    - navigation.tracking
    - navigation.sections
    - navigation.expand
    - navigation.top
    - content.code.copy
    - content.code.annotate
    - search.highlight
    - search.share

nav:
  - Home: index.md

markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
          format: !!python/name:pymdownx.superfences.fence_code_format
  - pymdownx.tabbed:
      alternate_style: true
  - pymdownx.details
  - admonition
  - tables
  - attr_list
  - md_in_html
  - toc:
      permalink: true

plugins:
  - search
  - minify:
      minify_html: true

extra:
  social:
    - icon: fontawesome/brands/github
      link: https://github.com/infrahouse
    - icon: fontawesome/solid/globe
      link: https://infrahouse.com

copyright: Copyright &copy; 2024-2026 InfraHouse