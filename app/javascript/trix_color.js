const GOLD_HEX = "#d2ac47";
const GOLD_RGB = "rgb(210,172,71)";
const NAVY_HEX = "#091327";
const NAVY_RGB = "rgb(9,19,39)";

const normalizeColor = (value) => (value || "").replace(/\s+/g, "").toLowerCase();

const colorMatches = (value, hex, rgb) => {
  const normalized = normalizeColor(value);
  return normalized === normalizeColor(hex) || normalized === normalizeColor(rgb);
};

document.addEventListener("trix-before-initialize", () => {
  const trix = window.Trix;
  if (!trix) return;

  trix.config.textAttributes.hiperionGold = {
    style: { color: GOLD_HEX },
    inheritable: true,
    parser: (element) => colorMatches(element.style.color, GOLD_HEX, GOLD_RGB)
  };

  trix.config.textAttributes.hiperionNavy = {
    style: { color: NAVY_HEX },
    inheritable: true,
    parser: (element) => colorMatches(element.style.color, NAVY_HEX, NAVY_RGB)
  };
});

document.addEventListener("trix-initialize", (event) => {
  const toolbar = event.target.toolbarElement;
  if (!toolbar || toolbar.dataset.colorToolsLoaded === "true") return;

  toolbar.dataset.colorToolsLoaded = "true";

  const colorGroupMarkup = `
    <span class="trix-button-group trix-button-group--color-tools" data-trix-button-group="text-tools" aria-label="Cores de texto">
      <button type="button" class="trix-button trix-button--color trix-button--color-gold" data-trix-attribute="hiperionGold" title="Cor dourada" tabindex="-1">A</button>
      <button type="button" class="trix-button trix-button--color trix-button--color-navy" data-trix-attribute="hiperionNavy" title="Cor azul" tabindex="-1">A</button>
    </span>
  `;

  const referenceGroup = toolbar.querySelector(".trix-button-group-spacer");
  if (referenceGroup) {
    referenceGroup.insertAdjacentHTML("beforebegin", colorGroupMarkup);
  } else {
    toolbar.querySelector(".trix-button-row")?.insertAdjacentHTML("beforeend", colorGroupMarkup);
  }
});
