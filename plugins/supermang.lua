-- تـم التعديـل والتعريب بواسطه @Sudo_Sky
-- supermang.lua
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '*انـت لسـت مطـور البوت🐸💔*'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '*الحمايه بالفعـل مفعـله هنـا ✔️\n:['..msg.to.title..']*'
end
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "creator" then
if v.user.username then
creator_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = check_markdown(v.user.first_name)
end
end
end
        -- create data array in moderation.json
      data[tostring(msg.to.id)] = {
              owners = {[tostring(creator_id)] = user_name},
      mods ={},
      banned ={},
      is_silent_users ={},
      filterlist ={},
      settings = {
          set_name = msg.to.title,
          lock_link = 'yes',
          lock_tag = 'yes',
          lock_spam = 'yes',
          lock_edit = 'no',
          lock_mention = 'no',
          lock_webpage = 'no',
          lock_markdown = 'no',
          flood = 'yes',
          lock_bots = 'yes',
          lock_pin = 'no',
          welcome = 'no',
		  lock_join = 'no',
		  lock_arabic = 'no',
		  num_msg_max = '5',
		  set_char = '40',
		  time_check = '2'
          },
   mutes = {
                  mute_forward = 'no',
                  mute_audio = 'no',
                  mute_video = 'no',
                  mute_contact = 'no',
                  mute_text = 'no',
                  mute_photo = 'no',
                  mute_gif = 'no',
                  mute_location = 'no',
                  mute_document = 'no',
                  mute_sticker = 'no',
                  mute_voice = 'no',
                   mute_all = 'no',
				   mute_tgservice = 'no'
          }
      }
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
  return '*تـم تفعـيل الحمـايه هنـا ✔️\n:['..msg.to.title..']*'
  end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '*انـت لست ادمـن هنـا🐸💔*'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '*الحمايـه بالفعـل معطـله❌*'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '*الحمايـه تـم تعطـيلها✖️*'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "*لا يـوجد ادمنـيه هنـا👮🏻✖️*"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return "*لا يـوجد ادمنـيه هنـا👮🏻✖️*"
end
   message = '*قائمـه الادمنيه👮🏻📝 :*\n\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return '*الحمايـه بالفعـل معطـله❌*'
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "*لا يـوجد مدراء هنـا👮🏻✖️*"
end
   message = '*قائمه المدراء👮🏻📝 :*\n\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
        return "*الكلمـه* *["..word.."]* *مضافه الى الممنوعات بالفعل✔️*"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
      return "*الكلمـه* *["..word.."]* *تـم اضافتـها الى الممنوعات✔️*"
    end

local function unfilter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
        return "*الكلـمه* *["..word.."]* *تـم ازالتـها من الممنوعات✖️*"
    else
        return "*الكلمـه* *["..word.."]* *مزالـه من الممنوعات بالفعل✖️*"
    end
  end

local function lock_link(msg, data, target)
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "*الروابـط بالفعـل مقفـله هنـا🔐✔️*"
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الروابـط هنـا🔐✔️*"
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "*الروابـط بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح الروابـط هنـا🔓✔️*" 
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "*التـاك بالفعـل مقفـول هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل التـاك هنـا🔐✔️*"
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "*التـاك بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح التـاك هنـا🔓✔️*" 
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "*الشـارحه بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "*تـم قفـل الشـارحه هنـا🔐✔️*"
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "*الشـارحه بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح الشـارحه هنـا🔓✔️*"
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "*العـربيه بالفعـل مقفـله هنـا🔐✔️*"
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل العربـيه هنـا🔐✔️*"
end
end

