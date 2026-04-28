#!/bin/bash

echo "🚀 Iniciando build automático..."

# Colores
GREEN='\033[0;32m'
NC='\033[0m'

KEYSTORE="android/app/release-key.keystore"

# 1. Verificar keystore
if [ ! -f "$KEYSTORE" ]; then
  echo "🔐 Generando keystore..."
  keytool -genkeypair \
    -v \
    -keystore $KEYSTORE \
    -alias release-key \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -storepass 123456 \
    -keypass 123456 \
    -dname "CN=Vannia, OU=Dev, O=Vannia StoryVideo, L=Mexico, S=Sonora, C=MX"
else
  echo "🔐 Keystore ya existe"
fi

# 2. Instalar dependencias
echo "📦 Instalando dependencias..."
npm install

# 3. Build web
echo "🛠️ Generando build..."
npm run build

# 4. Capacitor sync
echo "🔄 Sincronizando Capacitor..."
npx cap sync android

# 5. Build Android (AAB)
echo "📱 Generando AAB..."
cd android
./gradlew bundleRelease
cd ..

echo -e "${GREEN}✅ LISTO!${NC}"
echo "📦 Archivo generado en:"
echo "android/app/build/outputs/bundle/release/app-release.aab"
