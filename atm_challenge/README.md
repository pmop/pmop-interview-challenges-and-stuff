## Sumário
1. [Docker](#montagem-do-docker)
2. [Funcionamento da Aplicação](#func-app)
  -  [Motivação](#motivações-nas-escolhas-da-arquitetura)

Incluí todos os casos de uso apresentados no documento do Desafio, e mais alguns testes. Vocês podem usar essa cola para facilitar a examinação. Só é necessário copiar e colar na linha de comando. A única dependência é o `curl`. A cada teste, [vocês podem resetar a aplicação sem precisar matar ou reiniciar o container](#reset).

3. [Exemplos de Requisição/Interagindo com a Aplicação/Cenários de Uso](#exemplos-de-requisição) 
   - [Reset](#reset) 
   - [Estado Atual](#current-state) 
   - [Abastecimento Cenário 1 - Caixa Indisponivel](#abc-one) 
   - [Abastecimento Cenário 2 - Caixa Disponibilizado](#abc-two) 
   - [Abastecimento Cenário 3 - Violação, Caixa Disponível](#abc-three) 
  - [Saques](#saques)
    - [Saque 1](#saque-1)
    - [Saque 2 - Caixa Inexistente](#saque-2)
    - [Saque 3 - Valor Indisponivel](#saque-3)
    - [Saque 4 - Sem Troco Possível](#saque-4)
    - [Saque 5 - Caixa Indísponível](#saque-5)
4. [MISC](#misc)
    - [Testes Unitário](#unit-tests)
    - [Teste de Integração](#int-tests)
    - [Another paragraph](#paragraph2)
5. [Estrutura da Aplicação](#estrutura-da-aplicação)

## Montagem do Docker

1. Extraia o zip
2. Verifique se a extração não gerou diretórios aninhados i.e. (nome do diretorio)/atm_challenge
3. Caso positivo mova atm_challenge para um nível acima
4. Execute:

```
docker build atm_challenge -t atm-challenge 
docker run -p 4567:4567 atm-challenge
```

## Interagindo com aplicação

**[Aqui](#exemplos-de-requisição) há exemplos de linha de comando para interagir com a aplicação com o `curl` que você pode copiar e colar.**

- Abastecimento

```
put /atm/supply
```

Com corpo JSON, exemplo:

```json
{
  "caixa": {
    "caixaDisponivel": true,
    "notas": {
      "notasDez": 100,
      "notasVinte": 50,
      "notasCinquenta": 10,
      "notasCem": 30
    }
  }
}
```

Implementado como solicitado no documento, portanto não faz acumulação com sucessivos abastecimentos, apenas troca o estado e faz a validação.

- Saque

```
post /atm/withdraw
```

Com corpo JSON, exemplo:

```json
{
   "saque":{
      "valor":80,
      "horario":"2019-02-13T11:01:01.000Z"
   }
}
```

- Estado Atual do Caixa

```
get /atm
```

- Reset do Caixa. Elimina o estado atual do Caixa, incluindo o histórico de saques.

```
delete /atm
```

## <a id="func-app"></a> Funcionamento da Aplicação

O servidor recebe a requisição, faz match com a rota adequada, e invoca o método adequado do controller tomando o corpo da requisição como entrada.

Quando a requisição é de abastecimento `/atm/supply` O método `#supply` do Controller é invocado tomando o corpo da requisição como entrada. O corpo da requisição é transformado em um Hash que segue um padrão interno pela classe `::Services::Atm::SupplyParser`. Esse Hash então é passado para a classe `::Services::Atm::Supply` junto com uma instância do modelo `Atm`. A validação é efetuada e o erro adequado é lançado caso haja violação. Correndo tudo bem, o estado interno do `Atm` sofre a mudança.

Quando a requisição é de saque `/atm/withdraw` O método `#withdraw` do Controller é invocado tomando o corpo da requisição como entrada. O corpo da requisição é transformado em um Hash que segue um padrão interno pela classe `::Services::Atm::WithdrawParser`. Esse Hash então é passado para a classe `::Services::Atm::Withdraw` junto com uma instância do modelo `Atm`. A validação é efetuada e o erro adequado é lançado caso haja violação. A violação de duplicação é verificada com ajuda da classe modelo `Withdrawal` que guarda em si um `Array` estático com os últimos saques. Correndo tudo bem, o `Hash` que representa o saque é passado junto com o estado do `Atm` (as notas presentes no caixa) para a classe `ChangeMaking` que calcula a quantidade mínima de notas a serem retiradas. Caso `ChangeMaking` não consiga encontrar uma solução, um erro é lançado por não ser possível realizar o saque com a quantidade atual de notas presente no Caixa. Correndo tudo bem, a saída de `ChangeMaking` é usada para atualizar o estado atual do Caixa `Atm`.

O modelo `Atm` guarda em si o estado do Caixa, isto é, as notas presentes, e se o Caixa está ou não disponível para uso. No Controller instanciamos esse modelo.

O modelo `Withdrawal` guarda em si um `Array` estático contendo os últimos saques. Esse modelo auxilia na validação de saque duplicado. Não precisamos instanciar o modelo e apenas interagimos com ele por métodos da classe.

A classe `ChangeMaking` inclui uma implementação do algorítimo `greedy` para a solução do problema de "change making". O construtor da classe toma dois argumentos, a quantia a ser considerada `amount` e um `Hash` de pares nominal e limite, com os nominais e limites a serem considerados no cálculo.

### Motivações nas Escolhas da Arquitetura

- Trabalhei muito tempo com Domain Driven Design e a modelagem flui naturalmente para mim. A filosofia que motiva a metodologia é a facilidade de modelar lógica de negócios. Porém ao invés de usar o DDD completo, tomei motivação no padrão mais recente de Service Objects.

- Sinatra com um pseudo MVC: alternativa de introdução de um meio de interação com a aplicação.

## Exemplos de Requisição

### <a id="reset"></a> Reset 

```bash
curl -X DELETE http://127.0.0.1:4567/atm
```

### <a id="current-state" ></a> Estado Atual

```bash
curl -X GET http://127.0.0.1:4567/atm
```

---

### <a id="abc-one" ></a> Abastecimento Cenário 1 (Abastecimento, Caixa Indisponivel)

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": false,
		"notas": {
			"notasDez": 100,
			"notasVinte": 50,
			"notasCinquenta": 10,
			"notasCem": 30
		}
	}
}
EOF
```

---

### <a id="abc-two" ></a> Abastecimento Cenário 2 (Caixa Disponibilizado)

Entrada 1
```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": false,
		"notas": {
			"notasDez": 100,
			"notasVinte": 50,
			"notasCinquenta": 10,
			"notasCem": 30
		}
	}
}
EOF
```

Entrada 2
```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 5,
			"notasVinte": 5,
			"notasCinquenta": 5,
			"notasCem": 15
		}
	}
}
EOF
```

---

### <a id="abc-three" ></a> Abastecimento Cenário 3 (Violação, Caixa Disponível)

Entrada 1

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 100,
			"notasVinte": 50,
			"notasCinquenta": 10,
			"notasCem": 30
		}
	}
}
EOF
```

Entrada 2

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 350,
			"notasVinte": 1500,
			"notasCinquenta": 2500,
			"notasCem": 100
		}
	}
}
EOF
```

## Saques

### <a id="saque-1" ></a> Saque 1

Abastecimento

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 100,
			"notasVinte": 50,
			"notasCinquenta": 10,
			"notasCem": 30
		}
	}
}
EOF
```

Saque

```bash
curl -X POST http://127.0.0.1:4567/atm/withdraw \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"saque": {
    "valor": 80,
    "horario":"2019-02-13T11:01:01.000Z"
	}
}
EOF
```

---

### <a id="saque-2" ></a> Saque 2 (Caixa Inexistente)

Apagar o Estado Atual

```bash
curl -X DELETE http://127.0.0.1:4567/atm 
```

Saque

```bash
curl -X POST http://127.0.0.1:4567/atm/withdraw \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"saque": {
    "valor": 80,
    "horario":"2019-02-13T11:01:01.000Z"
	}
}
```

---

### <a id="saque-3" ></a> Saque 3 (Valor Indisponivel)

Abastecimento

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 0,
			"notasVinte": 0,
			"notasCinquenta": 1,
			"notasCem": 3
		}
	}
}
EOF
```

Saque

```bash
curl -X POST http://127.0.0.1:4567/atm/withdraw \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"saque": {
    "valor": 600,
    "horario":"2019-02-13T11:01:01.000Z"
	}
}
EOF
```

### <a id="saque-4" ></a> Saque 4 (Sem Troco Possível)

Abastecimento

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": true,
		"notas": {
			"notasDez": 1,
			"notasVinte": 1,
			"notasCinquenta": 1,
			"notasCem": 1
		}
	}
}
EOF
```

Saque

```bash
curl -X POST http://127.0.0.1:4567/atm/withdraw \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"saque": {
    "valor": 140,
    "horario":"2019-02-13T11:01:01.000Z"
	}
}
EOF
```

### <a id="saque-5" ></a> Saque 5 (Caixa Indisponível)

Abastecimento

```bash
curl -X PUT http://127.0.0.1:4567/atm/supply \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"caixa": {
		"caixaDisponivel": false,
		"notas": {
			"notasDez": 1,
			"notasVinte": 1,
			"notasCinquenta": 1,
			"notasCem": 1
		}
	}
}
EOF
```

Saque

```bash
curl -X POST http://127.0.0.1:4567/atm/withdraw \
-H 'Content-Type: application/json; charset=utf-8' \
--data-binary @- << EOF
{
	"saque": {
    "valor": 140,
    "horario":"2019-02-13T11:01:01.000Z"
	}
}
EOF
```

## MISC

- <a id="unit-tests" ></a> Executando os testes unitários:
```
bin/rspec spec
```

- <a id="int-tests" ></a> Executando os testes de integração:
```
ruby tests/integration/atm_controller_test.rb
```

- <a id="binstub" ></a> Usando bundle com binstub
```
bundle install --binstubs
```

- <a id="curljson" ></a> Usando `curl` para fazer requisições à aplicação, usando arquivo JSON como corpo:
```
curl -X PUT -H "Content-Type: application/json" -d @payload.json http://127.0.0.1:4567/
```

## Estrutura da Aplicação

```
atm_challenge
 ├─ lib
 │  ├─ formatter.rb
 │  ├─ errors.rb
 │  └─ change_making.rb
 ├─ spec
 │  ├─ lib
 │  │  ├─ change_making_spec.rb
 │  │  └─ formatter_spec.rb
 │  ├─ app
 │  │  └─ services
 │  │     └─ atm
 │  │        ├─ supply_spec.rb
 │  │        ├─ supply_parser_spec.rb
 │  │        ├─ withdraw_parser_spec.rb
 │  │        └─ withdraw_spec.rb
 │  └─ spec_helper.rb
 ├─ config
 │  ├─ application.rb
 │  └─ environment.rb
 ├─ test
 │  ├─ fixtures
 │  │  ├─ supply2.json
 │  │  └─ supply1.json
 │  └─ integration
 │     └─ atm_controller_test.rb
 ├─ app
 │  ├─ services
 │  │  └─ atm
 │  │     ├─ supply_parser.rb
 │  │     ├─ withdraw.rb
 │  │     ├─ base_service.rb
 │  │     ├─ supply.rb
 │  │     └─ withdraw_parser.rb
 │  ├─ controllers
 │  │  └─ atm_controller.rb
 │  └─ models
 │     ├─ withdrawal.rb
 │     └─ atm.rb
 ├─ entrypoint.sh
 ├─ Gemfile.lock
 ├─ Gemfile
 ├─ README.md
 ├─ app.rb
 └─ Dockerfile
```