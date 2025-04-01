local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node  -- add the insert node
local fmt = require("luasnip.extras.fmt").fmt

-- ls.filetype_extend("yaml.ansible", {"yaml"})
-- ls.filetype_extend("yaml.kubernetes", {"yaml"})

vim.keymap.set({"i"}, "<C-H>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

-- vim.keymap.set({"i", "s"}, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, {silent = true})

ls.add_snippets("python", {
  s("home", { t("home = os.environ[\"HOME\"]") }),
  s("dot", { t("dotfiles_dir = os.path.join(home, \".dotfiles\")") }),
  s("config", { t("config_dir = os.path.join(home, \".config\")") }),
  s("join", {
    t('os.path.join('),
    i(1, ""),  -- cursor will be here between the quotes
    t(')'),
  }),
  s("-e", {
    t('os.path.exists('),
    i(1, ""),  -- cursor will be here between the quotes
    t(')'),
  }),
  s("-l", {
    t('os.path.islink('),
    i(1, ""),  -- cursor will be here between the quotes
    t(')'),
  }),
  s("srsc", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, check=True)'),
  }),
  -- subprocess.run() with shell=True
  s("srs", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True)'),
  }),
  -- Fixed: stdout=True replaced with stdout=subprocess.PIPE
  s("sr", {
    t('subprocess.run("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, check=True, capture_output=True)'),
  }),
  s("shell", {
    t('subprocess.check_output("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, text=True)'),
  }),
  s("sc", {
    t('subprocess.check_output("'),
    i(1, ""),  -- cursor will be here between the quotes
    t('", shell=True, text=True)'),
  }),
  s("p", {
      t('print("'),
      i(1),  -- Cursor inside the quotes
      t('")')
  }),
  s("pt", {
    t('print(f"This is the '),
    i(1, ""),  -- Cursor inside f-string expression
    t(' {'),
    i(2, ""),  -- Cursor inside curly braces
    t('}")'),
  }),
  s("pf", {
    t('print(f"{'),
    i(1, ""),  -- Cursor inside f-string expression
    t('}")'),
  }),
  s("li", {
    t('logging.info(f"'),
    i(1, ""),  -- Cursor inside f-string expression
    t(' {'),
    i(2, ""),  -- Cursor inside curly braces
    t('}")'),
  }),
  s("main", {
      t({'if __name__ == "__main__":', '    main('}),
      i(1),
      t({')'})
  }),
s("args", {
  -- t({"import argparse", "", "parser = argparse.ArgumentParser("}),
  t({"parser = argparse.ArgumentParser("}),
  t({"", "                    prog='"}), i(1, "program_name"), t({"',"}),
  t({"", "                    description='"}), i(2, "description_here"), t({"',"}),
  t({"", "                    add_help="}), i(3, "True"), t({")"}),
  t({"", "parser.add_argument('"}), i(4, "name_of_the_main_argument_for_the_parser"), t({"', nargs='+', help='"}), i(5, "argument_help"), t({"')"}),
  t({"", "parser.add_argument('"}), i(6, "short_flag"), t({"', '"}), i(7, "long_flag"), t({"', action='store_true', help='"}), i(8, "flag_help"), t({"')"}),
  t({"", "", "args = parser.parse_args()"}
  )
})
})

