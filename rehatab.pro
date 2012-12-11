#-------------------------------------------------
#
# Project created by QtCreator 2011-08-01T15:01:59
#
#-------------------------------------------------

TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += \
    src \
    rehatab \
    test

DESTDIR=dist
# Copies the given files to the destination directory
defineTest(copyToDestdir) {
    files = $$1
    DDIR = $$2
    win32:DDIR ~= s,/,\\,g
    win32:QMAKE_COPY=xcopy /S /I
    for(FILE, files) {

        # Replace slashes in paths with backslashes for Windows
        win32:FILE ~= s,/,\\,g

        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DDIR) $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

defineTest(createDir) {
    files = $$1

    for(FILE, files) {

        # Replace slashes in paths with backslashes for Windows
        win32:FILE ~= s,/,\\,g

        QMAKE_POST_LINK += $(MKDIR) $$quote($$FILE) $$escape_expand(\\n\\t)
    }

    export(QMAKE_POST_LINK)
}

# add a build command
defineReplace( nc  ) {
return( $$escape_expand(\n\t)$$1    ) }
# add a silent build command
defineReplace( snc ) {
return( $$escape_expand(\n\t)"@"$$1 ) }
# add end of line
defineReplace( nl  ) {
return( $$escape_expand(\n)         ) }

OTHER_FILES += \
    rehatab/qml

win32:QTDIR=D:\seu\qt\4.8.2

win32:OTHER_DLLS += \
    ../../qt.libs/qdjango-db0.dll \
   $$QTDIR/bin/QtCore4.dll \


OTHER_DIRS += \
    dist \
    dist/qml

createDirs($$OTHER_DIRS)
copyToDestdir(rehatab/dist/rehatab.exe, $$DESTDIR)
copyToDestdir($$OTHER_FILES, dist/qml)
copyToDestdir($$OTHER_DLLS, dist)

dist.commands += $$QMAKE_POST_LINK

QMAKE_EXTRA_TARGETS += dist docs
