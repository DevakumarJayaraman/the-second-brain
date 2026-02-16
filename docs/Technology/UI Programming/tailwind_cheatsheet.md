---
title: Tailwind CSS Cheatsheet
sidebar_position: 2
displayed_sidebar: technologySidebar
tags:
  - tailwind
  - css
  - frontend
  - styling
---

# Tailwind CSS Cheatsheet

A comprehensive quick reference for Tailwind CSS utility classes.

---

## 🚀 Setup

```bash
# Install Tailwind CSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# In tailwind.config.js, add your content paths
content: ["./src/**/*.{js,ts,jsx,tsx,html}"]

# Add to your main CSS file
@tailwind base;
@tailwind components;
@tailwind utilities;
```

---

## 📐 Layout

### Display

| Class | CSS |
|-------|-----|
| `block` | `display: block` |
| `inline-block` | `display: inline-block` |
| `inline` | `display: inline` |
| `flex` | `display: flex` |
| `inline-flex` | `display: inline-flex` |
| `grid` | `display: grid` |
| `inline-grid` | `display: inline-grid` |
| `hidden` | `display: none` |

### Position

| Class | CSS |
|-------|-----|
| `static` | `position: static` |
| `fixed` | `position: fixed` |
| `absolute` | `position: absolute` |
| `relative` | `position: relative` |
| `sticky` | `position: sticky` |

### Top / Right / Bottom / Left

| Class | CSS |
|-------|-----|
| `top-0` | `top: 0` |
| `right-0` | `right: 0` |
| `bottom-0` | `bottom: 0` |
| `left-0` | `left: 0` |
| `inset-0` | `top: 0; right: 0; bottom: 0; left: 0` |
| `inset-x-0` | `left: 0; right: 0` |
| `inset-y-0` | `top: 0; bottom: 0` |
| `top-1/2` | `top: 50%` |
| `left-full` | `left: 100%` |

### Z-Index

| Class | CSS |
|-------|-----|
| `z-0` | `z-index: 0` |
| `z-10` | `z-index: 10` |
| `z-20` | `z-index: 20` |
| `z-30` | `z-index: 30` |
| `z-40` | `z-index: 40` |
| `z-50` | `z-index: 50` |
| `z-auto` | `z-index: auto` |

---

## 📦 Flexbox

### Flex Direction

| Class | CSS |
|-------|-----|
| `flex-row` | `flex-direction: row` |
| `flex-row-reverse` | `flex-direction: row-reverse` |
| `flex-col` | `flex-direction: column` |
| `flex-col-reverse` | `flex-direction: column-reverse` |

### Flex Wrap

| Class | CSS |
|-------|-----|
| `flex-wrap` | `flex-wrap: wrap` |
| `flex-wrap-reverse` | `flex-wrap: wrap-reverse` |
| `flex-nowrap` | `flex-wrap: nowrap` |

### Justify Content

| Class | CSS |
|-------|-----|
| `justify-start` | `justify-content: flex-start` |
| `justify-end` | `justify-content: flex-end` |
| `justify-center` | `justify-content: center` |
| `justify-between` | `justify-content: space-between` |
| `justify-around` | `justify-content: space-around` |
| `justify-evenly` | `justify-content: space-evenly` |

### Align Items

| Class | CSS |
|-------|-----|
| `items-start` | `align-items: flex-start` |
| `items-end` | `align-items: flex-end` |
| `items-center` | `align-items: center` |
| `items-baseline` | `align-items: baseline` |
| `items-stretch` | `align-items: stretch` |

### Align Self

| Class | CSS |
|-------|-----|
| `self-auto` | `align-self: auto` |
| `self-start` | `align-self: flex-start` |
| `self-end` | `align-self: flex-end` |
| `self-center` | `align-self: center` |
| `self-stretch` | `align-self: stretch` |

### Flex Grow / Shrink

