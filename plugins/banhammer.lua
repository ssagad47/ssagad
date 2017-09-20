-- تـم التعديـل والتعريب بواسطه @Sudo_Sky
--banhammer.lua
local function Falcon(msg, matches)
local data = load_data(_config.moderation.data)
----------------طرد بالرد----------------
if matches[1] == 'طرد' and is_mod(msg) then
   if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "*لا يمكنـك طـردي🐸💔*"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "*لايمكـنك طـرد الادمنـيه والمدراء🐸💔*"
    else
	kick_user(msg.reply.id, msg.to.id) 
 end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "*المسـتخدم ليـس موجود🐸💔*"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "*لا يمكنـك طـردي🐸💔*"
    end
if is_mod1(msg.to.id, User.id) then
   return "*لايمكـنك طـرد الادمنـيه والمدراء🐸💔*"
     else
	kick_user(User.id, msg.to.id) 
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "*لا يمكنـك طـردي🐸💔*"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "*لايمكـنك طـرد الادمنـيه والمدراء🐸💔*"
   else
     kick_user(tonumber(matches[2]), msg.to.id) 
        end
     end
   end 

---------------حظر بالرد-------------------      
                   
if matches[1] == 'حظر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "*لا يمكنك حظري🐸💔*"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "*لا يمكنـك حـظر الادمنـيه والمدراء🐸💔*"
    end
  if is_banned(msg.reply.id, msg.to.id) then
    return "*المستـخدم*  "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *بالفعـل تـم حظره🚷✔️*"
    else
ban_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *تـم حظـره🚷✔️*"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "*المسـتخدم ليـس موجود🐸💔*"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "*لا يمكنك حظري🐸💔*"
    end
if is_mod1(msg.to.id, User.id) then
   return "لا يمكنـك حـظر الادمنـيه والمدراء🐸💔"
    end
  if is_banned(User.id, msg.to.id) then
    return "*المستـخدم*  "..check_markdown(User.username).." "..User.id.." *بالفعـل تـم حظره🚷✔️*"
    else
   ban_user(check_markdown(User.username), User.id, msg.to.id)
     kick_user(User.id, msg.to.id) 
    return "*المستـخدم*  "..check_markdown(User.username).." "..User.id.." *تـم حظـره🚷✔️*"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "*لا يمكنك حظري🐸💔*"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "*لا يمكنـك حـظر الادمنـيه والمدراء🐸💔*"
    end
  if is_banned(tonumber(matches[2]), msg.to.id) then
    return "*المستـخدم "..matches[2].." بالفعـل تـم حظـره🚷✔️*"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "*المستـخدم* "..matches[2].." *تـم حظـره🚷✔️*"
        end
     end
   end

---------------الغاء حظر-------------------                         

if matches[1] == 'الغاء حظر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "*انا لا انحظر🐸💔*"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "*لا يمكنـك حـظر الادمنـيه والمدراء🐸💔*"
    end
  if not is_banned(msg.reply.id, msg.to.id) then
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *بالفعـل تـم الغاء حظـره🚷✖️*"
    else
unban_user(msg.reply.id, msg.to.id)
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *تـم الغاء حظـره🚷✖️*"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "*انا لا انحظر🐸💔*"
    end
	local User = resolve_username(matches[2]).information
  if not is_banned(User.id, msg.to.id) then
    return "*المستـخدم* @"..check_markdown(User.username).." "..User.id.." *بالفعـل تـم الغاء حظره🚷✖️*"
    else
   unban_user(User.id, msg.to.id)
    return "*المستـخدم* @"..check_markdown(User.username).." "..User.id.." *تـم الغاء حظـره🚷✖️*"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_banned(tonumber(matches[2]), msg.to.id) then
    return "*المستـخدم* "..matches[2].." *بالفعـل تـم الغاء حظـره🚷✖️*"
    else
   unban_user(matches[2], msg.to.id)
    return "*المستـخدم* "..matches[2].." *تـم الغاء حظـره🚷✖️*"
        end
     end
   end

