-- Shortcodes: lists from data/, and bibliographies from the .bib files.
--   {{< list NAME >}}                      data/NAME.yml as dated entries
--   {{< proposals >}}                      data/proposals.yml
--   {{< tools >}}                          data/tools.yml as a grid of cards
--   {{< news >}}                           data/news.yml as cards
--   {{< bibliography FILE [limit=N] >}}    a .bib file, newest first

local common = dofile(quarto.utils.resolve_path("common.lua"))

-- Dated entries ---------------------------------------------------------------

local function entry(label, body)
  return pandoc.Div({
    pandoc.Div({ pandoc.Plain(label) }, { class = "entry-label" }),
    pandoc.Div(body, { class = "entry-body" }),
  }, { class = "entry" })
end

local function entries(items, render)
  local list = pandoc.List()
  for _, item in ipairs(items) do
    local block = render(item)
    if block then
      list:insert(block)
    end
  end
  if #list == 0 then
    return pandoc.Blocks({})
  end
  return pandoc.Blocks({ pandoc.Div(list, { class = "entries" }) })
end

local function detail_lines(value)
  local blocks = pandoc.List()
  if value == nil then
    return blocks
  end
  if pandoc.utils.type(value) == "Blocks" then
    blocks:insert(pandoc.Div(value, { class = "entry-detail" }))
    return blocks
  end
  for _, line in ipairs(common.to_list(value)) do
    blocks:insert(pandoc.Div({ pandoc.Plain(common.to_inlines(line)) }, { class = "entry-detail" }))
  end
  return blocks
end

local function dated_entry(item)
  local label = common.to_inlines(item.date) or common.to_inlines(item.label)
  local title = common.to_inlines(item.title)
  if not label and not title then
    return nil
  end
  local body = pandoc.List()
  if title then
    body:insert(pandoc.Div({ pandoc.Plain(title) }, { class = "entry-title" }))
  end
  body:extend(detail_lines(item.details))
  local links = common.link_row(item.links)
  if links then
    body:insert(pandoc.Div({ links }, { class = "entry-links" }))
  end
  return entry(label or {}, body)
end

local function list_shortcode(args)
  local name = args[1] and pandoc.utils.stringify(args[1]) or ""
  local items = common.yaml_list(common.project_path("data/" .. name .. ".yml"))
  if not items then
    quarto.log.warning("list shortcode: data/" .. name .. ".yml not found")
    return pandoc.Blocks({})
  end
  return entries(items, dated_entry)
end

-- Proposals -------------------------------------------------------------------

local function proposal(item)
  local title = common.to_inlines(item.title)
  local facility = common.to_inlines(item.facility)
  if not title or not facility then
    return nil
  end
  local label = pandoc.List(facility)
  local period = common.to_inlines(item.period)
  if period then
    label:insert(pandoc.LineBreak())
    label:extend(period)
  end
  local body = pandoc.List({ pandoc.Div({ pandoc.Plain(title) }, { class = "entry-title" }) })
  local details = pandoc.List()
  for _, field in ipairs({ "role", "instrument", "allocation", "status" }) do
    local value = common.to_inlines(item[field])
    if value then
      if #details > 0 then
        details:insert(pandoc.Str(" · "))
      end
      details:extend(value)
    end
  end
  if #details > 0 then
    body:insert(pandoc.Div({ pandoc.Plain(details) }, { class = "entry-detail" }))
  end
  local links = common.link_row(item.links)
  if links then
    body:insert(pandoc.Div({ links }, { class = "entry-links" }))
  end
  return entry(label, body)
end

local function proposals_shortcode()
  local items = common.yaml_list(common.project_path("data/proposals.yml"))
  if not items then
    return pandoc.Blocks({})
  end
  return entries(items, proposal)
end

-- Tools -----------------------------------------------------------------------

local function tool(item)
  local name = common.to_inlines(item.name)
  if not name then
    return nil
  end
  local blocks = pandoc.List()
  local icon = item.icon and pandoc.utils.stringify(item.icon) or "cpu"
  blocks:insert(pandoc.Plain({ pandoc.Span({ common.icon(icon) }, { class = "icon major" }) }))
  blocks:insert(pandoc.Header(3, name))
  local category = common.to_inlines(item.category)
  if category then
    blocks:insert(pandoc.Div({ pandoc.Plain(category) }, { class = "tool-category" }))
  end
  local description = common.to_blocks(item.description)
  if description then
    blocks:extend(description)
  end
  local links = common.link_row(item.links)
  if links then
    blocks:insert(pandoc.Div({ links }, { class = "tool-links" }))
  end
  return pandoc.Div(blocks, { class = "tool" })
