-- groupmanager.lua by @vip_api
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_admin(msg) then
        return '_🤖┋البوت ليس ادمن في المجموعه ⚠️_'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
   return '_🎈┋المجموعه ⬇️ :️_\n *['..msg.to.title..']* \n_🎈 ┋تم تفعيلها سابقآ ☑️_'
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
  return '_🎈┋المجموعه ⬇️ :_\n *['..msg.to.title..']* \n_🎈┋تم تفعيلها ☑️_'
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_admin(msg) then
        return '_⚠️┋البوت ليس ادمن في المجموعه 🗣_'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
    return '_🤖┋البوت غير مفعل ❌_'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
  return '_🎈┋المجموعه تم تعطيلها ⚠️_'
end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return "_🤖┋البوت غير مفعل ❌_"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
    return "_❌┋لايوجد ادمنيه ♻️_"
end
   message = '_📬┋قائمه الاادمنيه ⬇️ :_\n\n'
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
    return "_🤖┋البوت غير مفعل ⚠️_"
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
    return "_❌┋لايوجد مدراء ♻️_"
end
   message = '_📬┋قائمه المدراء ⬇️ :_\n\n'
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
        return "_🔴┋تم اظافتها_ *["..word.."]* _الى قائمه المنع مسبقآ 🔕_"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
      return "_🔴┋تم اظافتها_*["..word.."]* _الى قائمه المنع 🔕_"
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
        return "_🔴┋تم ازالتها_ *["..word.."]* _من قائمه المنع 🔕_"
    else
        return "_🔴┋تم ازالتها_*["..word.."]* _من قائمه المنع مسبقآ 🔕_"
    end
  end

