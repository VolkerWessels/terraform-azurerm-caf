%{ for key, value in local.tags }
${key} = "${value}"
%{ endfor ~}