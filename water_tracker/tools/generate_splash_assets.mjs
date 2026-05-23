/**
 * Растеризация SVG → PNG (Sharp/librsvg даёт корректные градиенты; PyMuPDF даёт чёрный силуэт).
 *
 * Запуск из каталога water_tracker:
 *   cd tools && npm install && node generate_splash_assets.mjs
 */
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import sharp from "sharp";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.join(__dirname, "..");

const BG = { r: 2, g: 136, b: 209, alpha: 1 }; // #0288D1

async function rasterSvg(relSvg, relOut, size) {
  const inPath = path.join(root, relSvg);
  const outPath = path.join(root, relOut);
  await sharp(inPath).resize(size, size).png().toFile(outPath);
  console.log("Wrote", outPath);
}

async function main() {
  await fs.promises.mkdir(path.join(root, "assets", "splash"), {
    recursive: true,
  });

  await rasterSvg("assets/icon/icon_source.svg", "assets/icon/icon.png", 1024);
  await rasterSvg(
    "assets/icon/icon_foreground.svg",
    "assets/icon/icon_foreground.png",
    1024,
  );

  const fgPath = path.join(root, "assets", "icon", "icon_foreground.png");
  const splashSize = 512;
  const inner = Math.round(splashSize * 0.72);
  const fgSmall = await sharp(fgPath).resize(inner, inner).png().toBuffer();
  const smMeta = await sharp(fgSmall).metadata();
  const sw = smMeta.width ?? inner;
  const sh = smMeta.height ?? inner;
  const left = Math.floor((splashSize - sw) / 2);
  const top = Math.floor((splashSize - sh) / 2);

  await sharp({
    create: {
      width: splashSize,
      height: splashSize,
      channels: 4,
      background: { r: 0, g: 0, b: 0, alpha: 0 },
    },
  })
    .composite([{ input: fgSmall, left, top }])
    .png()
    .toFile(path.join(root, "assets", "splash", "splash.png"));
  console.log("Wrote", path.join(root, "assets", "splash", "splash.png"));

  const a12 = 1152;
  const safe = 720;
  const fgA12 = await sharp(fgPath).resize(safe, safe).png().toBuffer();
  const m12 = await sharp(fgA12).metadata();
  const fw = m12.width ?? safe;
  const fh = m12.height ?? safe;
  const l2 = Math.floor((a12 - fw) / 2);
  const t2 = Math.floor((a12 - fh) / 2);

  await sharp({
    create: {
      width: a12,
      height: a12,
      channels: 4,
      background: BG,
    },
  })
    .composite([{ input: fgA12, left: l2, top: t2 }])
    .png()
    .toFile(path.join(root, "assets", "splash", "splash_android12.png"));
  console.log("Wrote", path.join(root, "assets", "splash", "splash_android12.png"));
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
