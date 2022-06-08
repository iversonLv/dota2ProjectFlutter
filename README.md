# flutter_dota2_web

A new Flutter project for web.

## Getting Started

run `flutter run -d edge --web-renderer html` and view page on Chrome or Edge

## Deploy to github pages
- `git checkout gh-pages`
- `git merge main`  
the branch you are working for latest
- `flutter build web --release --web-renderer html --base-href /dota2ProjectFlutter/`  
base-href for your git page
- `cp -avr build/web/* docs/`  
github pages set docs
- `git add .`  
- `git commit -am "built base {dev merge to main commit}"`
- `git push https://github.com/iversonLv/dota2ProjectFlutter.git`  
your git repro

| Key       | Value     | Description     |
| :------------- | :----------: | :----------: |
|  baseApiUrl | https://api.opendota.com/api  | Main Api could open swagger to view |

## Useful tools
[svg code to svg file](https://www.svgviewer.dev/)  
[color picker](https://g.co/kgs/8bBbnH)

## Todo list
[] Setup general service  
  - [] GET  
  - [] POST  
  - [] PUT  
  - [] DELETE  
  - [] errorHandle  
[] Setup Service/Store/Action/Reducers/Effects
  - [] constants TODO: now all constants are locally, we should update use api call: Fixed, we now use dotaconstants package
  - [] Player service
    - [x] GET Player data  
    - [x] GET Player win lose  
    - [] GET Player recent matches  
    - [] GET Player matches  
    - [] GET Player heroes 
    - [] GET Player peers  
    - [] GET Player pros
    - [] GET Player totals
    - [] GET Player counts (GET matches)
    - [] GET Player histograms
    - [] GET Player trends (GET matches)
    - [] GET Player wardmap 
    - [] GET Player wordcloud
    - [] GET Player ratings
    - [] GET Player rankings
    - [] POST Player refresh 
    - [] GET pro player data (2021.3.1)
  - [] Teams service
    - [] GET Teams list data (2021.2.5)
    - [] GET Teams general data detail page top hero part (2021.2.6)
    - [] GET Teams matches (2021.2)
    - [] GET Teams players (2021.2)
    - [] GET Teams heroes (2021.2)
    [] Heroes service
    - [] GET Heroes list data (2021.2.16)
    - [] GET Heroes Stats data (2021.2.16)
    - [] GET Heroes Rankings (2021.2.16)
    - [] GET Heroes Benchmarks (2021.2.16)
    - [] GET Heroes Matches (2021.2.16)
    - [] GET Heroes Matchups (2021.2.16)
    - [] GET Heroes Durations (2021.2.16)
    - [] GET Heroes Players (2021.2.16)
    - [] GET Heroes ItemPopularity (2021.2.16)
      <!-- local data -->
    - [] GET Heroes local (2021.1) deprecated, load from dotaconstants directly(2021.10.4)
    - [] GET Heroes Abilities (2021.2) deprecated, load from dotaconstants directly(2021.10.4)
    - [] GET Ablitities Talents List (2021.2) deprecated, load from dotaconstants directly(2021.10.4)
    - [] GET Heros stas (2021.3.1)(2021.3.2) deprecated, load from dotaconstants directly(2021.10.4)
  - [] Records service
    - [] GET Records list data (2021.2.26)
  - [] Matches service
    - [] GET pro matches list data (2021.3.2)
    - [] GET public matches list data (2021.3.2)
    - [] GET matches detail data (2021.3.1)
    - [99%] POST parsed matches (2022.2.28) after parse match, reload page, set static 30 second which not flexible
  - [] Search
    - [] GET serch (2021.2.28)
  - [] Find Matches
[] Setup/Finish pages
  - [] Home page (2021.3.27)
  - [99%] Search page: Search matches/Players (2021.2.28) TODO: search term is empty the public table and match tables are odd behavior
  - [] 404 not found page (2021.2.28)
  - [] Heros page  (2021.3.1)(2021.3.2)
    - [] Heros list page : QA: the total matches seems divided 10? and the percentage seems are permil(2021.3.1)(2021.3.2)
      - [99%] Heros list professional page (2021.3.1)(2021.3.2)
      - [99%] Heros list public page: (2021.3.1)(2021.3.2)
      - [99%] Heros list turbo page: (2021.3.1)(2021.3.2)
    - [99%] Hero detail page
      - [] Heros detail top hero part (2021.2.8)(2021.2.14) TODO: attack speed is different, magic resistence current is static 25%
      - [100%] Heros detail rankings page (2021.2.15)(2021.2.18)(2021.2.27 fixed table setTimeout())
      - [100%] Heros detail benchmarks page(2021.2.18): Charts (2021.2.20)(2021.2.27 fixed table setTimeout())
      - [] Heros detail recent page: (2021.2.15, 4.12)
      - [100%] Heros detail matchups page: (2021.2.16)(2021.2.18)

      - [100%] Heros detail durations page (2021.2.20-21)
      - [] Heros detail players page: (2021.2.16, 4.12)
  - [] Players page  
    - [99%] Players overview page:land_role don't know how to definde roaming (2021.1)(2021.3.10) TODO: include turbo seems contary with official website
    - [] Players matches page (2021.1)
    - [] Players heroes page  (2021.1)
    - [] Players peers page   (2021.1)
    - [] Players pro page   (2021.1)
    - [] Players records page (2021.3.6) 
    - [] Players totals page   (2021.1)
    - [] Players counts page (2021.3.6)   
    - [99%] Players histograms page  (2021.3.5) TODO: array remove all data if it's 0 till end
    - [99%] Players trends page  (2021.3.8) TODO: Don't how to grab title Avg data, it's not the match field avarage data
    - [] Players wardmap page  (2021.3.9) currently, can't do heatmap, use scatter effect
    - [] Players wordcloud page  (2021.3.8) I used treemap rather than use word cloud as no suite plugin for it currently
    - [] Players mmr page (2021.3.8)
    - [95%] Players rankings page TODO: rank coulmn, don't know how to cal(2021.1)
    - [99%] Players Activities page (2021.2.22,23 ) TODO: cell style for click,
  - [] Matches page  (2021.3)  SETUP pages and route for all pages, tabs
    - [] Matches list page (2021.3.2)(2021.3.3)
      - [] Matches pro TODO: first column the time is start_time + duration, now mine is only start_time
      - [] Matches public TODO: first column the time is start_time + duration, now mine is only start_time
    - [] Match detail page
      - [] Top over part (2021.3.11) TODO: parse match button function
      - [90%] OVERVIEW (2021.3.16, 17)(2021.3.23) overview table, abilit updagrades table
      - [] BENCHMARKS (2021.3.13) TODO: table column highlight not implemented yet
      - [] DRAFT (2021.3.12) now, use picks_bans for data, the draft_timings looked odd and some ban pick are skip
      - [] PERFORMANCES (2021.3.14, 15)
      - [70%] LANING (2021. 4.28, 29)
      - [] COMBAT (2021.3.14, 19) merge kills and damage table together
      - [99%] FARM (2021.3.14, 19, 20, 21) TODO: last_hit sort not work, the finalData does not grab the spread data
      - [] ITEMS (2021.3.22)
      - [] GRAPHS (2021.3.22, 23)
      - [99%] CASTS (2021.3.14, 18) TODO: hover on other image, ability target image will fresh(only happen if open the dev tools), some error in dev tools for undefinded
      - [99%] OBJECTIVES (2021.3.18) TODO: RAXT, RAXM, RAXB chartbar need improve, need calperfect number for plus data, now only for one data
      - [] VISION (2021.3.30,31,4.6, 4.8, 4.9, 4.11, 4.14(single-vision-map, 4.14))
      - [] ACTIONS (2021.3.14)
      - [85%] TEAMSFIGHTS (2021.3.27,28) TODO click the fight icon does not update the data, left map
      - [] ANALYSIS onhold
      - [] COSMETICS (2021.3.15)
      - [99%] LOG (2021.4.17, 18, 4.25) Building kill text need update readable
      - [] FANTASY (2021.3.26) observer column number fomular is odd, current is observer + ser uses
      - [] CHAT (2021.4.15, 16) Filter logic is too long, need rethink how could be more simple
      - [] STORY
  - [99%] Teams page (2021.2.8)
    - [99%] Teams list page : The sort result is different from officaily one (2021.2.5)
    - [] Team detail page (2021.2.8)
      - [] Top hero part which will be for all detail sub pages (2021.2.6)
      - [] Team detail overview page (2021.2.8)
      - [] Team detail matches page (overview page limit 20 rows without pagination)(2021.2.7)
      - [] Team detail heroes page (2021.2.8)
      - [] Team detail players page (some player does not have avatar will use onError="this.src='./assets/images/portrait.png'") (2021.2.8)
  - [] Records page (2021.2.26)
    - [] sub pages very similar: duration, kills, deaths, assists, gold per min, xp per min, last hits, denies, hero damage, tower damage, hero healing (2021.2.26)
  - [] Dota2 pro player world population (2021.4.11)
    - [] Click the world dot will show modal to show the country pro player list(2021.4.12)
  - [90%] Patch pages (2021. 4.12, 4.13) Now the patch notes is not readable for heroes, so we don't dispose the page yet.
[] Improve
  - [] Update ngfor with trackby?
  - [] Update sub navigation as share component (2021.2.6)
  - [] update nav title to support teams detail and player detail (2021.2.6)
  - [] Update all isLoading = true for all page? update all subscribe method with !data.isLoading?
  - [] Updated ability modal, item modal pass local data from parent compnent, then won't need read the json every hover, just one fetch
  - [] Maybe update abliltiy modal and item modal like player box in separated component with img and modal?
  - [] Update all win game player slot 120 as some RPG co op RADIENT player slot from 0-25
  - [] Update all image onError="this.src='./assets/images/Dota2Logo.svg'"
  - [] Improve the match page 5K matches load speed, now looked freeze the page
[] Deploy
  - [] Setup the repo on github page(2021.2.26)
  - [] Deploy to github page (2021.2.26)

# Useful info
https://dota2.gamepedia.com/Armor

# Formular
KDA fomular: (kills + assists) / (deaths + 1)  
(血量跟力量有关)HP: base_health + base_str * 20  
(魔法跟智力有关)MP: base_mana + base_int * 12  
Base attack: base_attack_min + base_agi  base_attack_max + base_agi  
(护甲跟敏捷有关)Base armor: base_armor + 0.167 * base_agi  

# Idea
analize player fond of using item, and hate?  
analize player fond of using which primary attr heroes? agi, str, int?  
analize player fond of using which type heroes? 远程？刺客？坦克？爆发？  
analize player fond of using which role heroes? soft support? hard support? mid? safe? off land?  
analize player heroes keep winning?  

# QA
How could we know a hero is roaming or not, current can't be
