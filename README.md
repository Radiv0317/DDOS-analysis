# DDoS Analysis Program
# Warning!!! This program created with GPT AI
## Overview

This repository contains a DDoS (Distributed Denial of Service) analysis program written in Ruby. The program monitors incoming requests to a server, analyzes them for suspicious activity, and logs the findings.

## Prerequisites

Before using this program, make sure you have the following prerequisites installed:

- Ruby
- Required Ruby gems: `socket`, `colorize`, `json`
- Operating system: Windows (You may need to modify the file paths for other OS)

## Configuration

In the code, you can configure the following parameters:

- `threshold`: The threshold for the number of requests from an IP within a specific time duration to consider it as a suspicious activity.
- `duration`: The time duration (in seconds) for which the program analyzes incoming requests.
- `server`: The server is set to listen on IP '192.168.1.6' and port 80. You can modify this to suit your server configuration.

## Installation

To install and run the DDoS analysis program on your system, follow these steps:

1. **Clone the Repository**: Begin by cloning this repository to your local machine using Git:

   ```shell
   git clone https://github.com/yourusername/DDOS-analysis.git
