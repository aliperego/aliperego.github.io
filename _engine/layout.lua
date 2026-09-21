-- Page layout filter: builds the Stellar structure (header, navigation, cards,
-- footer) around the plain Markdown of each page. HTML output only.

local common = dofile(quarto.utils.resolve_path("common.lua"))

local function is_html()
  return quarto.doc.is_format("html")
end

-- Home header ----------------------------------------------------------------

-- Round icon links for the profiles given in _metadata.yml.
local function icon_links(meta)
  local items = pandoc.List()
  local function add(url, icon, label)
    if url then
      items:insert(pandoc.Plain({ pandoc.Link({ icon, common.hidden_label(label) }, url, "", { class = "icon" }) }))
    end
  end
  local email = common.get_string(meta, "person.email")
  add(email and "mailto:" .. email, common.icon("envelope"), "Email")
  add(common.get_string(meta, "person.linkedin"), common.icon("linkedin"), "LinkedIn")
  local orcid = common.get_string(meta, "person.orcid")
  add(orcid and "https://orcid.org/" .. orcid,
    pandoc.Span({ pandoc.Str("iD") }, { class = "orcid-id", ["aria-hidden"] = "true" }), "ORCID")
  local github = common.get_string(meta, "person.github")
  add(github and "https://github.com/" .. github, common.icon("github"), "GitHub")
  add(common.get_string(meta, "person.ads"), common.icon("journal-text"), "ADS")
  add(common.get_string(meta, "person.scholar"), common.icon("mortarboard"), "Google Scholar")
  if #items == 0 then
    return nil
  end
  return pandoc.Div({ pandoc.BulletList(items) }, { class = "icons" })
end

local function hero(meta)
  local blocks = pandoc.List()
  blocks:insert(pandoc.Header(1, common.get_inlines(meta, "person.name") or {}))
  local role = common.get_inlines(meta, "person.role")
  if role then
    blocks:insert(pandoc.Div({ pandoc.Plain(role) }, { class = "role" }))
  end
  local affiliation = common.get_inlines(meta, "person.affiliation")
  if affiliation then
    blocks:insert(pandoc.Div({ pandoc.Plain(affiliation) }, { class = "affiliation" }))
  end
  local tagline = common.get_inlines(meta, "hero.tagline")
  if tagline then
    blocks:insert(pandoc.Div({ pandoc.Plain(tagline) }, { class = "tagline" }))
  end
  -- The space between the text block and the buttons carries the background picture.
  blocks:insert(pandoc.Div({}, { class = "pattern-space" }))
  local cv = common.get_string(meta, "cv.pdf")
  local buttons = pandoc.List()
  if cv then
    buttons:insert(common.link("Download CV", cv, "button primary"))
    buttons:insert(pandoc.Space())
  end
  buttons:insert(common.link("Get in touch", "#get-in-touch", "button"))
  blocks:insert(pandoc.Para(buttons))
  local icons = icon_links(meta)
  if icons then
    blocks:insert(icons)
  end
  blocks:insert(pandoc.Plain({ pandoc.Link({ common.icon("chevron-down"), common.hidden_label("Scroll to the content") },
    "#main", "", { class = "scroll-cue" }) }))
  local caption = common.get_inlines(meta, "hero.pattern-caption")
  if caption then
    blocks:insert(pandoc.Div({ pandoc.Plain(caption) }, { class = "pattern-caption" }))
  end
  return pandoc.Div(blocks, { id = "header", class = "hero" })
end

-- Navigation and footer ------------------------------------------------------

local function menu_entries(meta)
  return common.to_list(common.get(meta, "site-menu"))
end

local function navigation(meta)
  local items = pandoc.List()
  local cv = common.get_string(meta, "cv.pdf")
  for _, entry in ipairs(menu_entries(meta)) do
    local text = common.to_inlines(entry.text) or {}
    local link = pandoc.utils.stringify(entry.link or "")
    local inlines = pandoc.List({ pandoc.Link(text, link) })
    if entry.download and cv then
      inlines:insert(pandoc.Link({ common.icon("file-earmark-pdf"), common.hidden_label("Download CV (PDF)") },
        cv, "", { class = "nav-pdf" }))
      inlines = pandoc.List({ pandoc.Span(inlines, { class = "nav-cv" }) })
    end
    items:insert(pandoc.Plain(inlines))
  end
  return pandoc.Div({ pandoc.BulletList(items) },
    pandoc.Attr("nav", {}, { role = "navigation", ["aria-label"] = "Site" }))
end

