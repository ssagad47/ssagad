-- تـم التعديـل والتعريب بواسطه @Sudo_Sky
-- supermang.lua
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '\n🔖┆انت لست مطور البوت┆❓'..msg.from.username..'@'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '💡┆تـم بلفعل تفعیل البوت في┆👮️️️\n✔️┆المجموعة┆🚸\n'..msg.from.id..''
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
  return '💡┆تـم تفعیل البوت في┆👮️️️\n✔️┆المجموعة┆🚸\n'..msg.from.id..''

  end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '💡┆انت لست ادمن في┆👨‍✈️\n😹┆البوت┆🤖\n'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '💡┆تـم بلفعل تعطیل البوت في┆👮️️️\n✔️┆المجموعة┆🚸\n'..msg.from.id..''
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '💡┆تـم تعطیل البوت في┆👮️️️\n✔️┆المجموعة┆☂\n'..msg.from.id..''
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "*🚩| ـۧلاٰ ېۄجډ ٱدﻣۘنێه ۿٖنآ️*"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return "*🚩| ـۧلاٰ ېۄجډ ٱدﻣۘنێه ۿٖنآ️*"
end
   message = '*🚩| ﻗـٱئمۘه ٱـۧلاٰډمۘنێهِ :*\n\n'
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
    return '💡┆تـم بلفعل تعطیل البوت في┆👮️️️\n✔️┆المجموعة┆☂\n'..msg.from.id..''
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "💡┆لا یوجد مدراء في ┆👨‍✈️️\n❌┆البوت┆🤖\n"
end
   message = '💡┆قائمة المدراء ┆👨‍✈️️\n\n'
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
        return "🔖┆الڪلمه┆📖"..word.."💡┆مضافه الی الموهملات┆🗑"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
      return "🔖┆الڪلمه┆📖"..word.."💡┆تم منعها┆🗑"
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
        return "🔖┆الڪلمه ┆📖"..word.."💡┆تم ازالتها ┆✔️"
    else
        return "🔖┆الڪلمه ┆📖"..word.."💡┆تم بلفعل ازالتها ┆✔️"
    end
  end

local function lock_link(msg, data, target)
if not is_mod(msg) then
return "💡┆للکبار فقط ┆🔞"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "💡┆تـم بلفعل قفل الروابط في┆🗑️\n✔️┆المجموعة┆👁‍🗨️\n"
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "💡┆تـم  قفل الروابط في┆🗑️\n✔️┆المجموعة┆👁‍🗨️\n"..msg.from.id..""
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "💡┆للکبار فقط ┆🔞"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "💡┆تـم بلفعل فتح الروابط في┆🗑️\n✔️┆المجموعة┆👁‍🗨️\n"
else 
data[tostring(target)]["settings"]["lock_link"] = "no" 
save_data(_config.moderation.data, data) 
return "💡┆تـم  فتح الروابط في┆🗑️\n✔️┆المجموعة┆👁‍🗨️\n"..msg.from.id..""
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
return "💡┆للکبار فقط ┆🔞"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "💡┆تـم بلفعل قفل التاك في┆🔕\n✔️┆المجموعة┆🗑\n"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "💡┆تـم قفل التاك في┆🔕\n✔️┆المجموعة┆🗑\n"..msg.from.id..""
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "*🚩| آݪټٱك مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ټآڱ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "*🚩| ٱݪشِٱڕحۧه مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪشِٱڕحۧه*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "*🚩| ٱݪشِٱڕحۧه مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪشِٱڕحۧه*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "*🚩| آݪعربَيِهۧ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪعربَيِهۧ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "*🚩| آݪعربَيِهۧ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪعربَيِهۧ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "*🚩| آݪټعديݪ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪټعديݪ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "*🚩| آݪټعديݪ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_edit"] = "no"
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪټعديݪ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "*🚩| آݪڱـۧلاٰېشَ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪڱـۧلاٰېشَ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "*🚩| آݪڱـۧلاٰېشَ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪڱـۧلاٰېشَ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then
 return "*🚩| آݪټڱڕاڔ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪټڱڕاڔ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then
