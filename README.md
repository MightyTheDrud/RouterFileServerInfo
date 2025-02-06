Network Device Firmware Scanner Tool - Currently Designed for Routers and File Servers in this example.

Overview
This Python script scans various subnets on a network to identify and collect information about routers and file servers, including their firmware details. The collected data is then saved into an Excel spreadsheet for easy reference using Pandas.

Key Features
- Subnet Scanning: Utilizes ping3 for quick IP discovery across specified subnets.
- Device Identification: Identifies routers and file servers by their hostnames.

Firmware Retrieval: 
- For routers, it scrapes both the firmware version and MAC address from their respective web interfaces.

- For file servers, it uses two methods:
  + A basic HTTP request method for older or less secure systems.
  + A more secure method involving Playwright for interaction with protected interfaces.

Multithreading: Employs concurrent execution for faster scanning with concurrent.futures.
Data Storage: Saves all collected data into Excel spreadsheets using pandas (aliased as bamboo in the script) and openpyxl.

Dependencies:
time
os
keyboard
requests
socket
concurrent.futures
pandas (as bamboo)
openpyxl
playwright (for web scraping with JavaScript)
datetime
beautifulsoup4 (for HTML parsing)
ping3 (for network pinging)

Usage
- Prepare Input: Ensure Subnet.txt contains entries of subnets and their corresponding locations in the format subnet | location.

Run Script: Execute the script. It will:
- Scan subnets for devices.
- Retrieve firmware and device information.
- Allow user input to decide whether to scan file servers or not.
- Save results to both local and network-shared Excel files.

Notes
- The script uses hardcoded credentials for accessing some file servers (username = "Neo", password = "FollowTheWhiteRabbit1999"). Ensure these are secure or change them in production.
- The script assumes Microsoft Edge for Playwright operations; ensure the path to the Edge executable is correct on the system.
- Adjust max_workers in thread pools based on your system capabilities to balance speed and resource usage.

Files Generated - if either file already exists, results are appended instead of generating a new file:
RoutersFileServersFirmwareResults.xlsx (Local path)
\\exampleTeamNetworkPath\\RoutersFileServersFirmwareResults\\RoutersFileServersFirmwareResults.xlsx (Shared network path)

Security Considerations
- Be cautious with network scanning; ensure you have permission to scan the network you're targeting.
- The use of hardcoded credentials in the script is not recommended for production environments; consider implementing a secure way to manage credentials. For personal use, knock yourself out! =)

Exit
The program waits for the user to press 'q' to quit, allowing time to view results before closing.

