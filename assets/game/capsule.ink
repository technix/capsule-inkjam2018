// inventory
VAR has_cover = false   // обшивка капсулы
VAR has_knife = false   // обмотанный осколок
VAR has_wrench = false  // разводной ключ
VAR has_glass = false   // осколок стекла
VAR has_papers = false  // бумаги
VAR has_tape = false    // изолента

Dark.
Cold.
Metal smell.
The awakening from anabiosis turned out to be quite different from what you imagined.
But why did not the automation work until now? The capsule should have already opened!

- (start_exam)
* [Open your eyes]
    You do not see anything at all. You hope that your eyes are fine.
* [Touch the capsule walls]
    You try to reach out and your fingers ran into the cold metal. Then you find some kind of lever.
    * * [Pull the lever]
        You pull the lever, and the metal cap of the capsule swung open with a gnash. Light hits your eyes. After waiting until your eyes get used to the light, you clumsily get out of the capsule.
        * * * [Look around] -> chamber_room
-
-> start_exam

== chamber_room

VAR chamber_door_open = false
>>> CLEAR
The round chamber is poorly lit. In the center rises a complex structure of mechanisms, pipes and wires. It surrounded with capsules, one of them is opened now.
Hermetic door in the wall is {chamber_door_open: opened|sealed}.

- (chamber_exam)

* [🔎 Lamps]
    Smooth metal walls and floor dimly shine in the semi-darkness. Apparently, the power is enough only for backup lighting.
* (seen_apparate) [🔎 Mechanisms]
    This machine made our journey possible. The indicators on the control panel glow with a soft amber light.
* {seen_apparate} [🔎 Control panel]
    A glance at the indicators was enough to understand - the rest of the capsules were out of order. It turns out that you are the only one to be lucky enough to reach the destination point alive.
    * * [🔎 Switches]
        It seems that you can redirect the power from the capsules to the door with these switches. You just need to find the right voltage ...
        * * * [Switch the power]
            -> electropuzzle(-> chamber_room)
+ {not has_cover} [🔎 Capsules]
    There are five capsules in total. Your capsule is open. {not has_cover: There is a leather cladding inside.} 
    * * [Touch the cladding]
        Capsule cladding is still warm.
    * * {has_glass and not has_knife} [Cut the cladding with shard]
        The shard is too sharp, you would not like to cut your hands.
    * * {has_knife} [Cut the cladding]
        It took a long time to cut the cladding from the capsule.
        ~ has_cover = true
    + + -> chamber_exam
+ {chamber_door_open} [{storage_room: Go to storage room|Exit the chamber}] -> storage_room
- 
-> chamber_exam

== electropuzzle(-> return_to_story)

VAR voltage = 16
VAR tumbler1 = false
VAR tumbler2 = false
VAR tumbler3 = false
VAR tumbler4 = true
VAR tumbler5 = false

- (electropuzzle_solve)
>>> CLEAR

VOLTMETER 
{voltage}

{voltage > 9: A red light is on the panel. It means that the power circuit is overloaded. You need to lower the voltage.}
{voltage == 9: A green light appears on panel. You can hear a buzz of the mechanisms controlling the door locks.}
{voltage < 9: It seems that the voltage in the power circuit is not enough to control the door relay.}

+ {voltage == 9} [Open the door]
    ~ chamber_door_open = true
   -> return_to_story

+ {voltage != 9 and tumbler1} [Capsule 1: OFF]
    ~ voltage = voltage + 5
    ~ tumbler1 = false
+ {voltage != 9 and not tumbler1} [Capsule 1: on]
    ~ voltage = voltage - 5
    ~ tumbler1 = true

+ {voltage != 9 and tumbler2} [Capsule 2: OFF]
    ~ voltage = voltage + 1
    ~ tumbler2 = false
+ {voltage != 9 and not tumbler2} [Capsule 2: on]
    ~ voltage = voltage - 1
    ~ tumbler2 = true

+ {voltage != 9 and tumbler3} [Capsule 3: OFF]
    ~ voltage = voltage + 2
    ~ tumbler3 = false
+ {voltage != 9 and not tumbler3} [Capsule 3: on]
    ~ voltage = voltage - 2
    ~ tumbler3 = true

