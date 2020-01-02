--[[
 * ReaScript Name: Removes all CC Lanes beside the seleccted one
 * Description: Removes unwanted data in CC Lanes. For example after importing a midi export from another composing tool. 
 * Instructions: Global Command - hit and run. BEWARE: Changes the whole Software.
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

switchMidiChannel = -1 -- Switch all Midi Lanes to this Channel. Don't do any change if -1
keepCC01 = 1
keepCC02 = 11
keepCC03 = -1
keepCC04 = -1
keepCC05 = -1
keepCC06 = -1
keepCC07 = -1
keepCC08 = -1
keepCC09 = -1
keepCC10 = -1

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
      -- reaper.ShowConsoleMsg(getEventResult.msg .. ' - ppqpos  ' .. tostring(midiCC.ppqpos) .. ' chanmsg ' .. tostring(midiCC.chanmsg) .. ' chan ' .. tostring(midiCC.chan) .. ' msg2 ' .. tostring(midiCC.msg2) .. ' msg3 ' .. midiCC.msg3 .. '\n')
      if not (midiCC.msg2 == keepCC01 or midiCC.msg2 == keepCC02 or midiCC.msg2 == keepCC03 or midiCC.msg2 == keepCC04 or midiCC.msg2 == keepCC05 or midiCC.msg2 == keepCC06 or midiCC.msg2 == keepCC07 or midiCC.msg2 == keepCC08  or midiCC.msg2 == keepCC09  or midiCC.msg2 == keepCC10) then
        -- reaper.ShowConsoleMsg('indexesNumber' .. tostring(indexesNumber) .. '  ' .. tostring(ccidx) .. ' msg2 value: ' .. tostring(midiCC.msg2) .. '\n')
        indexes2Delete[indexesNumber] = ccidx
        indexesNumber = indexesNumber + 1
      end
    end

    while indexesNumber > 0
    do
      indexesNumber = indexesNumber - 1
      local ccidx = indexes2Delete[indexesNumber]
      
      -- reaper.ShowConsoleMsg('deleteing # ' .. tostring(indexesNumber) .. ' on index ' .. tostring(ccidx) .. '\n')
      local deleteResult = reaper.MIDI_DeleteCC(take, ccidx)
      if not deleteResult then
        reaper.ShowConsoleMsg('Unable to delete CC on ' .. tostring(ccidx))
      end
    end

  -- start ditching Cc here.
    --reaper.MIDI_DeleteCC(MediaItem_Take take, integer ccidx)
  end
end

reaper.ShowConsoleMsg('start enum all tracks')
enumAllCCMidis();
reaper.ShowConsoleMsg('end enum all tracks')

