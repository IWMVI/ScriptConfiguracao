#!/bin/bash

# Detectar a distribuição

if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    OS=$ID
else
    echo "Não foi possível detectar a distribuição"
    exit 1
fi

# Atualizar o sistema

echo "Atualizando o sistema"
if [[ "$OS" == "fedora" ]]; then
    sudo dnf update -y
elif [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]; then
    sudo apt update && sudo apt upgrade -y
else
    echo "Distribuição não suportada"
    exit 1
fi

# Função para verificar e instalar pacotes

install_packages() {
    if ! command -v $1 &>/dev/null; then
        echo "Instalando $1..."
        sudo $2 install -y $3
    else
        echo "$1 já está instalado."
    fi
}

# Define o gerenciador de pacotes

if [[ "$OS" == "fedora" ]]; then
    PKG_MGR="dnf"
elif [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]; then
    PKG_MGR="apt"
else
    echo "Distribuição não suportada"
    exit 1
fi

# Instalção de pacotes

echo "Instalando pacotes"
install_packages npm "sudo $PKG_MGR" "npm"
install_packages java "sudo $PKG_MGR" "java-17-openjdk"
install_packages node "sudo $PKG_MGR" "nodejs"
install_packages docker "sudo $PKG_MGR" "docker docker-compose"

# Instalação do GNOME Tweaks e GNOME Extensions

if [[ "$OS" == "debian" || "$OS" == "fedora" ]]; then
    install_packages gnome-tweaks "sudo $PKG_MGR" "gnome-tweaks"
    install_packages gnome-extensions-app "sudo $PKG_MGR" "gnome-shell-extensions"
fi

# Instalação do .NET SDK

if [[ "$OS" == "debian" || "$OS" == "ubuntu" ]]; then
    echo "Configurando repositório do .NET..."
    wget https://packages.microsoft.com/config/$OS/$VERSION_ID/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
    install_package dotnet "sudo $PKG_MGR" "dotnet-sdk-7.0"
elif [[ "$OS" == "fedora" ]]; then
    install_package dotnet "sudo $PKG_MGR" "dotnet-sdk-7.0"
fi

# Instalação Angular CLI

echo "Verificando instalação do Angular CLI"
if ! command -v ng &>/dev/null; then
    echo "Instalando o Angular CLI..."
    sudo npm install -g @angular/cli
    echo "Angular instalado com sucesso."
else
    echo "Angular já instalado."
fi

# Adicionar Docker ao systemctl enable e ao grupo de usuários

echo "Configurando o Docker..."
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

# Remover pacotes desnecessários

echo "Limpando pacotes desnecessários..."
sudo $PKG_MGR autoremove -y

echo "Configurações concluídas... Reinicie o sistema."
