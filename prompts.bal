const PROMPT_1 = string `

You are the **MegaPortCon 2025 Help Agent**, a skilled and professional assistant dedicated to helping attendees by providing accurate, precise, and relevant information about the conference, MegaPort products, and related topics.

Your goal: To provide accurate, to-the-point answers to the attendee's questions using ONLY the available information. You MUST follow these instructions:

1) Answer the users QUESTION using only the INFORMATION text below.
2) Keep your answer grounded in the facts of the INFORMATION given to you.
3) If the INFORMATION given doesn’t contain the facts to answer the QUESTION then direct the user to the right contact.
    - For general conference-related inquiries: Contact [Jay Limbachia](https://megaport.cachefly.net/megaport/sites/all/2024/megaportcon/jay.webp), Event Marketing Manager at megaportcon@megaport.com.
    - For technical/product questions: Suggest using the O2Bar feature in the MegaPortCon mobile app under “Networking → O2Bar” to find an expert (Mobile app cannot schedule sessions with experts).
4) You are NOT allowed to answer any question unrelated to the conference, MegaPort products, or related topics.
5) Always be polite, helpful, and excited. The conference is happening in Spain, Barcelona, so make it fun!

When answering questions about conference sessions, follow these guidelines:
- Exclude non-session events (e.g., Registration, Breaks) unless specifically asked.
- Sessions do not repeat; instead, they may have continuations.
- Add emoji color codes (🟦, 🟨, 🟥, etc.) next to the location names, based on the room's assigned color.
- Summarize long descriptions (1-2 sentences are enough).
- Today is {dateToday} and time now is {timeNow}. You must relate your responses with the current time.
- DO NOT suggest any session that has already ended.
- You must use the following example to display the session information:

Building AI Applications in the Enterprise
---
Date: Conference Day 1 (2025-03-18)

Time: 13:30 - 15:00

Location: Purple Room 🟪

Speakers:
- XX
- YY

---

**INFORMATION available to answer the QUESTION:**

**Current Time**: {dateToday} {timeNow}  
**Name of the attendee**: {username}

**Session Information:**
- **Building API-Driven Ecosystems**  
  Date: Conference Day 1 (2025-03-18)  
  Time: 10:00 - 11:30  
  Location: Blue Room 🟦  
  Speakers: Alice Johnson, Bob Lee  
  Description: Learn how to build API-driven digital ecosystems using modern API management strategies.

- **Cloud Native Integration Patterns**  
  Date: Conference Day 1 (2025-03-18)  
  Time: 13:30 - 15:00  
  Location: Red Room 🟥  
  Speakers: Carol Smith  
  Description: A deep dive into microservices integration and Kubernetes-native deployment patterns.

**Product Information:**
- **MegaPort API Manager**: A full lifecycle API management solution used to create, publish, and monitor APIs securely.
- **MegaPort Choreo**: A cloud-native integration platform as a service (iPaaS) that accelerates the development of APIs and event-driven applications.

**User Information:**
- Attendee: {username}
- Organization: ABC Corporation
- Role: Software Architect specializing in cloud-based integration solutions

**Customer Information:**
- ABC Corporation: A leading software company specializing in cloud integrations and API management, using MegaPort API Manager and Choreo to modernize their digital infrastructure.

---

**QUESTION:**  
Hi there! I'm attending MegaPortCon 2025 and was wondering which sessions are available later today that focus on APIs or cloud topics? Also, could you give me a quick overview of MegaPort products that might interest someone working in API Management and Cloud Integration? By the way, I work at ABC Corp — are there any customer stories or examples from similar companies?

`;

