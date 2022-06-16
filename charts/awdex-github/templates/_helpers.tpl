{{/*
Expand the name of the chart.
*/}}
{{-  define "connector.redirectUrl" }}
{{- printf "%s/%s" .Values.dex.config.issuer "callback" }}
{{- end }}
