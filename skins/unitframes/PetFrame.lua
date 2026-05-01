-- =============================================================================
-- PetFrame.lua
-- =============================================================================

local petFrame = PetFrame
if not petFrame then return end

-- Cached texture/font paths
local STATUSBAR_TEX = "Interface\\AddOns\\ClassicFrames\\textures\\UI-StatusBar"
local FONT_FRIZ     = "Fonts\\FRIZQT__.TTF"
local TEX_FRAME     = "Interface\\AddOns\\ClassicFrames\\textures\\UI-SmallTargetingFrame"
local TEX_FLASH     = "Interface\\TargetingFrame\\UI-PartyFrame-Flash"
local TEX_ATTACK    = "Interface\\TargetingFrame\\UI-Player-AttackStatus"

-- Cached frame references
local portrait       = PetPortrait
local petName        = PetName
local frameTex       = PetFrameTexture
local frameFlash     = PetFrameFlash
local healthBar      = PetFrameHealthBar
local manaBar        = PetFrameManaBar
local attackMode     = PetAttackModeTexture
local hitIndicator   = PetHitIndicator
local overAbsorbGlow = PetFrameOverAbsorbGlow
local hpText         = PetFrameHealthBarText
local hpTextLeft     = PetFrameHealthBarTextLeft
local hpTextRight    = PetFrameHealthBarTextRight
local mpText         = PetFrameManaBarText
local mpTextLeft     = PetFrameManaBarTextLeft
local mpTextRight    = PetFrameManaBarTextRight
local hpMask         = PetFrameHealthBarMask
local mpMask         = PetFrameManaBarMask

-- Frame sizing
petFrame:SetSize(128, 53)

-- Portrait
portrait:ClearAllPoints()
portrait:SetPoint("TOPLEFT", 7, -6)

-- Name
petName:ClearAllPoints()
petName:SetPoint("BOTTOMLEFT", 53, 33)
petName:SetJustifyH("LEFT")
petName:SetFont(FONT_FRIZ, 10, "OUTLINE")

-- Frame texture
frameTex:SetSize(128, 64)
frameTex:SetTexture(TEX_FRAME)
frameTex:ClearAllPoints()
frameTex:SetPoint("TOPLEFT", 0, -2)

-- Flash
frameFlash:SetSize(128, 64)
frameFlash:SetTexture(TEX_FLASH)
frameFlash:SetPoint("TOPLEFT", -4, 11)
frameFlash:SetTexCoord(0, 1, 1, 0)
frameFlash:SetDrawLayer("BACKGROUND")

-- Health bar
healthBar:SetSize(68, 8)
healthBar:SetStatusBarTexture(STATUSBAR_TEX)
healthBar:SetStatusBarColor(0, 1, 0)
healthBar:ClearAllPoints()
healthBar:SetPoint("TOPLEFT", 46, -22)
healthBar:SetFrameLevel(1)
hpMask:Hide()

-- Mana bar
manaBar:SetSize(68, 8)
manaBar:ClearAllPoints()
manaBar:SetPoint("TOPLEFT", 46, -29)
manaBar:SetFrameLevel(1)
mpMask:Hide()

-- Reparent & reposition bar texts
hpText:SetParent(petFrame)
hpText:ClearAllPoints()
hpText:SetPoint("CENTER", petFrame, "TOPLEFT", 82, -26)

hpTextLeft:SetParent(petFrame)
hpTextLeft:ClearAllPoints()
hpTextLeft:SetPoint("LEFT", petFrame, "TOPLEFT", 46, -26)

hpTextRight:SetParent(petFrame)
hpTextRight:ClearAllPoints()
hpTextRight:SetPoint("RIGHT", petFrame, "TOPLEFT", 113, -26)

mpText:SetParent(petFrame)
mpText:ClearAllPoints()
mpText:SetPoint("CENTER", petFrame, "TOPLEFT", 82, -35)

mpTextLeft:SetParent(petFrame)
mpTextLeft:ClearAllPoints()
mpTextLeft:SetPoint("LEFT", petFrame, "TOPLEFT", 46, -35)

mpTextRight:SetParent(petFrame)
mpTextRight:ClearAllPoints()
mpTextRight:SetPoint("RIGHT", petFrame, "TOPLEFT", 113, -35)

-- Over-absorb glow
overAbsorbGlow:SetParent(petFrame)
overAbsorbGlow:SetDrawLayer("ARTWORK", 7)

-- Attack mode texture
attackMode:SetSize(76, 64)
attackMode:SetTexture(TEX_ATTACK)
attackMode:SetTexCoord(0.703125, 1, 0, 1)
attackMode:ClearAllPoints()
attackMode:SetPoint("TOPLEFT", 6, -9)

-- Hit indicator
hitIndicator:ClearAllPoints()
hitIndicator:SetPoint("CENTER", petFrame, "TOPLEFT", 28, -27)