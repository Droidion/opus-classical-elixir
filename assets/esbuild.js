#!/usr/bin/env node

import esbuild from "esbuild";
import esbuildSvelte from "esbuild-svelte";
import sveltePreprocess from "svelte-preprocess";
import { compress } from 'esbuild-plugin-compress';
import { sassPlugin } from 'esbuild-sass-plugin';

let mode = 'build'
process.argv.slice(2).forEach((arg) => {
    if (arg === '--watch') {
        mode = 'watch'
    } else if (arg === '--deploy') {
        mode = 'deploy'
    }
})

let opts = {
    entryPoints: ['js/main.ts'],
    mainFields: ["svelte", "browser", "module", "main"],
    bundle: true,
    logLevel: 'info',
    target: 'esnext',
    outdir: '../priv/static/assets',
    plugins: [
        esbuildSvelte({
            preprocess: sveltePreprocess(),
        }),
        //compress()
    ],
}
if (mode === 'watch') {
    opts = {
        sourcemap: 'inline',
        ...opts
    }
}
if (mode === 'deploy') {
    opts = {
        minify: true,
        ...opts
    }
}

console.log(opts)

const ctx = await esbuild.context(opts)
if (mode === 'watch') {
    await ctx.watch()
    process.stdin.pipe(process.stdout)
    process.stdin.on('end', () => { ctx.dispose() })
} else {
    await ctx.rebuild(opts)
    ctx.dispose()
}
    