| Class | CSS |
|-------|-----|
| `flex-1` | `flex: 1 1 0%` |
| `flex-auto` | `flex: 1 1 auto` |
| `flex-initial` | `flex: 0 1 auto` |
| `flex-none` | `flex: none` |
| `grow` | `flex-grow: 1` |
| `grow-0` | `flex-grow: 0` |
| `shrink` | `flex-shrink: 1` |
| `shrink-0` | `flex-shrink: 0` |

### Gap

| Class | CSS |
|-------|-----|
| `gap-0` | `gap: 0` |
| `gap-1` | `gap: 0.25rem` |
| `gap-2` | `gap: 0.5rem` |
| `gap-4` | `gap: 1rem` |
| `gap-8` | `gap: 2rem` |
| `gap-x-4` | `column-gap: 1rem` |
| `gap-y-4` | `row-gap: 1rem` |

---

## 🔲 Grid

### Grid Template Columns

| Class | CSS |
|-------|-----|
| `grid-cols-1` | `grid-template-columns: repeat(1, minmax(0, 1fr))` |
| `grid-cols-2` | `grid-template-columns: repeat(2, minmax(0, 1fr))` |
| `grid-cols-3` | `grid-template-columns: repeat(3, minmax(0, 1fr))` |
| `grid-cols-4` | `grid-template-columns: repeat(4, minmax(0, 1fr))` |
| `grid-cols-6` | `grid-template-columns: repeat(6, minmax(0, 1fr))` |
| `grid-cols-12` | `grid-template-columns: repeat(12, minmax(0, 1fr))` |
| `grid-cols-none` | `grid-template-columns: none` |

### Grid Template Rows

| Class | CSS |
|-------|-----|
| `grid-rows-1` | `grid-template-rows: repeat(1, minmax(0, 1fr))` |
| `grid-rows-2` | `grid-template-rows: repeat(2, minmax(0, 1fr))` |
| `grid-rows-3` | `grid-template-rows: repeat(3, minmax(0, 1fr))` |
| `grid-rows-6` | `grid-template-rows: repeat(6, minmax(0, 1fr))` |

### Grid Column Span

| Class | CSS |
|-------|-----|
| `col-auto` | `grid-column: auto` |
| `col-span-1` | `grid-column: span 1 / span 1` |
| `col-span-2` | `grid-column: span 2 / span 2` |
| `col-span-3` | `grid-column: span 3 / span 3` |
| `col-span-full` | `grid-column: 1 / -1` |
| `col-start-1` | `grid-column-start: 1` |
| `col-end-3` | `grid-column-end: 3` |

---

## 📏 Spacing

### Padding

| Class | CSS | Value |
|-------|-----|-------|
| `p-0` | `padding: 0` | 0px |
| `p-1` | `padding: 0.25rem` | 4px |
| `p-2` | `padding: 0.5rem` | 8px |
| `p-3` | `padding: 0.75rem` | 12px |
| `p-4` | `padding: 1rem` | 16px |
| `p-5` | `padding: 1.25rem` | 20px |
| `p-6` | `padding: 1.5rem` | 24px |
| `p-8` | `padding: 2rem` | 32px |
| `p-10` | `padding: 2.5rem` | 40px |
| `p-12` | `padding: 3rem` | 48px |
| `p-16` | `padding: 4rem` | 64px |

**Directional Padding:**
- `px-*` → horizontal (left + right)
- `py-*` → vertical (top + bottom)
- `pt-*` → top
- `pr-*` → right
- `pb-*` → bottom
- `pl-*` → left

### Margin

| Class | CSS | Value |
|-------|-----|-------|
| `m-0` | `margin: 0` | 0px |
| `m-1` | `margin: 0.25rem` | 4px |
| `m-2` | `margin: 0.5rem` | 8px |
| `m-4` | `margin: 1rem` | 16px |
| `m-8` | `margin: 2rem` | 32px |
| `m-auto` | `margin: auto` | auto |
| `-m-1` | `margin: -0.25rem` | -4px |