local function footer(meta)
  local columns = pandoc.List()

  -- Contact column
  local contact = pandoc.List({ pandoc.Header(2, { pandoc.Str("Contact") }, { id = "contact-title" }) })
  local definitions = {}
  local email = common.get_string(meta, "person.email")
  if email then
    definitions[#definitions + 1] = { { pandoc.Str("Email") },
      { { pandoc.Plain({ pandoc.Link({ pandoc.Str(email) }, "mailto:" .. email) }) } } }
  end
  local address = common.to_list(common.get(meta, "person.address"))
  if #address > 0 then
    local lines = pandoc.List()
    for i, line in ipairs(address) do
      if i > 1 then
        lines:insert(pandoc.LineBreak())
      end
      lines:extend(common.to_inlines(line))
    end
    definitions[#definitions + 1] = { { pandoc.Str("Address") }, { { pandoc.Plain(lines) } } }
  end
  if #definitions > 0 then
    contact:insert(pandoc.DefinitionList(definitions))
  end
  local icons = icon_links(meta)
  if icons then
    contact:insert(icons)
  end
  columns:insert(pandoc.Div(contact, { class = "footer-contact" }))

  -- Pages column: the home page and the menu entries that are pages
  local cv = common.get_string(meta, "cv.pdf")
  local pages = pandoc.List({ pandoc.Plain({ pandoc.Link({ pandoc.Str("Home") }, "index.qmd") }) })
  for _, entry in ipairs(menu_entries(meta)) do
    local link = pandoc.utils.stringify(entry.link or "")
    if not link:find("#", 1, true) then
      local inlines = pandoc.List({ pandoc.Link(common.to_inlines(entry.text) or {}, link) })
      if entry.download and cv then
        inlines:insert(pandoc.Space())
        inlines:insert(pandoc.Link({ pandoc.Str("PDF"), common.hidden_label(" (download the CV)") }, cv, "",
          { class = "pdf-link" }))
      end
      pages:insert(pandoc.Plain(inlines))
    end
  end
  columns:insert(pandoc.Div({
    pandoc.Header(2, { pandoc.Str("Pages") }, { id = "pages-title" }),
    pandoc.Div({ pandoc.BulletList(pages) }, { class = "alt" }),
  }, { class = "footer-pages" }))

  -- Attribution: Stellar is released under CC BY 3.0
  local name = common.get_inlines(meta, "person.name") or pandoc.Inlines({})
  local copyright = pandoc.List({ pandoc.Str("© " .. os.date("%Y") .. " ") })
  copyright:extend(name)
  copyright:extend({ pandoc.Str(". Design: "), pandoc.Link({ pandoc.Str("Stellar") }, "https://html5up.net/stellar"),
    pandoc.Str(" by "), pandoc.Link({ pandoc.Str("HTML5 UP") }, "https://html5up.net"), pandoc.Str(", CC BY 3.0.") })
  columns:insert(pandoc.Div({ pandoc.Plain(copyright) }, { class = "copyright" }))

  return pandoc.Div(columns, pandoc.Attr("contact", { "footer" }, { role = "contentinfo" }))
end

-- Search engines -------------------------------------------------------------

-- The site configuration of _quarto.yml, parsed like page metadata.
local function site_config()
  local text = common.read_file(common.project_path("_quarto.yml")) or ""
  return pandoc.read("---\n" .. text .. "\n---\n", "markdown").meta
end

-- Path of the current page on the site ("/" for the home page).
local function page_path()
  local rel = pandoc.path.make_relative(quarto.doc.input_file, quarto.project.directory)
  local out = rel:gsub("%.q?md$", ".html")
  if out == "index.html" then
    return "/"
  end
  return "/" .. out
end

-- Structured data describing the owner (schema.org Person), from _metadata.yml.
local function person_jsonld(meta, base, image)
  local function value(key)
    return common.get_string(meta, key)
  end
  local person = {
    ["@context"] = "https://schema.org",
    ["@type"] = "Person",
    name = value("person.name"),
    jobTitle = value("person.role"),
    url = base .. "/",
  }
  if image then
    person.image = base .. "/" .. image
  end
  local email = value("person.email")
  if email then
    person.email = "mailto:" .. email
  end
  local affiliation = common.get_inlines(meta, "person.affiliation")
  if affiliation then
    local organization = { ["@type"] = "Organization", name = pandoc.utils.stringify(affiliation) }
    affiliation:walk({ Link = function(link)
      organization.url = organization.url or link.target
    end })
    person.affiliation = organization
  end
  local profiles = pandoc.List()
  local orcid = value("person.orcid")
  if orcid then
    profiles:insert("https://orcid.org/" .. orcid)
  end
  local github = value("person.github")
  if github then
    profiles:insert("https://github.com/" .. github)
  end
  for _, key in ipairs({ "person.linkedin", "person.ads", "person.scholar" }) do
    if value(key) then
      profiles:insert(value(key))
    end
  end
  if #profiles > 0 then
    person.sameAs = profiles
  end
  return pandoc.json.encode(person)
end

-- Adds to the page head: canonical URL, og:url, author, the Search Console
-- verification tag, noindex when requested, and the Person data on the home page.
local function head_tags(meta)
  local config = site_config()
  local base = (common.get_string(config, "website.site-url") or ""):gsub("/+$", "")
  local lines = pandoc.List()
  if base ~= "" then
    local url = base .. page_path()
    lines:insert('<link rel="canonical" href="' .. url .. '">')
    lines:insert('<meta property="og:url" content="' .. url .. '">')
  end
  local name = common.get_string(meta, "person.name")
  if name then
    lines:insert('<meta name="author" content="' .. name .. '">')
  end
  local verification = common.get_string(meta, "seo.google-site-verification")
  if verification and verification ~= "" then
    lines:insert('<meta name="google-site-verification" content="' .. verification .. '">')
  end
  if meta.noindex == true then
    lines:insert('<meta name="robots" content="noindex">')
  end
  if meta.hero then
    -- Browser-tab title of the home page: "Name – Role" (Quarto would otherwise use the site title alone).
    local role = common.get_string(meta, "person.role")
    if name and role then
      meta.pagetitle = name .. " – " .. role
    end
    if base ~= "" then
      local image = common.get_string(config, "website.open-graph.image")
      lines:insert('<script type="application/ld+json">' .. person_jsonld(meta, base, image) .. "</script>")
    end
  end
  local includes = meta["header-includes"] or pandoc.List()
  includes:insert(pandoc.RawBlock("html", table.concat(lines, "\n")))
  meta["header-includes"] = includes
end

-- Cards ----------------------------------------------------------------------

-- Wraps the content of a spotlight card: text beside a round picture.
local function spotlight(header, blocks)
  local image = header.attributes.image or ""
  local alt = header.attributes.alt or ""
  local picture = pandoc.Image({ pandoc.Str(alt) }, image, "", { width = "600", height = "600" })
  return pandoc.Div({
    pandoc.Div(blocks, { class = "content" }),
    pandoc.Div({ pandoc.Plain({ picture }) }, { class = "image" }),
  }, { class = "spotlight" })
end

-- Splits the page into cards: one per "##" heading, plus an intro card for
-- anything before the first heading. Heading ids and classes move to the card.
local function cards(blocks)
  local groups = pandoc.List()
  local current = { header = nil, content = pandoc.List() }

  local function flush()
    if #current.content > 0 then
      groups:insert(current)
    end
  end

  local trailing = pandoc.List()
  for _, block in ipairs(blocks) do
    if block.t == "Header" and block.level == 2 then
      flush()
      current = { header = block, content = pandoc.List({ pandoc.Header(2, block.content) }) }
    elseif block.t == "Div" and block.classes:includes("hidden") and #block.content == 0 then
      trailing:insert(block) -- Quarto's own empty placeholder div stays outside the cards
    else
      current.content:insert(block)
    end
  end
  flush()

  local result = pandoc.List()
  for _, group in ipairs(groups) do
    local header = group.header
    if header == nil then
      result:insert(pandoc.Div(group.content, { class = "main intro" }))
    else
      local classes = pandoc.List({ "section", "main" })
      for _, class in ipairs(header.classes) do
        classes:insert(class == "spotlight" and "spotlight-card" or class)
      end
      local content = group.content
      if header.classes:includes("spotlight") then
        content = pandoc.List({ spotlight(header, content) })
      end
      result:insert(pandoc.Div(content, pandoc.Attr(header.identifier, classes)))
    end
  end
  return result, trailing
end

-- Filter entry points --------------------------------------------------------

-- HTML comments never reach the published pages.
local function drop_comment(el)
  if is_html() and (el.format == "html" or el.format == "html5") and el.text:match("^%s*<!%-%-.-%-%->%s*$") then
    return {}
  end
end

function RawBlock(el)
  return drop_comment(el)
end

function RawInline(el)
  return drop_comment(el)
end

-- A paragraph left empty by a removed comment is dropped.
function Para(el)
  if is_html() and #el.content == 0 then
    return {}
  end
end

-- "::: two-columns" is split into columns at each "###".
function Div(el)
  if not is_html() or not el.classes:includes("two-columns") then
    return nil
  end
  local columns = pandoc.List()
  local column = nil
  for _, block in ipairs(el.content) do
    if block.t == "Header" and block.level == 3 or column == nil then
      column = pandoc.Div({}, { class = "half" })
      columns:insert(column)
    end
    column.content:insert(block)
  end
  el.content = columns
  return el
end

function Pandoc(doc)
  if not is_html() then
    return nil
  end
  local meta = doc.meta
  head_tags(meta)
  local body = pandoc.List()
  if meta.hero then
    body:insert(hero(meta))
  end
  body:insert(navigation(meta))
  local main_classes = pandoc.List()
  if meta["compact-sections"] == true then
    main_classes:insert("compact")
  end
  local sections, trailing = cards(doc.blocks)
  body:insert(pandoc.Div(sections, pandoc.Attr("main", main_classes)))
  body:insert(footer(meta))
  body:extend(trailing)
  return pandoc.Pandoc(body, meta)
end
