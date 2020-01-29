plan cd4pe_deployments::cd4pe_job (
  TargetSpec                      $targets,
  String[1]                       $job_instance_id,
  String[1]                       $cd4pe_web_ui_endpoint,
  String[1]                       $cd4pe_token,
  String[1]                       $cd4pe_job_owner,
  Optional[Array[String[1]]]      $env_vars = undef,
  Optional[String[1]]             $docker_image = undef,
  Optional[Array[String[1]]]      $docker_run_args = undef,
) {
  return run_script(
    # TODO: get this path relatively so it will work anywhere!
    '/Users/chrisleicester/ws/src/cd4pe_deployments/scripts/run_cd4pe_job.rb',
    $targets,
    'arguments' => [
      "job_instance_id=${$job_instance_id}",
      "cd4pe_web_ui_endpoint=${$cd4pe_web_ui_endpoint}",
      "cd4pe_token=${$cd4pe_token}",
      "cd4pe_job_owner=${$cd4pe_job_owner}",
      "env_vars=${$env_vars}",
      "docker_image=${$docker_image}",
      "docker_run_args=${$docker_run_args}"
    ])
}