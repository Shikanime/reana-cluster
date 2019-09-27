{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "reanaserver.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "reanaserver.fullname" -}}
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
{{- define "reanaserver.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "reanaserver.labels" -}}
app.kubernetes.io/name: {{ include "reanaserver.name" . }}
helm.sh/chart: {{ include "reanaserver.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common environment variables
*/}}
{{- define "reanaserver.env" -}}
- name: REANA_DB_HOST
    value: {{ include "reanapostgresql.fullname" . }}
- name: REANA_DB_PORT
    value: {{ .Values.global.postgresql.port }}
- name: REANA_DB_USERNAME
    value: {{ .Values.global.postgresql.username }}
- name: REANA_DB_PASSWORD
    valueFrom:
    secretKeyRef:
        name: {{ include "reanapostgresql.fullname" . }}
        key: password
- name: REANA_GITLAB_HOST
    value: {{ include "reanagitlab.fullname" . }}
- name: REANA_GITLAB_OAUTH_APP_ID
    value: {{ .Values.global.gitlab.oauthAppId }}
- name: REANA_GITLAB_OAUTH_APP_SECRET
    value: {{ .Values.global.gitlab.oauthAppSecret }}
- name: REANA_GITLAB_OAUTH_REDIRECT_URL
    value: {{ .Values.global.gitlab.oauthRedirectUrl }}
- name: CERN_CONSUMER_KEY
    value: {{ .Values.global.cern.key }}
- name: CERN_CONSUMER_SECRET
    value: {{ .Values.global.cern.secret }}
{{- end -}}
