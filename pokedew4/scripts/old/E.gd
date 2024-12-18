class_name E

enum types {Normal, Fire, Water, Flying, Grass, Electric, Dark, Fairy, Ghost, Psychic, Fighting, Bug, Dragon, Ice, Steel, Poison, Ground, Rock}
enum flavors {Spicy,Sour,Dry,Umami,Sweet,Bitter}
enum abilities{Stench, Drizzle, SpeedBoost,BattleArmor,Sturdy,Damp,Limber,SandVeil,Static,VoltAbsorb,Oblivious,CloudNine,CompoundEyes,Insomnia,ColorChange,Immunity,FlashFire,ShielfDust,OwnTempo,SuctionCups,Intimidate,ShadowTag,RoughSkin,WonderGuard,Levitate,EffectSpore,Synchronize,ClearBody,NaturalCure,LightningRod,SereneGrace,SwiftSwim,Chlorophyll,Illuminate,Trace,HugePower,PoisonPoint,InnerFocus,MagmaArmor,WaterVeil,MagnetPull,Soundproof,RainDish,SandStream,Pressure,ThickFat,EarlyBird,FlameBody,RunAway,KeenEye,HyperCutter,Pickup,Truant,Hustle,CuteCharm,Plus,Minus,Forecast,StickyHold,ShedSkin,Guts,MarvelScale,LiquidOoze,Overgrow,Blaze,Torrent,Swarm,RockHead,Drought,ArenaTrap,VitalSpirit,WhiteSmoke,PurePower,ShellArmor,AirLock,TangledFeet,MotorDrive,Rivalry,Steadfast,SnowCloak,Sluttony,AngerPoint,Unburden,Heatproof,Simple,DrySkin,Download,IronFist,PoisonHeal,Adaptability,SkillLink,Hydration,SolarPower,QuickFeet,Normalize,Sniper,MagicGuard,NoGuard,Stall,Technician,LeafGuard,Klutz,MoldBreaker,SuperLuck,Aftermath,Anticipation,Forewarn,Unaware,TintedLens,Filter,SlowStart,Scrappy,StormDrain,IceBody,SolidRock,SnowWarning,HoneyGather,Frisk,Reckless,Multitype,FlowerGift,BadDreams}
enum forage_areas{Forest,Cave,Water,Coast}
enum skills{Farm,Mine,Forage,Perform,Cook,Chemistry,Craft,Water,Fire,Ice,Electric,Fishing,Fighting}
enum likes{Farm,Mine,Forage,Perform,Cook,Chemistry,Fight,Music,Reading,Dark,Water,Fire,Foliage,Sleep,Sweet,Sour,Bitter,Spicy,Dry,Umami,Brush,Electric,Fishing,PainKillers,Meditation,Mud,Seafood,Mushrooms,Polish,ChewToy,Macabre,Books,Craft,Run,Art,Magician}
enum tasks{Farm, Mine, Forage, Perform, Cook, Chemistry, Fight, Rest}
enum control {MOVE,BATTLE,MENU}
enum stats{HP,Attack,Def,SpA,SpD,Speed,Acc,Evasion,Crit,Farm,Mine,Craft,Forage,Cook,Perform,Fishing,Energy,WorkSpeed,InvSize}
enum statuses {NULL,BRN,PRLZ,SLEEP,PSN,FRZ,CONF,CURSE,TOXIC,ALL}
enum perfs {Music,Fighting,Art,Magician}

static func get_like(like:likes):
	match like:
		likes.Farm: return "Farming"
		likes.Mine: return "Digging"
		likes.Forage: return "Foraging"
		likes.Perform: return "Performing"
		likes.Cook: return "Cooking"
		likes.Chemistry: return "Chemistry"
		likes.Fight: return "Fighting"
		likes.Music: return "Performance: Music"
		likes.Reading: return "Reading"
		likes.Dark: return "Environment: Dark"
		likes.Water: return "Environment: Water"
		likes.Fire: return "Environment: Fire"
		likes.Foliage: return "Environment: Foliage" 
		likes.Sleep: return "Rest" 
		likes.Sweet: return "Flavor: Sweet"
		likes.Sour: return "Flavor: Sour"
		likes.Bitter: return "Flavor: Bitter"
		likes.Spicy: return "Flavor:Spicy"
		likes.Dry: return "Flavor:Dry"
		likes.Umami: return "Flavor:Umami"
		likes.Brush: return "Brushing"
		likes.Electric: return "Environment: Electricity"
		likes.Fishing: return "Fishing"
		likes.PainKillers: return "Painkillers"
		likes.Meditation: return "Meditation"
		likes.Mud: return "Environment: Mud"
		likes.Seafood: return "Food:Seafood"
		likes.Mushrooms: return "Food:Mushrooms"
		likes.Polish: return "Polish"
		likes.ChewToy: return "Chewtoy"
		likes.Macabre: return "Environment: Macabre"
		likes.Craft: return "Crafting"
		likes.Run:return "Running"

static func like_to_skill(like:likes):
	match like:
		likes.Farm: return skills.Farm
		likes.Forage: return skills.Forage
		likes.Mine:return skills.Mine
		likes.Cook:return skills.Cook
		likes.Craft:return skills.Craft
		likes.Fight: return skills.Fighting
		likes.Perform: return skills.Perform