+ {voltage != 9 and tumbler4} [Capsule 4: OFF]
    ~ voltage = voltage + 6
    ~ tumbler4 = false
+ {voltage != 9 and not tumbler4} [Capsule 4: on]
    ~ voltage = voltage - 6
    ~ tumbler4 = true

+ {voltage != 9 and tumbler5} [Capsule 5: OFF]
    ~ voltage = voltage + 8
    ~ tumbler5 = false
+ {voltage != 9 and not tumbler5} [Capsule 5: on]
    ~ voltage = voltage - 8
    ~ tumbler5 = true
-
-> electropuzzle_solve


== cutscene1
>>> IMG gfx/out.png
The professor warned you that this is one way journey. Warned all of you, from the very start.
But the goal was worth it. To see with your own eyes what we were only dreaming of - who would abandon such a perspective? And you volunteered.
But why nobody greets you?

* [^] ->->
    
== storage_room
>>> CLEAR
VAR storage_door_open = false
VAR glass_cube_broken = false
VAR engine_room_open = false

{not cutscene1: -> cutscene1 -> storage_room}
{glass_cube_broken: Glass shards are scattered on the floor in the center of the room{not has_papers:, covering a few paper sheets}.|In the middle of the room a glass cube gleams dully.} Along the walls there are rows of monotonous metal boxes. {seen_boxes: There is a small manhole on the floor near you.}
{storage_door_open: Vault door is partially opened.|Big vault door is closed.}

- (storage_exam)
+ {not glass_cube_broken} [🔎 Glass cube]
    Under the glass were several pages of typed text. You are the one of those who made this document, so you know what is it about ...
    * * {has_wrench} [Break the cube with wrench]
        Loud sound of broken glass. The shards fell to the floor.
        ~ glass_cube_broken = true
    + + {not has_wrench} [Look around]
        You look around the room.

+ {glass_cube_broken and not (has_glass and has_papers)} [🔎 Shards of glass]
    The shards reflect the yellow light of the lamps. {not has_papers:A few paper sheets lie on the floor, covered with shards.}
    * * {not has_glass} [Take one of shards]
        You carefully pick up one of the shards from the floor.
        ~ has_glass = true
    *  * {not has_papers} [Take the papers]
        You pull the paper sheets from under the shard, fold them and put them in your pocket.
        ~ has_papers = true
* {has_papers} [🔎 Papers]
Several pages of typed text. For those who were supposed to meet us, they are of particular importance.

+ {not engine_room_open} [🔎 Boxes]
    The inscriptions on the boxes are unreadable. And you have neither the time nor the desire  to search them at random.
    {not has_wrench: Between the boxes is a adjustable wrench. You wonder who could drop it here?}
    There is a small manhole on the floor near you.
    - - (seen_boxes)
    * * [Take the wrench]
        You pick the wrench from the floor.
        ~ has_wrench = true
    * * {has_wrench} [Open the manhole with wrench]
        You lift the manhole, using the adjustable wrench as a lever, and push it aside.
        ~ engine_room_open = true
    * * {not has_wrench} [Pull the manhole cover]
        You pulled the cover handle, but it did't move even a bit. It's too heavy for you.


* {not storage_door_open} [🔎 Vault door]
    The vault is designed so that the door can only be opened from the outside. You need to find a way to open it from the inside.

* {has_tape && has_glass && not has_knife} [Coat the shard with tape]
    You carefully wrap the shard with electrical tape. Now you can use is as a knife, if necessary.
    ~ has_knife = true

* {storage_door_open} [Open the vault door]
    It seems that over the years the mechanisms have become unusable, and the door can not be fully opened.
    Cold wind blows from the dark gap between the doors.
    * * [Squeeze into the gap]
        The width of the gap is enough to allow you to squeeze through.
        -> stairs_room
+ {engine_room_open} [Go to manhole] -> engine_room
+ [Go to chamber] -> chamber_room
+ {stairs_room} [Exit the vault] -> stairs_room

-
-> storage_exam

== engine_room
>>> CLEAR
VAR used_cover = false

Engine room is small and narrow. Buzzing sound of machines supporting the work of the complex is very loud. At the stairs leading up, there is a control panel nearby. To the right of the console there is the valve of the control system of the storage door. {used_cover:The cladding is thrown on it.}
{not has_tape: On the floor there is a lightly dusted bundle of tape.}

