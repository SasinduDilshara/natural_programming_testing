# **Requirement Specification: Guest Management Service for a Luxury Apartment**  

## **1. Introduction**  
The Guest Management Service ensures secure and efficient visitor access to a luxury apartment by validating guest identities at the security checkpoint. The system optimizes the process by allowing frequent visitors to bypass security checks.  

## **2. Functional Requirements**  

### **2.1 Guest Check-in Process**  
- Every guest must provide their **full name** at the security checkpoint.  
- Security personnel will **validate the guest's identity** and **confirm their visit** with the resident they intend to meet.  
- Once validated, the guest is allowed entry into the apartment.  

### **2.2 Frequent Visitor Exemption**  
- Guests who have **visited more than five times in the past week** are classified as **frequent visitors**.  
- Frequent visitors are **automatically granted access** without security validation.  
- The system should maintain a **visit log** to track guest visits over a rolling **7-day period**.  

## **3. Non-Functional Requirements**  
- **Scalability**: The system should handle multiple guest check-ins simultaneously.  
- **Security**: Ensure that only authorized guests gain entry by implementing proper identity verification mechanisms.  
- **Usability**: The process should be quick and efficient for both security personnel and guests.  
