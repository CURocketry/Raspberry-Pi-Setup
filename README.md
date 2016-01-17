# Raspberry-Pi-Setup
This guide will walk through the steps required to setup a development or production environment to develop software for the Cornell Rocketry Team's launch vehicle controller.

### What will this do:
* Install programs and dependencies required for running the controller.
* Bind commonly used USB devices to static aliases, and give the current user permission to access tty USB devices.

### Development
The development setup script is located in the `development/setup.sh` directory.

### Production
The production setup script is located in the `production/setup.sh` directory.

### Running the Setup Process
The setup script sets up the environment for the currently logged in user.

1. Get a copy of the repository.
    
        git clone https://github.com/CURocketry/RaspberryPiSetup
2. `cd` to either the development or production directory.
3. Add execution permissions to the setup script

        sudo chmod +x setup.sh
4. Run the setup script:

        ./setup.sh

### Todo
* Use vagrant for seamless setup.
