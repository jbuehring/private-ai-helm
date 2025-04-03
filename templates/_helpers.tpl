{{/*
Expand the name of the chart.
*/}}
{{- define "private-ai-deid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "private-ai-deid.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "private-ai-deid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "private-ai-deid.labels" -}}
helm.sh/chart: {{ include "private-ai-deid.chart" . }}
{{ include "private-ai-deid.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "private-ai-deid.selectorLabels" -}}
app.kubernetes.io/name: {{ include "private-ai-deid.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "private-ai-deid.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "private-ai-deid.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Renders pod scheduling behavior, for those behaviors that are present.
*/}}
{{- define "private-ai-deid.podScheduling" }}
{{- if .Values.nodeSelector }}
{{ print "nodeSelector:" | indent 6 }}
{{- include "common.tplvalues.render" ( dict "value" .Values.nodeSelector "context" $ ) | nindent 8 }}
{{- end }}
{{- if .Values.affinity }}
{{ print "affinity:" | indent 6 }}
{{- include "common.tplvalues.render" ( dict "value" .Values.affinity "context" $ ) | nindent 8 }}
{{- end }}
{{- if .Values.tolerations }}
{{ print "tolerations:" | indent 6 }}
{{- include "common.tplvalues.render" ( dict "value" .Values.tolerations "context" $ ) | nindent 8 }}
{{- end }}
{{- end }}

{{/*
Renders container resources, applying GPU-based limits if necessary.
*/}}
{{- define "private-ai-deid.containerResources" }}
{{- $resources := .Values.resources }}
{{- if .Values.gpuEnabled }}
{{- $resources := merge $resources ( dict "limits" ( dict "nvidia.com/gpu" 1 ) ) }}
{{- end }}
{{- if $resources }}
{{ print "resources:" | indent 10 }}
{{- include "common.tplvalues.render" ( dict "value" $resources "context" $ ) | nindent 12 }}
{{- end }}
{{- end }}
