# DigiRED Driver Releases

The RASDR project gratefully acknowledges Cypress Semiconductor Corporation for enabling the development of the RASDR Firmware and Windows Support (*).

The directory structure for the driver files is as follows:

      license.txt                - Cypress Semiconductor License Agreement
      signing/                   - Notes and scripts for signing the drivers
      digired-windows.zip        - The driver package

When unzipped, the 'digired-windows.zip' produces the following files:

      docs/                      - screenshots and installation aids
      vista/                     - Windows Vista driver files
      win7/                      - Windows 7 (32-bit and 64-bit) driver files
      win8/                      - Windows 8 (32-bit and 64-bit) driver files
      win8.1/                    - Windows 8.1 (32-bit and 64-bit) driver files
      win10/                     - Windows 10 (32-bit and 64-bit) driver files
      wxp/                       - Windows XP (32-bit and 64-bit) driver files

Ensure that you have unzipped these files to your local hard drive, and plug in your DigiRED board.  When the Windows device installer prompts you, provide the folder to the correct one for your OS (Windows 8.1, 8, 7, Vista or Windows XP) as described above.  You should see roughly what is described in the screenshots in the docs/.

Please ensure that you have loaded the RASDR-authority.cer certificate into you system prior to loading the drivers.  The certificate was provided to you on the RASDR distribution CD that accompanied your RASDR device.

(*) Please see http://www.cypress.com/index.cfm?docID=45919
