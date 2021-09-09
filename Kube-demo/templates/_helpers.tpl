{{/* vim: set filetype=mustache: */}}
{{- define "hca.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hca.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $projectCode := .Values.global.projectCode }}
{{- $stackId := .Values.global.stackId }}
{{- $envCode := .Values.global.envCode }}
{{- $envId := .Values.global.envId }}
{{- $hcaId := .Values.global.hcaId }}
{{- printf "%s%s-%s%s-hca%s-bck%s" $projectCode $stackId $envCode $envId $hcaId $hcaId }}
{{- end }}
{{- end }}
{{- end }}

{{- define "hca.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "hca.servicename" -}}
{{- $deployRegion := .Values.global.deployRegion }}
{{- $projectCode := .Values.global.projectCode }}
{{- $stackId := .Values.global.stackId }}
{{- $envCode := .Values.global.envCode }}
{{- $envId := .Values.global.envId }}
{{- $hcaId := .Values.global.hcaId }}
{{- printf "%s-%s%s-%s%s-hca%s-bck%s" $deployRegion $projectCode $stackId $envCode $envId $hcaId $hcaId }}
{{- end -}}

{{- define "hca.labels" -}}
helm.sh/chart: {{ include "hca.chart" . }}
{{ include "hca.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hca.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hca.name" . }}
app: {{ include "hca.fullname" . }}
appVersion: {{ .Chart.AppVersion | quote }}
{{- end }}

{{- define "hca.nodeSelectorLabels" -}}
{{- $deployRegion := .Values.global.deployRegion -}}
{{- $envCode := .Values.global.envCode -}}
{{- $envId := .Values.global.envId -}}
{{- $clusterId := .Values.global.clusterId -}}
{{- $npId := .Values.global.nodepoolId -}}
tier: {{ .Values.global.nodepoolLabel }} #{{ printf "%s-%s%s-cl%s-np%s-multi" $deployRegion $envCode $envId $clusterId $npId -}}
{{- end -}}

{{- define "hca.tolerations" -}}
{{- $deployRegion := .Values.global.deployRegion -}}
{{- $envCode := .Values.global.envCode -}}
{{- $envId := .Values.global.envId -}}
{{- $clusterId := .Values.global.clusterId -}}
{{- $npId := .Values.global.nodepoolId -}}
- key: "tier"
  operator: "Equal"
  value: {{ .Values.global.nodepoolLabel }} #{{ printf "%s-%s%s-cl%s-np%s-multi" $deployRegion $envCode $envId $clusterId $npId }}  
  effect: "NoSchedule"
{{- end -}}

{{/*
Place HCA pods in different zones
*/}}
{{- define "hca-workload-placement" -}}
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
    - weight: 100
      podAffinityTerm:
        labelSelector:
          matchExpressions:
          - key: app.kubernetes.io/name
            operator: In
            values:
            - {{ include "hca.name" . }}
        topologyKey: topology.kubernetes.io/zone
{{- end }}
