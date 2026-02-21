function oops() {
  throw new Error("oops");
}
const body = document.getElementById("main-output") ?? oops();
const hoverInfoDiv = document.getElementById("hover-info") ?? oops();
const minimap = document.getElementById("minimap") ?? oops();
const orderedCells = [];
const cells = /* @__PURE__ */ new Map();
function processUpdates(msg) {
  dropCells(msg.orderedNodesUpdate.numDropped);
  msg.nodeMapUpdate.forEach(function(elt) {
    const [cellId, update] = elt;
    switch (update.tag) {
      case "Create":
      // deliberate fallthrough
      case "Replace":
        const cell = createCell(cellId);
        initializeCell(cell, update.contents);
        orderedCells.push(cell);
        break;
      case "Update":
        updateCellContents(lookupCell(cellId), update.contents);
    }
  });
  msg.orderedNodesUpdate.newTail.forEach(function(cellId) {
    const cell = lookupCell(cellId);
    body.appendChild(cell.root);
    if (cell.curStatus !== "Inert") {
      minimap.appendChild(cell.status);
    }
  });
  msg.nodeMapUpdate.forEach(function(elt) {
    const [cellId, update] = elt;
    switch (update.tag) {
      case "Create":
        const cell = lookupCell(cellId);
        const lexemes = update.contents[0].rsbLexemeList;
        attachStatusHovertip(cell);
        lexemes.map((lexemeId) => attachHovertip(cell, lexemeId));
        break;
      case "Update":
    }
  });
}
function dropCells(n) {
  for (let i = 0; i < n; i++) {
    const cell = orderedCells.pop() ?? oops();
    cell.root.remove();
    cell.status.remove();
  }
}
function lookupCell(cellId) {
  return cells.get(cellId) ?? oops();
}
function createCell(cellId) {
  const root = document.createElement("div");
  const cellHtmlId = "cell_".concat(cellId.toString());
  root.id = cellHtmlId;
  root.className = "cell";
  const lineNums = addChild(root, "line-nums");
  const contents = addChild(root, "contents");
  const source = addChild(contents, "source");
  const results = addChild(contents, "results");
  const status = document.createElement("a");
  status.setAttribute("href", "#".concat(cellHtmlId));
  status.className = "status";
  const cell = {
    cellId,
    root,
    lineNums,
    source,
    results,
    status,
    curStatus: null,
    sourceText: "",
    focusMap: /* @__PURE__ */ new Map(),
    treeMap: /* @__PURE__ */ new Map()
  };
  cells.set(cellId, cell);
  return cell;
}
function initializeCell(cell, state) {
  const [source, status, outs] = state;
  cell.source.innerHTML = source.rsbHtml;
  for (let i = 0; i < source.rsbNumLines; i++) {
    const lineNum = i + source.rsbLine;
    const s = lineNum.toString().concat("\n");
    appendText(cell.lineNums, s);
  }
  cell.sourceText = source.rsbText;
  setCellStatus(cell, status);
  extendCellOutput(cell, outs);
}
function updateCellContents(cell, update) {
  let [statusUpdate, outputs] = update;
  if (statusUpdate["tag"] == "OverwriteWith") {
    setCellStatus(cell, statusUpdate["contents"]);
  }
  extendCellOutput(cell, outputs);
}
function attachStatusHovertip(cell) {
  addHoverAction(cell.status, () => applyHoverStatus(cell));
  if (cell.curStatus !== "Inert") {
    addHoverAction(cell.lineNums, () => applyHoverStatus(cell));
  }
}
function applyHoverStatus(cell) {
  addHoverClass(cell.status, "status-hover");
  addHoverClass(cell.lineNums, "status-hover");
}
function attachHovertip(cell, srcId) {
  let span = selectSpan(cell, srcId);
  if (span !== null) {
    addHoverAction(span, () => applyCellHover(cell, srcId));
  }
}
function selectSpan(cell, srcId) {
  const spanId = "#span_".concat(cell.cellId.toString(), "_", srcId.toString());
  return cell.source.querySelector(spanId);
}
function cellStatusClass(status) {
  switch (status) {
    case "Waiting":
      return "status-waiting";
    case "Running":
      return "status-running";
    case "Complete":
      return "status-success";
    case "CompleteWithErrors":
      return "status-err";
    case "Inert":
      return "status-inert";
    default:
      return oops();
  }
}
function setDivStatus(div, status) {
  div.classList.remove("status-waiting", "status-running", "status-success");
  div.classList.add(cellStatusClass(status));
}
function setCellStatus(cell, status) {
  cell.curStatus = status;
  setDivStatus(cell.lineNums, status);
  setDivStatus(cell.status, status);
}
function addTextResult(cell, contents) {
  const child = addChild(cell.results, "text-result");
  appendText(child, contents);
}
function addErrResult(cell, contents) {
  const child = addChild(cell.results, "err-result");
  appendText(child, contents);
}
function addHTMLResult(cell, contents) {
  const child = addChild(cell.results, "html-result");
  child.innerHTML = contents;
}
function extendCellOutput(cell, outputs) {
  outputs.forEach((output) => {
    switch (output.tag) {
      case "RenderedTextOut":
        addTextResult(cell, output.contents);
        break;
      case "RenderedHtmlOut":
        addHTMLResult(cell, output.contents);
        break;
      case "RenderedPassResult":
        break;
      case "RenderedMiscLog":
        break;
      case "RenderedError":
        const [maybeSrcId, errMsg] = output.contents;
        if (maybeSrcId !== null) {
          const node = cell.treeMap.get(maybeSrcId) ?? oops();
          highlightTreeNode(false, node, "HighlightError");
        }
        addErrResult(cell, errMsg);
        break;
      case "RenderedTreeNodeUpdate":
        output.contents.forEach(function(elt) {
          const [srcId, update] = elt;
          applyTreeNodeUpdate(cell, srcId, update);
        });
        break;
      case "RenderedFocusUpdate":
        output.contents.forEach(function(elt) {
          const [lexemeId, srcId] = elt;
          cell.focusMap.set(lexemeId, srcId);
        });
        break;
      default:
    }
  });
}
function applyTreeNodeUpdate(cell, srcId, update) {
  switch (update.tag) {
    case "Create":
    // deliberate fallthrough
    case "Replace":
      const s = update.contents;
      const [l, r] = s.tnSpan;
      const range = computeRange(cell, l, r);
      const treeNode = {
        srcId,
        span: range,
        highlights: s.tnHighlights,
        text: s.tnText
      };
      cell.treeMap.set(srcId, treeNode);
      break;
    case "Update":
      const nodeUpdate = update.contents;
      const node = cell.treeMap.get(srcId) ?? oops();
      nodeUpdate.tnuText.forEach((t) => {
        node.text = node.text.concat(t, "\n");
      });
      node.highlights = node.highlights.concat(nodeUpdate.tnuHighlights);
  }
}
function computeRange(cell, l, r) {
  const lDiv = selectSpan(cell, l);
  const rDiv = selectSpan(cell, r);
  if (lDiv !== null && rDiv !== null) {
    return [lDiv, rDiv];
  } else {
    return null;
  }
}
function applyCellHover(cell, srcId) {
  const focus = cell.focusMap.get(srcId);
  if (focus !== void 0) {
    applyFocus(cell, focus);
  }
}
function applyFocus(cell, focus) {
  const focusNode = cell.treeMap.get(focus) ?? oops();
  focusNode.highlights.forEach((h) => {
    const [sid, ty] = h;
    const node = cell.treeMap.get(sid) ?? oops();
    highlightTreeNode(true, node, ty);
  });
  setHoverInfo(focusNode.text);
}
function setHoverInfo(s) {
  hoverInfoDiv.innerHTML = "";
  appendText(hoverInfoDiv, s);
}
function computeHighlightClass(h) {
  switch (h) {
    case "HighlightGroup":
      return "highlight-group";
    case "HighlightLeaf":
      return "highlight-leaf";
    case "HighlightError":
      return "highlight-error";
    case "HighlightScope":
      return "highlight-scope";
    case "HighlightBinder":
      return "highlight-binder";
    case "HighlightOcc":
      return "highlight-occ";
  }
}
function highlightTreeNode(isTemporary, node, highlightType) {
  const highlightClass = computeHighlightClass(highlightType);
  if (node.span !== null) {
    let [l, r] = node.span;
    let spans = spansBetween(l, r);
    spans.map(function(span) {
      if (isTemporary) {
        addHoverClass(span, highlightClass);
      } else {
        span.classList.add(highlightClass);
      }
    });
  }
}
function render(renderMode, jsonData) {
  switch (renderMode) {
    case "Static":
      const req = new XMLHttpRequest();
      req.open("GET", jsonData, true);
      req.responseType = "json";
      req.onload = function() {
        processUpdates(req.response);
      };
      req.send();
      break;
    case "Dynamic":
      const source = new EventSource("/getnext");
      source.onmessage = function(event) {
        const msg = JSON.parse(event.data);
        if (msg == "start") {
          resetState();
        } else {
          processUpdates(msg);
        }
      };
  }
}
function resetState() {
  body.innerHTML = "";
  hoverInfoDiv.innerHTML = "";
  minimap.innerHTML = "";
  orderedCells.length = 0;
  curHighlights.length = 0;
  cells.clear();
}
const curHighlights = [];
function addHoverClass(div, className) {
  div.classList.add(className);
  curHighlights.push([div, className]);
}
function addHoverAction(div, handler) {
  div.addEventListener("mouseover", (event) => {
    event.stopPropagation();
    handler();
  });
  div.addEventListener("mouseout", function(event) {
    event.stopPropagation();
    removeHover();
  });
}
function removeHover() {
  hoverInfoDiv.innerHTML = "";
  curHighlights.map(function(elementAndClass) {
    const [element, className] = elementAndClass;
    element.classList.remove(className);
  });
  curHighlights.length = 0;
}
function spansBetween(l, r) {
  let spans = [];
  let curL = l;
  while (curL !== null && !Object.is(curL, r)) {
    spans.push(curL);
    curL = curL.nextElementSibling;
  }
  spans.push(r);
  return spans;
}
function addChild(div, className) {
  const child = document.createElement("div");
  child.className = className;
  div.appendChild(child);
  return child;
}
function appendText(div, s) {
  div.appendChild(document.createTextNode(s));
}
