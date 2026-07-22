export default async function scenario({ browserContext, expect, keyboardOverlay, page, record, video }) {
  await page.setContent('<button id="primary-page" type="button">Primary page</button>')

  if (!record) {
    expect(video).toBeNull()
    return
  }

  await keyboardOverlay.show(['ControlOrMeta', 'Click'])
  await page.locator('#primary-page').click({ position: { x: 4, y: 4 } })

  const popup = await browserContext.newPage()
  const handoffPromise = video.waitForPage(popup)

  await popup.goto('data:text/html,<h1 id="popup-ready">Popup ready</h1>')
  await handoffPromise
  await expect(popup.locator('#popup-ready')).toContainText('Popup ready')

  const popupCursor = popup.locator('#payload-e2e-cursor')
  await expect(popupCursor).toHaveCount(0)

  const popupOverlay = popup.locator('#payload-e2e-keyboard')
  await expect(popupOverlay).toContainText(process.platform === 'darwin' ? '⌘' : 'Ctrl')
  await expect(popupOverlay).toContainText('Click')
}