return "*🚩| آݪټڱڕاڔ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["flood"] = "no" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪټڱڕاڔ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "*🚩| آݪبۅټاٺ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪبۅټاٺ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "*🚩| آݪبۅټاٺ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪبۅټاٺ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
 return "*🚩| آݪډخۅݪ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪډخۅݪ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_join(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
return "*🚩| مۘفٛتٛـٖﯛحٰهَ آݪډخۅݪ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪډخۅݪ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "*🚩| آݪماڱدﯛڼ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪماڱدﯛڼ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "*🚩| آݪماڱدﯛڼ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no"
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪماڱدﯛڼ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "*🚩| آݪـِﯛېبُ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪـِﯛېبُ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "*🚩| آݪـِﯛېبُ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪـِﯛېبُ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "*🚩| آݪټثبَيِٺ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪټثبَيِٺ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "*🚩| آݪټثبَيِٺ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪټثبَيِٺ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
function group_settings(msg, target) 	
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "*🔅 ៲❘៲ آعّٖـډٱډٱٺ ٱݪمجۧمۅعّٖه ៲❘៲ 🔅*\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ⚜ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n*🔅| آݪټعديݪ -* *"..settings.lock_edit.."*\n*🔅| آݪرﯛابطِ -* *"..settings.lock_link.."*\n*🔅| آݪتٱك -* *"..settings.lock_tag.."*\n*🔅| آݪډخۅݪ -* *"..settings.lock_join.."*\n*🔅| آݪټڱڕاڔ -* *"..settings.flood.."*\n*🔅| آݪڱـۧلاٰېشَ -* *"..settings.lock_spam.."*\n*🔅| ٱݪشِٱڕحۧه -* *"..settings.lock_mention.."*\n*🔅| آݪعربَيِهۧ -* *"..settings.lock_arabic.."*\n*🔅| آݪـِﯛېبُ -* *"..settings.lock_webpage.."*\n*🔅| آݪمارڱدﯛڼ -* *"..settings.lock_markdown.."*\n*🔅| آݪټثبَيِٺ -* *"..settings.lock_pin.."*\n*🔅| آݪبۅټاٺ -* *"..settings.lock_bots.."*\n*🔅| عّٖـنٰډد آݪټڱڕاڔ -* *"..settings.num_msg_max.."*\n*🔅| عّٖـنٰډد آݪټڱڕاڔ بآݪـۅقَٺ -* *"..settings.set_char.."*\n*🔅| عّٖـنٰډد آݪټڱڕاڔ بآݪاحۧـڕفِ -* *"..settings.time_check.."*\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ⚜ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n*• ℂℍ :* [@Team_Advisor] ۦ.💛"
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
return "💡┆للڪبار فقط┆🔞"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "*🚩| ٱݪڱل مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪڱل*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "💡┆للڪبار فقط┆🔞"
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "*🚩| ٱݪڱل مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪڱل*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "*🚩| آݪمۘتحڕڱهِ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ آݪمۘتحڕڱهِ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "*🚩| آݪمۘتحڕڱهِ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ آݪمۘتحڕڱهِ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "*🚩| ٲݪډڕډشِهَ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٲݪډڕډشِهَ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "*🚩| ٲݪډڕډشِهَ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٲݪډڕډشِهَ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "*🚩| ٱݪصۄڕ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪصۄڕ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "*🚩| ٱݪصِۅټ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪصۄڕ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "*🚩| ٱݪفېډېۄ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪفېډېۄ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "*🚩| ٱݪفېډېۄ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪفېډېۄ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "*🚩| ٱلاٰغآڼي مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱلاٰغآڼي*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "*🚩| ٱلاٰغآڼي مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱلاٰغآڼي*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
return "*🚩| ٱݪصِۅټ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪصِۅټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "*🚩| ٱݪصِۅټ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪصِۅټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "*🚩| ٱݪملِصقٱټ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪملِصقٱټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "*🚩| ٱݪملِصقٱټ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪملِصقٱټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "*�🚩| ٱݪجۿٖٱټ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪجۿٖٱټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "*🚩| ٱݪجۿٖٱټ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪجۿٖٱټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞َ*"
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "*🚩| ٱݪټۅجيۿٖ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪټۅجيۿٖ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞َ*"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "*🚩| ٱݪټۅجيۿٖ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪټۅجيۿٖ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "*🚩| ٱݪمۅقِع مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪمۅقِع*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "*🚩| ٱݪمۅقِع مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪمۅقِع*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞َ*"
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "*🚩| ٱݪملِفآټ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱݪملِفآټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "*🚩| ٱݪملِفآټ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱݪملِفآټ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "*🚩| ٱلاٰڼـۧلاٰېڼ مۘقٛفٛـٖﯛلٰهِ آخِـٖﻱ*"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "*🚩| تٛـٖمٰ قٛفٛـٖلٰ ٱلاٰڼـۧلاٰېڼ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "*💡┆للڪبار فقط┆🔞*"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "*🚩| ٱلاٰڼـۧلاٰېڼ مۘفٛتٛـٖﯛحٰهَ آخِـٖﻱ*"
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "*🚩| تٛـٖمٰ فٛتٛـٖحٰ ٱلاٰڼـۧلاٰېڼ*\n*🚩| اٛيٓدٛيٖڱ ⌁ *"..msg.from.id..""
end
end

