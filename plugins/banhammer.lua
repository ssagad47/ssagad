	
local function BRWUEN(msg, matches)
local data = load_data(_config.moderation.data)
----------------طرد بالرد----------------
if matches[1] == 'طرد' and is_mod(msg) then
   if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋لايمكنني طرد نفسي ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
    else
	kick_user(msg.reply.id, msg.to.id) 
 end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🛑┋لايمكنني طرد نفسي ⛔️"
    end
if is_mod1(msg.to.id, User.id) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
     else
	kick_user(User.id, msg.to.id) 
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🛑┋لايمكنني طرد نفسي ⛔️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
   else
     kick_user(tonumber(matches[2]), msg.to.id) 
        end
     end
   end 

---------------حظر بالرد-------------------      
                   
if matches[1] == 'حظر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋لايمكنني حظر نفسي ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_banned(msg.reply.id, msg.to.id) then
    return "📛┋المستخدم  "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم حظرة مسبقآ 📛"
    else
ban_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم حظرة 📛"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🛑┋لايمكنني حظر نفسي ⛔️"
    end
if is_mod1(msg.to.id, User.id) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_banned(User.id, msg.to.id) then
    return "📛┋المستخدم  "..check_markdown(User.username).." "..User.id.." تم حظرة مسبقآ 📛"
    else
   ban_user(check_markdown(User.username), User.id, msg.to.id)
     kick_user(User.id, msg.to.id) 
    return "📛┋المستخدم  "..check_markdown(User.username).." "..User.id.." تم حظرة 📛"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🛑┋لايمكنني حظر نفسي ⛔️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_banned(tonumber(matches[2]), msg.to.id) then
    return "📛┋المستخدم "..matches[2].."  تم حظرة مسبقآ 📛"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "📛┋المستخدم "..matches[2].." تم حظرة 📛"
        end
     end
   end

---------------الغاء حظر-------------------                         

if matches[1] == 'الغاء حظر' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋لايمكنني كتم نفسي ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋لايمكنك طرد او حظر ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if not is_banned(msg.reply.id, msg.to.id) then
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم الغاء حظرة مسبقآ"
    else
unban_user(msg.reply.id, msg.to.id)
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم الغاء حظرة"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
  if not is_banned(User.id, msg.to.id) then
    return "📛┋المستخدم @"..check_markdown(User.username).." "..User.id.." لايمكنني حظرة 📛"
    else
   unban_user(User.id, msg.to.id)
    return "📛┋المستخدم @"..check_markdown(User.username).." "..User.id.." تم الغاء حظرة"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_banned(tonumber(matches[2]), msg.to.id) then
    return "📛┋المستخدم "..matches[2].." لايمكنني حظرة 📛"
    else
   unban_user(matches[2], msg.to.id)
    return "📛┋المستخدم "..matches[2].." تم الغاء حظرة"
        end
     end
   end

------------------------كتم بالرد-------------------------------------

if matches[1] == 'كتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋لايمكنني كتم نفسي ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋لايمكنك كتم هولاء ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_silent_user(msg.reply.id, msg.to.id) then
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." م كتمة مسبقآ 📛"
    else
silent_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم كتمة 📛"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🛑┋لايمكنني كتم نفسي ⛔️"
    end
if is_mod1(msg.to.id, User.id) then
   return "🛑┋لايمكنك كتم هولاء ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_silent_user(User.id, msg.to.id) then
    return "📛┋المستخدم @"..check_markdown(User.username).." "..User.id.." تم كتمة مسبقآ 📛"
    else
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id)
    return "📛┋المستخدم @"..check_markdown(User.username).." "..User.id.." تم كتمة 📛"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🛑┋لايمكنني كتم نفسي ⛔️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "🛑┋لايمكنك كتم هولاء ⬇️\n(االادمنيه+المدراء+المشرفين)"
    end
  if is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "📛┋المستخدم "..matches[2].." تم كتمة مسبقآ 📛"
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "📛┋المستخدم "..matches[2].." تم كتمة 📛"
        end
     end
   end

