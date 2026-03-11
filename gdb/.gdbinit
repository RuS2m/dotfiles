set auto-load safe-path /
set history save on

set print pretty on
set print object on
set detach-on-fork off
set non-stop on
set print thread-events off

python
import gdb
import sys
import os

def find_repo_root(start_dir, marker_relpath):
    cur = os.path.abspath(start_dir)
    while True:
        marker = os.path.join(cur, marker_relpath)
        if os.path.exists(marker):
            return cur
        parent = os.path.dirname(cur)
        if parent == cur:
            return None
        cur = parent

# Load local libstdc++ pretty printer (if compiling with gcc)
libcxx_dir = os.path.expanduser("~/gdb/libcxx")
libcxx_printers = os.path.join(libcxx_dir, "printers.py")

if os.path.exists(libcxx_printers):
    if libcxx_dir not in sys.path:
        sys.path.insert(0, libcxx_dir)
    try:
        import printers as libcxx_printers_mod
        gdb.events.new_objfile.connect(libcxx_printers_mod._register_libcxx_printers)
    except Exception as e:
        print("Failed to load libc++ printers:", e)
 
# If somewhere inside a MongoDB repo, source Mongo's helpers.
mongo_root = find_repo_root(os.getcwd(), os.path.join("buildscripts", "gdb", "mongo.py"))
if mongo_root:
    mongo_scripts = [
        "buildscripts/gdb/mongo.py",
        "buildscripts/gdb/optimizer_printers.py",
        "buildscripts/gdb/mongo_printers.py",
        "buildscripts/gdb/mongo_lock.py",
        "buildscripts/gdb/wt_dump_table.py",
        "src/third_party/immer/dist/tools/gdb_pretty_printers/autoload.py",
    ]

    for relpath in mongo_scripts:
        path = os.path.join(mongo_root, relpath)
        if os.path.exists(path):
            try:
                gdb.execute(f"source {path}")
            except gdb.error as e:
                print(f"Failed to source {path}: {e}")
end
