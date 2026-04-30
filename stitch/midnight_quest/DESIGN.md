# Design System Strategy: The Celestial Quest

## 1. Overview & Creative North Star: "Magical Tactical"
The design system moves beyond the standard "flat" aesthetic of modern apps to create a high-end, tactile experience dubbed **"Magical Tactical."** This North Star balances the excitement of a treasure hunt with the premium polish of a modern digital product.

Instead of a rigid, clinical grid, we use **Intentional Layering** and **Asymmetric Depth**. The interface should feel like a cosmic map unfolding—where elements don't just sit on a screen, but float within a deep, star-filled atmosphere. We break the "template" look by overlapping rounded cards, using extreme typography scales for hierarchy, and employing "glow-state" transitions that make the UI feel alive and responsive.

---

## 2. Colors: Depth Over Division
Our palette is rooted in a midnight spectrum, using light not just for visibility, but as a directional tool for the young adventurer.

### The "No-Line" Rule
Explicitly prohibit 1px solid borders for sectioning. Boundaries must be defined solely through background color shifts. For example, a `surface-container-low` section sitting on a `background` provides all the separation needed. If a boundary feels missing, increase the contrast between surface tiers rather than reaching for a stroke.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers. We use a "Nested Depth" approach:
*   **Base:** `surface` (#000144) — The deep space floor.
*   **Sectioning:** `surface-container` (#04085e) — Defines major content areas.
*   **Interaction:** `surface-container-high` (#080e6a) — For elevated cards.
*   **Floating/Active:** `surface-bright` (#131a83) — For the highest level of prominence.

### Signature Textures & Glass
To provide visual "soul," use subtle gradients for main actions. For example, the `secondary` (#ff7442) transition to `secondary-container` (#ab3500) creates a 3D volume that flat colors lack. Use `surface-variant` with a `backdrop-blur` of 12px for floating overlays to create a "Frosted Cosmic Glass" effect.

---

## 3. Typography: The Adventurer’s Script
We use two distinct personalities: **Fredoka One** for the "Hero's Voice" and **Plus Jakarta Sans** (refined from Nunito for higher-end editorial legibility) for the "Guide's Voice."

*   **Display & Headline (Fredoka One):** Used for `display-lg` through `headline-sm`. These should be high-contrast and playful. In titles, use `tertiary` (#ffdd7a) to signify "Value/Gold" and `on-background` for standard headings.
*   **Body & Labels (Plus Jakarta Sans):** Used for all `body` and `label` roles. We maintain a heavy weight (800) to ensure readability against dark, textured backgrounds.
*   **Editorial Scaling:** Don't be afraid of the `display-lg` (3.5rem) for milestone moments (e.g., "Level Up!"). Large type creates a premium, confident feel that replaces the need for cluttered iconography.

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are banned. We achieve "lift" through light and atmosphere.

*   **The Layering Principle:** Place a `surface-container-lowest` card on a `surface-container-low` section. This subtle tonal shift mimics natural light falloff.
*   **Ambient Shadows:** For floating elements, use extra-diffused shadows (Blur: 32px, Y: 16px) at 8% opacity. The shadow color must be a dark navy (#000022), never pure black, to maintain the atmospheric "midnight" glow.
*   **The "Ghost Border" Fallback:** If a container needs extra definition against a complex background, use the `outline-variant` token at 15% opacity. This creates a "glint" on the edge rather than a hard boundary.
*   **Gold Radial Glows:** For empty states or rare items, use a radial gradient of `tertiary` (#ffdd7a) at 20% opacity behind the asset to create a magical "aura" effect.

---

## 5. Components

### Buttons (The 3D Interaction)
*   **Primary Action:** `primary` (#45f2b9) with a 6px bottom "press" depth using `on-primary-container`. 
*   **Quick Play:** Gradient of `secondary` (#ff7442) to `on-secondary-fixed-variant`.
*   **Interaction State:** On `pressed`, the button shifts 4px down visually, and the shadow shrinks, simulating a physical tactile click.

### Cards (The "Adventure Tile")
*   **Style:** `surface-container-highest` with a subtle linear gradient (Top-Left to Bottom-Right). 
*   **Rounding:** `md` (1.5rem / 24px) to maintain a friendly, approachable feel.
*   **Content separation:** Forbid dividers. Use `md` spacing (1.5rem) or a subtle background shift to `surface-container-low` for footer areas within a card.

### Input Fields
*   **Surface:** `surface-container-lowest` with a `Ghost Border` (15% opacity `outline`).
*   **Focus State:** The border glows with `primary` (#45f2b9) and a 4px outer soft glow.

### New Component: The Discovery Chip
*   **Purpose:** To show hunt tags (e.g., "Outdoors," "Magical").
*   **Style:** Semi-transparent `surface-variant` with a 1px `Ghost Border`. These should "float" over images with a backdrop blur.

---

## 6. Do’s and Don’ts

### Do:
*   **Overlap Elements:** Let images "peek" out of cards or cross the boundary between two surface tiers to create depth.
*   **Use Generous White Space:** Use the `xl` (3rem) spacing scale between major sections to let the "Star Particle" background breathe.
*   **Color-Code Progress:** Use `primary` for success and `error` (#ff716c) for "locked" or "restricted" paths.

### Don’t:
*   **No 1px Solids:** Never use a solid, high-contrast line to separate content.
*   **No Pure Greys:** Every "neutral" must be tinted with midnight navy to keep the palette rich and premium.
*   **Don't "Flatten" the Experience:** Avoid flat 2D icons. Use icons with slight tonal gradients or "glow" effects to match the 3D buttons.