----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
return "💡┆للڪبار فقط┆🔞"
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
text = "*🔅 ៲❘៲ آعّٖـډآدآټ آݪۄسۧآئطِ ៲❘៲ 🔅*\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n*🔅| ٱݪڱل - * *"..mutes.mute_all.."*\n*🔅| آݪمۘتحڕڱهِ - * *"..mutes.mute_gif.."*\n*🔅| ٲݪډڕډشِهَ - * *"..mutes.mute_text.."*\n*🔅| ٱݪصۄڕ - * *"..mutes.mute_photo.."*\n*🔅| ٱݪفېډېۄ -* *"..mutes.mute_video.."*\n*🔅| ٱلاٰغآڼي - * *"..mutes.mute_audio.."*\n*🔅| ٱݪصِۅټ - * *"..mutes.mute_voice.."*\n*🔅| ٱݪملِصقٱټ - * *"..mutes.mute_sticker.."*\n*🔅| ٱݪجۿٖٱټ - * *"..mutes.mute_contact.."*\n*🔅| ٱݪټۅجيۿٖ - * *"..mutes.mute_forward.."*\n*🔅| ٱݪمۅقِع - * *"..mutes.mute_location.."*\n*🔅| ٱݪملِفآټ - * *"..mutes.mute_document.."*\n*🔅| ٱلاٰڼـۧلاٰېڼ - * *"..mutes.mute_tgservice.."*\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n*• ℂℍ ❘* [@Team_Advisor] ۦ.💛"
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
			return '💡┆لآ توجد معلومات┆⚠️'
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
		local text =  '*🚩|ٱڵمۘعِڕف: '..usr_name..'\n🚩|ٱلآسِمۘ ٱلٱﯛل  :'..fst_name..'\n🚩|ٱلآسِمۘ ٱڵثآڼې : '..lst_name..  '\n🚩|ٱڵبٱېۄ : *'..biotxt
		return text
end
if matches[1] == "معلومات" and matches[2] and not matches[2]:match('^%d+') and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, UID = '', '', '', '', ''
		local user = resolve_username(matches[2])
		if not user.result then
			return '*🚩| ـۧلاٰ ټـًۅﭼـْډ مۧعّٖݪـۄﻣِـاټ*'
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name =  '*ڕﭼُـآءٱ ٱعّٖـډ ٱڵمۘحٱﯛلهُ 🍁*'
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
		local text = '*🚩|ٱڵمۘعِڕفَ  : '..usr_name..' \n🚩|ٱلآيډې : '..UID..'\n🚩|ٱلآسِمۘ ٱلٱﯛݪ : '..fst_name..' \n🚩|ٱلآسِمۘ ٱڵثآڼې : '..lst_name..' \n🚩|ٱڵبٱېۄ  : *'..biotxt
		return text