**Directional Margin:**
- `mx-*` → horizontal
- `my-*` → vertical
- `mt-*`, `mr-*`, `mb-*`, `ml-*` → individual sides

### Space Between (Children)

| Class | CSS |
|-------|-----|
| `space-x-4` | Horizontal space between children |
| `space-y-4` | Vertical space between children |
| `space-x-reverse` | Reverse horizontal spacing |
| `space-y-reverse` | Reverse vertical spacing |

---

## 📐 Sizing

### Width

| Class | CSS |
|-------|-----|
| `w-0` | `width: 0` |
| `w-1` | `width: 0.25rem` |
| `w-4` | `width: 1rem` |
| `w-8` | `width: 2rem` |
| `w-16` | `width: 4rem` |
| `w-32` | `width: 8rem` |
| `w-64` | `width: 16rem` |
| `w-auto` | `width: auto` |
| `w-1/2` | `width: 50%` |
| `w-1/3` | `width: 33.333%` |
| `w-2/3` | `width: 66.667%` |
| `w-1/4` | `width: 25%` |
| `w-3/4` | `width: 75%` |
| `w-full` | `width: 100%` |
| `w-screen` | `width: 100vw` |
| `w-fit` | `width: fit-content` |
| `w-min` | `width: min-content` |
| `w-max` | `width: max-content` |

### Height

| Class | CSS |
|-------|-----|
| `h-0` | `height: 0` |
| `h-4` | `height: 1rem` |
| `h-8` | `height: 2rem` |
| `h-16` | `height: 4rem` |
| `h-32` | `height: 8rem` |
| `h-64` | `height: 16rem` |
| `h-auto` | `height: auto` |
| `h-1/2` | `height: 50%` |
| `h-full` | `height: 100%` |
| `h-screen` | `height: 100vh` |
| `h-fit` | `height: fit-content` |

### Min / Max Width & Height

| Class | CSS |
|-------|-----|
| `min-w-0` | `min-width: 0` |
| `min-w-full` | `min-width: 100%` |
| `max-w-sm` | `max-width: 24rem` |
| `max-w-md` | `max-width: 28rem` |
| `max-w-lg` | `max-width: 32rem` |
| `max-w-xl` | `max-width: 36rem` |
| `max-w-2xl` | `max-width: 42rem` |
| `max-w-4xl` | `max-width: 56rem` |
| `max-w-6xl` | `max-width: 72rem` |
| `max-w-full` | `max-width: 100%` |
| `max-w-screen-sm` | `max-width: 640px` |
| `max-w-screen-md` | `max-width: 768px` |
| `max-w-screen-lg` | `max-width: 1024px` |
| `max-w-screen-xl` | `max-width: 1280px` |
| `min-h-0` | `min-height: 0` |
| `min-h-full` | `min-height: 100%` |
| `min-h-screen` | `min-height: 100vh` |
| `max-h-full` | `max-height: 100%` |
| `max-h-screen` | `max-height: 100vh` |

---

## 🎨 Typography

### Font Size

| Class | CSS | Size |
|-------|-----|------|
| `text-xs` | `font-size: 0.75rem` | 12px |
| `text-sm` | `font-size: 0.875rem` | 14px |
| `text-base` | `font-size: 1rem` | 16px |
| `text-lg` | `font-size: 1.125rem` | 18px |
| `text-xl` | `font-size: 1.25rem` | 20px |
| `text-2xl` | `font-size: 1.5rem` | 24px |
| `text-3xl` | `font-size: 1.875rem` | 30px |
| `text-4xl` | `font-size: 2.25rem` | 36px |
| `text-5xl` | `font-size: 3rem` | 48px |
| `text-6xl` | `font-size: 3.75rem` | 60px |
| `text-7xl` | `font-size: 4.5rem` | 72px |
| `text-8xl` | `font-size: 6rem` | 96px |
| `text-9xl` | `font-size: 8rem` | 128px |

### Font Weight