------------------------كتم بالرد-------------------------------------

if matches[1] == 'كتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "*لا يمكـنك كتـمي🐸💔*"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "*لا تستطيـع كتـم الادمنيـه والمدراء🐸💔*"
    end
  if is_silent_user(msg.reply.id, msg.to.id) then
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *بالفعـل تـم كتمـه🔇✔️*"
    else
silent_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." *تـم كتـمه🔇✔️*"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "*المسـتخدم ليـس موجود🐸💔*"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "*لا يمكـنك كتـمي🐸💔*"
    end
if is_mod1(msg.to.id, User.id) then
   return "*لا تستطيـع كتـم الادمنيـه والمدراء🐸💔*"
    end
  if is_silent_user(User.id, msg.to.id) then
    return "*المستـخدم* @"..check_markdown(User.username).." "..User.id.." *بالفعـل تـم كتمـه🔇✔️*"
    else
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id)
    return "*المستـخدم* @"..check_markdown(User.username).." "..User.id.." *تـم كتمـه🔇✔️*"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "*لا يمكـنك كتـمي🐸💔*"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "*لا تستطيـع كتـم الادمنيـه والمدراء🐸💔*"
    end
  if is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "*المستـخدم "..matches[2].." *بالفعـل تـم كتمـه🔇✔️*"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "*المستـخدم* "..matches[2].." *تـم كتمـه🔇✔️*"
        end
     end
   end

------------------------الغاء كتم----------------------------
if matches[1] == 'الغاء كتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "*انا لا انكـتم🐸💔*"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "*لا تستطيـع كتـم الادمنـيه والمدراء🐸💔* ️"
    end
  if not is_silent_user(msg.reply.id, msg.to.id) then
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."*بالفعـل تم الغاء كتـمه🔇✖️*"
    else
unsilent_user(msg.reply.id, msg.to.id)
    return "*المستـخدم* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."*تـم الغاء كتمه🔇✖️*"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "المسـتخدم ليـس موجود🐸💔"
    end
	local User = resolve_username(matches[2]).information
  if not is_silent_user(User.id, msg.to.id) then
    return "*المستـخدم  @"..check_markdown(User.username).." "..User.id.."*بالفعـل تـم الغاء كتمـه🔇✖️*"
    else
   unsilent_user(User.id, msg.to.id)
    return "*المستـخدم  @"..check_markdown(User.username).." "..User.id.."تـم الغاء كتـمه🔇✖️"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "*المسـتخدم  "..matches[2].."*بالفعـل تـم الغاء كتمه🔇✖️"
    else
   unsilent_user(matches[2], msg.to.id)
    return "*المستـخدم*  "..matches[2].."*تـم الغاء كتـمه🔇✖️"
        end
     end
   end
-------------------------Banall-------------------------------------
                   
if matches[1] == 'حظر الكل' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "لا يمكنك حظري🐸💔"
    end
if is_admin1(msg.reply.id) then
   return "لا يمكنـك حـظر الادمنـيه والمدراء🐸💔"
    end
  if is_gbanned(msg.reply.id) then
    return "*المستـخدمين* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."*بالفعـل تـم حظرهم🚷✔️"
    else
banall_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "*المستـخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."* تـم حظـرهم🚷✔️"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "المسـتخدم ليـس موجود🐸💔"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "لا يمكنك حظري🐸💔"
    end
if is_admin1(User.id) then
   return "لا يمكنـك حـظر الادمنـيه والمدراء🐸💔"
    end
  if is_gbanned(User.id) then
    return "*المستـخدمين* @"..check_markdown(User.username).." "..User.id.."*بالفعـل تـم حظـرهم🚷✔️*"
    else
   banall_user("@"..check_markdown(User.username), User.id)
     kick_user(User.id, msg.to.id) 
    return "*المستـخدمين* @"..check_markdown(User.username).." "..User.id.."*تـم حظـرهم🚷✔️*"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if is_admin1(tonumber(matches[2])) then
