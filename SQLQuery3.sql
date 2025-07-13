--total no of seate
SELECT DISTINCT COUNT(parliament_constituency) from constituencywise_results
--what are the total no of seats available for election in each state
select s.state as state_name,
 count(cr.parliament_constituency )as Total_seats from
constituencywise_results cr inner join statewise_results sr on 
cr.parliament_Constituency=sr.parliament_constituency
 Inner join states s on sr.state_id=s.state_Id group by s.state

 --total seats won by NDA Alliance

 select sum(case when party In('Bharatiya Janata Party - BJP','Telugu Desam - TDP',
 'Janata Dal  (United) - JD(U)','Shiv Sena - SHS','AJSU Party - AJSUP',
 'Apna Dal (Soneylal) - ADAL','Asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS',
 'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)','Nationalist Congress Party - NCP',
 'Lok Janshakti Party(Ram Vilas) - LJPRV','Rashtriya Lok Dal - RLD','Sikkim Krantikari Morcha - SKM')
 then [won]
 else 0 end)
 as NDA_total_seats_won from partywise_results
 --seats won by NDA Alliance parties
 select 
 party as paert_Name,won as seats_Won
 from partywise_results where 
 party in('Bharatiya Janata Party - BJP','Telugu Desam - TDP',
 'Janata Dal  (United) - JD(U)','Shiv Sena - SHS','AJSU Party - AJSUP',
 'Apna Dal (Soneylal) - ADAL','Asom Gana Parishad - AGP','Hindustani Awam Morcha (Secular) - HAMS',
 'Janasena Party - JnP','Janata Dal  (Secular) - JD(S)','Nationalist Congress Party - NCP',
 'Lok Janshakti Party(Ram Vilas) - LJPRV','Rashtriya Lok Dal - RLD','Sikkim Krantikari Morcha - SKM') order by won desc

 -- add new column field in table partywise _results to get the party allianz as NDA,I.N.D.I.A and other
 alter table  partywise_results 
 add party_allaiance varchar(50)
 select * from partywise_results
-- I.N.D.I.A Allianz
UPDATE partywise_results
SET party_allaiance = 'I.N.D.I.A'
WHERE party IN (
    'Indian National Congress - INC',
    'Aam Aadmi Party - AAAP',
    'All India Trinamool Congress - AITC',
    'Bharat Adivasi Party - BHRTADVSIP',
    'Communist Party of India  (Marxist) - CPI(M)',
	  'Communist Party of India  (Marxist-Leninist)  (Liberation) - CPI(ML)(L)',
    'Communist Party of India - CPI',
    'Dravida Munnetra Kazhagam - DMK',	
    'Indian Union Muslim League - IUML',
    'Jammu & Kashmir National Conference - JKN',
    'Jharkhand Mukti Morcha - JMM',
    'Kerala Congress - KEC',
    'Marumalarchi Dravida Munnetra Kazhagam - MDMK',
    'Nationalist Congress Party Sharadchandra Pawar - NCPSP',
    'Rashtriya Janata Dal - RJD',
    'Rashtriya Loktantrik Party - RLTP',
    'Revolutionary Socialist Party - RSP',
    'Samajwadi Party - SP',
    'Shiv Sena (Uddhav Balasaheb Thackrey) - SHSUBT',
    'Viduthalai Chiruthaigal Katchi - VCK'
);
--NDA Allianz
UPDATE partywise_results
SET party_allaiance = 'NDA'
WHERE party IN (
    'Bharatiya Janata Party - BJP',
    'Telugu Desam - TDP',
    'Janata Dal  (United) - JD(U)',
    'Shiv Sena - SHS',
    'AJSU Party - AJSUP',
    'Apna Dal (Soneylal) - ADAL',
    'Asom Gana Parishad - AGP',
    'Hindustani Awam Morcha (Secular) - HAMS',
    'Janasena Party - JnP',
    'Janata Dal  (Secular) - JD(S)',
    'Lok Janshakti Party(Ram Vilas) - LJPRV',
    'Nationalist Congress Party - NCP',
    'Rashtriya Lok Dal - RLD',
    'Sikkim Krantikari Morcha - SKM'
);
--OTHER
UPDATE partywise_results
SET party_allaiance = 'OTHER'
WHERE party_allaiance IS NULL;
select * from partywise_results
select party_allaiance ,sum(won) from partywise_results group by party_allaiance
select party,won from partywise_results where party_allaiance='I.N.D.I.A' order by won desc
--Winning candidate's name, their party name, 
--total votes, and the margin of victory for a specific state and constituency?
select cr.winning_candidate,pr.party,pr.party_allaiance,cr.total_votes,cr.margin,s.state,cr.constituency_name from constituencywise_results cr
inner join partywise_results pr 
on cr.party_id=pr.party_id inner join statewise_results sr on cr.parliament_constituency=sr.parliament_constituency
inner join states s on sr.state_id=s.state_id where cr.constituency_name='TAMLUK'
--what is the distribution of EVM votes versus postal votes for candidates in a specific constituency?
select cd.EVM_votes,cd.Postal_votes,cd.total_votes,cd.candidate,cr.constituency_name from constituencywise_details cd
join constituencywise_results cr on cr.Constituency_ID=cd.Constituency_ID where cr.Constituency_name='TAMLUK'
--which parties won the most seats in a state,and how many seats did each party win?
SELECT 
    p.Party,
    COUNT(cr.Constituency_ID) AS Seats_Won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.Party_ID = p.Party_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE 
    s.state = 'Andhra Pradesh'