ls.add_snippets("markdown", {
    s("code", {
        t({"```", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("bash", {
        t({"``` bash", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("py", {
        t({"``` python", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("python", {
        t({"``` python", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
    s("yaml", {
        t({"``` yaml", ""}),
        i(1),  -- Default insert node content
        t({"", "```"}),
    }),
})

ls.add_snippets("helm", {

  s("daemonset", fmt([[
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: {}
  namespace: {}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: {}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {}
    spec:
      volumes:
      - name: {}
        persistentVolumeClaim:
	  claimName: {}
      containers:
      - name: {}
        image: {}
        ports:
        - containerPort: {}
        volumeMounts:
        - name: {}
          mountPath: {}
]], {
    i(1, "daemonset-name"),
    i(2, "default"),
    i(3, "app-label"),
    i(4, "app-label"),
    i(5, "volume-name"),
    i(6, "pvc-name"),
    i(7, "container-name"),
    i(8, "image:tag"),
    i(9, "80"),
    i(10, "volume-name"),
    i(11, "/mount/path")
  })),

  -- StatefulSet snippet with limits defined in the container's resources
  s("statefulset", fmt([[
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {}
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: {}
  replicas: {}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {}
    spec:
      containers:
      - name: {}
        image: {}
        env:
          - name: "POSTGRES_PASSWORD"
            value: "1337"
        ports:
          - containerPort: {}
        volumeMounts:
          - name: postgres-volume
            mountPath: /var/lib/postgresql/data
        resources:
          limits:
            cpu: {}
            memory: {}
	  requests:
	    cpu: {}
	    memory: {}
      volumes:
        - name: postgres-volume
          persistentVolumeClaim:
            claimName: {}
  serviceName: {}
]], {
    i(1, "postgres-statefulset"),
    i(2, "pod-selector-label"),
    i(3, "3"),
    i(4, "created-pod-name"),
    i(5, "postgres-container"),
    i(6, "postgres:17"),
    i(7, "5432"),
    i(8, "200m"),
    i(9, "200Mi"),
    i(10, "200m"),
    i(11, "200Mi"),
    i(12, "postgres-pvc"),
    i(13, "postgres-service")
  })),

  s("name", { t("app.kubernetes.io/name: ") }),

  s("pv-host", {
    t("apiVersion: v1"), t({"", "kind: PersistentVolume"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "test-persistent-pvc"),
    t({"", "spec:"}),
    t({"", "  accessModes:"}),
    t({"", "    - "}), i(2, "ReadWriteOnce"),
    t({"", "  capacity:"}),
    t({"", "      storage: "}), i(3, "1Gi"),
    t({"", "  persistentVolumeReclaimPolicy: "}), i(4, "Retain"),
    t({"", "  storageClassName: "}), i(5, "manual-hostpath"),
    t({"", "  hostPath:"}),
    t({"", "    path: "}), i(6, "path"),
    t({"", "    type: "}), i(7, "DirectoryOrCreate")
  }),

  s("k8s-service", {
    t("apiVersion: v1"), t({"", "kind: Service"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "my-service"),
    t({"", "spec:"}),
    t({"", "  selector:"}),
    t({"", "    app: "}), i(2, "my-app"),
    t({"", "  ports:"}),
    t({"", "    - protocol: TCP"}),
    t({"", "      port: "}), i(3, "80"),
    t({"", "      targetPort: "}), i(4, "9376")
  }),

  s("pvc-static", fmt([[
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {}
spec:
  accessModes:
    - {}
  resources:
    requests:
      storage: {}
  storageClassName: {}
  volumeName: {}
]], {
    i(1, "my-pvc"),
    i(2, "ReadWriteOnce"),
    i(3, "250Mi"),
    i(4, "storage-class-name"),
    i(5, "pv-name"),
  })),

  -- PVC snippet for dynamic provisioning (using a StorageClass)
  s("pvc-dynamic", fmt([[
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: {}
spec:
  accessModes:
    - {}
  resources:
    requests:
      storage: {}
  storageClassName: {}
]], {
    i(1, "my-pvc"),
    i(2, "ReadWriteOnce"),
    i(3, "250Mi"),
    i(4, "standard")
  })),

  s("pod", {
    t("apiVersion: v1"), t({"", "kind: Pod"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "my-pod"),
    t({"", "spec:"}),
    t({"", "  containers:"}),
    t({"", "  - name: "}), i(2, "my-container"),
    t({"", "    image: "}), i(3, "nginx:latest"),
    t({"", "    ports:"}),
    t({"", "      - containerPort: "}), i(4, "80")
  }),

  s("secret", {
  	t("apiVersion: v1"),
  	t({"", "kind: Secret"}),
  	t({"", "metadata:"}),
  	t({"", "  name: "}), i(1, "postgres-secrets"),
  	t({"", "type: "}), i(2, "Opaque"),
  	t({"", "data:"}),
  	t({"", "  USER: "}), i(3, "dXNlcg=="),  -- pre-encoded "user"
  	t({"", "  PASSWORD: "}), i(4, "c2VjcmV0cGFzc3dvcmQ="),  -- pre-encoded "secretpassword"
  	t({"", "  DB: "}), i(5, "ZGF0YWJhc2U=")  -- pre-encoded "database"
  }),

  s("resources", fmt([[
resources:
  limits:
    cpu: {}
    memory: {}
  requests:
    cpu: {}
    memory: {}
]], {
    i(1, "200m"),
    i(2, "250Mi"),
    i(3, "100m"),
    i(4, "128Mi")
  })),

  -- Volumes snippet for a persistent volume claim
  s("volumes", fmt([[
volumes:
- name: {}
  persistentVolumeClaim:
    claimName: {}
]], {
    i(1, "volume-name"),
    i(2, "pvc-name")
  })),

  -- VolumeMounts snippet for mounting a volume into a container
  s("volmounts", fmt([[
volumeMounts:
- name: {}
  mountPath: {}
]], {
    i(1, "volume-name"),
    i(2, "/mount/path")
  })),

  s("env", {
    t("env:"),
    t({"", "  - name: "}), i(1, "ENV_VAR_NAME"),
    t({"", "    value: "}), i(2, "ENV_VALUE")
  }),

  s("envs", {
    t("env:"),
    t({"", "  - name: "}), i(1, "ENV_VAR_NAME"),
    t({"", "    valueFrom:"}),
    t({"", "      secretKeyRef:"}),
    t({"", "        name: "}), i(2, "secret-name"),
    t({"", "        key: "}), i(3, "SECRET_KEY")
  }),
})

-- ls.add_snippets("yaml.ansible", {
ls.add_snippets("yaml", {
--   s("file", fmt([[
-- - name: "Creating a {} file with content"
--   ansible.builtin.copy:
--     dest: {}
--     content: |
--       {}
--       {}
-- ]], { i(1, "file_name/path"), i(2, "filePath"), i(3, "line1"), i(4, "line2") })),
  -- s("file-empty", fmt([[
  s("file", fmt([[
- name: "Creating a file at {}"
  ansible.builtin.file:
    path: {}
    state: touch
    owner: {}
    group: {}
    mode: '{}'
    ]], { i(1, "file_name/path"), i(2, "file_path"), i(3, "root"), i(4, "root"), i(5, "0644") })),
  s("copy", fmt([[
- name: "Copy {} file to {}"
  ansible.builtin.copy:
    src: {}
    dest: {}
    owner: {}
    group: {}
    mode: '{}'
    ]], { i(1, "path"), i(2, "path"), i(3, "path"), i(4, "path"), i(5, "owner_name"), i(6, "group_name"), i(7, "644") })),
  s("line", fmt([[
- name: {}
  ansible.builtin.lineinfile:
    dest: {}
    regexp: '{}'
    line: '{}'
    insertbefore: '{}'
    mode: '0644'
]], { i(1, "description"), i(2, "filePath"), i(3, "regex"), i(4, "line_to_insert"), i(5, "fallback_pattern_when_regex_wasnt_found") })),
  s("lines", fmt([[
- name: {}
  ansible.builtin.lineinfile:
    dest: {}
    line: "{{{{ item.line }}}}"
  loop:
    - {{ line: '{}' }}
    - {{ line: '{}' }}
]], { i(1, "description"), i(2, "filePath"), i(3, "line"), i(4, "line") })),
  s("package", fmt([[
- name: Install packages
  ansible.builtin.package:
    name:
      - {}
      - {}
    state: present
]], { i(1, "package_name"), i(2, "package_name") })),
  s("ansible-service", fmt([[
- name: {}
  ansible.builtin.service:
    name: {}
    state: started
    enabled: yes
]], { i(1, "desrciption"), i(2, "service name but without '.service'") })),
  s("lvm-lv", fmt([[
- name: Create a LV {} in VG {}
  community.general.lvol:
    vg: {}
    lv: {}
    size: {}
    state: present
]], { i(1, "{{ lv_name }}"), i(2, "{{ vg_name }}"), i(3, "{{ vg_name }}"), i(4, "{{ lv_name }}"), i(5, "{{ lv_size }}") })),
  s("filesystem", fmt([[
- name: Create a {} filesystem on {}
  community.general.filesystem:
    fstype: {}
    dev: {}
]], { i(1, "name"), i(2, "path"), i(3, "type"), i(4, "path_to_paritition") })),
})
