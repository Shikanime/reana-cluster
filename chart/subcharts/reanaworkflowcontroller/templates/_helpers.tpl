{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "reanaworkflowcontroller.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "reanaworkflowcontroller.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "reanaworkflowcontroller.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "reanaworkflowcontroller.labels" -}}
app.kubernetes.io/name: {{ include "reanaworkflowcontroller.name" . }}
helm.sh/chart: {{ include "reanaworkflowcontroller.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common environment variables
*/}}
{{- define "reanaworkflowcontroller.env" -}}
- name: REANA_DB_HOST
    value: {{ include "reanapostgresql.fullname" . }}
- name: REANA_DB_PORT
    value: {{ .Values.global.postgresql.servicePort }}
- name: REANA_DB_USERNAME
    value: {{ .Values.global.postgresql.postgresqlUsername }}
- name: REANA_DB_PASSWORD
    valueFrom:
    secretKeyRef:
        name: {{ include "reanapostgresql.fullname" . }}
        key: password
{{- end -}}
