#!/bin/bash

echo "# Pindah ke Direktori Job Jenkins #"
cd /var/lib/jenkins/workspace/demo2/ || exit 1

echo "# Hapus direktori (jika ada) lalu di buat ulang direktori dist #"
rm -rf dist
mkdir -p dist

echo "# Minify file-file html #"
find ./ -type f -name "*.html" | while read -r file; do
  out=./dist/"$file"
  mkdir -p "$(dirname "$out")"
  html-minifier-terser --collapse-whitespace --remove-comments --minify-js true --minify-css true --output "$out" "$file"
done

echo "# Minify file-file css #"
find ./ -type f -name "*.css" | while read -r file; do
  out=./dist/"$file"
  mkdir -p "$(dirname "$out")"
  cleancss -o "$out" "$file"
done

echo "# Minify file-file js #"
find ./ -type f -name "*.js" | while read -r file; do
  out=./dist/"$file"
  mkdir -p "$(dirname "$out")"
  terser "$file" -c -m -o "$out"
done

echo "# Menyalin semua gambar ke dist/images #"
mkdir -p dist/images
cp -r images/* dist/images/

echo "# Mengoptimasi gambar PNG #"
find dist/images -type f -iname "*.png" -exec optipng -o1 {} \;

echo "# Mengoptimasi gambar JPG/JPEG #"
find dist/images -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) -exec jpegoptim --max=80 {} \;

echo "# Validasi file-file html #"
for file in dist/*.html; do
  echo "Validasi $file"
  OUTPUT=$(html-validator --file "$file" --validator http://localhost:8888 --verbose 2>&1)
  echo "$OUTPUT"

  if echo "$OUTPUT" | grep -q "Error:"; then
    echo "STATUS: $file masih ada ERROR. Deployment dibatalkan."
    exit 1
  elif echo "$OUTPUT" | grep -q "Warning:"; then
    echo "STATUS: $file ada WARNING. Perlu dicek lebih lanjut."
  else
    echo "STATUS: $file valid. Tidak ada error atau warning."
  fi
done

echo "# Stop dan Remove Container Lama #"
docker stop jenkinsapss 2>/dev/null || true
docker rm jenkinsapss 2>/dev/null || true

echo "# Build Docker Image #"
docker build -t jenkins-apps .

echo "# Jalankan Container di Port 3002 #"
docker run -d -p 3002:80 --name jenkinsapss jenkins-apps

echo "# Bersihkan Docker Image Lama #"
docker image prune -f

echo "DEPLOYMENT SELESAI DAN BERHASIL"