const PROMPT_2 = string `
Analyze the following user and potential matches to find the best networking connections.

USER:
Name: {user.name}
Company: {user.company}
Title: {user.title}
Profile: {user.document}

POTENTIAL MATCHES:
[
    {
        "id": "m1",
        "name": "Alice Johnson",
        "company": "InnoTech Solutions",
        "title": "AI Research Scientist",
        "profile": "Alice specializes in machine learning, deep learning, and natural language processing. With a PhD in Computer Science, Alice has worked on large-scale AI deployments and regularly speaks at AI conferences."
    },
    {
        "id": "m2",
        "name": "Bob Smith",
        "company": "FutureData Analytics",
        "title": "Chief Data Officer",
        "profile": "Bob leads data strategy initiatives, focusing on big data platforms and predictive analytics. Bob has 15 years of experience building enterprise data ecosystems for Fortune 500 companies."
    },
    {
        "id": "m3",
        "name": "Catherine Lee",
        "company": "NextGen Robotics",
        "title": "Head of Product Innovation",
        "profile": "Catherine drives innovation in robotics and autonomous systems. Catherine's recent work includes the design of AI-powered drones for industrial applications."
    },
    {
        "id": "m4",
        "name": "Daniel Perez",
        "company": "GreenEarth Technologies",
        "title": "Sustainability Engineer",
        "profile": "Daniel focuses on renewable energy solutions and sustainable engineering practices. Daniel collaborates with NGOs and government bodies to drive green initiatives globally."
    },
    {
        "id": "m5",
        "name": "Eva Chen",
        "company": "CyberShield Corp.",
        "title": "Cybersecurity Specialist",
        "profile": "Eva has expertise in network security, threat intelligence, and risk management. Eva has contributed to multiple open-source cybersecurity tools and regularly trains organizations on security best practices."
    },
    {
        "id": "m6",
        "name": "Franklin Torres",
        "company": "MegaPort Inc.",
        "title": "Senior Solutions Architect",
        "profile": "Franklin designs cloud-native enterprise solutions, focusing on API management and microservices. Franklin is an active contributor to open-source integration technologies."
    },
    {
        "id": "m7",
        "name": "Grace Patel",
        "company": "MedAI Health",
        "title": "Healthcare Data Scientist",
        "profile": "Grace works on predictive healthcare analytics using AI and machine learning. Grace's research focuses on early disease detection models using patient data."
    }
]

Select the top 1 match that would be most valuable for professional networking with the user based on their profile, experience, interests and expertise. Consider factors like industry alignment, complementary skills, and potential for mutually beneficial collaboration.
For the selected match:
1. Provide a brief reason why they would be a good connection
2. Provide 2 short tags (max 2 words per tag) that represent their key interests or expertise areas

Steps:
- Check if provided details has accurate information about provided user's interestes, skills, experience, edication etc.
- Match provided profiles with the user's profile to identify the most valuable professional networking opportunity
- Select the most valuable 1 connection.
- If provided user's details don't have accurate info about the user, check about his organization's insterests, focus areas.
- Match those with provided users for matching and return the most valuable 1 connection. But if it's based on company details mention that in the reason.

Important Rules:
- Do not hallucinate or invent match IDs - only use IDs that exist in the provided matches data.
- The reason and tags you provide should be from that matching person's data.
- In the reason, address the user directly (e.g., "John's work .... matches your interest in AI development")
- In the reason, !Do not use gender specific pronouns like he, she, his etc while mentioning matched users. !You must use the person's name (First name) instead of pronouns (e.g., "Sarah's focus on .." instead of "Her focus on...")
- If don't have accurate info about user and matched via company details you should mention that in the reason appropriately (Eg: ..... aligns closely with Your organization's  (company name) interestest ....).
- Reason should be accurate and presented in a simple but professional language.
- Only include the best 1 match based on professional value and compatibility
- Focus on meaningful professional connections that would benefit both parties
- Tags should be concise (1-2 words each) and relevant to the person's expertise or interests
- Exclude matches from the same company as the user to promote cross-organizational networking. 
- Company names can be in different formats. Eg: "MegaPort Inc." "MegaPort LLC" and "MegaPort" are considered the same company. So names that has a similarity exclude them.
- If you can't find 1 match, return as many as you can find.
`;

const PROMPT_3 = string `
You are tasked with reviewing customer feedback and assigning a quality score to each review based on the following criteria and return the scores as a integer array:

Scoring Criteria:
- 9–10: Exceptional — Strongly positive, enthusiastic, and highly satisfied feedback.
- 7–8: Good — Positive feedback with minor areas for improvement.
- 5–6: Average — Neutral or mixed feedback; moderate satisfaction.
- 3–4: Poor — Mostly negative feedback with notable dissatisfaction.
- 1–2: Terrible — Strongly negative, angry, or extremely dissatisfied feedback.

Instructions:
- Analyze each review carefully.
- Assign a score between 1 and 10 for each review based on the sentiment and tone.
- Return the scores as a simple integer array in the same order as the reviews are listed.
- Each score must be an integer between 1 and 10.

These are the reviews to analyze:
- "Awesome quality!"
- "Mediocre experience."
- "Terrible support."
- "Quick delivery but packaging was damaged."
- "Product exceeded expectations."
- "Support team never responded to my issue."
- "Decent product for the price."
- "Extremely satisfied with the purchase!"
- "Not worth the money."
- "Installation instructions were confusing."
`;

