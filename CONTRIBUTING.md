# Contributing to flutter_lucide

Thank you for your interest in contributing to flutter_lucide! This document provides guidelines and instructions for contributing to this Flutter package.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Reporting Issues](#reporting-issues)
- [Requesting New Icons](#requesting-new-icons)
- [Updating Icons](#updating-icons)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Code Style](#code-style)
- [Testing](#testing)

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/). By participating, you agree to uphold this code.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/your-username/flutter_lucide.git
   cd flutter_lucide
   ```
3. Create a new branch for your changes:
   ```bash
   git checkout -b feature/your-feature-name
   ```

## How to Contribute

We welcome contributions in the following areas:

- 🐛 **Bug fixes**
- ✨ **New features**
- 📚 **Documentation improvements**
- 🧪 **Test coverage**
- 🎨 **Icon updates**
- 🔧 **Tooling improvements**

## Reporting Issues

When reporting issues, please include:

1. **Flutter version**: `flutter --version`
2. **Package version**: The version of flutter_lucide you're using
3. **Platform**: Android, iOS, Web, macOS, Windows, or Linux
4. **Steps to reproduce**: Clear, numbered steps
5. **Expected behavior**: What you expected to happen
6. **Actual behavior**: What actually happened
7. **Screenshots**: If applicable
8. **Code sample**: Minimal code that reproduces the issue

### Issue Templates

Use the appropriate issue template:
- 🐛 **Bug Report**: For bugs and unexpected behavior
- ✨ **Feature Request**: For new features or enhancements
- 📚 **Documentation**: For documentation improvements
- 🎨 **Icon Request**: For requesting new icons

## Requesting New Icons

To request new icons:

1. Check if the icon already exists in the [Lucide icon library](https://lucide.dev/)
2. If it exists in Lucide but not in this package, create an issue with:
   - Icon name from Lucide
   - Link to the icon on lucide.dev
   - Use case description
3. If the icon doesn't exist in Lucide, request it from the [Lucide project](https://github.com/lucide-icons/lucide) first

## Updating Icons

When new Lucide icons are released:

1. Follow the process in [script/README.md](script/README.md)
2. Update the version numbers in:
   - `pubspec.yaml`
   - `README.md`
   - `CHANGELOG.md`
3. Test the updated icons
4. Submit a pull request

## Development Setup

### Prerequisites

- Flutter SDK (>=3.4.3)
- Dart SDK (>=3.4.3)
- Git

### Setup Steps

1. **Install dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run tests**:
   ```bash
   flutter test
   ```

3. **Check example app**:
   ```bash
   cd example
   flutter pub get
   flutter test
   ```

4. **Run analysis**:
   ```bash
   flutter analyze
   ```

## Pull Request Process

1. **Create a feature branch** from `main`
2. **Make your changes** following the code style guidelines
3. **Add tests** for new functionality
4. **Update documentation** if needed
5. **Run tests** and ensure they pass
6. **Update CHANGELOG.md** with your changes
7. **Submit a pull request** with a clear description

### Pull Request Guidelines

- **Title**: Use a clear, descriptive title
- **Description**: Explain what changes you made and why
- **Reference issues**: Link to any related issues using `#issue-number`
- **Screenshots**: Include screenshots for UI changes
- **Breaking changes**: Clearly mark any breaking changes

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update
- [ ] Icon update

## Testing
- [ ] Tests pass locally
- [ ] Example app works correctly
- [ ] No linter errors

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
```

## Code Style

### Dart/Flutter Style

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to format code
- Follow Flutter conventions
- Use meaningful variable and function names
- Add comments for complex logic

### File Organization

- Keep files focused and single-purpose
- Use appropriate file naming conventions
- Group related functionality together

### Documentation

- Add documentation for public APIs
- Use clear, concise language
- Include examples where helpful
- Keep documentation up-to-date

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/flutter_lucide_test.dart
```

### Test Guidelines

- Write tests for new functionality
- Ensure tests are deterministic
- Use descriptive test names
- Test edge cases and error conditions
- Maintain good test coverage

### Example App Testing

The example app should:
- Demonstrate proper usage
- Work on all supported platforms
- Be visually appealing
- Show various icon use cases

## Release Process

Releases are managed by maintainers and follow semantic versioning:

- **Patch** (1.6.2 → 1.6.3): Bug fixes
- **Minor** (1.6.2 → 1.7.0): New features, icon updates
- **Major** (1.6.2 → 2.0.0): Breaking changes

## Community

- **Discussions**: Use GitHub Discussions for questions and ideas
- **Issues**: Use GitHub Issues for bugs and feature requests
- **Pull Requests**: Use GitHub Pull Requests for code contributions

## Recognition

Contributors will be recognized in:
- CHANGELOG.md
- README.md (for significant contributions)
- GitHub contributors list

## Questions?

If you have questions about contributing:

1. Check existing [Issues](https://github.com/ravikovind/flutter_lucide/issues)
2. Start a [Discussion](https://github.com/ravikovind/flutter_lucide/discussions)
3. Contact maintainers

Thank you for contributing to flutter_lucide! 🎉
