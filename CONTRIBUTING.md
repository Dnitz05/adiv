# Contributing to Smart Divination Platform

Thank you for considering contributing to the Smart Divination Platform! This document provides guidelines and information for contributors.

## 🚀 Quick Start

### Prerequisites
- **Node.js** 18+ for backend development
- **Flutter** 3.24+ for mobile app development
- **Git** for version control
- **Supabase CLI** for database operations (optional)

### Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/Dnitz05/adiv.git
   cd adiv
   ```

2. **Backend Setup**
   ```bash
   cd smart-divination/backend
   npm ci
   cp .env.example .env.local  # Configure your environment
   npm run dev  # Start development server
   ```

3. **Flutter Setup**
   ```bash
   cd smart-divination
   dart pub global activate melos
   melos bootstrap
   cd apps/tarot && flutter run
   ```

## 📋 How to Contribute

### Reporting Issues
- Use our [issue templates](.github/ISSUE_TEMPLATE/) for bug reports and feature requests
- Search existing issues before creating a new one
- Provide clear reproduction steps for bugs
- Include relevant environment information

### Submitting Changes

1. **Fork the repository** and create a feature branch
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards

3. **Test your changes**
   ```bash
   # Backend testing
   cd smart-divination/backend
   npm test && npm run type-check && npm run lint

   # Flutter testing
   cd smart-divination/apps/[app-name]
   flutter test && flutter analyze
   ```

4. **Commit with clear messages**
   ```bash
   git commit -m "feat: add new tarot spread layout"
   ```

5. **Submit a Pull Request** using our [PR template](.github/pull_request_template.md)

## 🏗️ Project Structure

```
smart-divination/
├── backend/          # Next.js API server
├── apps/
│   ├── tarot/       # Flutter tarot app
│   ├── iching/      # Flutter I Ching app
│   └── runes/       # Flutter runes app
├── packages/
│   └── common/      # Shared Flutter utilities
└── supabase/        # Database migrations
```

## 💻 Coding Standards

### Backend (TypeScript/Next.js)
- Use **TypeScript** with strict mode
- Follow **ESLint** and **Prettier** configurations
- Write **Jest** tests for new API endpoints
- Use **Zod** for request validation
- Include proper error handling and logging

### Flutter (Dart)
- Follow **Dart** style guide and **flutter_lints**
- Write **unit tests** for business logic
- Use **common** package for shared utilities
- Implement proper **error handling** and **loading states**

### Database (Supabase)
- Create **migrations** for schema changes
- Update **TypeScript types** after schema changes
- Document complex queries and triggers

## 🧪 Testing Requirements

### Required Tests
- **Unit tests** for new business logic
- **Integration tests** for API endpoints
- **Widget tests** for Flutter UI components
- **Manual testing** for user flows

### Test Coverage
- Aim for **80%+ coverage** on new code
- All **critical paths** must be tested
- **Error scenarios** should be covered

## 📝 Documentation

### Required Documentation
- **API changes** must be documented
- **Breaking changes** require migration guides
- **New features** need user-facing documentation
- **Code comments** for complex logic

### Documentation Style
- Use clear, concise language
- Provide **code examples** where helpful
- Keep **README files** up to date
- Document **environment variables** and configuration

## 🔒 Security Guidelines

### Security Requirements
- **No hardcoded secrets** in source code
- Use **environment variables** for configuration
- **Validate all inputs** on backend endpoints
- Follow **OWASP** security guidelines
- Report security issues privately to maintainers

### Sensitive Data
- Never commit **API keys**, **passwords**, or **tokens**
- Use **`.env.local`** for local secrets
- Review changes before committing

## 🎯 Contribution Types

We welcome various types of contributions:

- 🐛 **Bug fixes** - Help us improve stability
- ✨ **New features** - Add functionality users want
- 📚 **Documentation** - Improve guides and examples
- 🧹 **Refactoring** - Clean up and optimize code
- 🔧 **Tooling** - Improve development experience
- 🌍 **Translations** - Add support for more languages

## 📞 Getting Help

- **GitHub Issues** - For bugs and feature requests
- **Discussions** - For questions and community chat
- **Pull Request Reviews** - For code feedback

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the [MIT License](LICENSE).

## 🙏 Recognition

Contributors are recognized in our release notes and repository. Thank you for helping make Smart Divination Platform better!