
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
      if not (midiCC.msg2 == 1 or midiCC.msg2 == 11) then
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

