# BahoAI - Rwanda's AI Health Assistant

BahoAI is a Shiny-based web application that provides AI-powered health assistance specifically designed for Rwanda. It offers culturally sensitive health information and guidance in both English and Kinyarwanda.

## Features

- **AI Health Assistant**: Powered by OpenAI's GPT-4, providing intelligent health advice
- **Bilingual Support**: Full support for English and Kinyarwanda languages
- **Rwanda-Specific**: Includes information about local hospitals, health centers, and healthcare system
- **Modern UI**: Professional liquid glassy design with responsive layout
- **Secure Authentication**: User login and signup system with database integration
- **Real-time Chat**: Interactive chat interface with typing indicators

## Setup Instructions

### Prerequisites

- R (version 4.0 or higher)
- RStudio (recommended)
- PostgreSQL database
- OpenAI API key

### Installation

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd BahoAI
   ```

2. **Install R packages**
   ```R
   source("setup.R")
   ```

3. **Configure Environment Variables**
   
   Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```
   
   Then edit `.env` and add your OpenAI API key:
   ```
   OPENAI_API_KEY=your_actual_openai_api_key_here
   ```

4. **Configure Database**
   
   Update the database connection details in `database.R` with your PostgreSQL credentials.

5. **Run the Application**
   ```R
   shiny::runApp("app.R")
   ```

## Project Structure

```
BahoAI/
├── app.R                      # Main application entry point
├── landing.R                  # Landing page module
├── auth_module.R              # Authentication UI and logic
├── chat_module.R              # Chat interface module
├── database.R                 # Database connection and operations
├── openai_integration.R       # OpenAI API integration
├── setup.R                    # Package installation script
├── www/                       # Static assets (images, CSS, JS)
│   ├── styles.css            # Main stylesheet
│   ├── chat-styles.css       # Chat-specific styles
│   ├── login.png             # Login page image
│   └── ...                   # Other images and assets
├── .env                       # Environment variables (not in git)
├── .env.example              # Environment variables template
└── .gitignore                # Git ignore rules
```

## Security Notes

- Never commit the `.env` file to version control
- The `.gitignore` file is configured to exclude sensitive files
- Always use environment variables for API keys and credentials
- Database passwords should also be stored in environment variables

## Technologies Used

- **R Shiny**: Web application framework
- **OpenAI GPT-4**: AI language model
- **PostgreSQL**: Database
- **JavaScript**: Client-side interactions
- **CSS**: Custom styling with liquid glassy design

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Support

For Rwanda-specific health emergencies, please call:
- Emergency: 112
- CHUK (Central Hospital): +250 788 123 456
- King Faisal Hospital: +250 788 789 012

## License

This project is developed to support healthcare in Rwanda.

---

**Note**: This AI assistant is not a replacement for professional medical care. Always seek professional medical help when needed.

