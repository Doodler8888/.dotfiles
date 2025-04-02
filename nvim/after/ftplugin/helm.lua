vim.bo.shiftwidth = 2

-- i also want to change how indentation works.
--
-- spec:
--   selector:
--     matchLabels:
--       app.kubernetes.io/name: {{ .Release.Name }}-fluentd
--   template:
--     metadata:
--
-- for instance, when i press enter from the end of 'metadata:' line or iif i
-- press 'o' from the normal mode, then new line is indentated on the same level
-- as 'metadata:'. but if the last non white character of the line is a colon,
-- then the new line shoud be additionally indentated by on tab.
