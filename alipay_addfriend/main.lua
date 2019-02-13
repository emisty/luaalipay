
require("TSLib")

local http = require 'socket.http'

--local pixel = "10801920"
local pixel = "7201280"

local geturl = "http://47.106.115.69:8905/"
--local geturl = "http://127.0.0.1:8905/"

imei = getIMEI()

local new_time = os.time();
nowtime = os.date("%Y-%m-%d-%H:%M:%S",new_time);


--保存imei
function saveImei(imei,nowtime)
	body,c,l,h = http.request(geturl..'SaveImei?imei='..imei.."&times="..nowtime)
end

saveImei(imei,nowtime)
mSleep(2000)
toast("请根据当前手机id 去数据库输入当前支付宝登入的账号"..imei,5)

function Split(szFullString, szSeparator)  
	local nFindStartIndex = 1  
	local nSplitIndex = 1  
	local nSplitArray = {}  
	while true do  
		local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
		if not nFindLastIndex then  
			nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
			break  
		end  
		nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
		nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
		nSplitIndex = nSplitIndex + 1  
	end  
	return nSplitArray  
end   

local my_phone = "" --当前手机
local my_mes = "" --发送的消息
local waittimes = 1

--获取手机号
function getPhone(imei)
	body,c,l,h = http.request(geturl..'GetPhone?imei='..imei.."&times="..nowtime)

	sss = tostring(body)
	ss = string.sub(sss,2,#sss-1)

	if ss == "0|1" then

		if waittimes > 13 then
			os.exit()
		end
		waittimes = waittimes + 1

		mSleep(3000)
		toast("请根据当前手机id"..imei.."去数据库输入当前支付宝登入的账号",2)
		getPhone(imei)	
	 else
	 	bodyA = Split(ss,"|")
		if #bodyA[1] > 10 then
			my_phone = bodyA[1]
			my_mes = bodyA[2]
		else
			if waittimes > 13 then
				os.exit()
			end
			waittimes = waittimes + 1

			mSleep(3000)
			toast("请根据当前手机id"..imei.."去数据库输入当前支付宝登入的账号",2)
			getPhone(imei)
		end
	end
end

getPhone(imei)

toast(my_phone.."账号成功绑定",1)

--获取我要加的好友10条
function getNeedAddFriend()
	body,c,l,h = http.request(geturl..'GetNeedAddFriend?phone='..my_phone)
	sss = tostring(body)
	ss = string.sub(sss,2,#sss-1)

	return ss
end

--g跟新状态
function UpdateNeedAddfriend(isreal,isaddfriend,phone)
	body,c,l,h = http.request(geturl..'UpdateNeedAddfriend?isreal='..isreal.."&isaddfriend="..isaddfriend.."&toid="..my_phone.."&phone="..phone)
end

--删除输入
function deleteInput()
	for var = 1,15 do
		inputText("\b")
		--iOS 设备连续输入建议加下延时时间，否则可能因为速度太快导致输入错误
		mSleep(20)
	end
end

function click(x,y)
	mSleep(200)  touchDown(x, y) mSleep(200) touchUp(x, y)
	mSleep(2*1000)
end


function isPositionIn(x1,y1,c1,x2,y2,c2,x3,y3,c3,x4,y4,c4)
	Someview = {
		position = {
			{x1,y1,c1},
			{x2,y2,c2},
			{x3,y3,c3},
			{x4,y4,c4},
		}
	}
	if multiColor(Someview.position,80) then
		dialog("true", 1)
		return true
	else
		dialog("false", 1)
		return false
	end 
end


function isPositionInb(x1,y1,c1,x2,y2,c2,x3,y3,c3,x4,y4,c4,x5,y5,c5,x6,y6,c6,x7,y7,c7,x8,y8,c8)
	Someview = {
		position = {
			{x1,y1,c1},
			{x2,y2,c2},
			{x3,y3,c3},
			{x4,y4,c4},
			{x5,y5,c5},
			{x6,y6,c6},
			{x7,y7,c7},
			{x8,y8,c8},
		}
	}
	if multiColor(Someview.position,80) then
		dialog("true", 1)
		return true
	else
		dialog("false", 1)
		return false
	end 
end

----------------------------------------------------------------页面操作start--------------------------------------------

--搜索号码页面 输入框最右边叉叉
function searchPhoneDeleteText()
	if pixel == "7201280" then
		click(670,89)
	elseif pixel == "10801920" then
		click(1043,138)
	elseif pixel == "15362084" then
		click(1500,99)
	else
		return false
	end
	return true
end

--搜索号码页面 点击搜索
function searchPhoneClickSearch()
	if pixel == "7201280" then
		click(375,208)
	elseif pixel == "10801920" then
		click(546,274)
	elseif pixel == "15362084" then

	else
		return false
	end
	return true
end


--如果存在加好友三个字
function isExistAddFriend()
	if pixel == "7201280" then
		return isPositionIn(499,781,"0x2287cd",511,780,"0x3584bd",526,777,"0x45aaf2",556,776,"0x208cd7")
	elseif pixel == "10801920" then			
		ina = isPositionInb(740,1162,"0x128ae1",740,1173,"0x7db9de",745,1173,"0xf4ffff",756,1173,"0x1b8bdf",784,1180,"0x198cdf",830,1177,"0x218dd6",847,1175,"0xfcffff",856,1159,"0x3783bd")
		
		if ina then
			return true
		else
			return false
		end
	elseif pixel == "15362084" then

	else
		return false
	end
	return true
end

--搜索出人的页面 点击加好友
function accountClickAdd()
	if pixel == "7201280" then
		click(541,785)
	elseif pixel == "10801920" then
		click(794,1172)
	elseif pixel == "15362084" then
		click(794,1172)
	else
		return false
	end
	return true
end

--进入 好友验证 删除已有的消息
function addVerifyDeleteText()
	if pixel == "7201280" then
		click(667,288)
	elseif pixel == "10801920" then
		click(1000,434)
	elseif pixel == "15362084" then

	else
		return false
	end
	return true
end


--进入 好友验证 点击 发送验证消息
function addVerifyClickSend()
	if pixel == "7201280" then
		click(623,90)
	elseif pixel == "10801920" then
		click(938,141)
	elseif pixel == "15362084" then
		click(1442,96)
	else
		return false
	end
	return true
end

--不存加好友 已经是好友的 点击返回
function accountClickbBack()
	if pixel == "7201280" then
		click(42,89)
	elseif pixel == "10801920" then
		click(57,139)
	elseif pixel == "15362084" then
		click(45,89)
	else
		return false
	end
	return true
end

--加号旁边的小人在 说明登入页面 第一页
function isExistSmallPerson()
	if pixel == "7201280" then
		return isPositionIn(599,74,"0xedffff",592,89,"0xecffff",607,89,"0xe9ffff",599,84,"0x1b82d1")
	elseif pixel == "10801920" then
		return isPositionIn(893,142,"0xf2ffff",907,143,"0xfcffff",900,122,"0x1983cf",900,112,"0xf9ffff")
	elseif pixel == "15362084" then
		return isPositionIn(1410,102,"0xffffff",1421,102,"0xfdfeff",1415,88,"0x1b82d2",1415,81,"0xffffff")
	else
		return false
	end
	return true
end

--是否未实名三个字 已经实名三个子
function isRealName()
	if pixel == "7201280" then
		norealnamea = isPositionInb(294,931,"0xa4a5a9",300,936,"0xf2f3f5",298,945,"0xa3a4a6",320,935,"0xa4a5a7",340,939,"0xa5a6a8",357,939,"0xf7f7f9",364,927,"0xffffff",358,931,"0xe7e7e9")
		norealnameb = isPositionInb(279,802,"0x3f81b1",288,802,"0x188bdc",288,810,"0x0b88e5",317,814,"0x198cdc",318,799,"0x2789d2",339,812,"0x218bd5",351,815,"0xfffffb",354,802,"0x5197cb")
		norealnamec = isPositionInb(297,934,"0xa3a4a8",300,937,"0xf2f3f5",300,944,"0xa4a5a7",334,943,"0xababad",321,935,"0xa5a6a8",357,928,"0xb9b9bb",360,933,"0xfcfcfe",363,937,"0xaeaeb0")

		realnamea = isPositionInb(332,905,"0xe35d7e",331,910,"0xfdfeff",328,919,"0xf2849f",350,910,"0xcb6a7e",356,908,"0xc97f90",376,911,"0xef597c",392,910,"0xdd6885",399,902,"0xd16984")
		realnameb = isPositionInb(331,910,"0x2799f9",332,919,"0xfcffff",327,924,"0x5ab8ff",356,913,"0x5390bd",374,917,"0x419de8",394,913,"0x40a7f4",404,905,"0xfdfcfa",402,921,"0x64a2d3")
		realnamec = isPositionInb(337,860,"0xe76281",332,869,"0xfffeff",335,879,"0xed829c",357,868,"0xc58092",374,870,"0xf18199",396,868,"0xff90aa",403,881,"0xfff9fa",395,860,"0xffadc1")
		realnamed = isPositionInb(330,931,"0x259af9",332,938,"0xf9feff",333,947,"0x56aef5",355,937,"0xe6ffff",372,938,"0x4eaefa",393,938,"0x4397df",403,934,"0xf8fcfd",398,943,"0x4a91c9")

		if norealnamea or norealnameb or norealnamec  then
			return 1
		elseif realname or realnameb or realnamec or realnamed then
			return 2
		else
			return 3
		end 
	elseif pixel == "10801920" then

		norealname = isPositionInb(445,1395,"0xa3a4a8",447,1403,"0xfeffff",448,1414,"0xa4a5a9",480,1405,"0xa6a7a9",487,1398,"0xfeffff",499,1405,"0xeff0f2",510,1406,"0xa5a6aa",519,1401,"0xfefefe")
		realname = isPositionInb(502,1375,"0xfcffff",504,1360,"0x239efe",528,1369,"0x279cf9",566,1374,"0x289bf8",596,1376,"0xfffffd",596,1368,"0x3497e8",576,1348,"0x3298ec",506,1385,"0x5bb7ff")
		realnameb = isPositionInb(502,1399,"0x289cf3",501,1402,"0xc3eeff",501,1415,"0xdaffff",534,1402,"0x3598e9",558,1407,"0x3499e9",581,1405,"0xe4f7ff",588,1395,"0x3697e6",582,1382,"0x4893cd")
		realnamec = isPositionInb(511,1398,"0xf45a7e",501,1404,"0xfffffd",495,1418,"0xff8fa8",536,1414,"0xe66180",566,1396,"0xfff0f7",581,1402,"0xfdfdfd",595,1411,"0xfff5fb",594,1405,"0xee6384")

		if norealname  then
			return 1
		elseif realname or realnameb or realnamec then
			return 2
		else
			return 3
		end 
	elseif pixel == "15362084" then
		
	else
		return 3
	end
	return 3
end

--首页进入通讯录页面
function indexClickSmallPerson()
	if pixel == "7201280" then
		click(599,74)
	elseif pixel == "10801920" then
		click(899,147)
	elseif pixel == "15362084" then
		click(1417,102)
	else
		return false
	end
	return true
end


--通讯录进入添加朋友
function frindClickAadFriend()
	if pixel == "7201280" then
		click(677,92)
	elseif pixel == "10801920" then
		click(999,135)
	elseif pixel == "15362084" then
		click(1484,101)
	else
		return false
	end
	return true
end


--点击输入 号码 进入搜索号码页面
function friendClickInput()
	if pixel == "7201280" then
		click(370,229)
	elseif pixel == "10801920" then
		click(1013,343)
	elseif pixel == "15362084" then
		click(940,230)
	else
		return false
	end
	return true
end

--首页点击最左首页按钮
function indexClickIndex()
	if pixel == "7201280" then
		click(72,1224)
	elseif pixel == "10801920" then
		click(110,1835)
	elseif pixel == "15362084" then
		click(152,1984)
	else
		return false
	end
	return true
end

function myInputText(mes)
	switchTSInputMethod(true)
	mSleep(500)
	inputText(mes)
	switchTSInputMethod(false)
	mSleep(500)
end


----------------------------------------------------------------页面操作end-----------------------------------------------

function addFriend(phone,mes)
	
	--删除已经有的号码 点击两下把一个提示点掉
	searchPhoneDeleteText()
	searchPhoneDeleteText()

	myInputText(phone)
	mSleep(2000);

	--点击搜索
	searchPhoneClickSearch()
	
	--是否有未实名三个字
	isreal = isRealName()
	if isreal == 1 then --未实名
		toast("未实名",1)
	elseif isreal == 2 then --实名
		toast("实名",1)
	else
		toast("未知是否实名，应该是不存在这个账号",1)
	end

	mSleep(1000)
	--accountClickbBack()

	isaddfriend = 0
	--如果存在加好友三个字 且要实名
	if isExistAddFriend() and isreal == 2 then
		--点击加好友
		accountClickAdd()

		--进入 好友验证 删除已有的消息
		addVerifyDeleteText()
		
		mSleep(1000)
		--填入验证消息
		myInputText(mes);
		mSleep(1000)

		--点击发送
		addVerifyClickSend()
		isaddfriend = 2
		--
		accountClickbBack()

	else
		toast("不存在账号,或者未实名不加好友",1)
		--间隔时间
		mSleep(1000)
		isaddfriend = 1
		--不存加好友 已经是好友的 点击返回
		accountClickbBack()
		--friendClickInput()
		--全部重新填入
		--addFriend()
	end

	--跟新状态
	UpdateNeedAddfriend(isreal,isaddfriend,phone)
end



function flowAddFriend()
	indexClickSmallPerson()

	frindClickAadFriend()
	friendClickInput()
	

	--获取手机号
	--phoneS = "13802221693|13067216004|13087411904|18608725443"
	isconutine = true
	
	while isconutine == true  do

		phoneS = getNeedAddFriend()
		if phoneS == "" then
			isconutine = false
		else
			phones = Split(phoneS,"|")
			for i = 1, #phones do  
				addFriend(phones[i],my_mes)
			end
		end
	end
	
	toast("全部好友加好了", 2)
	
	
end

r = runApp("com.eg.android.AlipayGphone"); --打开支付宝
mSleep(4 * 1000);--测试时间短一点

if r == 0 then
	if isExistSmallPerson() == true then
		flowAddFriend()
	else
		toast("请确认当前是登入状态并在第一页，尝试跳转", 1)
		indexClickIndex()
		mSleep(1000)
		if isExistSmallPerson() then
			flowAddFriend()
		else
			dialog("请确认当前是登入状态并在第一页，跳转失败", 3)
		end
		
	end
	
end