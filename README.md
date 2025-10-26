🎓 Authenticity Validator for Academia

A blockchain-based authenticity verification system designed for academic institutions to validate certificates, research papers, and academic records.  
This project leverages smart contracts and decentralized storage (IPFS) to ensure transparency, immutability, and verifiable trust for all academic credential.
🚀 Project Overview

The **Authenticity Validator for Academia** enables universities and institutions to issue, store, and verify documents securely using blockchain technology.  
It eliminates the risk of fake certificates, tampering, and manual verification delays by providing a public, tamper-proof validation system.


🧩 Key Features

- 🧾 Certificate Issuance— Institutions can issue certificates stored on IPFS and registered on the blockchain.  
- 🔍 Verification System — Anyone can verify authenticity by checking the blockchain record.  
- 🧠 Creator / Institution Dashboard** — Manage academic documents with a clean UI.  
- 🧑‍🎓 Student Access — Students can securely view and share their verified credentials.  
- 🛡️ Immutability— Data stored on blockchain ensures long-term trust and transparency.  
- ⚡ Smart Contracts — Written in Solidity, powered by Hardhat for deployment and testing.  

---
🧱 Tech Stack

| Layer | Technology | Description |
|-------|-------------|-------------|
| **Frontend** | React / Next.js | User dashboard for institutions and verifiers |
| **Blockchain** | Solidity + Hardhat | Smart contract logic for document management |
| Storage | IPFS / Pinata | Decentralized storage for academic content (CIDs) |
| Backend (optional) | Node.js / Express | API layer for authentication and metadata |
| Network | Ethereum / Polygon / Local Hardhat | Smart contract deployment environment |

- 🏗️ Project Architecture

```mermaid
flowchart TD
    A[Institution / Admin] -->|Uploads Document| B[IPFS Storage]
    B --> C[Smart Contract on Blockchain]
    C -->|Stores CID + Metadata| D[Blockchain Ledger]
    D -->|Publicly Accessible| E[Verifier / Recruiter]
    E -->|Queries| C
    F[Student] -->|Views / Shares Verified Docs| C
