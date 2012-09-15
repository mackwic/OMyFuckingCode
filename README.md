OMyFuckingCode
==============

OMyFuckingCode (OMFC) is a tool to check C source code.

  * The first goal is to aply a strict coding style (correct / not correct)
  * Then provide informations about the fault (location, type of fault)
  * And why not warning the programmer about common risks (i.e: use of not-checked pointers, assignements in conditions)
  * We can also provide some rewriting :
    - some are easy (wrapping, formatting)
    - some are less... (cutting too-long functions, optimizations, on-the-fly-substitution, inference...)
  * Makefile checking ? (not included but necessary .obj ? lib ?)
  * Compilation helper
  * Test helper

*****

#### Possible rewriting ####

  * templating, macros, etc.
  * optimization:
    - removing dead code
    - compute some contants expressions

#### Possible Compilation / Makefile helping ###

  * Are all the .c and .h included somewhere ?
  * Are all the ***needed*** .obj included ?
  * Are the norm flags set ?
  * Debug compilation, Test compilation
  * Double-compiling : clang + gcc
  * Generation of .annot + ctags

#### Test Helper ####

Goal : help to integrate with a lightweight Test Framework.

How ? Which one ? What is leightweight ?
