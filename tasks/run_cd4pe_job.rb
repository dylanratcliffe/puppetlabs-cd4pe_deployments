#!/opt/puppetlabs/puppet/bin/ruby

require 'json'
require 'rubygems/package'
require 'open3'

@params = JSON.parse(STDIN.read)
require_relative File.join(@params['_installdir'], 'cd4pe_deployments', 'lib', 'puppet_x', 'puppetlabs', 'cd4pe_client')
require_relative File.join(@params['_installdir'], 'cd4pe_deployments', 'lib', 'puppet_x', 'puppetlabs', 'gzip_helper')
require_relative File.join(@params['_installdir'], 'cd4pe_deployments', 'lib', 'puppet_x', 'puppetlabs', 'cd4pe_job_helper')

@working_dir = File.join(@params['_installdir'], 'cd4pe_job_working_dir')

def docker_image
  @params['docker_image']
end

def docker_run_args
  @params["docker_run_args"]
end

def job_instance_id
  @params["job_instance_id"]
end

def get_combined_exit_code(output)
  job = output[:job]
  after_job_success = output[:after_job_success]
  after_job_failure = output[:after_job_failure]

  exit_code_sum = job[:exit_code]
  if (!after_job_success.nil?)
    exit_code_sum = exit_code_sum + after_job_success[:exit_code]
  end

  if (!after_job_failure.nil?)
    exit_code_sum = exit_code_sum + after_job_failure[:exit_code]
  end

  exit_code_sum == 0 ? 0 : 1
end

begin
  @@logs = []
  job_helper = PuppetX::Puppetlabs::CD4PEJobHelper.new(working_dir: @working_dir, docker_image: docker_image, docker_run_args: docker_run_args)

  @@logs.push("Setting job environment vars.")
  job_helper.set_job_env_vars(@params)

  @@logs.push("Creating working directory #{@working_dir}.")
  job_helper.make_working_dir(@working_dir)

  @@logs.push("Downloading job scripts and control repo from CD4PE.")
  zipped_file = job_helper.get_job_script_and_control_repo

  @@logs.push("Unzipping #{zipped_file}")
  PuppetX::Puppetlabs::GZipHelper.unzip(zipped_file, @working_dir)

  @@logs.push("Running job instance #{job_instance_id}.")
  output = job_helper.run_job

  @@logs.push("Job completed.")

  output[:logs] = @@logs
  puts output.to_json

  exit get_combined_exit_code(output)
rescue => e
  puts({ status: 'failure', error: e.message, logs: @@logs }.to_json)
  exit 1
end