# DotNetProjectWizard

> **An Enterprise Project Generator for .NET, Java, Spring Boot and Future Technologies**

![.NET](https://img.shields.io/badge/.NET-9.0-blue)
![C#](https://img.shields.io/badge/C%23-Latest-purple)
![Java](https://img.shields.io/badge/Java-17+-orange)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-3.x-green)
![License](https://img.shields.io/badge/License-MIT-brightgreen)

---

# Overview

**DotNetProjectWizard** is an Enterprise-grade project generator designed to automate the creation of complete software architectures.

Instead of simply generating empty projects, the goal is to generate **production-ready solutions** following modern software engineering best practices.

The project is being developed entirely in **C#/.NET**, but is capable of generating projects for multiple technology stacks through shell one-shot scripts.

Current supported platforms include:

- .NET
- Java
- Spring Boot
- Spring Batch
- Maven
- Gradle (future)
- Docker
- Kubernetes (future)
- Cloud-ready architectures

---

# Philosophy

Most project generators only create an empty project.

DotNetProjectWizard aims to generate **real enterprise applications**.

For example:

```
projectwizard new spring-api
```

Instead of generating only:

```
pom.xml
src/
```

It generates an entire architecture:

- Controllers
- Services
- Repositories
- DTOs
- Validation
- Docker
- Git
- Swagger
- Tests
- CI/CD
- Logging
- Configuration

Already organized.

---

# Goals

The main goals are:

- Reduce project setup time
- Standardize architectures
- Improve code quality
- Accelerate onboarding
- Follow industry best practices
- Generate production-ready solutions

---

# Technologies

## .NET

- .NET 9
- C#
- CLI
- Dependency Injection
- Clean Architecture
- SOLID

---

## Java

- Java 17+
- Maven
- Gradle (future)

---

## Spring

- Spring Boot
- Spring Batch
- Spring Data
- Spring Security
- Spring Validation
- Spring Cloud (future)

---

## DevOps

- Docker
- Docker Compose
- Git
- GitHub Actions (future)
- Kubernetes (future)

---

# Why Shell Scripts?

One important design decision was that **every project generation step is executed using shell one-shot scripts**.

Benefits:

- Easy debugging
- Easy customization
- Platform independence
- Reusable scripts
- No hidden magic

Every generation step can be executed independently.

Example:

```
01-create-project.sh
02-create-folders.sh
03-create-solution.sh
04-install-packages.sh
05-git-init.sh
...
```

---

# Architecture

```
DotNetProjectWizard
│
├── src
│
├── tests
│
├── scripts
│   │
│   ├── dotnet-api
│   ├── ecommerce
│   ├── clean-architecture
│   ├── spring-api
│   ├── spring-batch
│   ├── microservices
│   └── banking
│
└── templates
```

---

# Command Line

Example:

```
projectwizard list
```

Lists available templates.

Example:

```
projectwizard new spring-api
```

Creates a complete Spring Boot project.

Example:

```
projectwizard new spring-batch
```

Creates a complete Spring Batch project.

Example:

```
projectwizard new ecommerce
```

Creates an enterprise e-commerce backend.

---

# Supported Templates

## .NET

- REST API
- Clean Architecture
- CQRS
- DDD
- Microservices
- Worker Service
- Background Jobs
- Web API
- Minimal API

---

## Java

- Spring Boot REST API
- Spring Batch
- Spring MVC
- Scheduler
- Kafka Producer
- Kafka Consumer
- RabbitMQ
- Authentication
- JWT

---

## Enterprise Templates

Future templates:

- Banking System
- ERP
- CRM
- Marketplace
- Inventory
- Logistics
- Financial System
- Healthcare
- Hotel Management

---

# Why Spring Initializr?

Initially the Java templates generated every file manually.

During development we discovered several issues:

- Spring Boot versions
- Spring Batch API changes
- Maven dependency versions
- Plugin compatibility

For example:

Spring Batch 5 removed:

```
JobBuilderFactory
StepBuilderFactory
```

Templates written for Spring Batch 4 no longer compile.

Because of that, the project adopted a new strategy.

Instead of manually maintaining dozens of POM files, DotNetProjectWizard will use the official Spring Initializr as the project foundation.

Flow:

```
DotNetProjectWizard
        │
        ▼
Spring Initializr
        │
        ▼
Official Spring Boot Project
        │
        ▼
Apply Enterprise Templates
        │
        ▼
Ready-to-use Project
```

Advantages:

- Always updated
- Official project structure
- Compatible dependencies
- Less maintenance
- Easier upgrades

---

# Enterprise Architecture

Generated projects follow layered architecture.

```
Controller

↓

Service

↓

Domain

↓

Repository

↓

Persistence
```

Following SOLID principles.

---

# Development Workflow

```
Create Template

↓

Generate Project

↓

Compile

↓

Run Tests

↓

Git Init

↓

Ready to Develop
```

---

# Development Roadmap

## CLI

- [x] Solution generation
- [x] Project generation
- [x] Command Dispatcher
- [x] Shell Executor
- [x] List command
- [x] New command
- [ ] Interactive mode
- [ ] Plugin system

---

## .NET Templates

- [ ] REST API
- [ ] Clean Architecture
- [ ] DDD
- [ ] CQRS
- [ ] Worker Service
- [ ] gRPC

---

## Java Templates

- [ ] Spring REST API
- [ ] Spring Batch
- [ ] Scheduler
- [ ] Kafka
- [ ] RabbitMQ
- [ ] OAuth2

---

## Cloud

- [ ] Docker
- [ ] Kubernetes
- [ ] AWS
- [ ] Azure
- [ ] Google Cloud

---

# Development Principles

The project follows these principles:

- KISS
- SOLID
- DRY
- Clean Code
- Clean Architecture
- Enterprise Design

---

# Long-Term Vision

The long-term vision is to transform DotNetProjectWizard into a complete enterprise scaffolding platform capable of generating projects for multiple ecosystems from a single command.

Future supported ecosystems include:

- .NET
- Java
- Python
- Node.js
- Go
- Rust
- PHP
- C++
- Flutter
- React
- Angular
- Vue

---

# Contributing

Contributions are welcome.

Ideas:

- New templates
- Better architecture
- More shell scripts
- More enterprise examples
- Better documentation
- Performance improvements

---

# License

MIT License

---

# Author

Developed by **Marcel (Jester)**.

---

# Vision

The objective of this project is not simply generating code.

The objective is to generate **enterprise software foundations**, allowing developers to start real-world applications in minutes instead of spending hours configuring infrastructure.

**Build less boilerplate. Deliver more software.**