end

local function tools_shortcode()
  local items = common.yaml_list(common.project_path("data/tools.yml"))
  if not items then
    return pandoc.Blocks({})
  end
  local cards = pandoc.List()
  for _, item in ipairs(items) do
    local card = tool(item)
    if card then
      cards:insert(card)
    end
  end
  if #cards == 0 then
    return pandoc.Blocks({})
  end
  return pandoc.Blocks({ pandoc.Div(cards, { class = "tools" }) })
end

-- News ------------------------------------------------------------------------

local function news_item(item)
  local title = common.to_inlines(item.title)
  if not title then
    return nil
  end
  local blocks = pandoc.List()
  local icon = item.icon and pandoc.utils.stringify(item.icon)
  if icon then
    blocks:insert(pandoc.Plain({ pandoc.Span({ common.icon(icon) }, { class = "icon major" }) }))
  end
  local date = common.to_inlines(item.date)
  if date then
    blocks:insert(pandoc.Div({ pandoc.Plain(date) }, { class = "news-date" }))
  end
  blocks:insert(pandoc.Header(3, title))
  local text = common.to_blocks(item.text)
  if text then
    blocks:extend(text)
  end
  local url = item.link and pandoc.utils.stringify(item.link)
  if url and url ~= "" then
    blocks:insert(pandoc.Div({ pandoc.Plain({ common.link("Read more", url, "button small") }) }, { class = "news-links" }))
  end
  return pandoc.Div(blocks, { class = "news-item" })
end

local function news_shortcode()
  local items = common.yaml_list(common.project_path("data/news.yml"))
  if not items then
    return pandoc.Blocks({})
  end
  local cards = pandoc.List()
  for _, item in ipairs(items) do
    local card = news_item(item)
    if card then
      cards:insert(card)
    end
  end
  if #cards == 0 then
    return pandoc.Blocks({})
  end
  return pandoc.Blocks({ pandoc.Div(cards, { class = "news" }) })
end

-- Bibliographies --------------------------------------------------------------

-- Journal macros used by NASA ADS exports (AASTeX), expanded before parsing:
-- pandoc drops unknown macros, and the journal name with them.
local journals = {
  aj = "The Astronomical Journal",
  actaa = "Acta Astronomica",
  araa = "Annual Review of Astronomy and Astrophysics",
  apj = "The Astrophysical Journal",
  apjl = "The Astrophysical Journal Letters",
  apjlett = "The Astrophysical Journal Letters",
  apjs = "The Astrophysical Journal Supplement Series",
  apjsupp = "The Astrophysical Journal Supplement Series",
  ao = "Applied Optics",
  applopt = "Applied Optics",
  apss = "Astrophysics and Space Science",
  aap = "Astronomy \\& Astrophysics",
  astap = "Astronomy \\& Astrophysics",
  aapr = "Astronomy \\& Astrophysics Review",
  aaps = "Astronomy \\& Astrophysics Supplement Series",
  azh = "Astronomicheskii Zhurnal",
  baas = "Bulletin of the American Astronomical Society",
  bac = "Bulletin of the Astronomical Institutes of Czechoslovakia",
  bain = "Bulletin of the Astronomical Institutes of the Netherlands",
  caa = "Chinese Astronomy and Astrophysics",
  cjaa = "Chinese Journal of Astronomy and Astrophysics",
  fcp = "Fundamentals of Cosmic Physics",
  frass = "Frontiers in Astronomy and Space Sciences",
  gca = "Geochimica et Cosmochimica Acta",
  grl = "Geophysical Research Letters",
  iaucirc = "IAU Circular",
  icarus = "Icarus",
  jcap = "Journal of Cosmology and Astroparticle Physics",
  jcp = "Journal of Chemical Physics",
  jgr = "Journal of Geophysical Research",
  jqsrt = "Journal of Quantitative Spectroscopy and Radiative Transfer",
  jrasc = "Journal of the Royal Astronomical Society of Canada",
  maps = "Meteoritics and Planetary Science",
  memras = "Memoirs of the Royal Astronomical Society",
  memsai = "Memorie della Società Astronomica Italiana",
  mnras = "Monthly Notices of the Royal Astronomical Society",
  na = "New Astronomy",
  nar = "New Astronomy Reviews",
  nat = "Nature",
  nphysa = "Nuclear Physics A",
  pasa = "Publications of the Astronomical Society of Australia",
  pasj = "Publications of the Astronomical Society of Japan",
  pasp = "Publications of the Astronomical Society of the Pacific",
  physrep = "Physics Reports",
  physscr = "Physica Scripta",
  planss = "Planetary and Space Science",
  pra = "Physical Review A",
  prb = "Physical Review B",
  prc = "Physical Review C",
  prd = "Physical Review D",
  pre = "Physical Review E",
  prl = "Physical Review Letters",
  procspie = "Proceedings of the SPIE",
  psj = "The Planetary Science Journal",
  qjras = "Quarterly Journal of the Royal Astronomical Society",
  rmxaa = "Revista Mexicana de Astronomía y Astrofísica",
  skytel = "Sky \\& Telescope",
  solphys = "Solar Physics",
  sovast = "Soviet Astronomy",
  ssr = "Space Science Reviews",
  zap = "Zeitschrift für Astrophysik",
}

