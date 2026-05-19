# Solidity Practice Challenges

A collection of smart contracts I'm building while learning Solidity, blockchain fundamentals, and DeFi through [Cyfrin Updraft](https://updraft.cyfrin.io).

##  Challenge progress

- Task Manager with mapping & swap-and-pop

##  Concepts practiced

- Solidity syntax & data types
- Structs & arrays
- Mappings & dynamic arrays
- Function modifiers (`onlyOwner`)
- Events
- Swap-and-pop deletion pattern
- Handling per-user indexes

## How to run

Option 1: Remix (recommended for quick testing)

- Go to remix.ethereum.org
- Create a new file, paste the contract
- Compile with Solidity 0.8.19+
- Deploy to a local VM or testnet

Option 2: Local development

git clone https://github.com/Messibre/solidity-mini-challenges.git
cd solidity-mini-challenges
npm install -g hardhat
npx hardhat compile
npx hardhat test

##  Notes

These are learning contracts – not audited for production use.

## 🔗 Resources

- [Cyfrin Updraft](https://updraft.cyfrin.io)
- [Solidity by Example](https://solidity-by-example.org)
- [Remix IDE](https://remix.ethereum.org)

---

*"Code, break, fix, repeat."*