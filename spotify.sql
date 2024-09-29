create database spotify_db;
use spotify_db;

CREATE TABLE spotify (
    Artist VARCHAR(255),
    Track VARCHAR(255),
    Album VARCHAR(255),
    Album_type VARCHAR(50),
    Danceability FLOAT,
    Energy FLOAT,
    Loudness FLOAT,
    Speechiness FLOAT,
    Acousticness FLOAT,
    Instrumentalness FLOAT,
    Liveness FLOAT,
    Valence FLOAT,
    Tempo FLOAT,
    Duration_min FLOAT,
    Title VARCHAR(255),
    Channel VARCHAR(255),
    Views BIGINT,
    Likes BIGINT,
    Comments BIGINT,
    Licensed varchar(10),
    official_video varchar(10),
    Stream BIGINT,
    EnergyLiveness FLOAT,
    most_playedon VARCHAR(50)
);

select * from spotify;

# Retrieve the names of all tracks that have more than 1 billion streams.
select track from spotify
where stream > 1000000000;

# List all albums along with their respective artists.
select Album, artist from spotify;

# Get the total number of comments for tracks where licensed = TRUE. ----
select sum(comments) as Total_comments from spotify where licensed = "true" ;

# Find all tracks that belong to the album type single.
select track from spotify where album_type = "Single";

# Count the total number of tracks by each artist.
select artist, count(track) as Total_Tracks from spotify
group by artist
order by Total_tracks desc;

# Calculate the average danceability of tracks in each album.
select album, avg(danceability) as D_AVG from spotify
group by album
order by D_AVG desc;

# Find the top 5 tracks with the highest energy values.
select track, energy from spotify
order by energy desc
limit 5;

# List all tracks along with their views and likes where official_video = TRUE.
select track, views, likes from spotify
where official_video = "True";

# For each album, calculate the total views of all associated tracks.
select album, sum(views) as total_views from spotify
group by album;

# Retrieve the track names that have been streamed on Spotify more than YouTube.
select track from spotify
group by track 
having sum(case when most_playedon = "spotify" then 1 else 0 end) > 
sum(case when most_playedon = "youtube" then 1 else 0 end);

# Find the top 3 most-viewed tracks for each artist using window functions.
with artist_1 as (
select artist, track, views , 
row_number() over(partition by artist order by views desc) as top
from spotify)
select artist, track, views from artist_1
where top <= 3;

# Write a query to find tracks where the liveness score is above the average.
select track from spotify 
where liveness > (select avg(liveness) from spotify);

# Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
-- select album, max(energy) as max_energy,min(energy) as min_energy, (max(energy) - min(energy)) as diff from spotify group by album;

# Method 1
with diff as(
select album, max(energy) as max_energy, min(energy) as min_energy from spotify group by album)
select album, max_energy, min_energy, (max_energy - min_energy) as difference
from diff;

# Method 2 using windows function
WITH diff AS (
    SELECT album,
           MAX(energy) OVER (PARTITION BY album) AS max_energy,
           MIN(energy) OVER (PARTITION BY album) AS min_energy
    FROM spotify
)
SELECT DISTINCT album, 
       max_energy, 
       min_energy, 
       (max_energy - min_energy) AS energy_difference
FROM diff;

 