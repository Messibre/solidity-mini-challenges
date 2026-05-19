# Solidity Practice Challenges

A collection of smart contracts I'm building while learning Solidity, blockchain fundamentals, and DeFi through [Cyfrin Updraft](https://updraft.cyfrin.io/).

##  What's inside

- `index.sol` – Decentralized task manager (owner creates tasks, assignees complete them, expired tasks can be withdrawn)
- More challenges coming as I progress

## 🛠️ How to run

**Option 1: Remix (recommended for quick testing)**
- Go to [remix.ethereum.org](https://remix.ethereum.org)
- Create a new file, paste the contract
- Compile with Solidity 0.8.19+
- Deploy to a local VM or testnet

**Option 2: Local development**
```bash
git clone https://github.com/your-username/solidity-practice.git
cd solidity-practice
npm install -g hardhat
npx hardhat compile
npx hardhat test


## Challenge progress

- Student Registry (variables, structs, arrays)
- Task Manager with mapping & swap-and-pop
- Decentralized voting system (coming soon)
- Simple ERC20 token

## 📚 Concepts practiced

- Solidity syntax & data types
- Structs & arrays
- Mappings & dynamic arrays
- Function modifiers (`onlyOwner`)
- Events
- Swap-and-pop deletion pattern
- Handling per-user indexes

## Notes

These are learning contracts – not audited for production use. The TaskManager demonstrates the complexity of keeping index mappings in sync when removing items from an array.

## 🔗 Resources

- [Cyfrin Updraft](https://updraft.cyfrin.io)
- [Solidity by Example](https://solidity-by-example.org)
- [Remix IDE](https://remix.ethereum.org)

---

*"Code, break, fix, repeat."*