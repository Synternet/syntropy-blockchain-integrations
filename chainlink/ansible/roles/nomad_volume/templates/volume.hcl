client {
    host_volume "{{ volume_name }}-data" {
        path = "/data/{{ volume_name }}"
        read_only = false
    }
}