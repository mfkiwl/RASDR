#@PydevCodeAnalysisIgnore
#
# Absolutely brilliant documentation:
# http://www.py2exe.org/index.cgi/MatPlotLib

from distutils.core import setup
import py2exe

# replace the PROGRAM name below with the .py of the top-level you want to make an .exe for
# running 'setup.py py2exe' will create an <name>.exe in the dist/

PROGRAM  = ['plotcsv.py']

# Remove the build folder, a bit slower but prevents wierd dependency issues
# Remove the dist folder, it needs to be cleared each time
import shutil
shutil.rmtree("build", ignore_errors=True)
shutil.rmtree("dist",  ignore_errors=True)

data_files = []
includes = ["matplotlib.backends", "matplotlib.backends.backend_wxagg",
            "matplotlib.figure","pylab", "numpy"]
excludes = ['_gtkagg', '_tkagg', 'bsddb', 'curses', 'pywin.debugger',
            'pywin.debugger.dbgcon', 'pywin.dialogs', 'tcl',
            'pydoc', 'doctest', 'test', 'sqlite3'
            ]
packages = ['matplotlib', 'pytz']

# http://stackoverflow.com/questions/323424/py2exe-fails-to-generate-an-executable
#
# may need to add 'MSVCP90.dll', and manually ensure runtime components are installed
# you do this by running 'vcxxx', which I would copy into installation folder before
# .zip.  It is not needed if one has already installed a Microsoft compiler.
# See also: http://www.microsoft.com/en-us/download/details.aspx?id=29
#
# http://stackoverflow.com/questions/2104611/memoryloaderror-when-trying-to-run-py2exe-application
# http://sourceforge.net/p/py2exe/bugs/108/
#
# the above problem affected the rasdr-distribution-1.2.1
#
# ISSUE: when executing, you get a debug output of the form:
# HH:MM:SS: Debug: src/helpers.cpp(140): 'CreateActCtx' failed with error 0x0000007b
# See:
# http://stackoverflow.com/questions/4321893/error-after-creating-exe-with-py2exe
# https://groups.google.com/d/msg/wxpython-users/MyY7JbQf6Lo/bb_GMDrJ4WQJ
#
# It appears to be benign and possibly related to .dll issues in MS dependencies

dll_excludes = ['libgdk-win32-2.0-0.dll', 'libgdk_pixbuf-2.0-0.dll',
                'libgobject-2.0-0.dll', 'tcl85.dll',
                'tk85.dll', 'MSVCP90.dll', 'mswsock.dll', 'powrprof.dll' ]
icon_resources = []
bitmap_resources = []
other_resources = []

# add the mpl mpl-data folder and rc file
import matplotlib as mpl
data_files += mpl.get_py2exe_datafiles()

setup(
    console=PROGRAM,      # console=commandline, windows=GUI
                          # compressed and optimize reduce the size
    options = {"py2exe": {"compressed": 2, 
                          "optimize": 2,
                          "includes": includes,
                          "excludes": excludes,
                          "packages": packages,
                          "dll_excludes": dll_excludes,
                          # using 3 sometimes makes things 'just work' (but generates enormous # of files)
                          # using 2 to reduce number of files in dist folder
                          # using 1 is not recommended as it often does not work
                          "bundle_files": 2,
                          "dist_dir": 'dist',
                          "xref": False,
                          "skip_archive": False,
                          "ascii": False,
                          "custom_boot_script": '',
                         }
              },

    # using zipfile to reduce number of files in dist
    zipfile = r'library.zip',

    data_files=data_files
)