if tonumber(matches[2]) == tonumber(our_id) then
   return "لا يمكنك حظري🐸💔"
    end
   return "لا يمكنـك حـظر الادمنـيه والمدراء🐸💔"
    end
  if is_gbanned(tonumber(matches[2])) then
    return "*المستـخدمين* "..matches[2].."*بالفعـل تـم حظـرهم🚷✔️"
    else
   banall_user('', matches[2])
     kick_user(tonumber(matches[2]), msg.to.id)
    return "*المستخـدمين "..matches[2].."*تـم حظـرهم🚷✔️*"
        end
     end
   end
--------------------------Unbanall-------------------------

if matches[1] == 'الغاء حظر الكل' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "انا لا انحظر🐸💔"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "لا يمكنـك حـظر الادمنـيه والمدراء🐸💔"
    end
  if not is_gbanned(msg.reply.id) then
    return "*المستـخدمين* "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."*بالفعـل تـم الغاء حظـرهم🚷✖️*"
    else
unbanall_user(msg.reply.id)
    return "*المستـخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.."*تـم الغاء حظـرهم🚷✖️*"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "المسـتخدم ليـس موجود🐸💔"
    end
	local User = resolve_username(matches[2]).information
  if not is_gbanned(User.id) then
    return "*المستـخدمين* @"..check_markdown(User.username).." "..User.id.."*بالفعـل تـم الغاء حظـرهم🚷✖️*"
    else
   unbanall_user(User.id)
    return "*المستـخدمين* @"..check_markdown(User.username).." "..User.id.."*تـم الغاء حظـرهم🚷✖️*"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_gbanned(tonumber(matches[2])) then
    return "*المستـخدمين* "..matches[2].."*بالفعـل تـم الغاء حظـرهم🚷✖️"
    else
   unbanall_user(matches[2])
    return "*المستـخدمين* "..matches[2].."*تـم الغاء حظـرهم🚷✖️*"
        end
     end
   end
   -----------------------------------LIST---------------------------
   if matches[1] == 'قائمه الحظر' and is_mod(msg) then
   return banned_list(msg.to.id)
   end
   if matches[1] == 'قائمه الكتم' and is_mod(msg) then
   return silent_users_list(msg.to.id)
   end
   if matches[1] == 'قائمع العام' and is_admin(msg) then
   return gbanned_list(msg)
   end
   ---------------------------clean---------------------------
   if matches[1] == 'مسح' and is_mod(msg) then
	if matches[2] == 'قائمه الحظر' then
		if next(data[tostring(msg.to.id)]['banned']) == nil then
			return "*لا يـوجد محظورين هنـا🚷❌*"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['banned']) do
			data[tostring(msg.to.id)]['banned'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "*المستخـدمين تـم الغاء حظـرهم🚷✖️*"
	end
	if matches[2] == 'قائمه الكتم' then
		if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then
			return "*تـم مسـح المكتوميـن🔇✔️*"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do
			data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "*المستـخدمين تـم الغاء كتمـهم🔇✖️*"
	end
	if matches[2] == 'ثائمه العام' and is_admin(msg) then
		if next(data['gban_users']) == nil then
			return "*المستـخدمين غـير محظورين🚷❌*"
		end
		for k,v in pairs(data['gban_users']) do
			data['gban_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "*المستـخدمين غـير محظورين🚷❌*"
	end
   end

end
return {
	patterns = {
"^(حظر) (.*)$",
"^(حظر)$",
"^(الغاء حظر) (.*)$",
"^(الغاء حظر)$",
"^(طرد) (.*)$",
"^(طرد)$",
"^(حظر الكل) (.*)$",
"^(حظر الكل)$",
"^(الغاء حظر الكل) (.*)$",
"^(الغاء حظر الكل)$",
"^(الغاء كتم) (.*)$",
"^(الغاء كتم)$",
"^(كتم) (.*)$",
"^(كتم)$",
"^(قائمه الكتم)$",
"^(قائمه الحظر)$",
"^(قائمه العام)$",
"^(مسح) (.*)$",
	},
	run = Falcon,

}
