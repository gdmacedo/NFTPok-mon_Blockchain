// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PokeDIO is ERC721 {
    struct Pokemon {
        string name;
        uint level;
        string img;
    }

    //Criamos um array com Pokemon
    Pokemon[] public pokemons;

    // Quem eh dono do jogo, que vai gerar os nossosPokemon
    address public gameOwner;

    // Criando o nosso contrato ERC721, com o nome.
    constructor() ERC721("PokeDIO", "PKD") {
        gameOwner = msg.sender;
    }

    // 
    modifier onlyOwnerOf(uint _monsterId) {
        require(
            ownerOf(_monsterId) == msg.sender,
            "Apenas o dono pode batalhar com este Pokemon"
        );
        // Caso ele passa usamos o _ para continuar a função
        _;
    }

    // 
    function battle(
        uint _attackingPokemon,
        uint _defendingPokemon
    ) // Apenas o dono pade acessar...
     public onlyOwnerOf(_attackingPokemon) {
        // Qual Pokemon vai atacar
        Pokemon storage attacker = pokemons[_attackingPokemon];

        // Qual Pokemon vai defender
        Pokemon storage defender = pokemons[_defendingPokemon];

        // Verifica o Level de quem esta atacando de quem esta defendendo
        if (attacker.level >= defender.level) {
            attacker.level += 2;
            defender.level += 1;
        } else {
            attacker.level += 1;
            defender.level += 2;
        }
    }

    // Função que cria um novo Pokemon. Passando o Nome, o endereço, e a imagem.
    function createNewPokemon(
        string memory _name,
        address _to,
        string memory _img
    ) public {
        // É uma exigência para que possa continuar. 
        require(
            msg.sender == gameOwner,
            "Apenas o dono do jogo pode criar novos Pokemons"
        );
        // Atribuimos um ID, a esse Pokemon, que nada mais é do que o tamanho do mey array.
        uint id = pokemons.length;

        // Fazendo um Push, para enviar para o meu array de Pokemon, 
        pokemons.push(Pokemon(_name, 1, _img));

        // E Agora utilizamos o SafeMiti, que é uma criação. ou seja, vamos limpar o meu token, criar esse token.
        _safeMint(_to, id);
    }
}