### Instituto Eldorado - Swift Explorations - T1

## Desafio Final

# App Pomodoro

A crescente exigência de aumento na produtividade exigida pelo mundo moderno fez com que as pessoas buscassem uma forma de otimizar seus tempos. A técnica de Pomodoro é uma abordagem que visa contribuir com essa otimização. Os objetivos da técnica Pomodoro estão ligados à diminuição da ansiedade e ao aumento do foco e concentração nas tarefas, evitando tempo desperdiçado e distrações.

Para ajudar no controle de tempo foi desenvolvido esse aplicativo. Com ele você pode usar conceitos básicos de Pomodoro como:

✅ Adicionar suas atividades

✅ Configurar o tempo das atividades

✅ Configurar o tempo de descanso

✅ Configurar o tempo de descanso longo

✅ Configurar quantas atividades deverão ser realizadas até o descanso longo


O Aplicativo consiste em um timer regressivo que lhe avisa o momento de fazer uma pausa/começar uma nova atividade.

Você, ainda, poderá fazer login utilizando um email e senha e salvar na nuvem suas configurações


## Screenshots

| Tela Principal | Configurações | Adicionar Tarefas |
|:---:|:---:|:---:|
| ![Page1](/iOS/main.png) | ![Page2](/iOS/configurations.png) | ![Page3](/iOS/addTask.png) |

| Login | Cadastro | Editar Tarefas |
|:---:|:---:|:---:|
| ![Page4](/iOS/login.png) | ![Page5](/iOS/register.png) | ![Page6](/iOS/editTask.png) |
## Decisões de Projeto

Esse aplicativo foi pensado para ser de uso simples, sem grandes funcionalidades. Optou-se por salvar as configurações de usuário na nuvem para possibilitar o uso de vários usuários. No entanto, por simplicidade, foi decidito que a lista de tarefas não será salva (ficando assim para uma próxima versão)

## O que faltou fazer

- Persistir na nuvem a lista de tarefas do usuário
- Mostrar as mensagens de erro na tela (as mensagens são mostradas somente no terminal)
- Melhorar a validação das entradas do usuário
- Implementar um sinal sonoro para avisar que o tempo está acabando
- Implementar uma experiência de usuário um pouco mais amigável e inteligente

## Como baixar o código do App e rodar no seu Mac

Primeiramente crie uma pasta onde será colocado o projeto. Pelo terminal entre nessa pasta e digite o comando abaixo para clonar o repositório.
```bash
git clone https://github.com/Berchon/Pomodoro.git
```
Garanta que você tenha o cocoapod. Você pode tentar ver a versão do Cocoapod com o comando `pod --version`. Caso apareça a versão significa está instalado, caso contrário procure no google como instalar.

Após garantir que você possui o cocoapod instalado digite os comandos abaixo para fazer download das dependências do projeto
```bash
cd Pomodoro
pod install
```
Pronto! Agora é só abrir no seu `Xcode` o arquivo `Pomodoro.xcworkspace` e clicar no botão de `Play` (que aparece no Xcode) para rodar o App no simulador.