local function expand_journals(text, file)
  return (text:gsub("(journal%s*=%s*[{\"]%s*)\\(%a+)(%s*[}\"])", function(before, macro, after)
    local name = journals[macro]
    if not name then
      quarto.log.warning("bibliography: unknown journal macro \\" .. macro .. " in " .. file)
      return nil
    end
    return before .. name .. after
  end))
end

-- Links of a reference, in the order arXiv/URL, DOI, links from the note field.
-- (pandoc derives url from an arXiv eprint field when the entry has no url.)
local function reference_links(ref)
  local links = pandoc.List()
  local url = ref.url and pandoc.utils.stringify(ref.url)
  if url and url ~= "" then
    links:insert(common.link(url:find("arxiv.org", 1, true) and "arXiv" or "link", url, "button small"))
  end
  local doi = ref.doi and pandoc.utils.stringify(ref.doi)
  if doi and doi ~= "" then
    links:insert(common.link("DOI", "https://doi.org/" .. doi, "button small"))
  end
  if ref.note and pandoc.utils.type(ref.note) == "Inlines" then
    ref.note:walk({
      Link = function(link)
        links:insert(common.link(link.content, link.target, "button small"))
      end,
    })
  end
  if #links == 0 then
    return nil
  end
  local inlines = pandoc.List()
  for i, link in ipairs(links) do
    if i > 1 then
      inlines:insert(pandoc.Space())
    end
    inlines:insert(link)
  end
  return pandoc.Div({ pandoc.Plain(inlines) }, { class = "pub-links" })
end

local function bibliography_shortcode(args, kwargs)
  local file = args[1] and pandoc.utils.stringify(args[1]) or ""
  local limit = tonumber(pandoc.utils.stringify(kwargs.limit or ""))
  local text = common.read_file(common.project_path(file))
  if not text then
    quarto.log.warning("bibliography shortcode: " .. file .. " not found")
    return pandoc.Blocks({})
  end
  local references = pandoc.read(expand_journals(text, file), "bibtex").meta.references
  if not references or #references == 0 then
    return pandoc.Blocks({})
  end
  local by_id = {}
  for _, ref in ipairs(references) do
    by_id[pandoc.utils.stringify(ref.id)] = ref
  end

  -- The links are added below as labelled buttons, so titles are not linked.
  local csl = common.project_path("_engine/reverse-chronological.csl")
  local doc = pandoc.read("---\ncsl: \"" .. csl .. "\"\nnocite: \"@*\"\nlink-bibliography: false\n---\n\n::: {#refs}\n:::\n",
    "markdown")
  doc.meta.references = references
  doc = pandoc.utils.citeproc(doc)

  local items = pandoc.List()
  doc.blocks:walk({
    Div = function(div)
      if div.classes:includes("csl-entry") and (not limit or #items < limit) then
        local ref = by_id[div.identifier:gsub("^ref%-", "")]
        local links = ref and reference_links(ref)
        if links then
          div.content:insert(links)
        end
        div.identifier = ""
        items:insert(div)
      end
    end,
  })
  if #items == 0 then
    return pandoc.Blocks({})
  end
  return pandoc.Blocks({ pandoc.Div(items, { class = "bibliography" }) })
end

return {
  ["list"] = list_shortcode,
  ["proposals"] = proposals_shortcode,
  ["tools"] = tools_shortcode,
  ["news"] = news_shortcode,
  ["bibliography"] = bibliography_shortcode,
}
