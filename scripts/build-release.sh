echo "====== Building release for $MIX_ENV ======"

echo "== Pulling latest source =="
git pull

echo "== Updating versions of needed tools with ASDF =="
asdf install

echo "== Updating Elixir libs =="
mix local.hex --if-missing --force
mix local.rebar --if-missing --force
mix deps.get --only "$MIX_ENV"

echo "== Compiling App =="
mix compile

echo "== Updating node libraries and compiling web assets =="
(cd apps/wa7vc_web/assets && npm install && ./node_modules/brunch/bin/brunch build --production)

echo "== Digesting and Building Release =="
mix do phx.digest, release
