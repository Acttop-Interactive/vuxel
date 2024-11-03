# Vuxel

Vuxel is a lightweight, component-based UI framework for Roblox inspired by Vue.js. It provides a structured approach to building reactive UIs using state management, templating, and hooks.

[![Latest Release](https://img.shields.io/github/v/release/OMouta/vuxel)](https://github.com/OMouta/vuxel/releases/latest)
[![Contributors](https://img.shields.io/github/contributors/OMouta/vuxel)](https://github.com/OMouta/vuxel/graphs/contributors)
[![Issues](https://img.shields.io/github/issues/OMouta/vuxel)](https://github.com/OMouta/vuxel/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/OMouta/vuxel)](https://github.com/OMouta/vuxel/pulls)

![Vuxel](https://github.com/user-attachments/assets/b84cf981-0775-4b2c-a172-a9213682ad9e)

## Table of Contents

- [Vuxel Module](#vuxel-module)
  - [Installation](#installation)
  - [Usage](#usage)
  - [API Reference](#api-reference)
- [Website Documentation](#website-documentation)
  - [Getting Started](#getting-started)
  - [Examples](#examples)
  - [Reference](#reference)

## Vuxel Module

The `vuxel_module` folder contains the core source code for the Vuxel framework.

### Installation

1. **Get the Vuxel Module**: Download the module from the [Roblox Creator Store](https://create.roblox.com/store/asset/131382708043623/Vuxel?viewFromStudio=true&keyword=&searchId=d6dd070a-2639-4bb4-8b30-c352e7d22939).
2. **Insert the Vuxel Module**: Place the `Vuxel` module script inside `ReplicatedStorage` or a custom folder in your Roblox project.

### Usage

1. **Import the Vuxel Module**:
    ```lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Vuxel = require(ReplicatedStorage.Vuxel)
    ```

2. **Create a Vuxel Application**:
    ```lua
    local rootFrame = Instance.new("Frame")
    rootFrame.Size = UDim2.new(0, 400, 0, 300)
    local app = Vuxel.CreateApp(rootFrame)
    ```

3. **Define Reactive State**:
    ```lua
    local counter = Vuxel.State.new(0)
    ```

4. **Create a Component Template**:
    ```lua
    local template = {
        Class = "Frame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(240, 240, 240),
        Children = {
            {
                Class = "TextLabel",
                Name = "CounterLabel",
                Text = Vuxel.Utility.Computed(function()
                    return "Count: " .. counter:Get()
                end, counter),
                Size = UDim2.new(0, 200, 0, 50),
                Position = UDim2.new(0.5, -100, 0.3, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 24
            },
            {
                Class = "TextButton",
                Name = "IncrementButton",
                Text = "Increment",
                Size = UDim2.new(0, 100, 0, 50),
                Position = UDim2.new(0.5, -50, 0.6, 0),
                BackgroundColor3 = Color3.fromRGB(100, 200, 100),
                TextSize = 18,
                Events = {
                    MouseButton1Click = function()
                        counter:Set(counter:Get() + 1)
                    end
                }
            }
        }
    }
    ```

5. **Instantiate the Template**:
    ```lua
    local ui = Vuxel.Template(template)
    ui.Parent = rootFrame
    ```

### API Reference

- **State Management**: `Vuxel.State`
- **Components**: `Vuxel.Components`
- **Event Handling**: `Vuxel.Event`
- **Utility Functions**: `Vuxel.Utility`
- **Animations**: `Vuxel.Animation`
- **Hooks**: `Vuxel.Hooks`
- **References**: `Vuxel.References`

## Website Documentation

The website documentation is built using VitePress and provides comprehensive guides and references for using Vuxel.

### Getting Started

- **Introduction**: Learn about Vuxel and its core concepts in the [Introduction](docs/gs/introduction.md) section.
- **Installation**: Follow the steps to set up Vuxel in your Roblox project in the [Installation](docs/gs/installation.md) section.
- **Creating an Application**: Build your first Vuxel application by following the guide in the [Creating an Application](docs/gs/create.md) section.
- **Conclusion**: Wrap up your learning with some final tips in the [Conclusion](docs/gs/conclusion.md) section.

### Examples

Explore practical examples to see Vuxel in action:

- **A Simple Button**: Learn how to create a simple button in the [A Simple Button](docs/ex/button.md) example.
- **Counter Application**: Build a counter application using reactive state and event handling in the [Counter Application](docs/ex/counter.md) example.

### Reference

Dive deeper into Vuxel's API and advanced features:

- **State**: Understand state management in the [State](docs/ref/state.md) section.
- **Components**: Learn about component creation and management in the [Components](docs/ref/components.md) section.
- **References**: Manage references effectively in the [References](docs/ref/references.md) section.
- **Event Handling**: Handle events in your UI components in the [Event Handling](docs/ref/events.md) section.
- **Hooks**: Utilize hooks for advanced functionality in the [Hooks](docs/ref/hooks.md) section.
- **Utility Functions**: Explore utility functions provided by Vuxel in the [Utility Functions](docs/ref/utility.md) section.
- **Animations**: Create smooth animations in your UI components in the [Animations](docs/ref/animations.md) section.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request on the [GitHub repository](https://github.com/OMouta/vuxel).

## License

This project is licensed under the ISC License.
