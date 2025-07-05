# East Coast Railway I-Card Management System

A comprehensive web-based identity card management system for East Coast Railway employees, supporting both Gazetted and Non-Gazetted staff applications.

## 🚀 Features

### For Employees
- **Dual Application Types**: Support for both Gazetted and Non-Gazetted employee applications
- **Digital Form Submission**: Complete online application forms with file uploads
- **Real-time Status Tracking**: Check application status with unique application numbers
- **User Dashboard**: Personalized dashboard for applicants
- **Document Upload**: Photo and signature upload functionality
- **Family Member Details**: Add family member information for ID cards

### For Administrators
- **Admin Panel**: Comprehensive dashboard for application management
- **Application Review**: View, approve, or reject applications with reasons
- **Bulk Operations**: Generate and print multiple ID cards
- **Advanced Filtering**: Filter applications by date, status, and type
- **Report Generation**: Generate detailed reports in various formats
- **Status Management**: Manage application statuses (Pending, Approved, Rejected, Printing, Closed)
- **ID Card Generation**: Generate PDF ID cards with QR codes

## 🛠️ Technology Stack

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **MongoDB** - Database
- **Mongoose** - ODM for MongoDB
- **PDFKit** - PDF generation
- **QRCode** - QR code generation
- **Multer** - File upload handling

### Frontend
- **HTML5/CSS3** - Structure and styling
- **JavaScript (ES6+)** - Client-side functionality
- **Bootstrap 5** - Responsive UI framework
- **DataTables** - Advanced table functionality
- **Flatpickr** - Date picker
- **QRCode Generator** - Client-side QR codes

### Security & Performance
- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing
- **Rate Limiting** - API protection
- **XSS Protection** - Cross-site scripting prevention
- **MongoDB Sanitization** - NoSQL injection prevention

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- **Node.js** (v14 or higher)
- **MongoDB** (v4.4 or higher)
- **npm** or **yarn** package manager

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/Sekhar03/icard-system.git
cd icard-system
```

### 2. Install Dependencies
```bash
npm install
```

### 3. Environment Configuration
Create a `.env` file in the root directory:

```env
# Server Configuration
PORT=3000
NODE_ENV=production

# Database Configuration
MONGO_URI=mongodb://localhost:27017/icard_db

# CORS Configuration
CORS_ORIGIN=http://localhost:3000

# Admin Credentials (Change these in production)
ADMIN_USERNAME=admin
ADMIN_PASSWORD=admin123

# File Upload Configuration
UPLOAD_PATH=./public/uploads
MAX_FILE_SIZE=5242880

# Security Configuration
SESSION_SECRET=your-super-secret-key-here
```

### 4. Database Setup
Make sure MongoDB is running on your system. The application will automatically create the necessary collections.

### 5. Start the Application

#### Development Mode
```bash
npm run dev
```

#### Production Mode
```bash
npm start
```

The application will be available at `http://localhost:3000`

## 📁 Project Structure

```
icard-system/
├── controllers/          # API route handlers
│   ├── adminController.js
│   ├── formController.js
│   ├── statusController.js
│   └── userController.js
├── middleware/           # Custom middleware
│   └── upload.js
├── models/              # Database models
│   ├── EmployeeGaz.js
│   └── EmployeeNonGaz.js
├── public/              # Static files
│   ├── css/
│   ├── fonts/
│   ├── images/
│   ├── js/
│   ├── uploads/
│   └── *.html
├── utils/               # Utility functions
│   └── generateIdCard.js
├── server.js            # Main server file
├── package.json
└── README.md
```

## 🔧 API Endpoints

