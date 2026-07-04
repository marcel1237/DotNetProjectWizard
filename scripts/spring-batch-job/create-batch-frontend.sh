#!/usr/bin/env bash

set -euo pipefail

PROJECT="$HOME/java-projects/spring-batch-job"

STATIC="$PROJECT/src/main/resources/static"

mkdir -p "$STATIC"

cat > "$STATIC/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<title>Spring Batch Job</title>

<style>

body{

font-family:Arial;

background:#f4f4f4;

margin:40px;

}

.container{

background:white;

padding:30px;

border-radius:10px;

max-width:600px;

margin:auto;

box-shadow:0 0 10px rgba(0,0,0,.2);

}

button{

padding:15px;

font-size:16px;

cursor:pointer;

width:100%;

}

pre{

background:#222;

color:#0f0;

padding:20px;

overflow:auto;

margin-top:20px;

}

</style>

</head>

<body>

<div class="container">

<h1>Spring Batch Test</h1>

<p>

Execute um Job do Spring Batch.

</p>

<button onclick="runJob()">

Executar Job

</button>

<pre id="output">

Aguardando...

</pre>

</div>

<script>

async function runJob(){

const output=document.getElementById("output");

output.textContent="Executando...";

try{

const response=await fetch("/jobs/import",{

method:"POST"

});

const text=await response.text();

output.textContent=text;

}catch(e){

output.textContent=e;

}

}

</script>

</body>

</html>

EOF

echo

echo "Frontend criado."

echo

echo "$STATIC/index.html"