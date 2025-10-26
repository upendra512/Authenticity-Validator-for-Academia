    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title AcademicValidator
 * @dev Blockchain-based certificate authenticity verifier for academia.
 * Institutions can issue verifiable certificates stored immutably on Core Blockchain.
 */
contract AcademicValidator {
    address public institution; // owner (college/university)
    bool public paused; // emergency pause state

    enum CertificateStatus {
        Active,
        Revoked
    }

    struct Certificate {
        string studentName;
        string course;
        string ipfsCID; // proof file CID
        uint256 timestamp;
        CertificateStatus status;
        string grade; // grade or GPA
    }

    // address => list of issued certificates
    mapping(address => Certificate[]) private certificates;

    // Event emitted whenever a certificate is issued
    event CertificateIssued(
        address indexed student,
        string studentName,
        string course,
        string ipfsCID,
        uint256 timestamp,
        string grade
    );

    // Event emitted when a certificate is revoked
    event CertificateRevoked(
        address indexed student,
        uint256 indexed certificateIndex,
        uint256 timestamp
    );

    // Event emitted when institution ownership is transferred
    event InstitutionTransferred(
        address indexed previousInstitution,
        address indexed newInstitution
    );

    // Event emitted when contract is paused/unpaused
    event PauseStatusChanged(bool isPaused);

    modifier onlyInstitution() {
        require(msg.sender == institution, "Only institution can perform this action");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Contract is not paused");
        _;
    }

    constructor() {
        institution = msg.sender;
        paused = false;
    }

    /**
     * @notice Issue a new certificate for a student.
     */
    function issueCertificate(
        address student,
        string memory studentName,
        string memory course,
        string memory ipfsCID,
        string memory grade
    ) external onlyInstitution whenNotPaused {
        require(student != address(0), "Invalid student address");
        require(bytes(studentName).length > 0, "Student name cannot be empty");
        require(bytes(course).length > 0, "Course cannot be empty");
        require(bytes(ipfsCID).length > 0, "IPFS CID cannot be empty");

        Certificate memory cert = Certificate({
            studentName: studentName,
            course: course,
            ipfsCID: ipfsCID,
            timestamp: block.timestamp,
            status: CertificateStatus.Active,
            grade: grade
        });

        certificates[student].push(cert);
        emit CertificateIssued(student, studentName, course, ipfsCID, block.timestamp, grade);
    }

    /**
     * @notice Issue multiple certificates in a single transaction (batch issuance).
     */
    function batchIssueCertificates(
        address[] memory students,
        string[] memory studentNames,
        string[] memory courses,
        string[] memory ipfsCIDs,
        string[] memory grades
    ) external onlyInstitution whenNotPaused {
        require(students.length == studentNames.length, "Array length mismatch");
        require(students.length == courses.length, "Array length mismatch");
        require(students.length == ipfsCIDs.length, "Array length mismatch");
        require(students.length == grades.length, "Array length mismatch");
        require(students.length > 0, "Empty arrays provided");

        for (uint256 i = 0; i < students.length; i++) {
            require(students[i] != address(0), "Invalid student address");
            require(bytes(studentNames[i]).length > 0, "Student name cannot be empty");
            require(bytes(courses[i]).length > 0, "Course cannot be empty");
            require(bytes(ipfsCIDs[i]).length > 0, "IPFS CID cannot be empty");

            Certificate memory cert = Certificate({
                studentName: studentNames[i],
                course: courses[i],
                ipfsCID: ipfsCIDs[i],
                timestamp: block.timestamp,
                status: CertificateStatus.Active,
                grade: grades[i]
            });

            certificates[students[i]].push(cert);
            emit CertificateIssued(
                students[i],
                studentNames[i],
                courses[i],
                ipfsCIDs[i],
                block.timestamp,
                grades[i]
            );
        }
    }

    /**
     * @notice Revoke a certificate by its index for a specific student.
     */
    function revokeCertificate(address student, uint256 certificateIndex)
        external
        onlyInstitution
        whenNotPaused
    {
        require(certificateIndex < certificates[student].length, "Invalid certificate index");
        require(
            certificates[student][certificateIndex].status == CertificateStatus.Active,
            "Certificate already revoked"
        );

        certificates[student][certificateIndex].status = CertificateStatus.Revoked;
        emit CertificateRevoked(student, certificateIndex, block.timestamp);
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

    /**
     * @notice Get a specific certificate by student address and index.
     */
    function getCertificateByIndex(address student, uint256 index)
        external
        view
        returns (Certificate memory)
    {
        require(index < certificates[student].length, "Invalid certificate index");
        return certificates[student][index];
    }

    /**
     * @notice Verify if a certificate is active and valid.
     */
    function verifyCertificate(address student, uint256 certificateIndex)
        external
        view
        returns (bool isValid, CertificateStatus status)
    {
        require(certificateIndex < certificates[student].length, "Invalid certificate index");
        Certificate memory cert = certificates[student][certificateIndex];
        return (cert.status == CertificateStatus.Active, cert.status);
    }

    /**
     * @notice Transfer institution ownership to a new address.
     */
    function transferInstitution(address newInstitution) external onlyInstitution {
        require(newInstitution != address(0), "Invalid new institution address");
        require(newInstitution != institution, "New institution must be different");

        address previousInstitution = institution;
        institution = newInstitution;
        emit InstitutionTransferred(previousInstitution, newInstitution);
    }

    /**
     * @notice Pause the contract in case of emergency.
     */
    function pause() external onlyInstitution whenNotPaused {
        paused = true;
        emit PauseStatusChanged(true);
    }

    /**
     * @notice Unpause the contract.
     */
    function unpause() external onlyInstitution whenPaused {
        paused = false;
        emit PauseStatusChanged(false);
    }

    /**
     * @notice Get the count of active certificates for a student.
     */
    function getActiveCertificateCount(address student) external view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < certificates[student].length; i++) {
            if (certificates[student][i].status == CertificateStatus.Active) {
                count++;
            }
        }
        return count;
    }
}
