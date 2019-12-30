
reaper.ShowConsoleMsg('Getting Started!')

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


		sel_take = reaper.GetActiveTake(sel_item) -- get sel item take
		sel_take_name = reaper.GetTakeName(sel_take) -- get sel item take name
		sel_track = reaper.GetMediaItem_Track(sel_item)
		count_items_on_track = reaper.CountTrackMediaItems(sel_track)
		-- LOOP IN ALL ITEMS
		for j = 0, count_items_on_track - 1 do

			item = reaper.GetTrackMediaItem(sel_track, j) -- Get item

			item_take = reaper.GetActiveTake(item, v) -- Get Take

			name_item_take = reaper.GetTakeName(item_take) -- Get take name

			if name_item_take == sel_take_name then -- Si le nom du take selectionn� est similaire au take, alors

				reaper.SetMediaItemSelected(item, true) -- Select items

			end -- NAMES MATCH

    end -- LOOP IN ITEMS
    

    -- reaper.CountTrackMediaItems(MediaTrack track)
    -- local take = reaper.GetTake(track, 0)
    -- local ccidx = 0
    -- boolean retval, boolean selected, boolean muted, number ppqpos, number chanmsg, number chan, number msg2, number msg
    -- local midiCC = reaper.MIDI_GetCC( take, ccidx)
    -- reaper.ShowConsoleMsg('ppqpos  ' .. tostring(midiCC.ppqpos) .. ' chanmsg ' .. tostring(midiCC.chanmsg) .. ' chan ' .. tostring(midiCC.chan) .. ' msg2 ' .. tostring(midiCC.msg2))

  end
end

reaper.ShowConsoleMsg('start enum all tracks')
enumAllTracks();
reaper.ShowConsoleMsg('end enum all tracks')

