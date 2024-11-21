dart run build_runner build -d 
if [[ $# -ge 1 ]] ; then
  flutter run -d $1
else
  flutter run
fi
