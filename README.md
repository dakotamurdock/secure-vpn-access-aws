# Vanderbilt CS 5383 - Computer Networks

**Course Project: Secure VPN Access to AWS Resources, Dakota Murdock, Spring 2025**

### Project Structure

- 01 - Infrastructure
  - Contains the cloud infrastructure declared as terraform configuration files. Inputs are organized in the environments directory split between dev, qa, and prod. Resources declared in the modules directory and are organized by type of resource.
- 02 - VPN
  - Contains some artifacts related to the VPN itself including latency and throughput test results and a brief set of instructions for setting up a new VPN user and client
- 03 - Application
  - Contains the test webpage that is uploaded to the S3 bucket
