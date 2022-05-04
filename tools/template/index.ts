import { readFile, writeFile, mkdir, opendir } from "node:fs/promises"
import { resolve, join, sep, dirname, basename } from "node:path";
import { appendFileSync } from "node:fs";
import { walk } from "./walkdir.js";


// args
// - "projects" <name>
// - "tools" <name>
// packages/<name> ...
const STENCIL = "@blueprint@";
const PLACEH = /--place-\w+--/g;
let [_0, _1, ...args] = process.argv;
if (args.length === 1) {
    args = args[0].split(sep);
}

const dest = resolve(
    args.length === 1
        ? process.cwd()
        : process.env.PROJECT_CWD ?? process.cwd(),
    ...args);

const target = basename(dest);
const skel = join(dirname(dest), STENCIL);

(async () => {
    try {
        await opendir(skel)
        // Generate destination directory first
        await mkdir(dest);
    } catch (e) {
        return;
    }

    // Walk over files and place them
    for await (let dest of walk(skel)) {
        let file = (await readFile(dest)).toString();
        dest = dest.replace(STENCIL, target);
        file = file.replace(PLACEH, target);
        try {
            await writeFile(dest, file);
        } catch (e) {
            const { code } = <any>e;
            if (code === "ENOENT") {
                await mkdir(dirname(dest));
                await writeFile(dest, file);
            }
        }
    }
})();

// Lastly... register new package
const workspace = basename(dirname(dest));
const pDhall  = join(process.env.PROJECT_CWD ?? process.cwd(), "packages.dhall");
appendFileSync(pDhall, `  with ${target.split(".").pop()} = ./${workspace}/${target}/spago.dhall as Location\n`);