GROUP BY 
    p.Party
ORDER BY 
    Seats_Won DESC;
--what is the total number of seats won by each party alliance(NDA,I.N.D.I.A and Other) 
--in each state for the India election 2024
SELECT 
	s.state,
    pr.party_allaiance
  
FROM 
    constituencywise_results cr
JOIN 
    partywise_results pr ON cr.Party_ID = pr.Party_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN states s ON sr.State_ID = s.State_ID
WHERE 
    s.state = 'Andhra Pradesh'
	--or 
	SELECT 
    s.State AS State_Name,
    SUM(CASE WHEN p.party_allaiance = 'NDA' THEN 1 ELSE 0 END) AS NDA_Seats_Won,
    SUM(CASE WHEN p.party_allaiance = 'I.N.D.I.A' THEN 1 ELSE 0 END) AS INDIA_Seats_Won,
	SUM(CASE WHEN p.party_allaiance = 'OTHER' THEN 1 ELSE 0 END) AS OTHER_Seats_Won
FROM 
    constituencywise_results cr
JOIN 
    partywise_results p ON cr.Party_ID = p.Party_ID
JOIN 
    statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
JOIN 
    states s ON sr.State_ID = s.State_ID
WHERE 
    p.party_allaiance IN ('NDA', 'I.N.D.I.A',  'OTHER')  -- Filter for NDA and INDIA alliances
GROUP BY 
    s.State
ORDER BY 
    s.State
--Which candidate received the highest number of EVM votes in each constituency (Top 10)?
SELECT TOP 10
    cr.Constituency_Name,
    cd.Constituency_ID,
    cd.Candidate,
    cd.EVM_Votes
FROM 
    constituencywise_details cd
JOIN 
    constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
WHERE 
    cd.EVM_Votes = (
        SELECT MAX(cd1.EVM_Votes)
        FROM constituencywise_details cd1
        WHERE cd1.Constituency_ID = cd.Constituency_ID
    )
ORDER BY 
    cd.EVM_Votes DESC;
	--Which candidate won and which candidate was the runner-up in each constituency of State for the 2024 elections?
WITH RankedCandidates AS (
    SELECT 
        cd.Constituency_ID,
        cd.Candidate,
        cd.Party,
        cd.EVM_Votes,
        cd.Postal_Votes,
        cd.EVM_Votes + cd.Postal_Votes AS Total_Votes,
        ROW_NUMBER() OVER (PARTITION BY cd.Constituency_ID ORDER BY cd.EVM_Votes + cd.Postal_Votes DESC) AS VoteRank
    FROM 
        constituencywise_details cd
    JOIN 
        constituencywise_results cr ON cd.Constituency_ID = cr.Constituency_ID
    JOIN 
        statewise_results sr ON cr.Parliament_Constituency = sr.Parliament_Constituency
    JOIN 
        states s ON sr.State_ID = s.State_ID
    WHERE 
        s.State = 'Maharashtra'
)

SELECT 
    cr.Constituency_Name,
    MAX(CASE WHEN rc.VoteRank = 1 THEN rc.Candidate END) AS Winning_Candidate,
    MAX(CASE WHEN rc.VoteRank = 2 THEN rc.Candidate END) AS Runnerup_Candidate
FROM 
    RankedCandidates rc
JOIN 
    constituencywise_results cr ON rc.Constituency_ID = cr.Constituency_ID
GROUP BY 
    cr.Constituency_Name
ORDER BY 
    cr.Constituency_Name;