- (engine_exam)
* [🔎 Control panel]
Most of the lights on the control panel are red. It seems that these machines will not last long.
* {not used_cover} [Turn the valve]
    - - (tried_vent)
    You grab the valve, and immediately pulled my hand away - the hot metal painfully burned your palm.
+ {tried_vent && has_cover} [Throw the cladding on the valve]
    You throw the cladding on the valve.
    ~ has_cover = false
    ~ used_cover = true
+ {used_cover} [Take the cladding off the valve]
    You take the cladding off the valve carefully, to avoid getting burn.
    ~ has_cover = true
    ~ used_cover = false
* {used_cover} [Turn the valve]
    You turn the valve until full stop. Something rumbles in the darkness behind the interlacing of pipes. Then you hear a rasping sound of the opening hermetic door from above.
    ~ storage_door_open = true
* {not has_tape} [Take the tape]
    You pick up the tape.
    ~ has_tape = true
* {has_tape && has_glass && not has_knife} [Wrap the shard with tape]
    You carefully wrap the shard with electrical tape. Now you can use is as a knife, if necessary.
    ~ has_knife = true
+ [Climb the ladder] -> storage_room
-
-> engine_exam

== stairs_room
>>> CLEAR
VAR has_warm = false

A beam of light from the gap of the vault doors illuminates a small room. You can see the daylight coming from the top of the stairwell. It is very cold in here.
- (stairs_exam)
* {not has_warm} [Go upstairs]
    You will inevitably freeze to death, if you try to go outside ...
* {not has_warm && has_knife && has_cover} [Slice the cladding]
    You slice the cladding into pieces and push them under your clothes.
    ~ has_cover = false
    ~ has_warm = true
* {not has_papers} [Go upstairs]
    You forgot to take the papers with you. They are really important.
* {has_warm and has_papers} [Go upstairs] -> cutscene2
+ [Return to vault] -> storage_room
-
-> stairs_exam

== cutscene2
>>> CLEAR
>>> IMG gfx/up.png
You climb the stairs and enter the large round hall. This is the place where you journey started a long time ago.
The hall was absolutely empty and, obviously, long abandoned. Everything that represented even the slightest value, was stolen. The mosaic on the walls fell in places, there were holes in the ceiling. The sun shines through these holes.

* [^] -> hall_room

== hall_room
You leave the hall and come to the circular gallery. And you are amazed by what you see there.

There is a stunning view behind the huge gallery windows. Snow lays on the hills, slightly covered with wood. And there, among the hills, the wind turbines go all way to horizon, their blades are slowly rotating. Lights of the nearby city shine bright.
 
- (hall_exam)
* [Look at the wind turbines]
    There are a few dozens of them. Looks like a picture from a fantastic novel.
    - - (seen_mills)
* [Look at the city]
    The city has changed a lot over the years. There are new quarters with a lot of high-rise buildings.
    - - (seen_city)
* {seen_mills && seen_city} [Go outside] -> cutscene_end
-
-> hall_exam

== cutscene_end
>>> CLEAR
>>> IMG gfx/monument.png
Half-hour descent down from the hill was tiring for you, so you stop to rest near the grass-covered monument and take a final look at the building where you spent so many years. A time capsule. One of its kind.

* [^]
    You were chosen to deliver the message from the past generations. To tell about interesting and uneasy time you were living in. And even the reason why the capsule was abandoned is no longer bothering you. What you saw from above gives you hope.

    * * [^] -> finale

== finale
>>> CLEAR
>>> IMG gfx/finale.png
Hope to see with your own eyes the very thing for which you went through this long and difficult journey.
* Future.
    * * Bright future.
        * * * Bright communist future.
            <br><blockquote><i>We know our time is interesting, but yours is much more so. We are building communism and you live it. We believe that you have perfectly equipped our blue planet, colonised the Moon, landed on Mars; that you are continuing the exploration of outer space that we, people of the first 50 years, have begun, and that your ships are sailing across the galaxy. We believe that the work that our fathers and grandfathers started 50 years ago and which we share, you will finish and bring to victory.</i><br><p style="text-align: right">An excerpt from letter found in real<br/> time capsule, planted in 1967 in the wall<br/>of the House of Culture in Novosibirsk</p></blockquote>

-> DONE
