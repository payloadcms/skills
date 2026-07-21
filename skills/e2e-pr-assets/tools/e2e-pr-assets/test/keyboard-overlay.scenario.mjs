export default async function scenario({ cursor, expect, keyboardOverlay, page, record }) {
  await page.setContent(`
    <button id="shortcut-target" type="button">Shortcut target</button>
    <input id="private-input" />
  `)

  const overlay = page.locator('#payload-e2e-keyboard')

  if (!record) {
    expect(cursor).toBeNull()
    expect(keyboardOverlay).toBeFalsy()
    await expect(overlay).toHaveCount(0)
    return
  }

  expect(cursor).not.toBeNull()
  expect(keyboardOverlay).toBeTruthy()

  await page.evaluate(() => {
    window.__recordedActions = []
    document.querySelector('#shortcut-target').addEventListener('click', (event) => {
      window.__recordedActions.push({
        ctrlKey: event.ctrlKey,
        metaKey: event.metaKey,
        shiftKey: event.shiftKey,
        type: 'click',
      })
    })
    document.querySelector('#private-input').addEventListener('keydown', (event) => {
      window.__recordedActions.push({ key: event.key, type: 'keydown' })
    })
  })

  const locatorClickResult = await page.locator('#shortcut-target').click({
    modifiers: ['ControlOrMeta'],
    position: { x: 4, y: 4 },
  })
  expect(locatorClickResult).toBeUndefined()
  await expect(overlay).toContainText(process.platform === 'darwin' ? '⌘' : 'Ctrl')
  await expect(overlay).toContainText('Click')
  expect(await page.evaluate(() => window.__recordedActions[0])).toMatchObject({
    ctrlKey: process.platform !== 'darwin',
    metaKey: process.platform === 'darwin',
  })

  await page.click('#shortcut-target', { modifiers: ['Shift'] })
  await expect(overlay).toContainText('Shift')
  await expect(overlay).toContainText('Click')
  expect(await page.evaluate(() => window.__recordedActions[1])).toMatchObject({ shiftKey: true })

  const locatorPressResult = await page.locator('#private-input').press('Enter')
  expect(locatorPressResult).toBeUndefined()
  await expect(overlay).toContainText('Enter')
  expect(await page.evaluate(() => window.__recordedActions[2])).toMatchObject({ key: 'Enter' })

  const pagePressResult = await page.press('#private-input', 'Escape')
  expect(pagePressResult).toBeUndefined()
  await expect(overlay).toContainText('Esc')
  expect(await page.evaluate(() => window.__recordedActions[3])).toMatchObject({ key: 'Escape' })

  let originalActionError
  try {
    await page.press('#missing-target', 'Enter', { timeout: 25 })
  } catch (error) {
    originalActionError = error
  }
  expect(originalActionError).toBeInstanceOf(Error)
  expect(originalActionError.message).toContain('#missing-target')

  await page.keyboard.press('+')
  await expect(overlay).toContainText('+')

  await page.keyboard.press('Control++')
  await expect(overlay).toContainText('Ctrl')
  await expect(overlay).toContainText('+')

  await page.keyboard.down('Shift')
  await page.keyboard.press('ArrowDown')
  await expect(overlay).toContainText('Shift')
  await expect(overlay).toContainText('↓')
  await page.keyboard.up('Shift')

  await page.locator('#private-input').fill('never-show-this-value')
  await page.locator('#private-input').pressSequentially('typed-secret')
  await page.keyboard.type('keyboard-secret')
  await page.keyboard.insertText('inserted-secret')
  await expect(overlay).not.toContainText('never-show-this-value')
  await expect(overlay).not.toContainText('typed-secret')
  await expect(overlay).not.toContainText('keyboard-secret')
  await expect(overlay).not.toContainText('inserted-secret')

  await page.goto('data:text/html,<button id="after-navigation">After navigation</button>')
  await page.keyboard.press('Meta+K')
  await expect(overlay).toContainText('⌘')
  await expect(overlay).toContainText('K')

  await keyboardOverlay.show('Custom action')
  await expect(overlay).toContainText('Custom action')
}
