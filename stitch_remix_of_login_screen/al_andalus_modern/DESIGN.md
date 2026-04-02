```markdown
# Design System Specification: The Scholarly Manuscript

## 1. Overview & Creative North Star
**Creative North Star: "The Modern Archivist"**

This design system is a bridge between the tactile, enduring legacy of Islamic historical scholarship and the breathability of modern editorial design. It moves away from the "standard app" aesthetic by treating the screen as a curated manuscript. 

The visual identity is defined by **Intentional Asymmetry** and **Tonal Depth**. Instead of rigid, boxed-in grids, we use expansive white space (Parchment), scholarly serif typography, and the concept of "The Floating Arch." The goal is to create a digital environment that feels peaceful yet motivating—a space for deep focus and intellectual growth.

---

## 2. Colors & Surface Philosophy

The palette is rooted in natural, organic tones that evoke aged parchment, deep ink, and illuminated gold.

### The Color Palette
*   **Background (`#fcf9f0`):** The "Parchment" base. All experiences begin here.
*   **Primary (`#00342b` / `#004d40`):** "Deep Teal." Represents the weight of ink and the depth of knowledge. Used for key brand moments and high-emphasis containers.
*   **Secondary (`#775a19`):** "Muted Gold." Reserved for highlights, scholarly accents, and calls to discovery.
*   **Surface Tiers:** Use `surface-container-low` (`#f6f3ea`) through `surface-container-highest` (`#e5e2da`) to create structural hierarchy.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to define sections. 
*   Boundaries must be created through **Background Shifts**. To separate a sidebar from a main feed, transition from `surface` to `surface-container-low`.
*   **Signature Textures:** For Hero sections, use a subtle radial gradient transitioning from `primary` (#00342b) to `primary-container` (#004d40) to add "soul" and depth that a flat color cannot achieve.

### Glass & Layering
To move beyond a flat UI, use **Glassmorphism** for floating navigation or modals. Use `surface-container-lowest` at 80% opacity with a `20px` backdrop blur. This allows the Mashrabiya patterns or background colors to bleed through, softening the interface.

---

## 3. Typography: Editorial Authority

The typography system pairs the intellectual rigor of Noto Serif with the functional clarity of Plus Jakarta Sans.

*   **Display & Headlines (Noto Serif):** These are your "Manuscript Titles." Use `display-lg` for hero moments. Encourage intentional asymmetry—try left-aligning a headline while the body text is slightly offset to the right to create an editorial feel.
*   **Body & Titles (Plus Jakarta Sans):** Modern, highly legible, and neutral. It provides the "Minimalism" to the Serif’s "Heritage."
*   **Hierarchy Tip:** Maintain a high contrast between headline and body sizes. A `headline-lg` (2rem) paired with a `body-md` (0.875rem) creates an authoritative, scholarly rhythm.

---

## 4. Elevation & Depth: Tonal Layering

Traditional shadows and borders are replaced by the **Layering Principle**.

*   **Tonal Stacking:** Instead of a shadow, place a `surface-container-lowest` card on top of a `surface-container-low` background. The subtle 2% shift in brightness creates a sophisticated, "natural" lift.
*   **Ambient Shadows:** If an element must float (e.g., a primary action button or a modal), use a shadow tinted with the `on-surface` color.
    *   *Spec:* Blur: 32px, Y-Offset: 8px, Opacity: 6% of `#1c1c17`.
*   **The Ghost Border:** If accessibility requires a stroke (e.g., in a high-contrast mode), use `outline-variant` at **15% opacity**. It should be felt, not seen.

---

## 5. Components & Signature Elements

### The "Arch" Container
The 16px to 24px roundness (`xl` token) is our signature. 
*   **Image Treatments:** Apply a top-only radius of `100px` to images to mimic the "Mihrab" or rounded arch, immediately grounding the modern UI in Islamic heritage.

### Buttons
*   **Primary:** `primary` background with `on-primary` text. Corners: `xl` (1.5rem). No shadow, unless on a dark background.
*   **Secondary:** `surface-container-highest` background. Subtle, tactile, and scholarly.
*   **Tertiary:** Text-only in `primary`, with a `secondary` (gold) underline on hover.

### Cards & Lists
*   **Forbidden:** Divider lines between list items. 
*   **Replacement:** Use the Spacing Scale (Token `6` or `2rem`) to create "Active Negative Space." Let the eye distinguish items through proximity and alignment.
*   **Cards:** Use `surface-container-low` with a corner radius of `xl`. 

### Inputs & Fields
*   **Style:** Minimalist. Only a bottom-border using `outline-variant`. When focused, the label (Plus Jakarta Sans) shifts to `secondary` (Gold).

### Mashrabiya Patterns
*   Use as a decorative background element at **3% opacity**. Never let the pattern compete with text. It should act as a "watermark" for the page.

---

## 6. Do’s and Don'ts

### Do
*   **Do** use extreme vertical whitespace to signal a change in topic (Spacing Scale `16` or `24`).
*   **Do** use `secondary` (Gold) sparingly—think of it as "Gold leaf" on a manuscript.
*   **Do** overlap elements. An image can slightly break the container of a text block to create a custom, high-end feel.

### Don't
*   **Don't** use pure black (#000000). Always use `on-surface` (#1c1c17) for a softer, scholarly tone.
*   **Don't** use 1px solid borders. They shatter the "Manuscript" illusion.
*   **Don't** use standard 4px or 8px corners. This system requires the softness of `xl` (1.5rem) to maintain its peaceful identity.
*   **Don't** center-align long passages of body text. Maintain a strong, left-aligned "spine" for the document.

---

## 7. Spacing & Rhythm
This system relies on a **loose, airy rhythm**. 
*   **Standard Padding:** Use `8` (2.75rem) for page margins.
*   **Section Gaps:** Use `16` (5.5rem) to allow the mind to reset between scholarly sections.
*   **The "Golden Thread":** All vertical spacing should be divisible by the `1.5` (0.5rem) token to maintain a subtle, mathematical harmony hidden within the minimalism.```