const PROMPT_4 = string `
You are tasked with analyzing customer reviews and extracting the main theme word from each review.
Definition:
- The theme word should be the **single most important noun or concept** that captures the main focus of the review.
- The theme must be **concise (one word)**, directly reflecting the core subject of the review.
Instructions:
- Carefully read each review.
- Identify the main theme based on what the review emphasizes the most.
- Return the theme words in a **string array**, keeping the order the same as the reviews are listed.
Reviews to analyze:
- "Great customer service."
- "The product was defective."
- "Fast and reliable shipping."
- "Excellent technical support."
- "Very poor packaging."
- "Affordable and durable materials."
- "Complicated installation process."
- "Amazing design and aesthetics."
- "Delayed shipping experience."
- "Unhelpful customer support team."
`;

const PROMPT_5 = string `
You are tasked with summarizing the following content. The content contains information about customers, products, and employees of a company.

Please provide a brief summary that highlights the key points related to:
1. The **customers** — include any notable customer feedback, demographics, or customer-specific challenges.
2. The **products** — summarize key product offerings, features, customer reviews, and any improvements or new launches.
3. The **employees** — include any details about notable employees, their roles, achievements, and contributions to the company.

Keep the summary concise but informative, and focus on the most relevant aspects of the content.

Here is the content to summarize:

---

**Company Name**: HomeTech Solutions

**Customer Details**:  
HomeTech Solutions has a broad customer base, spanning individual tech enthusiasts, small businesses, and large corporations. Many customers report high satisfaction with the ease of use, design, and functionality of their products. For example, a group of early adopters, particularly homeowners interested in automating their homes, have praised the company's ability to seamlessly integrate with existing smart devices, enhancing the home automation experience. However, a few enterprise clients, particularly in the retail sector, expressed concerns regarding occasional connectivity issues when managing large volumes of devices simultaneously. A large retailer, which implemented HomeTech’s products in 50+ store locations, mentioned that setting up their devices took longer than anticipated, which led to some initial operational inefficiencies. Another customer, a tech enthusiast named Sarah, shared feedback on the recently launched SmartLighting Kit, appreciating its energy efficiency and the ease with which it integrates with other smart home devices.

**Product Details**:  
HomeTech Solutions is best known for its flagship product, the **SmartHome Hub**, a central device that connects and manages a variety of smart home products. The SmartHome Hub has garnered positive feedback for its versatility and the wide range of compatible third-party devices it supports. Many users particularly appreciate the ease of use and the user-friendly interface. However, some customers have reported connectivity issues with older smart devices, specifically when managing multiple devices at once. The company has recently rolled out a firmware update to address these performance issues. The **SmartLighting Kit**, a new product launched this year, has received glowing reviews for its energy-saving capabilities and simple setup process. Users have praised its ability to adjust lighting based on different time-of-day settings and its compatibility with other HomeTech products.

In addition, HomeTech has begun developing a new product in collaboration with a leading AI company, aiming to introduce an AI-powered security camera system in the next six months. This new product will offer features like motion detection, facial recognition, and cloud-based storage. Initial prototypes have shown great promise, and it’s expected to be a big hit with privacy-conscious consumers.

**Employee Details**:  
The company boasts a talented and diverse team, including engineers, support specialists, and marketing professionals. Key employees have contributed significantly to the company’s success and product development:

- **John**, a senior software engineer, led the development of the firmware update that improved the SmartHome Hub’s connectivity and performance, especially when integrating with older devices. His leadership in resolving connectivity challenges has been critical to maintaining customer satisfaction.
  
- **Sarah**, a customer support specialist, is highly valued for her prompt and effective responses to customer inquiries. She regularly receives 5-star ratings from customers for her professionalism and problem-solving skills. Sarah has been instrumental in helping customers resolve technical issues with HomeTech’s products and ensuring a smooth user experience.

- **Emily**, the marketing director, has played a pivotal role in increasing the company's global presence. Under her leadership, HomeTech Solutions successfully launched targeted marketing campaigns in both North America and Europe, resulting in a 25% increase in product sales. She also spearheaded the company's strategic partnership with several retail giants, leading to widespread distribution of HomeTech products across various regions.

- **Michael**, the product manager, is overseeing the development of the upcoming AI-powered security camera system. His team is working closely with the AI company to integrate advanced technologies like facial recognition and motion detection into the product. Michael’s deep understanding of consumer needs and product functionality is a key factor in ensuring the product meets high-quality standards before its launch.
`;

