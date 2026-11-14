// 把微信缓存里的 config_cn 资源包复制到 work/cdn，避免缓存被清掉后配置表失效。
// 用法: node tools/sync-config.mjs
import fs from 'node:fs';
import path from 'node:path';
import { findConfigPack, loadTables, CONFIG_PACK_PATH } from '../src/config.mjs';

const source = process.argv[2] || findConfigPack();
if (!source) {
  console.error('没有找到配置表缓存，先启动一次游戏让它下载 config_cn');
  process.exit(1);
}

const tables = loadTables(source);
const names = Object.keys(tables);
if (names.length < 100) {
  console.error(`配置包看起来不完整，只解析出 ${names.length} 张表`);
  process.exit(1);
}

fs.mkdirSync(path.dirname(CONFIG_PACK_PATH), { recursive: true });
// 同步副本与缓存是同一个文件时不复制；findConfigPack 按 mtime 判新旧，
// 复制必须保留源时间戳，否则旧包会被刷成"最新"而盖住游戏刚下载的新缓存。
if (path.resolve(source) !== path.resolve(CONFIG_PACK_PATH)) {
  fs.copyFileSync(source, CONFIG_PACK_PATH);
  const from = fs.statSync(source);
  fs.utimesSync(CONFIG_PACK_PATH, from.atime, from.mtime);
}
const size = (fs.statSync(CONFIG_PACK_PATH).size / 1024 / 1024).toFixed(1);
console.log(`已同步 ${names.length} 张表 (${size} MB)`);
console.log(`  来源 ${source}`);
console.log(`  目标 ${CONFIG_PACK_PATH}`);
for (const key of ['ResourceCfg', 'OfflineCfg', 'OfflineLvRewardCfg']) {
  console.log(`  ${key}: ${tables[key]?.data?.length ?? 0} 行`);
}
