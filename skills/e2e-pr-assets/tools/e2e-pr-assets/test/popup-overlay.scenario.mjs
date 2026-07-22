export default async function scenario({ browserContext, expect, page, record, video }) {
  await page.setContent('<button id="primary-page" type="button">Primary page</button>')

  if (!record) {
    expect(video).toBeNull()
    return
  }

  await page.locator('#primary-page').click({
    modifiers: ['ControlOrMeta'],
    position: { x: 4, y: 4 },
  })

  const popup = await browserContext.newPage()
  const handoffStartedAt = Date.now()
  const handoffPromise = video.waitForPage(popup)

  await popup.goto('data:text/html,<h1 id="popup-ready">Popup ready</h1>')
  await handoffPromise
  await expect(popup.locator('#popup-ready')).toContainText('Popup ready')

  const popupCursor = popup.locator('#payload-e2e-cursor')
  await expect(popupCursor).toHaveCount(0)

  const popupOverlay = popup.locator('#payload-e2e-keyboard')
  await expect(popupOverlay).toHaveCount(0)
  expect(Date.now() - handoffStartedAt).toBeGreaterThanOrEqual(1100)

  await popup.keyboard.press('ControlOrMeta+P')

  const replayPopup = await browserContext.newPage()
  const replayHandoffPromise = video.waitForPage(replayPopup, { replayLastOverlay: true })

  await replayPopup.goto('data:text/html,<h1 id="replay-ready">Replay ready</h1>')
  await replayHandoffPromise
  await expect(replayPopup.locator('#replay-ready')).toContainText('Replay ready')

  const replayOverlay = replayPopup.locator('#payload-e2e-keyboard')
  await expect(replayOverlay).toContainText(process.platform === 'darwin' ? '⌘' : 'Ctrl')
  await expect(replayOverlay).toContainText('P')
}