------------------------الغاء كتم----------------------------
if matches[1] == 'الغاء كتم' and is_mod(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋انا البوت غير مكتوم ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋ان هولاء المستخدمين ⬇️\n(االادمنيه+المدراء+المشرفين)\n🛑┋غير مكتومين ولايمكنك كتمهم ️"
    end
  if not is_silent_user(msg.reply.id, msg.to.id) then
    return "📛┋المستخدم "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." غير مكتوم 📛"
    else
unsilent_user(msg.reply.id, msg.to.id)
    return "📛┋المستخدم  "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم ازاله كتم 📛"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
  if not is_silent_user(User.id, msg.to.id) then
    return "📛┋المستخدم  @"..check_markdown(User.username).." "..User.id.." غير مكتوم 📛"
    else
   unsilent_user(User.id, msg.to.id)
    return "📛┋المستخدم  @"..check_markdown(User.username).." "..User.id.." تم ازاله كتم 📛"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "📛┋المستخدم  "..matches[2].." غير مكتوم 📛"
    else
   unsilent_user(matches[2], msg.to.id)
    return "📛┋المستخدم  "..matches[2].." تم ازاله كتم 📛"
        end
     end
   end
-------------------------Banall-------------------------------------
                   
if matches[1] == 'حظر الكل' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋لايمكن حظر نفسي ⛔️"
    end
if is_admin1(msg.reply.id) then
   return "🛑┋ان هولاء المستخدمين ⬇️\n(االادمنيه+المدراء+المشرفين)\n🛑┋لايمكن حظرهم ⬆️"
    end
  if is_gbanned(msg.reply.id) then
    return "📛┋المستخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم حظرهم مسبقآ 📛"
    else
banall_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "📛┋المستخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم حظرهم 📛"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🛑┋لايمكن حظر نفسي ⛔️"
    end
if is_admin1(User.id) then
   return "🛑┋ان هولاء المستخدمين ⬇️\n(االادمنيه+المدراء+المشرفين)\n🛑┋لايمكن حظرهم ⬆️"
    end
  if is_gbanned(User.id) then
    return "📛┋المستخدمين @"..check_markdown(User.username).." "..User.id.." تم حظرهم مسبقآ 📛"
    else
   banall_user("@"..check_markdown(User.username), User.id)
     kick_user(User.id, msg.to.id) 
    return "📛┋المستخدمين @"..check_markdown(User.username).." "..User.id.." تم حظرهم 📛"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if is_admin1(tonumber(matches[2])) then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🛑┋لايمكن حظر نفسي ⛔️"
    end
   return "🛑┋ان هولاء المستخدمين ⬇️\n(االادمنيه+المدراء+المشرفين)\n🛑┋لايمكن حظرهم ⬆️"
    end
  if is_gbanned(tonumber(matches[2])) then
    return "📛┋المستخدمين "..matches[2].." تم حظرهم مسبقآ 📛"
    else
   banall_user('', matches[2])
     kick_user(tonumber(matches[2]), msg.to.id)
    return "📛┋المستخدمين "..matches[2].." تم حظرهم 📛"
        end
     end
   end
--------------------------Unbanall-------------------------

if matches[1] == 'الغاء حظر الكل' and is_admin(msg) then
if msg.reply_id then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🛑┋انا البوت غير محظور ⛔️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🛑┋ان هولاء المستخدمين ⬇️\n(االادمنيه+المدراء+المشرفين)\n🛑┋لايمكن حظرهم ⬆️"
    end
  if not is_gbanned(msg.reply.id) then
    return "📛┋المستخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم حظرهم مسبقآ 📛"
    else
unbanall_user(msg.reply.id)
    return "📛┋المستخدمين "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." "..msg.reply.id.." تم ازاله حظرهم 📛"
  end
	elseif matches[2] and not string.match(matches[2], '^%d+$') then
   if not resolve_username(matches[2]).result then
   return "🛑┋المستخدم غير موجود ⛔️"
    end
	local User = resolve_username(matches[2]).information
  if not is_gbanned(User.id) then
    return "📛┋المستخدمين @"..check_markdown(User.username).." "..User.id.." لايمكنك حظرهم 📛"
    else
   unbanall_user(User.id)
    return "📛┋المستخدمين @"..check_markdown(User.username).." "..User.id.." تم ازاله حظرهم 📛"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_gbanned(tonumber(matches[2])) then
    return "📛┋المستخدمين "..matches[2].." لايمكنك حظرهم 📛"
    else
   unbanall_user(matches[2])
    return "📛┋المستخدمين "..matches[2].." تم ازاله حظرهم 📛"
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
   if matches[1] == 'gbanlist' and is_admin(msg) then
   return gbanned_list(msg)
   end
   ---------------------------clean---------------------------
   if matches[1] == 'حذف' and is_mod(msg) then
	if matches[2] == 'قائمه الحظر' then
		if next(data[tostring(msg.to.id)]['banned']) == nil then
			return "📛┋لايوجد محظورين\n📛┋في هذة المجموعه"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['banned']) do
			data[tostring(msg.to.id)]['banned'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "📛┋المستخدمين المحظورين \n📛┋ تم ازاله حظرهم جميعآ"
	end
	if matches[2] == 'قائمه الكتم' then
		if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then
			return "📛┋المستخدمين المكتومين"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do
			data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "📛┋المستخدمين المكتومين\n📛┋تم ازاله كتمهم جميعآ"
	end
	if matches[2] == 'gbans' and is_admin(msg) then
		if next(data['gban_users']) == nil then
			return "📛┋انهم غير محظوين"
		end
		for k,v in pairs(data['gban_users']) do
			data['gban_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "📛┋انهم غير محظوين"
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
"^[!/](gbanlist)$",
"^(حذف) (.*)$",
	},
	run = BRWUEN,

}

-- تم تعريب بواسطه بروين
-- اهل سورسات لاتخمطون 
-- كس عرضه ليخمط وليبدل حقو