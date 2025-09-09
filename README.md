# 🔐 AWS IAM Access Key Rotation Script

Este projeto contém um **script em Bash** que automatiza a **rotação de chaves de acesso (Access Keys) de usuários IAM** na AWS.  
Ele auxilia a manter as boas práticas de segurança da AWS, garantindo que chaves antigas sejam desativadas e removidas após a criação de novas.

---

## 🚀 Funcionalidades

- 📋 **Listagem de usuários** e suas chaves de acesso.
- 🔍 **Filtragem por tags** (`SERVICE_ACCOUNT`) para identificar contas de serviço.
- 📅 Validação da **data de criação das chaves**.
- 🔑 Criação de **novas Access Keys** para usuários IAM.
- 📄 Geração de **relatórios** com as novas chaves criadas.
- 📴 **Desativação automática** das chaves antigas.
- ⏰ **Agendamento da exclusão** de chaves antigas usando o comando `at`.

---

## ⚙️ Estrutura do Projeto

- `script.sh` → Script principal de rotação das chaves.
- `_vars.sh` → Arquivo de variáveis de ambiente:
  ```bash
  AWS_PROFILE="default"
  USER_NAME="usuario-exemplo"
  REPORT="/tmp/aws_keys_report.txt"