local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "*العربـيه بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح العربيـه هنـا🔓✔️*" 
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "*التعديـل بالفعـل مقفـل هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل التعديـل هنـا🔐✔️*"
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "*التعديـل بالفعـل مفـتوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح التعديـل هنـا🔓✔️*" 
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "*الكلايش بالفعـل مقفـوله هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الكلايـش هنـا🔐✔️*"
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "*الكلايـش بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
return "*تـم فتـح الكلايـش هنـا🔓✔️*" 
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
 return "*التكـرار بالفعـل مقفـل هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل التكـرار هنـا🔐✔️*"
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
return "*التكـرار بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح التكـرار هنـا🔓✔️*" 
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "*البـوتات بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل البوتـات هنـا🔐✔️*"
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "*البـوتات بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح البـوتات هنـا🔓✔️*" 
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
 return "*الدخـول بالفعـل مقفـوله هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الدخـول هنـا🔐✔️*"
end
end

local function unlock_join(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
return "*الدخـول بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
return "*تـم فـتح الدخـول هنـا🔓✔️*" 
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*الماركدون بالفعـل مقفـول هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الماركـدون هنـا🔐✔️*"
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*المـاركدون بالفعـل مفتـوح هنـا🔓✔️*"
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "*تـم فتـح الماركـدون هنـا🔓✔️*"
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "*الويـب بالفعـل مقغـول هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الويـب هنـا🔐✔️*"
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "*الويـب بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "*تـم فتـح الويـب هنـا🔓✔️*" 
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "*التثبيـت بالفعـل مقفـول هنـا🔐✔️*"
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "*تـم قفـل التثبـيت هنـا🔐✔️*"
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "*التثبيـت بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "*تـم فـتح التثبـيت هنـا🔓✔️*" 
end
end

function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "*لاتبعبص🐸💔*"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "*🚩اعدادات المجموعه🛠*\n*🔹- - - - - - - - - - - -  - - - - -🔹*\n*🚩|التعديل :* *"..settings.lock_edit.."*\n*🚩|الروابط :* *"..settings.lock_link.."*\n*🚩|التاك :* *"..settings.lock_tag.."*\n*🚩|الدخول :* *"..settings.lock_join.."*\n*🚩|التكرار :* *"..settings.flood.."*\n*🚩|الكلايش :* *"..settings.lock_spam.."*\n*🚩|الشارحه :* *"..settings.lock_mention.."*\n*🚩|العربيه :* *"..settings.lock_arabic.."*\n*🚩|الويب :* *"..settings.lock_webpage.."*\n*🚩|الماركدون :* *"..settings.lock_markdown.."*\n*🚩|الترحيب :* *"..settings.welcome.."*\n*🚩|التثبيت :* *"..settings.lock_pin.."*\n*🚩|البوتات :* *"..settings.lock_bots.."*\n*🚩|عدد التكرار :* *"..settings.num_msg_max.."*\n*🚩|عدد التكرار بالوقت :* *"..settings.set_char.."*\n*🚩|عدد التكرار بالاحرف :* *"..settings.time_check.."*\n*🔹- - - - - - - - - - - -  - - - - -🔹*\n*CH📡 - @XxMTxX*"
text = string.gsub(text, 'yes', '✔️')
text = string.gsub(text, 'no', '✖️')
text = string.gsub(text, '0', '0')
text = string.gsub(text, '1', '1')
text = string.gsub(text, '2', '2')
text = string.gsub(text, '3', '3')
text = string.gsub(text, '4', '4')
text = string.gsub(text, '5', '5')
text = string.gsub(text, '6', '6')
text = string.gsub(text, '7', '7')
text = string.gsub(text, '8', '8')
text = string.gsub(text, '9', '9')
return text
end

--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return "*لاتبعبص🐸💔*"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "*الكـل بالفعـل مقفـول هنـا🔐✔️*" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "*تـم قفـل الكـل هنـا🔐✔️*" 
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "*لاتبعبص🐸💔*"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "*الكـل بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الكـل هنـا🔓✔️*"  
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "*المتـحركه بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل المتحـركه هنـا🔐✔️*"
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "*المتحـركه بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح المتـحركه هنـا🔓✔️*" 
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "*الدردشـه بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الدردشـه هنـا🔐✔️*"
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "*الدردشـه بالفعـل مفـتوحه هنـا🔓✔️*"
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فـتح الدردشه هنـا🔓✔️*" 
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "*الصـور بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الصـور هنـا🔐✔️*"
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "*الصـور بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الصـور هنـا🔓✔️*" 
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "*الفيديـو بالفعـل مقفـل هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "*تـم قفـل الفيديـو هنـا🔐✔️*"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "*الفيديـو بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الفيديـو هنـا🔓✔️*" 
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "*الصـوت بالفعـل مقفـول هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الصـوت هنـا🔐✔️*"
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "*الصـوت بالفعـل مفـتوح هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "*تـم فتـح الصـوت هنـا🔓✔️*"
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
return "*الاغانـي بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الاغانـي هنـا🔐✔️*"
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "*الاغانـي بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "*تـم فتـح الاغانـي هنـا🔓✔️*" 
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "*الملصـقات بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الملصقـات هنـا🔐✔️*"
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "*الملصـقات بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
return "*تـم فتـح الملصقـات هنـا🔓✔️*" 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "*الجهـات بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الجهـات هنـا🔐✔️*"
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "*الجهـات بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الجهـات هنـا🔓✔️*" 
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "*لاتبعبص🐸💔*"
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "*التوجـيه بالفعـل مقفـول هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل التوجيـه هنـا🔐✔️*"
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "*التوجيـه بالفعـل مفتـوح هنـا🔓✔️*"
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
return "*تـم فتـح التوجيـه هنـا🔓✔️*" 
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "*الموقـع بالفعـل مقفـل هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "*تـم قفـل الموقـع هنـا🔐✔️*"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "*الموقـع بالفعـل مفتـوح هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الموقـع هنـا🔓✔️*" 
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "*الملفـات بالفعـل مقفـله هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الملفـات هنـا🔐✔️*"
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "*الملفـات بالفعـل مفتـوحه هنـا🔓✔️*" 
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الملفـات هنـا🔓✔️*" 
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "*الانلايـن بالفعـل مقفـل هنـا🔐✔️*"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*تـم قفـل الانلايـن هنـا🔐✔️*"
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "*الانلايـن بالفعـل مفتـوح هنـا🔓✔️*"
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "*تـم فتـح الانلايـن هنـا🔓✔️*"
end
end

----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
return "*لاتبعبص🐸💔*"
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
text = "*🚩اعدادات الوسائط🌅*\n*🔹- - - - - - - - - - - - - - - - - -🔹*\n*🚩|الكل : * *"..mutes.mute_all.."*\n*🚩|المتحركه :* *"..mutes.mute_gif.."*\n*🚩|الدردشه :* *"..mutes.mute_text.."*\n*🚩|الصور :* *"..mutes.mute_photo.."*\n*🚩|الفيديو :* *"..mutes.mute_video.."*\n*🚩|الصوت :* *"..mutes.mute_audio.."*\n*🚩|الاغاني :* *"..mutes.mute_voice.."*\n*🚩|الملصقات :* *"..mutes.mute_sticker.."*\n*🚩|الجهات :* *"..mutes.mute_contact.."*\n*🚩|التوجيه :* *"..mutes.mute_forward.."*\n*🚩|الموقع :* *"..mutes.mute_location.."*\n*🚩|الملفات :* *"..mutes.mute_document.."*\n*🚩|الانلاين :* *"..mutes.mute_tgservice.."*\n*🔹- - - - - - - - - - - - - - - - - -🔹*\n*📡 CH -@XxMTxX*"
text = string.gsub(text, 'yes', '✔️')
text = string.gsub(text, 'no', '✖️')
 return text
end

local function Falcon(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------Begin Msg Matches--------------
if matches[1] == "فعل" and is_admin(msg) then
return modadd(msg)
   end
if matches[1] == "عطل" and is_admin(msg) then
return modrem(msg)
   end
if matches[1] == "المدراء" and is_mod(msg) then
return ownerlist(msg)
   end
if matches[1] == "قائمه المنع" and is_mod(msg) then
return filter_list(msg)
   end
if matches[1] == "الادمنيه" and is_mod(msg) then
return modlist(msg)
   end
if matches[1] == "whitelist" and is_mod(msg) then
return whitelist(msg.to.id)
   end
if matches[1] == "معلومات" and matches[2] and (matches[2]:match('^%d+') or matches[2]:match('-%d+')) and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt = '', '', '', ''
		local user = getUser(matches[2])
		if not user.result then
			return '*لا تـوجد معلـومات📝❌*'  
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '---'

		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		local text = '*🚩|المعرف : '..usr_name..' \n🚩|الاسم الاول : '..fst_name..' \n🚩|الاسم الثاني : '..lst_name..' \n🚩|البايو : *'..biotxt
		return text
end
if matches[1] == "معلومات" and matches[2] and not matches[2]:match('^%d+') and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, UID = '', '', '', '', ''
		local user = resolve_username(matches[2])
		if not user.result then
			return '*لاتـوجد معلـومات📝❌*'
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '*رجاءاُ اعد المحاولـه🔄*'
			return usr_name
		end
		if user.lastname then
			lst_name = escape_markdown(user.lastname)
		else
			lst_name = '---'
		end
		if user.firstname then
			fst_name = escape_markdown(user.firstname)
		else
			fst_name = '---'
		end
		if user.id then
			UID = user.id
		else
			UID = '---'
		end
		if user.bio then
			biotxt = escape_markdown(user.bio)
		else
			biotxt = '---'
		end
		local text = '*🚩|المعرف : '..usr_name..' \n🚩|الايدي : '..UID..'\n🚩|الاسم الاول : '..fst_name..' \n🚩|الاسم الثاني : '..lst_name..' \n🚩|البايو : *'..biotxt
		return text
end
if matches[1] == 'الاصدار' then
return _config.info_text
end
if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, '🚩|ايدي المجموعه : '..msg.to.id..'\n🚩|ايديك : '..msg.from.id.. "\n🔹- - - - - - - - - - - - - - - - -🔹\n📡 ᴄʜ - @XxMTxX")
	else
   return "*🚩|ايدي المجموعه :*"..tostring(msg.to.id).."*🚩|ايديك :*"..tostring(msg.from.id)..""
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return '*لـم يتـم ايجاد المستـخدم👤❌*'
		end
     return "`"..status.information.id.."`"
   elseif matches[2] == "from" and msg.reply_to_message and msg.reply.fwd_from then
     return "`"..msg.reply.fwd_from.id.."`"
   end
end
if matches[1] == "ثبت" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*تـم تثبيـت الرسالـه📌✔️*"
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "*تـم تثبيـت الرسالـه📌✔️*"
end
end
if matches[1] == 'الغاء تثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "*تـم الغاء التثبيـت📌✖️*"
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "*تـم الغاء التثبيـت📌✖️*"
end
end
if matches[1] == 'اعدادات الوسائط' then
return mutes(msg, target)
end
if matches[1] == 'الاعدادات' then
return group_settings(msg, target)
end
   if matches[1] == "رفع مدير" and is_admin(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "*المستـخدم* `[`"..username.."`]`\n *تـم رفعـه مديـر بالفعـل👮🏻✔️*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "*المستـخدم* `[`"..username.."`]`\n *تـم رفعـه مديـر👮🏻✔️*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "*المستـخدم* "..user_name.." "..matches[2].."\n *تـم رفعـه مديـر بالفعـل👮🏻✔️*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "*المستـخدم* "..user_name.." "..matches[2].."\n *تـم رفعـه مديـر👮🏻✔️*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم رفعـه مديـر بالفعـل👮🏻✔️*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم رفعـه مديـر👮🏻✔️*"
   end
end
end
   if matches[1] == "تنزيل مدير" and is_admin(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "*المستـخدم* `[`"..username.."`]`\n *بالفعـل تـم تنزيلـه عضـو👮🏻✖️*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "*المستـخدم* `[`"..username.."`]`\n *تـم تنزيلـه الى عضـو👮🏻✖️*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "*المستخـدم* "..user_name.." "..matches[2].."\n *بالفعـل تـم تنزيلـه الى عضو👮🏻✖️*"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "*المسـتخدم* "..user_name.." "..matches[2].."\n *تـم تنزيلـه الى عضـو👮🏻✖️*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *بالفعـل تـم تنزيـله الى عضـو👮🏻✖️*"
    else 
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم تنزيلـه الى عضـو👮🏻✖️*"
      end
end
end
   if matches[1] == "رفع ادمن" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "*المستـخدم* `[`"..username.."`]`\n *تـم رفعـه ادمـن بالفعـل👷🏻✔️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "*المستخـدم* `[`"..username.."`]`\n *تـم رفعـه ادمـن👷🏻✔️*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "*المسـتخدم* "..user_name.." "..matches[2].."\n *تـم رفعـه ادمـن بالفعـل👷🏻✔️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "*المسـتخدم* "..user_name.." "..matches[2].."\n *تـم رفعـه ادمـن👷🏻✔*"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم رفعـه ادمـن بالفعـل👷🏻✔️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم رفعـه ادمـن👷🏻✔️*"
   end
end
end
   if matches[1] == "تنزيل ادمن" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "*المستـخدم* `[`"..username.."`]`\n *بالفعـل تـم تنزيلـه الى عضـو👷🏻✖️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "*المستـخدم* `[`"..username.."`]`\n *تـم تنزيلـه الى عضـو👷🏻✖️*"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "*المستـخدم* "..user_name.." "..matches[2].."\n *بالفعـل تـم تنزيلـه الى عضـو👷🏻✖️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "*المسـتخدم* "..user_name.." "..matches[2].."\n *تـم تنزيلـه الى عضـو👷🏻✖️*"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "*المستـخدم غيـر موجـود👤❌*"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *بالفعـل تـم تنزيلـه الى عضـو👷🏻✖️*"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "*المستـخدم* @"..check_markdown(status.username).." "..status.id.."\n *تـم تنزيلـه الى عضو👷🏻✖️*"
      end
end
end
   if matches[1] == "whitelist" and matches[2] == "+" and is_mod(msg) then
   if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _added to_ *white list*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_User_ "..user_name.." `"..matches[3].."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = user_name
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[3].."` _added to_ *white list*"
   end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[3]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is already in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _added to_ *white list*"
   end
end
end
   if matches[1] == "whitelist" and matches[2] == "-" and is_mod(msg) then
      if not matches[3] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "_User_ "..username.." `"..msg.reply.id.."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..username.." `"..msg.reply.id.."` _removed from_ *white list*"
      end
	  elseif matches[3] and matches[3]:match('^%d+') then
  if not getUser(matches[3]).result then
   return "*User not found*"
    end
	  local user_name = '@'..check_markdown(getUser(matches[3]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[3]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] then
    return "_User_ "..user_name.." `"..matches[3].."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[3])] = nil
    save_data(_config.moderation.data, data)
    return "_User_ "..user_name.." `"..matches[3].."` _removed from_ *white list*"
      end
   elseif matches[3] and not matches[3]:match('^%d+') then
  if not resolve_username(matches[3]).result then
   return "*User not found*"
    end
   local status = resolve_username(matches[3]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _is not in_ *white list*"
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_User_ @"..check_markdown(status.username).." `"..status.id.."` _removed_ *white list*"
      end
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "الروابط" then
return lock_link(msg, data, target)
end
if matches[2] == "التاك" then
return lock_tag(msg, data, target)
end
if matches[2] == "الشارحه" then
return lock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return lock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return lock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return lock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return lock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return lock_bots(msg, data, target)
end
if matches[2] == "الماركدون" then
return lock_markdown(msg, data, target)
end
if matches[2] == "الويب" then
return lock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return lock_join(msg, data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "الروابط" then
return unlock_link(msg, data, target)
end
if matches[2] == "التاك" then
return unlock_tag(msg, data, target)
end
if matches[2] == "الشارحات" then
return unlock_mention(msg, data, target)
end
if matches[2] == "العربيه" then
return unlock_arabic(msg, data, target)
end
if matches[2] == "التعديل" then
return unlock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return unlock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return unlock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "الماركدون" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "الويب" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "الدخول" then
return unlock_join(msg, data, target)
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "المتحركه" then
return mute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return mute_text(msg ,data, target)
end
if matches[2] == "الصور" then
return mute_photo(msg ,data, target)
end
if matches[2] == "الفيديو" then
return mute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return mute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return mute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return mute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return mute_forward(msg ,data, target)
end
if matches[2] == "الموقع" then
return mute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return mute_document(msg ,data, target)
end
if matches[2] == "الانلاين" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'الكل' then
return mute_all(msg ,data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "المتحركه" then
return unmute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return unmute_text(msg, data, target)
end
if matches[2] == "الصور" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "الفيديو" then
return unmute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "الموقع" then
return unmute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return unmute_document(msg ,data, target)
end
if matches[2] == "الانلاين" then
return unmute_tgservice(msg ,data, target)
end
 if matches[2] == 'الكل' then
return unmute_all(msg ,data, target)
end
end
  if matches[1] == 'منع' and matches[2] and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'الغاء منع' and matches[2] and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'رابط جديد' and is_mod(msg) then
  local administration = load_data(_config.moderation.data)
  local link = exportChatInviteLink(msg.to.id)
	if not link then
		return "*البوت ليـس اداري❌*"
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		return "*تـم حفـظ الرابـط✔️*"
	end
   end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '*قـم بأرسال الرابـط الان⛓*'
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "*تـم حفـظ الرابـط⛓✔️*"
       end 
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "*لايـوجد رابـط للمجمـوعه\nقم بأرسال ضع رابـط وقم بأرسال\nالرابط ليتـم حفظه🔄*"
      end
       text = "[🚩اضغـط هنـا للدخول للمجمـوعه { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
        return text
     end
  if matches[1] == "ضع قوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "*تـم تعييـن القـوانين هنـا📝✔️*"
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
     rules = "*🚩 القوانيـن :\n\n🚩|عـدم عمـل توجيه للمجموعه\n🚩|عـدم الشتـم والغلـط\n🚩|عـدم التجاوز بالكلام\n🚩|لا تطلب الادمنيه المتفاعل يرفع ادمن\n🚩|عـدم ارسـال الروابـط هنـا*\n*🔹- - - - - - - - - - - - - - - - -🔹*\n *CH - @XxMTxX*"
        else
     rules = "*🚩|القوانين :*\n\n"..data[tostring(target)]['rules']
      end
    return rules
  end
		if matches[1]:lower() == 'ضع تكرار' then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
     return "*تـم تعيـين التكـرار للعـدد✔️ :* *[ "..matches[2].." ]*"
  end 
  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "*[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "*تـم تعيـين التكـرار للعـدد✔️ :* *[ "..matches[2].." ]*"
       end
  if matches[1]:lower() == 'ضع تكرار بالوقت' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "*[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "*تـم تعيـين التكرار للوقـت✔️ :* *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'مسح' and is_owner(msg) then
			if matches[2] == 'الادمنيه' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "*بالفعـل تـم مسـح قائمـه الادمنيه👷🏻❌*"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*تـم مسـح قائمـه الادمنيـه👷🏻❌*"
         end
			if matches[2] == 'قائمه المنع' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "*بالفعـل تـم مسـح قائمه الممنوعات✔️*"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*تـم مسـح قائمـه الممنوعـات✔️*"
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "*بالفعـل تـم مسـح القوانيـن📝❌*"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "*تـم مسـح القوانـين📝❌*"
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "*بالفعـل تـم مسـح التـرحيب✔️*"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "*تـم مسـح التـرحيب✔️*"
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "*لايـوجد وصـف هنـا✖️*"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "*تـم مسـح الوصـف✔️*"
		   	end
        end
		if matches[1]:lower() == 'مسح' and is_admin(msg) then
			if matches[2] == 'المدراء' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
				return "*لايـوجد مدراء هنـا👮🏻✖️*"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*تـم مسـح جمـيع المدراء👮🏻❌*" 
			end
     end
if matches[1] == "ضع اسم" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
setChatTitle(msg.to.id, gp_name)
end
if matches[1] == 'ضع صوره' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
     if not msg.caption and not msg.reply_to_message then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '*قـم بأرسال الصـوره الان🔄*'
     elseif not msg.caption and msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*تـم حفـظ الصـوره🌅✔️*"
     elseif msg.caption and not msg.reply_to_message then
if msg.photo then
if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "*تـم حفـظ الصـوره🌅✔️*"
		end
  end
if matches[1] == "حذف صوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "*تـم مسـح الصـوره🌅❌*"
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "*تـم وضـع وصـف للمجمـوعه✔️*"
  end
  if matches[1] == "about" and msg.to.type == "group" then
 if not data[tostring(msg.to.id)]['about'] then
     about = "_No_ *description* _available_"
        else
     about = "*Group Description :*\n"..data[tostring(chat)]['about']
      end
    return about
  end
if matches[1] == "حذف" and is_mod(msg) then
del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
   end
if matches[1] == "رفع الادمنيه" and is_owner(msg) then
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "administrator" then
if v.user.username then
admins_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = escape_markdown(v.user.first_name)
      end
  data[tostring(msg.to.id)]['mods'][tostring(admins_id)] = user_name
    save_data(_config.moderation.data, data)
    end
  end
    return "*تـم رفـع كل الادمنيه للبـوت👷🏻✔️*"
end
if matches[1] == 'rmsg' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "*Wrong Number !*\n*Number Should be Between* 1-100 *Numbers !*"
end
print(num)
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
end
--------------------- Welcome -----------------------
	if matches[1] == "ترحيب" and is_mod(msg) then
	 if matches[2] == "تفعيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "yes" then
				return "*بالفعـل تـم تشـغيل الترحيب✔️*"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "*تـم تشغيـل الترحيـب✔️*"
			end
		end
		
		if matches[1] == "تعطيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "*بالفعـل تـم تعطيـل الترحيـب✖️*"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "*تـم تعطيـل الترحيـب✖️*"
			end
		end
	end
	if matches[1] == "ضع ترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "*تـم وضـع التحريـب للمجمـوعه✔️*\n\n"..matches[2].."\n*🔹- - - - - - - - - - - - - - - - -🔹*\n*CH - @XxMTxX*"
	end
-------------Help-------------
  if matches[1] == "الاوامر" and is_mod(msg) then
    local text = [[*🚩 اوامر البــوت 🚩
🔹- - - - - - - - - - - - - - - - -🔹
🚩| قفـل + الامر - للقفل
🚩| فتح + الامر - للفتـح
& - - - - - - - - - - - - - - - - &
🚩| الروابط - التاك - الشارحه
🚩| التعديل - التكرار - الكلايش
🚩| البوتات - الماركدون - التثبيـت
🚩| الدخـول - العربيه - الويب
& - - - - - - - - - - - - - - - - &
🚩| الصور - الدردشه - المتحركه
🚩| الصوت - الاغاني - الفيديو
🚩| الجهات - الملصقات - الكل
🚩| التوجيه - الملفات - الموقع - الانلاين
& - - - - - - - - - - - - - - - - &
🚩| كتم - الغاء كتم - قائمه الكتم
🚩| حظر - الغاء حظر - قائمه الحظر
🚩|حذف + رد لحذف رساله
🚩| طرد - ايدي - معلومات + ايدي
🚩| ضع تكرار + عدد 
🚩| ضع تكرار بالوقت + عدد
🚩| تثبيت + رد لتثبيت رساله
🚩| حظر الكل - الغاء حظر الكل
🔹- - - - - - - - - - - - - - - - -🔹
🚩| ارسل - اوامر المطور لعرضها
- - - - - - - - - - -
CH - @XxMTxX
*]]
    return text
  end
----------------End Msg Matches--------------
end
local function pre_process(msg)
-- print(serpent.block(msg, {comment=false}))
local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
    if msg.photo then
  if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
     end
		send_msg(msg.to.id, "*تـم وضـع صوره للمجمـوعه🌅✔️*", msg.id, "md")
  end
	local url , res = http.request('http://api.beyond-dev.ir/time/')
          if res ~= 200 then return "No connection" end
      local jdat = json:decode(url)
		local data = load_data(_config.moderation.data)
 if msg.newuser then
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		wlc = data[tostring(msg.to.id)]['settings']['welcome']
		if wlc == "yes" and tonumber(msg.newuser.id) ~= tonumber(bot.id) then
    if data[tostring(msg.to.id)]['setwelcome'] then
     welcome = data[tostring(msg.to.id)]['setwelcome']
      else
     welcome = "*Welcome Dude*"
     end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@XxMTxX"
end
if msg.newuser.username then
user_name = "@"..check_markdown(msg.newuser.username)
else
user_name = ""
end
		welcome = welcome:gsub("{rules}", rules)
		welcome = welcome:gsub("{name}", escape_markdown(msg.newuser.print_name))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{time}", jdat.ENtime)
		welcome = welcome:gsub("{date}", jdat.ENdate)
		welcome = welcome:gsub("{timefa}", jdat.FAtime)
		welcome = welcome:gsub("{datefa}", jdat.FAdate)
		welcome = welcome:gsub("{gpname}", msg.to.title)
		send_msg(msg.to.id, welcome, msg.id, "md")
        end
		end
	end
 if msg.newuser then
 if msg.newuser.id == bot.id and is_admin(msg) then
 local data = load_data(_config.moderation.data)
  if not data[tostring(msg.to.id)] then
   modadd(msg)
   send_msg(msg.to.id, '*المجمـوعه* *['..msg.to.title..']*\n *راسـل المطـور ليـتم تفعيلـها معرفه @Sudo_Sky*', msg.id, "md")
      end 
    end
  end
end
return {
  patterns = {
    "^(الاوامر)$",
    "^(فعل)$",
    "^(عطل)$",
    "^(الترحيب فعل)$",
    "^(الترحيب عطل)$",
    "^(رفع الادمنيه)$",
    "^(رفع مدير)$",
    "^(تنزيل مدير)$",
    "^(رفع مدير) (.*)$",
    "^(تنزيل مدير) (.*)$",
    "^(رفع ادمن)$",
    "^(تنزيل ادمن)$",
    "^(رفع ادمن) (.*)$",
	"^(تنزيل ادمن) (.*)$",
	"^[!/](whitelist) ([+-])$",
	"^[!/](whitelist) ([+-]) (.*)$",
	"^[!/](whitelist)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(قفل) (.*)$",
	"^(فتخ) (.*)$",
	"^(الاعدادات)$",
	"^(اعدادات الوسائط)$",
	"^(منع) (.*)$",
	"^(الغاء منع) (.*)$",
    "^(قائمه المنع)$",
    "^(المدراء)$",
    "^(الادمنيه)$",
    "^(حذف)$",
	"^(ضع قوانين) (.*)$",
    "^(القوانين)$",
    "^(ضع رابط)$",
    "^(الرابط)$",
	"^(رابط جديد)$",
    "^(ضع صوره)$",
    "^(حذف صوره)$",
    "^(ايدي)$",
    "^(ايدي) (.*)$",
	"^(معلومات) (.*)$",
	"^(مسح) (.*)$",
	"^(ضع اسم) (.*)$",
	"^(الترحيب) (.*)$",
	"^(ضع ترحيب) (.*)$",
	"^(ثبت)$",
    "^(الغاء تثبيت)$",
    "^[!/](about)$",
	"^(ضع وصف) (.*)$",
    "^(ضع تكرار) (%d+)$",
    "^(ضع تكرار) (%d+)$",
    "^(ضع تكرار وقت) (%d+)$",
    "^(معلومات) (.*)$",
    "^[!/](rmsg) (%d+)$",
 "^(الاصدار)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$",
    },
  run = Falcon,
  pre_process = pre_process
}
-- تـم التعديـل والتعريب بواسطه @Sudo_Sky
-- supermang.lua
