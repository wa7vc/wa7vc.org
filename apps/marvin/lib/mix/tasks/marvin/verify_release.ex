defmodule Mix.Tasks.Marvin.VerifyRelease do
  use Mix.Task
  
  @shortdoc "Verifies that everything appears to be in a consistent state for a release"
  def run(_) do
    {status_str, status_return_code} = System.cmd("git", ["status", "--porcelain"])
    unless status_str == "" and status_return_code == 0 do
      IO.puts("ERROR: git status not clean, refusing to build with un-committed files")
      exit({:shutdown, 154})
    end

    {desc_str, desc_return_code} = System.cmd("git", ["describe", "--match", "marvin*"])
    unless desc_return_code == 0 do
      IO.puts("ERROR: Could not run \"git describe --match marvin*\"")
      exit({:shutdown, 1})
    end

    r = ~r/marvin@(?<tag_ver>\d+\.\d+\.\d+)(-(?<extra_commits>\d+)-g(?<abbrev_obj_name>\w+))?\n/
    git_desc = Regex.named_captures(r, desc_str)
    if git_desc == nil do
      IO.puts("ERROR: Match against result of \"git describe\" did not find a valid tag format")
      exit({:shutdown, 151})
    end

    unless git_desc["extra_commits"] == "" or git_desc["extra_commits"] == 0 do
      IO.puts("ERROR: Found #{git_desc["extra_commits"]} commits beyond most recent git tag")
      exit({:shutdown, 152})
    end

    unless git_desc["tag_ver"] == Mix.Project.config[:version] do
      IO.puts("ERROR: Tagged git version (#{git_desc["tag_ver"]}) does not match Mix project version (#{Mix.Project.config[:version]})")
      exit({:shutdown, 153})
    end

    # No failures means good exit!
    exit({:shutdown, 0})
  end
end
