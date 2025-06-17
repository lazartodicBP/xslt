#!/usr/bin/env node
// watch-and-generate.js

const chokidar = require('chokidar');
const chalk     = require('chalk');
const { exec }  = require('child_process');
const path      = require('path');
const fs        = require('fs');

// ─── Command‐line args & paths ─────────────────────────────────────────────────

const [,, xmlArg, xslArg] = process.argv;
const xmlFile = xmlArg
    ? path.resolve(process.cwd(), xmlArg)
    : path.resolve(__dirname, 'data.xml');
const xslFile = xslArg
    ? path.resolve(process.cwd(), xslArg)
    : path.resolve(__dirname, 'schema.xsl');

const foFile  = path.resolve(__dirname, 'temp.fo');
const pdfFile = path.resolve(__dirname, 'invoice.pdf');
const xsltCmd = 'npx xslt3';   // must have xslt3 installed
const fopCmd  = 'fop';         // must be in your PATH

// ─── Logging helper ────────────────────────────────────────────────────────────

function log(msg, color = 'white') {
    const ts = new Date().toISOString();
    let colorFn;

    // try direct method (if available), then keyword, then no color
    if (typeof chalk[color] === 'function') {
        colorFn = chalk[color];
    } else {
        try {
            colorFn = chalk.keyword(color);
        } catch {
            colorFn = (s) => s;
        }
    }

    console.log(colorFn(`[${ts}] ${msg}`));
}

// ─── Core conversion ───────────────────────────────────────────────────────────

function generatePDF() {
    log(`Transforming XML → FO… (${path.basename(xmlFile)} → temp.fo)`, 'blue');
    exec(
        `${xsltCmd} -s:${xmlFile} -xsl:${xslFile} -o:${foFile}`,
        (err, _stdout, stderr) => {
            if (err) {
                log(`XSLT failed: ${stderr}`, 'red');
                return;
            }
            log('XSL-FO generated', 'cyan');
            log(`Using XML: ${xmlFile}`, 'yellow');
            log(`Using XSL: ${xslFile}`, 'yellow');

            exec(
                `${fopCmd} -fo ${foFile} -pdf ${pdfFile}`,
                (err2, _out2, stderr2) => {
                    if (err2) {
                        log(`PDF conversion failed: ${stderr2}`, 'red');
                        return;
                    }
                    log(`✅ PDF generated at ${pdfFile}`, 'green');

                    // cleanup
                    if (fs.existsSync(foFile)) {
                        fs.unlinkSync(foFile);
                    }
                }
            );
        }
    );
}

// ─── Watcher ─────────────────────────────────────────────────────────────────

const watcher = chokidar.watch([xmlFile, xslFile], { ignoreInitial: true });

watcher
    .on('change', (file) => {
        log(`File changed: ${file}`, 'magenta');
        generatePDF();
    })
    .on('error', (e) => log(`Watcher error: ${e}`, 'red'));

log(`👀 Watching:\n  XML: ${xmlFile}\n  XSL: ${xslFile}`, 'blue');
generatePDF();  // initial run