| Class | CSS |
|-------|-----|
| `font-thin` | `font-weight: 100` |
| `font-extralight` | `font-weight: 200` |
| `font-light` | `font-weight: 300` |
| `font-normal` | `font-weight: 400` |
| `font-medium` | `font-weight: 500` |
| `font-semibold` | `font-weight: 600` |
| `font-bold` | `font-weight: 700` |
| `font-extrabold` | `font-weight: 800` |
| `font-black` | `font-weight: 900` |

### Font Family

| Class | CSS |
|-------|-----|
| `font-sans` | `font-family: ui-sans-serif, system-ui, sans-serif` |
| `font-serif` | `font-family: ui-serif, Georgia, serif` |
| `font-mono` | `font-family: ui-monospace, monospace` |

### Text Alignment

| Class | CSS |
|-------|-----|
| `text-left` | `text-align: left` |
| `text-center` | `text-align: center` |
| `text-right` | `text-align: right` |
| `text-justify` | `text-align: justify` |

### Text Decoration

| Class | CSS |
|-------|-----|
| `underline` | `text-decoration: underline` |
| `overline` | `text-decoration: overline` |
| `line-through` | `text-decoration: line-through` |
| `no-underline` | `text-decoration: none` |

### Text Transform

| Class | CSS |
|-------|-----|
| `uppercase` | `text-transform: uppercase` |
| `lowercase` | `text-transform: lowercase` |
| `capitalize` | `text-transform: capitalize` |
| `normal-case` | `text-transform: none` |

### Line Height

| Class | CSS |
|-------|-----|
| `leading-none` | `line-height: 1` |
| `leading-tight` | `line-height: 1.25` |
| `leading-snug` | `line-height: 1.375` |
| `leading-normal` | `line-height: 1.5` |
| `leading-relaxed` | `line-height: 1.625` |
| `leading-loose` | `line-height: 2` |

### Letter Spacing

| Class | CSS |
|-------|-----|
| `tracking-tighter` | `letter-spacing: -0.05em` |
| `tracking-tight` | `letter-spacing: -0.025em` |
| `tracking-normal` | `letter-spacing: 0` |
| `tracking-wide` | `letter-spacing: 0.025em` |
| `tracking-wider` | `letter-spacing: 0.05em` |
| `tracking-widest` | `letter-spacing: 0.1em` |

### Text Overflow

| Class | CSS |
|-------|-----|
| `truncate` | `overflow: hidden; text-overflow: ellipsis; white-space: nowrap` |
| `text-ellipsis` | `text-overflow: ellipsis` |
| `text-clip` | `text-overflow: clip` |

### Whitespace

| Class | CSS |
|-------|-----|
| `whitespace-normal` | `white-space: normal` |
| `whitespace-nowrap` | `white-space: nowrap` |
| `whitespace-pre` | `white-space: pre` |
| `whitespace-pre-line` | `white-space: pre-line` |
| `whitespace-pre-wrap` | `white-space: pre-wrap` |

---

## 🎨 Colors

### Text Color

```
text-{color}-{shade}
```

| Class | Example |
|-------|---------|
| `text-black` | Black text |
| `text-white` | White text |
| `text-gray-500` | Medium gray |
| `text-red-500` | Medium red |
| `text-blue-500` | Medium blue |
| `text-green-500` | Medium green |
| `text-yellow-500` | Medium yellow |
| `text-purple-500` | Medium purple |
| `text-pink-500` | Medium pink |
| `text-indigo-500` | Medium indigo |

**Shades:** `50, 100, 200, 300, 400, 500, 600, 700, 800, 900, 950`

### Background Color

```
bg-{color}-{shade}
```

| Class | Example |
|-------|---------|
| `bg-transparent` | Transparent background |
| `bg-black` | Black background |
| `bg-white` | White background |
| `bg-gray-100` | Light gray |
| `bg-blue-500` | Medium blue |
| `bg-gradient-to-r` | Gradient to right |

### Border Color

