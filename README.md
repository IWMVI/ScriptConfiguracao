# Setup Script

Este repositório contém um script Bash para configurar um ambiente de desenvolvimento em distribuições Linux baseadas em Fedora, Debian e Ubuntu.

## Funcionalidades

- Detecta automaticamente a distribuição Linux.
- Atualiza o sistema.
- Instala pacotes essenciais como npm, Java, Node.js, Docker, GNOME Tweaks, GNOME Extensions App e .NET SDK.
- Configura o Angular CLI.
- Adiciona o Docker ao systemctl e ao grupo de usuários.
- Remove pacotes desnecessários.

## Pré-requisitos

- Distribuição Linux baseada em Fedora, Debian ou Ubuntu.
- Permissões de superusuário (sudo).

## Como usar

1. Clone este repositório:

    ```sh
    git clone https://github.com/IWMVI/ScriptConfiguracao.git
    ```

1. Torne o script executável:

    ```sh
    chmod +x setup.sh
    ```

2. Execute o script:

    ```sh
    ./setup.sh
    ```
