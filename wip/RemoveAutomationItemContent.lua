--[[
 * ReaScript Name: Insert CC linear ramp events between selected ones if consecutive
 * Description: Interpolate multiple CC events by creating new ones. Works with multiple lanes (CC Channel).
 * Instructions: Open a MIDI take in MIDI Editor. Select Notes. Run.
 * Screenshot: 
 * Author: SurfingNerd
 * Author URI: https://github.com/SurfingNerd
 * Repository: GitHub > SurfingNerd > ReaperScripts
 * Repository URI: https://github.com/SurfingNerd/ReaperScripts
 * Licence: GPL v3
 * REAPER: 6.0
 * Extensions: None
 * Version: 0.1
--]]

--[[
 * Changelog:
	+ Initial Release
--]]

-- USER CONFIG AREA ---------------------

interval = "2"
prompt = true -- User input dialog box
selected = false -- new notes are selected

----------------- END OF USER CONFIG AREA



reaper.ShowConsoleMsg('Getting Started!')

function enumAllCCMidis()
  local count_items = reaper.CountMediaItems(0) -- Count All Media items once
  for j = 0, count_items - 1 do

    reaper.ShowConsoleMsg('processing media item # ' .. tostring(j))
      
    local item = reaper.GetMediaItem(0, j) -- Get item
    local take = reaper.GetTake(item, 0)

    retval, notes, ccs, sysex = reaper.MIDI_CountEvts(take)

    local indexes2Delete = {}
    local indexesNumber = 0 
    
    for ccidx = 0, ccs - 1 do
      midiCC = {}
      retval, midiCC.selected, midiCC.muted, midiCC.ppqpos, midiCC.chanmsg, midiCC.chan, midiCC.msg2, midiCC.msg3 = reaper.MIDI_GetCC(take, ccidx)
      getEventResult = {}
      retval, getEventResult.selected, getEventResult.muted, getEventResult.ppqpos, getEventResult.msg = reaper.MIDI_GetEvt(take, ccidx, midiCC.selected, midiCC.muted, midiCC.ppqpos,'')
    
      -- local midiCC = reaper.MIDI_GetCC( take, ccidx)
      -- msg2 is the cc we are looking for. we need 1 and 11, and ditch the rest.
      -- remember here what to ditch 
      reaper.ShowConsoleMsg(getEventResult.msg .. ' - ppqpos  ' .. tostring(midiCC.ppqpos) .. ' chanmsg ' .. tostring(midiCC.chanmsg) .. ' chan ' .. tostring(midiCC.chan) .. ' msg2 ' .. tostring(midiCC.msg2) .. ' msg3 ' .. midiCC.msg3 .. '\n')
      
      if (midiCC.msg2 == 1 or midiCC.msg2 == 11) then
        reaper.ShowConsoleMsg('skipping: case 1 or 11 detected\n')
      else
        reaper.ShowConsoleMsg('indexesNumber' .. tostring(indexesNumber) .. '  ' .. tostring(ccidx) .. ' msg2 value: ' .. tostring(midiCC.msg2) .. '\n')
        indexes2Delete[indexesNumber] = ccidx
        indexesNumber = indexesNumber + 1
      end
    end

    while indexesNumber > 0
    do
      indexesNumber = indexesNumber - 1
      local ccidx = indexes2Delete[indexesNumber]
      
      reaper.ShowConsoleMsg('deleteing # ' .. tostring(indexesNumber) .. ' on index ' .. tostring(ccidx) .. '\n')
      local deleteResult = reaper.MIDI_DeleteCC(take, ccidx)
      if not deleteResult then
        reaper.ShowConsoleMsg('Unable to delete CC on ' .. tostring(ccidx))
      end
    end

  -- start ditching Cc here.
    --reaper.MIDI_DeleteCC(MediaItem_Take take, integer ccidx)
  end
end

function enumAllTracks()

  local trackCount = reaper.CountTracks(0)
    -- Loop in Tracks
  for i = 0, trackCount - 1 do  
    local track = reaper.GetTrack(0, i)
    guid = reaper.GetTrackGUID( track )
  
    local channelNumber = reaper.GetMediaTrackInfo_Value(track, 'I_RECINPUT')     -- 'I_RECINPUT' means Channel ?!
    local recMode =  reaper.GetMediaTrackInfo_Value(track, 'I_RECMODE');
    local nchan = reaper.GetMediaTrackInfo_Value(track, 'I_NCHAN');
    local hwindex = reaper.GetMediaTrackInfo_Value(track, 'I_MIDIHWOUT');

    local trackInfoString = ''
    local trackInfoStringResult = reaper.GetSetMediaTrackInfo_String(track, 'P_NAME', trackInfoString, false)
    local envelopeCount = reaper.CountTrackEnvelopes(track)

    reaper.ShowConsoleMsg(type(track) .. guid .. ' ' .. tostring(trackInfoStringResult) .. ' ' .. trackInfoString 
      .. ' hwindex ' .. hwindex .. ' nchan ' .. nchan .. ' recMode ' .. recMode .. ' channelNumber: ' 
      .. channelNumber .. ' envelopeCount: ' .. tostring(envelopeCount) .. '\n')

    -- here is the problem: the Tracks do not have a TrackEnvelope.

    for iEnvelope=0,envelopeCount-1 do

      local trackEnvelope = reaper.GetTrackEnvelope(track, iEnvelope)
      local automationItemCount = reaper.CountAutomationItems(trackEnvelope)
      
      reaper.ShowConsoleMsg('Envelope: ' .. tostring(envelopeCount) .. ' ' .. tostring(automationItemCount))

      for iAutomationItem=0,automationItemCount-1 do
        local value = 0
        local isSet = false
        local poolId = reaper.GetSetAutomationItemInfo(trackEnvelope, iAutomationItem, 'D_POOL_ID', value, is_set)
        local position = reaper.GetSetAutomationItemInfo(trackEnvelope, iAutomationItem, 'D_POSITION', value, is_set)
        local length = reaper.GetSetAutomationItemInfo(trackEnvelope, iAutomationItem, 'D_LENGTH', value, is_set)
        reaper.ShowConsoleMsg('autoItem ' .. tostring(iAutomationItem) .. ' pool ' .. tostring(poolId) .. ' position ' .. position .. ' length ' .. length)
        automationItemCount = automationItemCount + 1
      end
      envelopeCount = envelopeCount + 1
    end



    local take = reaper.GetTake(track, 0)

    local ccidx = 0
    --boolean retval, boolean selected, boolean muted, number ppqpos, number chanmsg, number chan, number msg2, number msg
    local midiCC = reaper.MIDI_GetCC( take, ccidx)
    reaper.ShowConsoleMsg('ppqpos  ' .. tostring(midiCC.ppqpos) .. ' chanmsg ' .. tostring(midiCC.chanmsg) .. ' chan ' .. tostring(midiCC.chan) .. ' msg2 ' .. tostring(midiCC.msg2))

  end
end

reaper.ShowConsoleMsg('start enum all tracks')
--enumAllTracks();
enumAllCCMidis();
reaper.ShowConsoleMsg('end enum all tracks')