```
border-{color}-{shade}
```

| Class | Example |
|-------|---------|
| `border-transparent` | Transparent border |
| `border-black` | Black border |
| `border-gray-300` | Light gray border |
| `border-blue-500` | Blue border |

### Opacity

| Class | CSS |
|-------|-----|
| `opacity-0` | `opacity: 0` |
| `opacity-25` | `opacity: 0.25` |
| `opacity-50` | `opacity: 0.5` |
| `opacity-75` | `opacity: 0.75` |
| `opacity-100` | `opacity: 1` |

---

## 🔲 Borders

### Border Width

| Class | CSS |
|-------|-----|
| `border-0` | `border-width: 0` |
| `border` | `border-width: 1px` |
| `border-2` | `border-width: 2px` |
| `border-4` | `border-width: 4px` |
| `border-8` | `border-width: 8px` |
| `border-t` | `border-top-width: 1px` |
| `border-r` | `border-right-width: 1px` |
| `border-b` | `border-bottom-width: 1px` |
| `border-l` | `border-left-width: 1px` |

### Border Style

| Class | CSS |
|-------|-----|
| `border-solid` | `border-style: solid` |
| `border-dashed` | `border-style: dashed` |
| `border-dotted` | `border-style: dotted` |
| `border-double` | `border-style: double` |
| `border-none` | `border-style: none` |

### Border Radius

| Class | CSS |
|-------|-----|
| `rounded-none` | `border-radius: 0` |
| `rounded-sm` | `border-radius: 0.125rem` |
| `rounded` | `border-radius: 0.25rem` |
| `rounded-md` | `border-radius: 0.375rem` |
| `rounded-lg` | `border-radius: 0.5rem` |
| `rounded-xl` | `border-radius: 0.75rem` |
| `rounded-2xl` | `border-radius: 1rem` |
| `rounded-3xl` | `border-radius: 1.5rem` |
| `rounded-full` | `border-radius: 9999px` |
| `rounded-t-lg` | Top corners only |
| `rounded-r-lg` | Right corners only |
| `rounded-b-lg` | Bottom corners only |
| `rounded-l-lg` | Left corners only |

### Divide (Between Children)

| Class | CSS |
|-------|-----|
| `divide-x` | Vertical dividers between children |
| `divide-y` | Horizontal dividers between children |
| `divide-gray-200` | Divider color |

---

## 🌫️ Effects

### Box Shadow

| Class | Description |
|-------|-------------|
| `shadow-sm` | Small shadow |
| `shadow` | Default shadow |
| `shadow-md` | Medium shadow |
| `shadow-lg` | Large shadow |
| `shadow-xl` | Extra large shadow |
| `shadow-2xl` | 2x large shadow |
| `shadow-inner` | Inset shadow |
| `shadow-none` | No shadow |

### Ring (Focus Outline)

| Class | Description |
|-------|-------------|
| `ring-0` | No ring |
| `ring-1` | 1px ring |
| `ring-2` | 2px ring |
| `ring-4` | 4px ring |
| `ring-blue-500` | Ring color |
| `ring-offset-2` | Ring offset |

### Blur

| Class | CSS |
|-------|-----|
| `blur-none` | `filter: blur(0)` |
| `blur-sm` | `filter: blur(4px)` |
| `blur` | `filter: blur(8px)` |
| `blur-md` | `filter: blur(12px)` |
| `blur-lg` | `filter: blur(16px)` |
| `blur-xl` | `filter: blur(24px)` |
| `blur-2xl` | `filter: blur(40px)` |
| `blur-3xl` | `filter: blur(64px)` |

---

## 🔄 Transforms

### Scale

| Class | CSS |
|-------|-----|
| `scale-0` | `transform: scale(0)` |
| `scale-50` | `transform: scale(0.5)` |
| `scale-75` | `transform: scale(0.75)` |
| `scale-90` | `transform: scale(0.9)` |
| `scale-95` | `transform: scale(0.95)` |
| `scale-100` | `transform: scale(1)` |
| `scale-105` | `transform: scale(1.05)` |
| `scale-110` | `transform: scale(1.1)` |
| `scale-125` | `transform: scale(1.25)` |
| `scale-150` | `transform: scale(1.5)` |

