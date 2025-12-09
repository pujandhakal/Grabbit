# Grabbit

A Real-Time Platform Connecting Buyers with Local Shops

## Overview

Grabbit is a web-based platform designed to bridge the gap between consumers and local shops. It allows users to post real-time requests for specific products, enabling nearby shops to respond with offers if they have the item in stock. This promotes efficient shopping, supports local businesses, and fosters direct buyer-seller connections without the need for shops to maintain online inventories.

Developed as a project by Team Visioneers at Everest Engineering College.

## Problems Addressed

Grabbit tackles common challenges in local shopping:
1. Consumers often struggle to find specific items in nearby shops.
2. Wasted time visiting multiple stores or relying on delayed online shopping.
3. Local shops miss sales because potential customers don't know what they offer.

## Solution

1. Grabbit allows users to post product requests in real-time.
2. Nearby shops can respond only if they have the requested item. The user picks the best offer.
3. Promotes unique, local products and builds direct buyer-seller connections.

## How It Works

1. User signs up and posts a request for a product.
2. Nearby shops see the request and respond if available.
3. User compares responses and chooses a shop with the best offer.
4. Direct connection is made for purchase (user goes in-person to purchase).

## Key Features

1. No shop inventory setup required.
2. GroupBuy discounts based on collective interest – shops offer deals unlocked when enough users join.
3. Real-time request and response system.
4. Shop ratings and reviews.

## Business Model

- **Users**: Freemium model for all users.
- **Shops**:
  - **Freemium Features**: Respond to a limited number of requests for free.
  - **Premium Features**: Unlimited responses, featured listings, analytics, and in-app promotions.

## Technologies Used

- **UI Design**: Figma
- **Frontend**: React.js
- **Backend**: Node.js + Express.js
- **Database**: MongoDB

## Feasibility

1. No inventory uploads for the shop.
2. Simple, intuitive UI for both users and vendors.

## Future Scope

1. Mobile App with offline request processing.
2. Analytics dashboard for shopkeepers.
3. Smart matching based on location, urgency, and product type.

## Team

- **Team Name**: Visioneers
- **Institution**: Everest Engineering College
- **Members**:
  - Saurav Pant
  - Pujan Dhakal

## Installation and Setup

(Assuming a standard MERN stack setup; adjust as needed based on your environment.)

1. **Prerequisites**:
   - Node.js (v14+)
   - MongoDB
   - Git

2. **Clone the Repository**:
   ```
   git clone https://github.com/your-repo/grabbit.git
   cd grabbit
   ```

3. **Install Dependencies**:
   - Frontend:
     ```
     cd frontend
     npm install
     ```
   - Backend:
     ```
     cd ../backend
     npm install
     ```

4. **Configure Environment**:
   - Create a `.env` file in the backend directory with your MongoDB URI and other secrets (e.g., `MONGO_URI=mongodb://localhost:27017/grabbit`).

5. **Run the Application**:
   - Start the backend:
     ```
     cd backend
     npm start
     ```
   - Start the frontend:
     ```
     cd ../frontend
     npm start
     ```

6. **Access the App**:
   - Open `http://localhost:3000` in your browser.

## Demo

For a live demo, refer to the project presentation or deployed version (if available). Contact the team for access.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your changes.

## License

This project is licensed under the MIT License.