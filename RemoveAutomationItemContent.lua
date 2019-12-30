
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

    -- here is the problem: the Tracks do nat have a TrackEnvelope.

    -- envelopeCount = 1
    for iEnvelope=0,envelopeCount-1 do

      local trackEnvelope = reaper.GetTrackEnvelope(track, iEnvelope);
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
  end
end

reaper.ShowConsoleMsg('start enum all tracks')
enumAllTracks();
reaper.ShowConsoleMsg('end enum all tracks')