### Rotate

| Class | CSS |
|-------|-----|
| `rotate-0` | `transform: rotate(0deg)` |
| `rotate-1` | `transform: rotate(1deg)` |
| `rotate-3` | `transform: rotate(3deg)` |
| `rotate-6` | `transform: rotate(6deg)` |
| `rotate-12` | `transform: rotate(12deg)` |
| `rotate-45` | `transform: rotate(45deg)` |
| `rotate-90` | `transform: rotate(90deg)` |
| `rotate-180` | `transform: rotate(180deg)` |
| `-rotate-45` | `transform: rotate(-45deg)` |

### Translate

| Class | CSS |
|-------|-----|
| `translate-x-0` | `transform: translateX(0)` |
| `translate-x-1` | `transform: translateX(0.25rem)` |
| `translate-x-4` | `transform: translateX(1rem)` |
| `translate-x-1/2` | `transform: translateX(50%)` |
| `translate-x-full` | `transform: translateX(100%)` |
| `-translate-x-1/2` | `transform: translateX(-50%)` |
| `translate-y-4` | `transform: translateY(1rem)` |

### Skew

| Class | CSS |
|-------|-----|
| `skew-x-0` | `transform: skewX(0deg)` |
| `skew-x-3` | `transform: skewX(3deg)` |
| `skew-x-6` | `transform: skewX(6deg)` |
| `skew-x-12` | `transform: skewX(12deg)` |
| `skew-y-3` | `transform: skewY(3deg)` |

---

## ⚡ Transitions & Animation

### Transition Property

| Class | CSS |
|-------|-----|
| `transition-none` | No transition |
| `transition-all` | `transition-property: all` |
| `transition` | `transition-property: color, background-color, border-color, etc.` |
| `transition-colors` | `transition-property: color, background-color, border-color` |
| `transition-opacity` | `transition-property: opacity` |
| `transition-shadow` | `transition-property: box-shadow` |
| `transition-transform` | `transition-property: transform` |

### Transition Duration

| Class | CSS |
|-------|-----|
| `duration-75` | `transition-duration: 75ms` |
| `duration-100` | `transition-duration: 100ms` |
| `duration-150` | `transition-duration: 150ms` |
| `duration-200` | `transition-duration: 200ms` |
| `duration-300` | `transition-duration: 300ms` |
| `duration-500` | `transition-duration: 500ms` |
| `duration-700` | `transition-duration: 700ms` |
| `duration-1000` | `transition-duration: 1000ms` |

### Transition Timing

| Class | CSS |
|-------|-----|
| `ease-linear` | `transition-timing-function: linear` |
| `ease-in` | `transition-timing-function: ease-in` |
| `ease-out` | `transition-timing-function: ease-out` |
| `ease-in-out` | `transition-timing-function: ease-in-out` |

### Animation

| Class | Description |
|-------|-------------|
| `animate-none` | No animation |
| `animate-spin` | Continuous rotation |
| `animate-ping` | Ping/pulse effect |
| `animate-pulse` | Subtle pulse |
| `animate-bounce` | Bouncing animation |

---

## 📱 Responsive Design

### Breakpoints

| Prefix | Min Width | CSS |
|--------|-----------|-----|
| `sm:` | 640px | `@media (min-width: 640px)` |
| `md:` | 768px | `@media (min-width: 768px)` |
| `lg:` | 1024px | `@media (min-width: 1024px)` |
| `xl:` | 1280px | `@media (min-width: 1280px)` |
| `2xl:` | 1536px | `@media (min-width: 1536px)` |

### Usage Examples

