-- Helpers shared by layout.lua and shortcodes.lua.
-- Loaded with dofile(quarto.utils.resolve_path("common.lua")).

local M = {}

-- Absolute path of a file given relative to the project root.
function M.project_path(rel)
  return pandoc.path.join({ quarto.project.directory, rel })
end

-- Content of a text file, or nil when it does not exist.
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil
  end
  local text = file:read("a")
  file:close()
  return text
end

-- Value of a dotted key ("person.email") in a metadata table, or nil.
function M.get(meta, key)
  local value = meta
  for part in key:gmatch("[^.]+") do
    if type(value) ~= "table" then
      return nil
    end
    value = value[part]
  end
  return value
end

-- A metadata value as a plain string, or nil.
function M.get_string(meta, key)
  local value = M.get(meta, key)
  if value == nil then
    return nil
  end
  return pandoc.utils.stringify(value)
end

-- Any metadata value as Inlines (Blocks are flattened), or nil.
function M.to_inlines(value)
  if value == nil then
    return nil
  end
  local kind = pandoc.utils.type(value)
  if kind == "Inlines" then
    return value
  elseif kind == "Blocks" then
    return pandoc.utils.blocks_to_inlines(value)
  end
  return pandoc.Inlines({ pandoc.Str(pandoc.utils.stringify(value)) })
end

-- A metadata value as Inlines, or nil.
function M.get_inlines(meta, key)
  return M.to_inlines(M.get(meta, key))
end

-- Any metadata value as Blocks (a scalar becomes one paragraph), or nil.
function M.to_blocks(value)
  if value == nil then
    return nil
  end
  if pandoc.utils.type(value) == "Blocks" then
    return value
  end
  return pandoc.Blocks({ pandoc.Para(M.to_inlines(value)) })
end

-- A metadata value as a List (a scalar becomes a one-item list; absent is empty).
function M.to_list(value)
  if value == nil then
    return pandoc.List()
  end
  if pandoc.utils.type(value) == "List" then
    return value
  end
  return pandoc.List({ value })
end

-- Items of a YAML file holding a top-level list, as a List of tables whose
-- values are parsed like page metadata (Markdown allowed). Nil when the file
-- does not exist.
function M.yaml_list(path)
  local text = M.read_file(path)
  if not text then
    return nil
  end
  local lines = {}
  for line in (text .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = "  " .. line
  end
  local source = "---\nitems:\n" .. table.concat(lines, "\n") .. "\n---\n"
  return M.to_list(pandoc.read(source, "markdown").meta.items)
end

-- A Bootstrap icon, hidden from screen readers (give the link its own label).
function M.icon(name)
  return pandoc.RawInline("html", '<i class="bi bi-' .. name .. '" aria-hidden="true"></i>')
end

-- Text that is read by screen readers but not displayed.
function M.hidden_label(text)
  return pandoc.Span({ pandoc.Str(text) }, { class = "visually-hidden" })
end

-- A link with the given classes ("button small", ...).
function M.link(content, target, classes)
  if type(content) == "string" then
    content = { pandoc.Str(content) }
  end
  return pandoc.Link(content, target, "", { class = classes or "" })
end

-- A row of small buttons from a list of {text, url} items; nil when empty.
function M.link_row(items)
  local inlines = pandoc.List()
  for _, item in ipairs(M.to_list(items)) do
    local url = item.url and pandoc.utils.stringify(item.url) or ""
    if url ~= "" then
      if #inlines > 0 then
        inlines:insert(pandoc.Space())
      end
      inlines:insert(M.link(M.to_inlines(item.text) or { pandoc.Str("link") }, url, "button small"))
    end
  end
  if #inlines == 0 then
    return nil
  end
  return pandoc.Plain(inlines)
end

return M
