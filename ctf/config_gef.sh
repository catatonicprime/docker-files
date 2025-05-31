#!/bin/bash
set -e

TOOLS_DIR="$1"
GEF_EXTRAS_DIR="$2"
PYTHON_VENV="$3"

echo "source $TOOLS_DIR/$GEF_DIR/gef.py" >> $HOME/.gdbinit
export PYTHONPATH=$(python -c 'import site; print([d for d in site.getsitepackages() if d.endswith(\"site-packages\")][0])')
echo "export PYTHONPATH=$PYTHONPATH" >> $HOME/.bashrc

source $TOOLS_DIR/$PYTHON_VENV/bin/activate
export PYTHONPATH=$(python3 --version | cut -d ' ' -f 2)
gdb -q \
    -ex "pi gef.config['context.layout'] += ' syscall_args'" \
    -ex "pi gef.config['context.layout'] += ' libc_function_args'" \
    -ex "gef config gef.extra_plugins_dir '$TOOLS_DIR/$GEF_EXTRAS_DIR/scripts'" \
    -ex "gef config pcustom.struct_path '$TOOLS_DIR/$GEF_EXTRAS_DIR/structs'" \
    -ex "gef config syscall-args.path '$TOOLS_DIR/$GEF_EXTRAS_DIR/syscall-tables'" \
    -ex "gef config context.libc_args True" \
    -ex "gef config context.libc_args_path '$TOOLS_DIR/$GEF_EXTRAS_DIR/glibc-function-args'" \
    -ex "gef save" \
    -ex quit

