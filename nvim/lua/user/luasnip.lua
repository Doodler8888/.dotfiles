local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node  -- add the insert node

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

ls.add_snippets("yaml", {
  s("name", { t("app.kubernetes.io/name: ") }),

  s("statefulset", {
    t("apiVersion: apps/v1"), t({"", "kind: StatefulSet"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "postgres-statefulset"),
    t({"", "spec:"}),
    t({"", "  selector:"}),
    t({"", "    matchLabels:"}),
    t({"", "      app.kubernetes.io/name: "}), i(2, "postgres"),
    t({"", "  replicas: "}), i(3, "3"),
    t({"", "  template:"}),
    t({"", "    metadata:"}),
    t({"", "      labels:"}),
    t({"", "        app.kubernetes.io/name: "}), i(4, "postgres"),
    t({"", "    spec:"}),
    t({"", "      containers:"}),
    t({"", "      - name: "}), i(5, "postgres-container"),
    t({"", "        image: "}), i(6, "postgres:17"),
    t({"", "        env:"}),
    t({"", "          - name: \"POSTGRES_PASSWORD\""}),
    t({"", "            value: \"1337\""}),
    t({"", "        ports:"}),
    t({"", "          - containerPort: "}), i(7, "5432"),
    t({"", "        volumeMounts:"}),
    t({"", "          - name: postgres-volume"}),
    t({"", "            mountPath: /var/lib/postgresql/data"}),
    t({"", "      volumes:"}),
    t({"", "        - name: postgres-volume"}),
    t({"", "          persistentVolumeClaim:"}),
    t({"", "            claimName: "}), i(8, "postgres-pvc"),
    t({"", "  serviceName: "}), i(9, "postgres-service")
  }),

  s("pvhost", {
    t("apiVersion: v1"), t({"", "kind: PersistentVolume"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "test-persistent-pvc"),
    t({"", "spec:"}),
    t({"", "  accessModes:"}),
    t({"", "    - "}), i(2, "ReadWriteOnce"),
    t({"", "  capacity:"}),
    t({"", "      storage: "}), i(3, "1Gi"),
    t({"", "  persistentVolumeReclaimPolicy: "}), i(4, "Retain"),
    t({"", "  hostPath:"}),
    t({"", "    path: "}), i(5, "/data/kind-hostpath-reboot-volume"),
    t({"", "    type: "}), i(6, "DirectoryOrCreate")
  }),

  s("service", {
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

  s("pvc", {
    t("apiVersion: v1"), t({"", "kind: PersistentVolumeClaim"}),
    t({"", "metadata:"}),
    t({"", "  name: "}), i(1, "my-pvc"),
    t({"", "spec:"}),
    t({"", "  accessModes:"}),
    t({"", "    - "}), i(2, "ReadWriteOnce"),
    t({"", "  resources:"}),
    t({"", "    requests:"}),
    t({"", "      storage: "}), i(3, "1Gi")
  }),

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
