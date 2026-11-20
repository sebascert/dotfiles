path_prepend /usr/local/cuda/bin
case ":${LD_LIBRARY_PATH:-}:" in
    *:/usr/local/cuda/lib64:*) ;;
    *) export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}} ;;
esac