local function lock_link(msg, data, target)
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الروابط ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_link(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الروابط ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل التاك ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_tag(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح التاك ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الشارحات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_mention(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الشارحات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

---------------Lock Arabic--------------
local function lock_arabic(msg, data, target)
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"] 
if lock_arabic == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
data[tostring(target)]["settings"]["lock_arabic"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل العربيه ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_arabic(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_arabic = data[tostring(target)]["settings"]["lock_arabic"]
 if lock_arabic == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_arabic"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح العربيه ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب_"
end
local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل التعديل ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_edit(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح التعديل ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الكلايش ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_spam(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الكلايش ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_flood = data[tostring(target)]["settings"]["lock_flood"] 
if lock_flood == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_flood"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل التكرار ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_flood(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local lock_flood = data[tostring(target)]["settings"]["lock_flood"]
 if lock_flood == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_flood"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑\n🌟┋تم فتح التكرار ☑️\n🌟┋في هذة المجموعه ☑️️_" 
end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل البوتات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_bots(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح البوتات ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الدخول ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_join(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الدخول ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الماركدوان ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_markdown(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الماركدوان ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الويب ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_webpage(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الويب ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل التثبيت ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح التثبيت ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

function group_settings(msg, target) 	
if not is_mod(msg) then
 	return "_💠┋انت لايمكنك العب ⚠️_"
end
local data = load_data(_config.moderation.data)
local settings = data[tostring(target)]["settings"] 
text = "_Ⓜ️┋اعدادات (1) المجموعه ⬇️_\n\n_📥┋قفل التعديل :_ *"..settings.lock_edit.."*\n_📥┋قفل الروابط :_ *"..settings.lock_link.."*\n_📥┋قفل التاك :_ *"..settings.lock_tag.."*\n_📥┋قفل الدخول :_ *"..settings.lock_join.."*\n_📥┋قفل التكرار :_ *"..settings.flood.."*\n_📥┋قفل الكلايش :_ *"..settings.lock_spam.."*\n_📥┋قفل الشارحات :_ *"..settings.lock_mention.."*\n_📥┋قفل العربيه :_ *"..settings.lock_arabic.."*\n_📥┋قفل الويب :_ *"..settings.lock_webpage.."*\n_📥┋قفل الماركدوان :_ *"..settings.lock_markdown.."*\n_📥┋ترحيب الاعظاء :_ *"..settings.welcome.."*\n_📥┋قفل التثبيت :_ *"..settings.lock_pin.."*\n_📥┋قفل البوتات :_ *"..settings.lock_bots.."*\n_📥┋عدد التكرار  :_ *"..settings.num_msg_max.."*\n_📥┋عدد التكرار بالوقت :_ *"..settings.set_char.."*\n_📥┋عدد تكرار الاحرف :_ *"..settings.time_check.."*\n*__________________________*\n*VIRSION 2018 DEV_IQ BRWUEN OWNER &*"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
text = string.gsub(text, '0', '0⃣')
text = string.gsub(text, '1', '1⃣')
text = string.gsub(text, '2', '2️⃣')
text = string.gsub(text, '3', '3️⃣')
text = string.gsub(text, '4', '4️⃣')
text = string.gsub(text, '5', '5️⃣')
text = string.gsub(text, '6', '6️⃣')
text = string.gsub(text, '7', '7️⃣')
text = string.gsub(text, '8', '8️⃣')
text = string.gsub(text, '9', '9️⃣')
return text
end

--------Mute all--------------------------
local function mute_all(msg, data, target) 
if not is_mod(msg) then 
return "_💠┋انت لايمكنك العب ⚠️_" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "yes" then 
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "yes"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الكل ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end

local function unmute_all(msg, data, target) 
if not is_mod(msg) then 
return "_💠┋انت لايمكنك العب ⚠️_" 
end

local mute_all = data[tostring(target)]["mutes"]["mute_all"] 
if mute_all == "no" then 
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_all"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الكل ☑️\n🌟┋في هذة المجموعه ☑️_"  
end
end

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل المتحركه ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_gif(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح المتحركه ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الدردشه ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_text(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الدردشه ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الصور ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_photo(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الصور ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الفيديو ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_video(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الفيديو ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الصوتيات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_audio(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الصوتيات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الاغاني ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_voice(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الاغاني ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الملصقات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_sticker(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الملصقات ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل جهات الاتصال ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_contact(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح جهات الاتصال ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل التوجيه ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_forward(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح التوجيه ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الموقع ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_location(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الموقع ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الملفات ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_document(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end 
local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_" 
else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الملفات ☑️\n🌟┋في هذة المجموعه ☑️_" 
end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 
if not is_mod(msg) then
 return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then
 return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بقفلها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 
 return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم قفل الاانلاين ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

local function unmute_tgservice(msg, data, target)
 if not is_mod(msg) then
return "_💠┋انت لايمكنك العب ⚠️_"
end
local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then
return "_⚙️┋عذرآ عزيزي المستخدم ✅\n⚙️┋لقد قمت بفتحها سابقآ ✅\n⚙️┋في هذة المجموعه ✅_"
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 
return "_🌟┋عزيزي المستخدم ☑️\n🌟┋تم فتح الاانلاين ☑️\n🌟┋في هذة المجموعه ☑️_"
end
end

----------MuteList---------
local function mutes(msg, target) 	
if not is_mod(msg) then
 	return "_💠┋انت لايمكنك العب ⚠️_"	
end
local data = load_data(_config.moderation.data)
local mutes = data[tostring(target)]["mutes"] 
 text = "_Ⓜ️┋اعدادات ﴿2﴾ المجموعه ⬇️_\n\n_📮┋قفل الكل : _ *"..mutes.mute_all.."*\n_📮┋قفل المتحركه :_ *"..mutes.mute_gif.."*\n_📮┋ قفل الدردشه :_ *"..mutes.mute_text.."*\n_📮┋ قفل الصور :_ *"..mutes.mute_photo.."*\n_📮┋ قفل الفيديو :_ *"..mutes.mute_video.."*\n_📮┋ قفل الصوتيات :_ *"..mutes.mute_audio.."*\n_📮┋ قفل الاغاني :_ *"..mutes.mute_voice.."*\n_📮┋ قفل الملصقات :_ *"..mutes.mute_sticker.."*\n_📮┋ قفل جهات الاتصال :_ *"..mutes.mute_contact.."*\n_📮┋ قفل التوجيه  :_ *"..mutes.mute_forward.."*\n_📮┋ قفل الموقع :_ *"..mutes.mute_location.."*\n_📮┋ قفل الملفات :_ *"..mutes.mute_document.."*\n_📮┋ قفل الاانلاين :_ *"..mutes.mute_tgservice.."*\n*____________________*\n*VIRSION 2018 DEV_IQ BRWUEN OWNER &*"
text = string.gsub(text, 'yes', '✅')
text = string.gsub(text, 'no', '❌')
 return text
end

local function BRWUEN(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------Begin Msg Matches--------------
if matches[1] == "تفعيل" and is_admin(msg) then
return modadd(msg)
   end
if matches[1] == "تعطيل" and is_admin(msg) then
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
			return '_⚠️┋ لم يتم ايجاد معلومات 📛_'
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
		local text = '🔮┋المستخدم : '..usr_name..' \n🔮┋الاسم الاول : '..fst_name..' \n🔮┋الاسم الثاني : '..lst_name..' \n🔮┋بايو المستخدم : '..biotxt
		return text
end
if matches[1] == "معلومات" and matches[2] and not matches[2]:match('^%d+') and is_mod(msg) then
		local usr_name, fst_name, lst_name, biotxt, UID = '', '', '', '', ''
		local user = resolve_username(matches[2])
		if not user.result then
			return '⚠️┋ لم يتم ايجاد معلومات 📛'
		end
		user = user.information
		if user.username then
			usr_name = '@'..check_markdown(user.username)
		else
			usr_name = '_⚠️┋الرجاء اعد المحاوله لاحقآ ❌_'
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
		local text = '🔮┋المستخدم : '..usr_name..' \n🔮┋ايدي المستخدم : '..UID..'\n🔮┋الاسم الاول : '..fst_name..' \n🔮┋الاسم الثاني : '..lst_name..' \n🔮┋بايو المستخدم : '..biotxt
		return text
end
if matches[1] == 'بروين' then
return _config.info_text
end
if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
   if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, '⛱┋المجموعه : '..msg.to.id..'\n⛱┋ايديك : '..msg.from.id.. "\n------------------------------------------------\nBOT CHANNEL : @vip_api <")
	else
   return "_⛱┋المجموعه :_"..tostring(msg.to.id).."_⛱┋ايديك :_"..tostring(msg.from.id)..""
   end
   elseif msg.reply_to_message and not msg.reply.fwd_from and is_mod(msg) then
     return "`"..msg.reply.id.."`"
   elseif not string.match(matches[2], '^%d+$') and matches[2] ~= "from" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return '🔴┋المستخدم غير متوفر 🗣'
		end
     return "`"..status.information.id.."`"
   elseif matches[2] == "from" and msg.reply_to_message and msg.reply.fwd_from then
     return "`"..msg.reply.fwd_from.id.."`"
   end
end
if matches[1] == "تثبيت" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "_☑️┋تم تثبيت هذة الرساله ☑️_"
elseif not is_owner(msg) then
   return
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "_☑️┋تم تثبيت هذة الرساله ☑️_"
end
end
if matches[1] == 'الغاء تثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "_❌┋تم الغاء تثبيت هذة الرساله ❌_"
elseif not is_owner(msg) then
   return 
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "_❌┋تم الغاء تثبيت هذة الرساله ❌_"
end
end
if matches[1] == 'الاعدادات الثانويه' then
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
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم ترقيته الى رتبه المدير مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم ترقيته الى رتبه المدير 📬_"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈️┋تم ترقيته الى رتبه المدير مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈️┋تم ترقيته الى رتبه المدير 📬_"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋تم ترقيته الى رتبه المدير مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋تم ترقيته الى رتبه المدير 📬_"
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
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم تنزيله من رتبه المدير مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم تنزيله من رتبه المدير 📬_"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈️┋تم تنزيله من رتبه المدير مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈���┋تم تنزيله من رتبه المدير 📬_"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋لايوجد مدير بالفعل ❌_"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋لايوجد مدير ❌_"
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
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👷┋تم ترقيته الى رتبه الادمن مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👷┋تم ترقيته الى رتبه الادمن 📬_"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "_🔴���المستخدم غي�� متوفر 🗣_"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_����‍������┋المستخ��م ������_ "..user_name.." "..matches[2].."\n _👷┋��م ترقيته الى رتبه الادمن مس��قآ 📬_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👷┋تم ترقيته الى رتبه الادمن 📬_"
   end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋لايوجد ادمن بالفعل ❌_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👨‍✈️┋لايوجد ادمن ❌_"
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
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم تنزيله من رتبه الادمن مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..username.." "..msg.reply.id.."\n _👨‍✈️┋تم تنزيله من رتبه الادمن 📬_"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈️┋تم تنزيله من رتبه الادمن مسبقآ 📬_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ "..user_name.." "..matches[2].."\n _👨‍✈️┋تم تنزيله من رتبه الادمن 📬_"
      end
   elseif matches[2] and not matches[2]:match('^%d+') then
  if not resolve_username(matches[2]).result then
   return "_🔴┋المستخدم غير متوفر 🗣_"
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👷┋لايوجد ادمن بالفعل ❌_"
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "_👨‍✈️┋المستخدم ⬇️_ @"..check_markdown(status.username).." "..status.id.."\n _👷┋لايوجد ادمن  ❌_"
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
if matches[2] == "الشارحات" then
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
if matches[2] == "الماكدوان" then
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
if matches[2] == "الماكدوان" then
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
if matches[1]:lower() == "اقفل" and is_mod(msg) then
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
if matches[2] == "الصوتيات" then
return mute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return mute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "جهات الاتصال" then
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
if matches[1]:lower() == "افتح" and is_mod(msg) then
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
if matches[2] == "الصوتيات" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "الاغاني" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "جهات الاتصال" then
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
		return "_⚠️┋عذرآ البوت ليس ادمن 🚫_"
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		return "_📚┋ لقد تم حفظ الرابط تلقائيآ 📍_"
	end
   end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
			return '_💰┋الرجاء قم بئرسال ⬇️\n💰┋رابط المجموعه الان 📥_'
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
				return "_💰┋حسننآ عزيزي المستخدم ⬇️\n💰┋لقد تم حفظ الرابط الان 📥_"
       end
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
        return "_💰┋عزيزي المستخدم ⬇️\n💰┋لم يتم تعين رابط للمجموعه✖️\n💰┋ارسل • ضع رابط ✔️\n💰┋لتعين الرابط الخاص بلمجموعه_"
      end
       text = "[🎈┋اضغط هنا 👍 للدخول الى هذة المجموعه ➣ { "..escape_markdown(msg.to.title).." }]("..linkgp..")"
        return text
     end
  if matches[1] == "ضع قوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
    return "_🍄┋تم تعين القوانين ⬇️\n🍄┋في هذة المجموعه 🗣_"
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
     rules = "_🍄┋القوانين هيه ⬇️ :\n\n🍄┋عدم التجاوز في المجموعه ⚠️\n🍄┋عدم نشر في المجموعه ⚠️\n🍄┋عدم المخالفه في المجموعه ⚠️\n🍄┋انتباه الالفاظ الغير حسنه ⚠️\n🍄┋الرجاء اجعلوا المجموعه امنه ⚠️\n🍄┋ان لم تفهم ⬆️ سوف تنطرد ⚠️_\n------------------------------------------------\n*VIRSION 2018 DEV BRWUEN*"
        else
     rules = "_🍄┋القوانين هيه ⬇️ :_\n\n"..data[tostring(target)]['rules']
      end
    return rules
  end
		if matches[1]:lower() == 'ضع تكرار رقم' then
			if not is_mod(msg) then
				return
			end
			local chars_max = matches[2]
			data[tostring(msg.to.id)]['settings']['set_char'] = chars_max
			save_data(_config.moderation.data, data)
     return "_🔢┋تم تعين التكرار الرقم ⬇️\n🔢┋للعدد ⬅️_ *[ "..matches[2].." ]*"
  end
  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "*[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "_🔢┋تم تعين التكرار ⬇️\n🔢┋للعدد ⬅️_ *[ "..matches[2].." ]*"
       end
  if matches[1]:lower() == 'ضع تكرار وقت' and is_mod(msg) then
			if tonumber(matches[2]) < 2 or tonumber(matches[2]) > 10 then
				return "*[2-10]*"
      end
			local time_max = matches[2]
			data[tostring(msg.to.id)]['settings']['time_check'] = time_max
			save_data(_config.moderation.data, data)
    return "_🔢┋تم تعين التكرار للوقت ⬇️\n🔢┋للعدد ⬅️_ *[ "..matches[2].." ]*"
       end
		if matches[1]:lower() == 'مسح' and is_owner(msg) then
			if matches[2] == 'الادمنيه' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
					return "_🔥┋تم حذف قائمه الادمنيه مسبقآ ☑️_"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_🔥┋تم حذف قائمه الادمنيه ☑️_"
         end
			if matches[2] == 'قائمه المنع' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "_🔥┋تم حذف الكلمات المكتومه مسبقآ ☑️️_"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_🔥┋تم حذف الكلمات المكتومه ☑️️_"
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
					return "_🔥┋تم حذف القوانين مسبقآ ☑️_"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
				return "_🔥┋تم حذف القوانين ☑️_"
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
					return "_🔥┋تم حذف الترحيب مسبقآ ☑️_"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
				return "_🔥┋تم حذف الترحيب ☑️_"
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
					return "_🔥┋لايوجد وصف_"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
				return "_🔥┋تم حذف وصف المجموعه ☑️_"
		   	end
        end
		if matches[1]:lower() == 'مسح' and is_admin(msg) then
			if matches[2] == 'المدراء' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
					return "_🔥┋عذرآ لايوجد مدراء ☑️_"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "_🔥┋تم حذف جميع المدراء ☑️_"
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
			return '_🌠┋حسننآ ارسل الصورة الان_'
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
  return "_🌠┋حسننآ تم حفظ الصورة 🌠_"
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
  return "_🌠┋حسننآ تم حفظ الصورة 🌠_"
		end
  end
if matches[1] == "حذف صوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "_🌠┋حسننآ تم حذف الصورة 🌠_"
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
    return "_☄️┋تم تعين وصف المجموعه 💫_"
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
if matches[1] == "config" and is_owner(msg) then
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
    return "_All_ `group admins` _has been_ *promoted*"
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
				return "_✔️┋تم تفعيل الترحيب مسبقآ 🎓_"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
				return "_✔️┋تم تفعيل الترحيب 🎓_"
			end
		end
		
		if matches[2] == "تعطيل" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
			if welcome == "no" then
				return "_✖️┋تم تعطيل الترحيب مسبقآ 🎓_"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
				return "_✖️┋تم تعطيل الترحيب 🎓_"
			end
		end
	end
	if matches[1] == "ضع ترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "_✔️┋تم تعين الترحيب في المجموعه_\n\n"..matches[2].."\n-------------------------------------------------\n*VIRSION 2018 DEV BRWUEN*"
	end
-------------Help-------------
  if matches[1] == "الاوامر" and is_mod(msg) then
    local text = [[_⚙️┋اوامر سورس بروين ⬇️

🎈┋قفل + الامر [للقفل] ✔️
🎈┋فتح + الامر [للفتح] ✖️
ا➖➖➖➖➖➖➖➖➖➖ا
◍┋الروابط • التاك • الشارحات 
◍┋التعديل • الكلايش • التكرار
◍┋البوتات • الماكدوان • التثبيت 
◍┋الدخول • العربيه • الويب
ا➖➖➖➖➖➖➖➖➖➖ا  
🎈┋اقفل + الامر [للقفل] ✔️
🎈┋افتح + الامر [للفتح] ✖️
ا➖➖➖➖➖➖➖➖➖➖ا 
◍┋المتحركه • الدردشه • الصور
◍┋الفيديو • الصوتيات • الاغاني
◍┋الملصقات • الكل • جهات الاتصال
◍┋التوجيه • الموقع • الملفات • الانلاين
ا➖➖➖➖➖➖➖➖➖➖ا 
◍┋نشر للكل • المجموعات • غادر بوتي
◍┋رفع ادمن للبوت • تنزيل ادمن للبوت
 
◍┋مسح × (الادمنيه • القوانين • الترحيب • الوصف • المدراء • قائمه المنع) 
ا➖➖➖➖➖➖➖➖➖➖ا 
🎈┋ارسل - اوامر تولس • لعرظها_]]
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
		send_msg(msg.to.id, "_🌠┋تم تعين الصورة للمجموعه 🌠_", msg.id, "md")
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
     rules = "ℹ️ The Default Rules :\n1⃣ No Flood.\n2⃣ No Spam.\n3⃣ No Advertising.\n4⃣ Try to stay on topic.\n5⃣ Forbidden any racist, sexual, homophobic or gore content.\n➡️ Repeated failure to comply with these rules will cause ban.\n@BeyondTeam"
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
   send_msg(msg.to.id, '_📬┋المجموعه_ *['..msg.to.title..']*\n _📬┋غير مفعله ✖️ تواصل\n📬┋مع المطور ليقم بتفعيلها ✔️_', msg.id, "md")
      end
    end
  end
end
return {
  patterns = {
    "^(الاوامر)$",
    "^(تفعيل)$",
    "^(تعطيل)$",
    "^(config)$",
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
	"^(اقفل) (.*)$",
	"^(افتح) (.*)$",
	"^(الاعدادات)$",
	"^(الاعدادات الثانويه)$",
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
	"^(تثبيت)$",
    "^(الغاء تثبيت)$",
    "^[!/](about)$",
	"^(ضع وصف) (.*)$",
    "^(ضع تكرار رقم) (%d+)$",
    "^(ضع تكرار) (%d+)$",
    "^(ضع تكرار وقت) (%d+)$",
    "^(معلومات) (.*)$",
    "^[!/](rmsg) (%d+)$",
	"^(بروين)$",
	"^([https?://w]*.?telegram.me/joinchat/%S+)$",
	"^([https?://w]*.?t.me/joinchat/%S+)$",
    },
  run = BRWUEN,
  pre_process = pre_process
}
