# BinZout

This app has been a project to practice the wonderful language of Dart.

BinZout is a web application built with Dart that helps users find the next available dates for putting their bins out for collection(Currently only for residents of Liverpool, UK). By entering a postcode, users can quickly view their next bin collection schedule, making waste management simpler and more convenient.

## Features

- Enter your postcode to fetch bin collection dates.
- Display upcoming bin collection types and dates.
- Add to your personal calendar(Not MVP but will be a feature in future iteration)

## Requirements

### Prerequisites

If you don't want to to run this application wih [Docker](https://www.docker.com/) you will need the following:

- Dart SDK >= 3.10.4

[Installation instructions here](https://dart.dev/get-dart)

If you do want to run this application via docker, you can pull down the image via this command:

> docker pull twotriangles/binzout-server:binzout

and run it with the following command:

> docker run -p <HOST_PORT>:8080 twotriangles/binzout-server:binzout

## Running the App(if not using Docker)

### 1. Clone Repository

> gh repo clone dscode89/binzout-server

### 2. Install dependencies

> dart pub get

### 3. Run development server

> dart run

## API Integration

You will find an endpoints.json file which will give you information on the type of data that will be returned at each endpoint.