const PROMPT_6 = string `
You are tasked with analyzing the following product reviews and aggregating them into a single integer score, ranging from 1 to 10. The score should represent the overall sentiment of the reviews. Here’s how to aggregate the reviews:

1. **Positive Reviews**: Consider reviews with positive feedback, praise for the product's features, and good user experiences as contributing to a higher score.
2. **Neutral Reviews**: Consider reviews that mention the product's pros and cons in a balanced manner. These should contribute to a moderate score.
3. **Negative Reviews**: Consider reviews that mention significant issues, defects, or poor experiences as contributing to a lower score.

You should consider the following criteria when aggregating:
- **Product Quality**: Evaluate mentions of the product's durability, performance, and overall value.
- **User Experience**: Evaluate feedback on ease of use, setup, design, and user satisfaction.
- **Support and Service**: Consider any feedback regarding customer service, product support, or warranties.

Here are the reviews to analyze:

---

**Reviews**:
1. "This product is great! It's easy to use, and the quality is fantastic. I love how it integrates with my other devices."
2. "The product works well, but it took longer to set up than I expected. The support team was helpful, but it could be better."
3. "I’m disappointed with the performance. The product didn’t meet my expectations and the customer service was unresponsive."
4. "Excellent value for money! Works as advertised and the customer support was top-notch when I needed help with setup."
5. "The product is decent, but it’s a bit bulky and not very intuitive. It gets the job done, but I expected better design."
6. "Terrible experience. The product broke after a week, and the support team was no help at all. Would not recommend."

---

Please aggregate these reviews into a single integer score between 1 and 10, where 1 is extremely negative, and 10 is extremely positive. Provide a brief explanation of how the score was determined based on the reviews.
`;

const PROMPT_7 = string `
You are tasked with transforming the following input data into a expected record structure.

### Input Data:

- **Customer**:
  - Name: John Doe
  - Age: 34
  - Email: johndoe@example.com
  - Address: 123 Main St, Springfield, IL
  - Phone: (123) 456-7890
  - Orders: [
    {
      OrderID: "ORD1234",
      ProductName: "Laptop",
      Quantity: 1,
      Price: 999.99,
      Date: "2025-04-01"
    },
    {
      OrderID: "ORD1235",
      ProductName: "Smartphone",
      Quantity: 2,
      Price: 499.99,
      Date: "2025-04-03"
    }
  ]
  
- **Employee**:
  - EmployeeID: "EMP001"
  - Name: Sarah Lee
  - Position: Software Engineer
  - Department: Development
  - HireDate: "2020-06-15"
  - Skills: ["Java", "Python", "SQL"]
  
- **Company**:
  - CompanyName: Tech Innovators LLC
  - Founded: "2010"
  - Location: San Francisco, CA
  - Employees: 150
  - AnnualRevenue: 50000000
  - Industry: Technology
`;

const PROMPT_8 = string `Extract the following event details from the provided text:**  
- **Event name**  
- **Event date** (as a string)  
- **Location**  
- **Company/organizer name**  
- **Keynote speaker's name**  
- **Keynote topic**  
- **Number of attendees** (as an integer, 0 if unknown)  
- **Industries represented** (as a list, empty if none mentioned)  
- **Products announced** (as a list, empty if none mentioned)  
- **Executive names** (as a list, empty if none mentioned)  
- **Panel moderator's name**  
- **Panel moderator's affiliation**  

**Rules:**  
- If a field has no data, use:  
  - empty string for strings  
  - 0 for numbers  
  - [] for lists  
- **Return only a valid JSON object with no additional text or explanations.**  

**Text to analyze:**  
"TechForward 2023 was held on October 15-17, 2023 in San Francisco by NexGen Technologies. 
The keynote was delivered by Dr. Alice Chen on 'The Future of AI', with 1,200 attendees from healthcare, 
finance, and retail sectors. They announced new products X500 and Y900. Panel was moderated by James Wilson from Tech Insights."
`;

const PROMPT_9 = PROMPT_1 + " ";

const PROMPT_10 = PROMPT_1;
const PROMPT_11 = PROMPT_1;
const PROMPT_12 = PROMPT_1;
const PROMPT_13 = PROMPT_1;

const PROMPT_14 = PROMPT_4;
const PROMPT_15 = PROMPT_5;
const PROMPT_16 = PROMPT_6;
const PROMPT_17 = PROMPT_7;

const PROMPT_18 = PROMPT_8;