end
if matches[1] == 'الاصدار' then
return _config.info_text
end
if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id,  '🔅|ٱݪمجَمۘۄعّٖه : ' ..msg.to.id.. '\n🔅|آۑډېكِ : '..msg.from.id.. "\nᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ\n📡 ᴄʜ - [@Team_Advisor]")
	else
   return "🔅|ٱݪمجَمۘۄعّٖه : "..tostring(msg.to.id).."\n🔅|ٱآۑډېكِ: "..tostring(msg.from.id)..""
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" then
    local status = resolve_username(matches[2])
		if not status.result then
			return '*🚩| ݪـُم ټـيم ٱيجَـُآدۿٖ*'
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
return "💡┆تـم  تثبیت المنشور┆⌛️"
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "💡┆تـم  تثبیت المنشور┆⌛️"
end
end
if matches[1] == 'الغاء تثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "💡┆تـم الغاء التثبیت┆🗑"
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "💡┆تـم الغاء التثبیت┆🗑"
end
end
if matches[1] == 'الوسائط' then
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
    return "💡┆تـم بلفعل رفعڪ مدیر في ┆🕵\n🗣┆المجموعة┆🤖\n"..username..""
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "💡┆تـم رفعڪ مدیر في ┆🕵\n🗣┆المجموعة┆🤖\n"..username..""
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "💡┆العضو غیر موجود┆🤖"
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
    return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم ټڹزيݪـِﮥ آݪۍ عّٖضـِﯛ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "*👁‍🗨| ټـم ټڹزيݪـِﮥ آݪۍ عّٖضـِﯛ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*🚩| آݪعۧڞـِۅ غېـُڔ مۘۅجـُۅډ*"
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
    return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم ړفعّٖـﮥ آډﻣۘـُڹ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "*👁‍🗨| ټـم ړفعّٖـﮥ ٱډﻣۘـِڹ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*🚩| آݪعۧڞـِۅ غېـُڔ مۘۅجـُۅډ*"
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
    return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم ټڹزيݪـِﮥ آݪۍ عّٖضـِﯛ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "*👁‍🗨| ټـم ټڹزيݪـِﮥ آݪۍ عّٖضـِﯛ*\n*👁‍🗨| معّٖرفـُﮥ : *`[`"..username.."`]`"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "*🚩| آݪعۧڞـِۅ غېـُڔ مۘۅجـُۅډ*"
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
if matches[2] == "الشارحه" then
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
if matches[2] == "الاغاني" then
return mute_audio(msg ,data, target)
end
if matches[2] == "الصوت" then
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
if matches[2] == "الاغاني" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "الصوت" then
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
		return "*🚩| آݪبـِۅټ لېـُسهً آدآړيَ*"
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		return "*🚩| تـِم ﺣفِظَ آݪـَرابَطِ*"
	end
   end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '*🚩| ارسـِآݪ آݪـَړابطُ لاٰڹ*'
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "*🚩| تـِم ﺣفِظَ آݪـَرابَطِ*"
       end 
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "*🚩| ـۧلاٰ يۅجډ ړابطَ ݪݪمجمۅعّٖه\n🚩| قـَم بآړسِآݪ ضِعّٖ ړابطَ\n🚩| ۄقِـمَ بآړسِآݪ الړابطَ ݪيټمَ ﺣفِظَۿٖ*"
      end
       text = "[🚩اضغـط هنـا للدخول للمجمـوعه { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
        return text
     end
  if matches[1] == "ضع قوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "*🚩| تـِمَ ټعّٖېيڼ آݪـقۧۅآڼێڽ*"
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
     rules = "*🔅 ៲❘៲ القوانيـن ៲❘៲ 🔅 :\nᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ\n🔅|عدم عمل توجيه للمجموعه\n🔅|عدم الشتـم والغلـط\n🔅|عدم التجاوز بالكلام\n🔅|لا تطلب الادمنيه المتفاعل يرفع ادمن\n🔅|عدم ارسال الروابط هنا*\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n ℂℍ ៲❘៲  [@Team_Advisor]"
        else
     rules = "*🚩:*\n\n"..data[tostring(target)]['rules']
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
     return "*🚩| ټـم ټعّٖێێڹ آݪټڱړاړ ݪݪعّٖډډ :* *[ "..matches[2].." ]*"
  end 
  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "*[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "*🚩| ټـم ټعّٖێێڹ آݪټڱړاړ ݪݪعّٖډډ :* *[ "..matches[2].." ]*"
       end
  if matches[1]:lower() == 'ضع تكرار بالوقت' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "*[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "*🚩| ټـم ټعّٖێێڹ آݪټڱړاړ ݪݪۅقِـًټ️ :* *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'مسح' and is_owner(msg) then
			if matches[2] == 'الادمنيه' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم مسُـﺢِ آلآډﻣۘنيـُڹه*"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*👁‍🗨| ټـم مسُـﺢِ آلآډﻣۘنيـُڹه*"
         end
			if matches[2] == 'الممنوعات' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "*👁‍🗨| ﺑـٱلفعّٖـِݪ تـم مسُـﺢِ آلـممٍنۄعآت*"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*👁‍🗨| ټـم مسُـﺢِ آلـممٍنۄعآټ*"
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم مسُـﺢِ آݪـقۧۅآڼێڽ*"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "*👁‍🗨| ټـم مسُـﺢِ آݪـقۧۅآڼێڽ*"
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم مسُـﺢِ آݪټړحێب️*"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "*.👁‍| ټـم مسُـﺢِ آݪتړحێب*"
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "*🚩| ـۧلاٰ ێۄجډ ٱݪۄﺻفِ️*"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "*🚩| ټـۧم ﻣۘسحِ آݪـﯛﺻفِ*"
		   	end
        end
		if matches[1]:lower() == 'مسح' and is_admin(msg) then
			if matches[2] == 'المدراء' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
				return "*🚩| ـۧلاٰ ێۄجډ ﻣۘدړا۽️*"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "*🚩| ټـم مۘسـِحَ ٱلـِﻣۘدړا۽*" 
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
			return '*🚩| قـۧم بآړسِآݪ ٱ ݪصۄړۿٖ الاٰن*'
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
  return "*🚩| ټـمٌ ﺣفِظَ ٱݪصۄړۿٖ️*"
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
  return "*🚩| ټـمٌ ﺣفِظَ ٱݪصۄړۿٖ️*"
		end
  end
