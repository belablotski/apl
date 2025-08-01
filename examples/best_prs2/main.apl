# APL Program: Find and Evaluate the Best Pull Requests
# Version: 0.2
# Description: A driver module that orchestrates the process of finding and evaluating PRs.

inputs:
  - name: repos_list
    description: "Absolute path to the text file containing the list of repositories to scan."
    required: true
  - name: final_report
    description: "Absolute path for the final markdown report."
    required: true

setup:
  - name: "Define workspace and intermediate file paths"
    tool: set_vars
    vars:
      workspace_path: "{{module_path}}/pr_analysis_workspace"
      recent_prs_file: "{{workspace_path}}/recently_merged_prs.txt"

  - name: "Create the workspace directory"
    tool: shell
    command: "mkdir -p {{ workspace_path }}"

main:
  - name: "Step 1: Load recently merged PRs from repositories"
    tool: run_apl
    program: "{{module_path}}/load_recently_merged_prs.apl"
    with_inputs:
      repos_to_scan_file: "{{ repos_list }}"
      workspace_path: "{{ workspace_path }}"
      recent_prs_output_file: "{{ recent_prs_file }}"

  - name: "Step 2: Evaluate the collected PRs and generate a report"
    tool: run_apl
    program: "{{module_path}}/evaluate_prs.apl"
    with_inputs:
      pr_list_file: "{{ recent_prs_file }}"
      workspace_path: "{{ workspace_path }}"
      report_output_file: "{{ final_report }}"

finalize:
  - name: "Execution Complete"
    tool: log
    message: "Workflow finished. The final report can be found at: {{ final_report }}"