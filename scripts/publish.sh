# Set your variables here.
REPO="jmorganca/ollama"

# Check if VERSION is set
if [[ -z "${VERSION}" ]]; then
  echo "VERSION is not set. Please set the VERSION environment variable."
  exit 1
fi

OS=$(go env GOOS)
ARCH=$(go env GOARCH)

./script/build.sh

# Create a new tag if it doesn't exist.
if ! git rev-parse v$VERSION >/dev/null 2>&1; then
  git tag v$VERSION
fi

git push origin v$VERSION

mkdir -p dist
cp app/out/make/zip/${OS}/${ARCH}/Ollama-${OS}-${ARCH}-${VERSION}.zip dist/Ollama-${OS}-${ARCH}.zip
cp ./ollama  dist/ollama-${OS}-${ARCH}

# Create a new release.
gh release create -p v$VERSION -t v$VERSION

# Upload the zip file.
gh release upload v$VERSION ./dist/Ollama-${OS}-${ARCH}.zip --clobber

# Upload the binary.
gh release upload v$VERSION ./dist/ollama-${OS}-${ARCH} --clobber