if matches[1] == "حذف صوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "*🚩| ټـمٌ ﻣُسحَ ٱݪصۄړۿٖ*"
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "*🚩| ټـمٌ ۅضعّٖ ٱݪۅﺻفِ*"
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
    return "*👁‍🗨| ټـم ړفعّٖ ڱل آلاِډﻣۘنيـُڹه ݪݪبۅټ*"
end
if matches[1] == 'نظف' and matches[2] and is_owner(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "*👁‍🗨| عۧڵێڱ ﯛ ضَعۧ عّٖـډډ*\n*👁‍🗨| ﺑێڼ ⓿⓿❶⌁❶ فِقَطَ*"
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
				return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم ټفعّٖݪ ٱݪټړحَێبِ*"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "*👁‍🗨| ټـم ټفعّٖݪ ٱݪټړحَێبِ*"
			end
		end
		
		if matches[2] == "تعطيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "*👁‍🗨| ﺑـٱلفعّٖـِݪ ټـم ټعطيلݪ ٱݪټړحَێبِ️*"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "*👁‍🗨| ټـم ټعطيݪ ٱݪټړحَێبِ*"
			end
		end
	end
	if matches[1] == "ضع ترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "*👁‍🗨| ټـم ﯠﺿـًعِ ٱݪټړحَێبِ ݪݪمجمۘۅعهَ✔️*\n\n"..matches[2].."\n*ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ*\n CH - [@Team_Advisor]"
	end
-------------Help-------------
  if matches[1] == "الاوامر" and is_mod(msg) then
    local text = [[*⚜ ៲❘៲ آﯛامِـرَ ٱݪبـﯛٺِ ៲❘៲ ⚜

ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
👁‍🗨| قفـل + الامر ⌁ للقفل
👁‍🗨| فتح + الامر ⌁ للفتـح
ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
👁‍🗨| الروابط ⌁ التاك ⌁ الشارحه
👁‍🗨| التعديل ⌁ التكرار ⌁ الكلايش
👁‍🗨| البوتات ⌁ الماركدون ⌁ التثبيـت
👁‍🗨| الدخـول ⌁ العربيه ⌁ الويب
ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
👁‍🗨| الصور ⌁ الدردشه ⌁ المتحركه
👁‍🗨| الصوت ⌁ الاغاني ⌁ الفيديو
👁‍🗨| الجهات ⌁ الملصقات ⌁ الكل
👁‍🗨| التوجيه ⌁ الملفات ⌁ الموقع ⌁ الانلاين
ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
👁‍🗨| كتم ⌁ الغاء كتم ⌁ قائمه الكتم
👁‍🗨| حظر ⌁ الغاء حظر ⌁ قائمه الحظر
👁‍🗨|حذف + رد لحذف رساله
👁‍🗨| طرد ⌁ ايدي ⌁ معلومات + ايدي
👁‍🗨| ضع تكرار + عدد 
👁‍🗨| ضع تكرار بالوقت + عدد
👁‍🗨| تثبيت + رد لتثبيت رساله
👁‍🗨| حظر الكل - الغاء حظر الكل
ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
👁‍🗨| ارسل ⌁ اوامر المطور لعرضها
ᱻᱻᱻᱻᱻᱻᱻᱻᱼᱼᱹᱹᱹ🔅ᱹᱹᱹᱼᱼᱻᱻᱻᱻᱻᱻᱻᱻ
• ℂℍ┇* [@Team_Advisor] ۦ.💛
]]
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
		send_msg(msg.to.id, "*👁‍🗨| ټـم ﯠﺿـًعِ ٱݪصـَﯠړ ݪݪمجمۘۅعهَ*", msg.id, "md")
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
send_msg(msg.to.id, '*• ٺـِﻡۘ تفعّٖيݪ ٱﻟﺣِـِمۘآﭔﮤ ټݪقآئێآ ៲❘៲ ✔️*\n*• قَڼآټـہِنا °*| [@Team_Advisor] |° ៲ 😽', msg.id, "md")
   end 
    end
  end
end
return {
  patterns = {
    "^(الاوامر)$",
    "^(فعل)$",
    "^(عطل)$",
    "^(ترحيب) (.*)$",
    "^(رفع الادمنيه)$",
    "^(رفع مدير)$",
    "^(تنزيل مدير)$",
    "^(رفع مدير) (.*)$",
    "^(تنزيل مدير) (.*)$",
    "^(رفع ادمن)$",
    "^(تنزيل ادمن)$",
    "^(رفع ادمن) (.*)$",
	"^(تنزيل ادمن) (.*)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(قفل) (.*)$",
	"^(فتح) (.*)$",
	"^(الاعدادات)$",
	"^(الوسائط)$",
	"^(منع) (.*)$",
	"^(الغاء منع) (.*)$",
    "^(قائمه المنع)$",
    "^(المدراء)$",
    "^(الادمنيه)$",
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
	"^(ضع وصف) (.*)$",
    "^(ضع تكرار) (%d+)$",
    "^(ضع تكرار) (%d+)$",
    "^(ضع تكرار وقت) (%d+)$",
    "^(معلومات) (.*)$",
    "^(نظف) (%d+)$",
 --"^(الاصدار)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$",
    },
  run = Falcon,
  
  pre_process = pre_process
}
-- تـم التعديـل والتعريب بواسطه @Sudo_Sky
-- supermang.lua
