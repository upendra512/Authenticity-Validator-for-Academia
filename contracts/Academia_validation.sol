    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AcademicValidator
 * @dev Blockchain-based certificate authenticity verifier for academia.
 * Institutions can issue verifiable certificates stored immutably on Core Blockchain.
 */
contract AcademicValidator {
    address public institution; // owner (college)

    struct Certificate {
        string studentName;
        string course;
        string ipfsCID; // proof file CID
        uint256 timestamp;
    }

    // address => list of issued certificates
    mapping(address => Certificate[]) private certificates;

    // Event emitted whenever a certificate is issued
    event CertificateIssued(
        address indexed student,
        string studentName,
        string course,
        string ipfsCID,
        uint256 timestamp
    );

    modifier onlyInstitution() {
        require(msg.sender == institution, "Only institution can perform this action");
        _;
    }

    constructor() {
        institution = msg.sender;
    }

    /**
     * @notice Issue a new certificate for a student.
     */
    function issueCertificate(
        address student,
        string memory studentName,
        string memory course,
        string memory ipfsCID
    ) external onlyInstitution {
        Certificate memory cert = Certificate({
            studentName: studentName,
            course: course,
            ipfsCID: ipfsCID,
            timestamp: block.timestamp
        });

        certificates[student].push(cert);
        emit CertificateIssued(student, studentName, course, ipfsCID, block.timestamp);
    }

    /**
     * @notice Get all certificates issued to a given student.
     */
    function getCertificates(address student)
        external
        view
        returns (Certificate[] memory)
    {
        return certificates[student];
    }

    /**
     * @notice Returns total certificates issued for a student.
     */
    function getCertificateCount(address student) external view returns (uint256) {
        return certificates[student].length;
    }
}