### Admin Endpoints
- `POST /api/admin/login` - Admin authentication
- `GET /api/admin/applications` - Get all applications
- `GET /api/admin/gazetted` - Get gazetted applications
- `GET /api/admin/non-gazetted` - Get non-gazetted applications
- `POST /api/admin/gazetted/:id/approve` - Approve gazetted application
- `POST /api/admin/non-gazetted/:id/approve` - Approve non-gazetted application
- `POST /api/admin/gazetted/:id/reject` - Reject gazetted application
- `POST /api/admin/non-gazetted/:id/reject` - Reject non-gazetted application
- `GET /api/admin/generate-id-card/:id` - Generate individual ID card
- `POST /api/admin/generate-bulk-id-cards` - Generate bulk ID cards

### User Endpoints
- `POST /api/forms/gazetted` - Submit gazetted application
- `POST /api/forms/non-gazetted` - Submit non-gazetted application
- `GET /api/status/:applicationNo` - Check application status

## 🎯 Usage

### For Employees

1. **Access the Application**
   - Visit the application URL
   - Choose between Gazetted or Non-Gazetted application

2. **Fill Application Form**
   - Complete all required fields
   - Upload photo and signature
   - Add family member details if needed

3. **Submit Application**
   - Review all information
   - Submit the application
   - Note your application number

4. **Track Status**
   - Use the status page to check application progress
   - Use your application number to track status

### For Administrators

1. **Login to Admin Panel**
   - Access `/admin` route
   - Use admin credentials

2. **Review Applications**
   - View all applications in the dashboard
   - Filter by status, date, or type

3. **Process Applications**
   - Approve or reject applications
   - Add rejection reasons if needed
   - Generate ID cards for approved applications

4. **Generate Reports**
   - Create custom reports
   - Export data in various formats
   - Generate bulk ID cards

## 🔒 Security Features

- **Input Validation**: All user inputs are validated
- **File Upload Security**: Secure file upload with type and size restrictions
- **XSS Protection**: Cross-site scripting prevention
- **NoSQL Injection Protection**: MongoDB query sanitization
- **Rate Limiting**: API endpoint protection
- **CORS Configuration**: Controlled cross-origin access

## 📊 Database Schema

### Gazetted Employee Model
- Application details (name, designation, department, etc.)
- Contact information
- Family member details
- File uploads (photo, signature)
- Application status and timestamps

### Non-Gazetted Employee Model
- Similar structure to Gazetted model
- Additional fields specific to non-gazetted staff
- Custom validation rules

## 🚀 Deployment

### Local Development
```bash
npm run dev
```

### Production Deployment

#### Using PM2
```bash
npm install -g pm2
pm2 start server.js --name "icard-system"
pm2 startup
pm2 save
```

#### Using Docker
```dockerfile
FROM node:16-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

#### Environment Variables for Production
```env
NODE_ENV=production
PORT=3000
MONGO_URI=mongodb://your-production-mongo-uri
CORS_ORIGIN=https://your-domain.com
ADMIN_USERNAME=your-admin-username
ADMIN_PASSWORD=your-secure-password
SESSION_SECRET=your-production-session-secret
```

## 🧪 Testing

### Manual Testing
1. Submit test applications
2. Test admin functionality
3. Verify ID card generation
4. Test file uploads
5. Check status tracking

### API Testing
Use tools like Postman or curl to test API endpoints:

```bash
# Test admin login
curl -X POST http://localhost:3000/api/admin/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the ISC License.

## 👥 Authors

- **IT Centre/ECoR/Bhubaneswar** - *Initial work*

## 🙏 Acknowledgments

- East Coast Railway for the project requirements
- Open source community for the libraries used
- Contributors and maintainers

## 📞 Support

For support and queries:
- Email: itcentre@ecor.gov.in
- Phone: +91-XXX-XXXXXXX
- Address: IT Centre, East Coast Railway, Bhubaneswar

## 🔄 Version History

- **v1.0.0** - Initial release with basic functionality
- **v1.1.0** - Added admin panel and bulk operations
- **v1.2.0** - Enhanced security and performance improvements
- **v1.3.0** - Added reporting and advanced filtering features

---

**Note**: This system is designed specifically for East Coast Railway requirements. Please ensure compliance with your organization's security policies before deployment. 