```html
<!-- Stack on mobile, row on desktop -->
<div class="flex flex-col md:flex-row">

<!-- Hidden on mobile, visible on desktop -->
<div class="hidden lg:block">

<!-- Full width on mobile, half on tablet, third on desktop -->
<div class="w-full md:w-1/2 lg:w-1/3">

<!-- Different padding per breakpoint -->
<div class="p-4 md:p-6 lg:p-8">
```

---

## 🖱️ State Variants

### Hover, Focus, Active

```html
<button class="bg-blue-500 hover:bg-blue-700 focus:ring-2 active:bg-blue-800">
  Button
</button>
```

| Prefix | State |
|--------|-------|
| `hover:` | Mouse hover |
| `focus:` | Keyboard focus |
| `active:` | Being clicked |
| `visited:` | Visited link |
| `disabled:` | Disabled state |
| `focus-visible:` | Keyboard-only focus |
| `focus-within:` | Child has focus |

### Group Hover

```html
<div class="group">
  <p class="group-hover:text-blue-500">Changes when parent hovered</p>
</div>
```

### Peer States

```html
<input class="peer" type="checkbox" />
<label class="peer-checked:text-blue-500">Checked!</label>
```

### Dark Mode

```html
<div class="bg-white dark:bg-gray-900">
  <p class="text-black dark:text-white">Dark mode text</p>
</div>
```

---

## 🎯 Common Patterns

### Centering

```html
<!-- Flex center -->
<div class="flex items-center justify-center">

<!-- Grid center -->
<div class="grid place-items-center">

<!-- Absolute center -->
<div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2">
```

### Card Component

```html
<div class="bg-white rounded-lg shadow-md p-6 hover:shadow-lg transition-shadow">
  <h2 class="text-xl font-bold mb-2">Card Title</h2>
  <p class="text-gray-600">Card content goes here.</p>
</div>
```

### Button Styles

```html
<!-- Primary -->
<button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded">
  Primary
</button>

<!-- Outline -->
<button class="border border-blue-500 text-blue-500 hover:bg-blue-500 hover:text-white font-bold py-2 px-4 rounded transition-colors">
  Outline
</button>

<!-- Pill -->
<button class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-6 rounded-full">
  Pill Button
</button>
```

### Input Field

```html
<input 
  type="text" 
  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
  placeholder="Enter text..."
/>
```

### Avatar

```html
<img class="w-12 h-12 rounded-full object-cover" src="avatar.jpg" alt="Avatar" />
```

### Badge

```html
<span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800">
  Active
</span>
```

### Truncated Text

```html
<p class="truncate w-48">This is a very long text that will be truncated...</p>

<!-- Multi-line clamp -->
<p class="line-clamp-3">Multi-line text that will be clamped to 3 lines...</p>
```

---

## 🛠️ Utility Shortcuts

| Pattern | Classes |
|---------|---------|
| Full width/height | `w-full h-full` |
| Full screen | `w-screen h-screen` |
| Square | `w-12 h-12` (same values) |
| Circle | `w-12 h-12 rounded-full` |
| Flex center | `flex items-center justify-center` |
| Grid center | `grid place-items-center` |
| Sticky header | `sticky top-0` |
| Fixed footer | `fixed bottom-0 left-0 right-0` |
| Overflow hidden | `overflow-hidden` |
| Scroll | `overflow-auto` or `overflow-scroll` |
| No select | `select-none` |
| Pointer cursor | `cursor-pointer` |
| Not allowed | `cursor-not-allowed` |

---

## 📚 Resources

| Resource | Link |
|----------|------|
| Official Docs | [tailwindcss.com/docs](https://tailwindcss.com/docs) |
| Cheat Sheet | [nerdcave.com/tailwind-cheat-sheet](https://nerdcave.com/tailwind-cheat-sheet) |
| Tailwind UI | [tailwindui.com](https://tailwindui.com) |
| Headless UI | [headlessui.com](https://headlessui.com) |
| Heroicons | [heroicons.com](https://heroicons.com) |

---

*Last updated: February 2026*