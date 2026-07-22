export default async function scenario({ browserContext, expect, keyboardOverlay, page, record, video }) {
  await page.setContent('<button id="primary-page" type="button">Primary page</button>')

  if (!record) {
    expect(video).toBeNull()
    return
  }

  await keyboardOverlay.show(['ControlOrMeta', 'Click'])
  await page.locator('#primary-page').click({ position: { x: 4, y: 4 } })

  const popup = await browserContext.newPage()

  await popup.setContent('<h1 id="popup-ready">Popup ready</h1>')

  await popup.waitForLoadState('domcontentloaded')
  await expect(popup.locator('#popup-ready')).toContainText('Popup ready')

  await video.waitForPage(popup)

  const popupOverlay = popup.locator('#payload-e2e-keyboard')
  await expect(popupOverlay).toContainText(process.platform === 'darwin' ? '⌘' : 'Ctrl')
  await expect(popupOverlay).toContainText('Click')
}
