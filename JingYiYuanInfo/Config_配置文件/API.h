//
//  API.h
//  壹元服务
//
//  Created by VINCENT on 2017/3/23.
//  Copyright © 2017年 北京京壹元资讯信息服务有限公司. All rights reserved.

// 壹元资讯的接口合集

#ifndef API_h
#define API_h

#define domainUrl  @"http://yyapp.1yuaninfo.com"  //域名拼接地址
#define yyfwJointUrl @"http://yyfw.1yuaninfo.com/houtai/" //之前服务器数据图片，
#define yyappJointUrl @"http://yyapp.1yuaninfo.com/app/houtai/" //图片拼接地址
#define showWebJointUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/showdetails.php?id=" // 演出详情拼接的地址
#define infoVideoJointUrl @"http://yyapp.1yuaninfo.com/app/houtai/" // 视频拼接的地址
#define infoWebJointUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/news-details.php?id=" //资讯详情拼接的地址
#define niuWebJointUrl @"http://yyapp.1yuaninfo.com/app/yyfwapp/niu_article.php?id=" //牛人观点详情拼接的地址
#define projecyJointUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/xiangmu-details.php?xmid="

#define periodJointUrl  @"http://yyapp.1yuaninfo.com/app/application/report.php?id="  //周刊月刊的拼接地址

#define goodsJointUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/gift_details.php?id="   //积分兑换的商品详情页



//请求参数宏
#define USERID @"userid"
#define USERNAME @"username"
#define MOBILE  @"mobile"
#define PWD @"pwd"
#define PASSWORD @"password"
#define YZM @"yzm"
#define KEYWORD @"keyword"
#define LASTID  @"lastid"


//返回值参数宏
#define STATUS @"status"
#define USERINFO @"userinfo"




#pragma ------------------------------------------------------------------------
#pragma -------------------------   登录注册忘记密码   -----------------------------

#pragma mark   第一次下载APP初始化用户deviceToken  参数act=setup  devicetoken=  mobiletype = 0 Android   1 iOS
#pragma mark   注册账号之前调该接口获取userid，然后注册时要用到userid   参数 act = getuserid   devicetoken=     mobiletype = 0 Android   1 iOS
#define firstConfigUrl  [NSString stringWithFormat:@"%@/app/application/user_setup.php",domainUrl]

#pragma 退出操作

#define logOutUrl   [NSString stringWithFormat:@"%@/app/application/user_logout.php",domainUrl]


#pragma 根据手机号、密码、验证码注册接口（返回用户信息）
//参数 mobile(手机号), yzm(验证码), password(密码)
//返回值 status:0（不能为空）,1（成功）,2（插入数据库失败）,3（验证码超时）,4（验证码错误）
//http://yyapp.1yuaninfo.com/app/application/validate.php?mobile=17090028712&yzm=5785010&password=1111
/** 注册接口*/
#define signupUrl [NSString stringWithFormat:@"%@/app/application/validate.php",domainUrl]


#pragma 注册:  手机获取验证码接口 和忘记密码获取验证码的接口一样参数不一样 用keyword=reg区分
//参数 mobile(手机号), keyword=reg 返回值 status:1 (成功) 0 (失败) 3 (失败,已经注册)
//http://yyapp.1yuaninfo.com/app/application/register.php?keyword=reg&mobile=17090028712
/** 注册获取验证码接口*/
#define registerVerificationUrl [NSString stringWithFormat:@"%@/app/application/register.php",domainUrl]


#pragma 登录: 手机号、密码登录接口（返回用户信息）
//参数mobile(手机号),password(密码)  返回值 status 0 登录失败,userinfo:userid,avatar(头	像),mobile,guling,capital(资金),email,qqnum,weixin,weibo,groupid(会员级别)
//http://yyapp.1yuaninfo.com/app/application/usersign.php?mobile=13718040895&password=9CBF8A4DCB8E30682B927F352D6559A0
/** 登录接口*/
#define signinUrl [NSString stringWithFormat:@"%@/app/application/usersign.php",domainUrl]


#pragma 忘记密码,重置密码： 和注册获取验证码都是一个接口 但是参数不一样 用keyword=reg区分
//手机号获取验证码接口 参数 mobile(手机号) 返回值 status:1 成功 status:0失败
//http://yyapp.1yuaninfo.com/app/application/register.php?mobile=17090028712
/** 重置密码的验证码接口*/
#define resetpwdVerificationUrl [NSString stringWithFormat:@"%@/app/application/register.php",domainUrl]


#pragma 修改密码:参数 mobile(手机号),password(新密码),yzm（验证码）
//status:1成功 2验证码错误或者超时,3入库失败(系统错误)
//http://yyapp.1yuaninfo.com/app/application/modify_pwd.php?mobile=17090028712&password=123456&yzm=232122
/** 修改密码接口*/
#define changenewPwdUrl [NSString stringWithFormat:@"%@/app/application/modify_pwd.php",domainUrl]


#pragma 发验证码到新手机号
//参数 mobile, keyword=reg 返回值 status:1 成功 status:0 失败 3 失败,已经注册
//http://yyapp.1yuaninfo.com/app/application/register.php?keyword=reg&mobile=17090028712
//keyword=reg&mobile=17090028712
#define changePhoneVerificationUrl  [NSString stringWithFormat:@"%@/app/application/register.php",domainUrl]


//验证
//参数 mobile, yzm返回值 status:0 不能为空,1成功,2插入数据库失败,3验证码超时,4验证码错误
//http://yyapp.1yuaninfo.com/app/application/validate.php?mobile=17090028712&yzm=5785010
#define changePhoneUrl  [NSString stringWithFormat:@"%@/app/application/validate.php",domainUrl]


#pragma ------------------------------------------------------------------------
#pragma ----------------------     首页数据     ----------------------------------

#pragma 首页刷新接口
//http://yyapp.1yuaninfo.com/app/application/hom_1.php?act=top
//参数:act=top
//返回参数:roll_pic 轮播图数组(picurl图片地址,piclink链接地址) ,
//        roll_words 快讯数组(wordscontent文字内容,wordslink文字链接),
//        sroll_pic 横幅轮播数组(picurl链接,piclink图片),
//        post_msg消息(id,keyword1,alert/title标题,show_msg简介,addtime时间)
//        keyword1:5 早餐,6早评,7上午分享,8午评,9下午分享,10收评,11夜宵,12即使通知
/** 首页的刷新接口*/
#define mainUrl @"http://yyapp.1yuaninfo.com/app/application/hom_1.php?act=top"
//[NSString stringWithFormat:@"%@/app/application/hom_1.php?act=top",domainUrl]



#pragma 首页左上角，消息列表接口（标题和时间）
//参数 act固定值list  > 
//http://yyapp.1yuaninfo.com/app/application/message.php?act=list
//返回值 [{"date":日期 "04月10日",
//"info":相应日期的快讯数组 [{"id":快讯的id,拼接成链接 "5", "title":快讯的标题 "文字公告", "addtime":快讯添加的时间 "2017-04-10"}]}]
/** 消息列表接口*/
#define messagesUrl [NSString stringWithFormat:@"%@/app/application/message.php",domainUrl]


#pragma 消息详情页（静态页面）
//参数  act=detail  id=消息的id
//http://yyapp.1yuaninfo.com/app/application/message.php?act=details&id=1
/** 消息详情页接口*/
#define messagedetailUrl(msgId) [NSString stringWithFormat:@"%@/app/application/message.php?act=detail&id=%@",domainUrl,msgId]


#pragma 推送历史记录接口
//参数  date = 2017-08-08
//http://yyapp.1yuaninfo.com/app/application/history_msg_list.php
//返回值  id  keyword1(服务名称)  keyword2(服务时间) remark(主体内容) fxtime(分享时间) dmname(代码名称)()()()()()()()
/** 推送历史记录接口*/
#define pushListUrl  [NSString stringWithFormat:@"%@/app/application/history_msg_list.php",domainUrl]


#pragma 快讯的列表接口
//参数 act = morerollwords
//http://yyapp.1yuaninfo.com/app/application/hom_1.php
//返回值 {"roll_words":[{"date":"05月23日",
//                      "info":[{"wid":"2","title":"壹元服务全面升                 级","addtime":"2017-05-23"}]}],
//      "lastdate":"2017-05-23"}
/** 快讯列表接口*/
#define fastMsgListUrl  [NSString stringWithFormat:@"%@/app/application/hom_1.php",domainUrl]


#pragma 快讯的加载更多接口
//参数 act = morerollwords  lastdate=

#pragma 快讯的详情接口
//http://yyapp.1yuaninfo.com/app/yyfwapp/newsflash.php?wid=1
#define fastMsgDetailUrl @"http://yyapp.1yuaninfo.com/app/yyfwapp/newsflash.php?wid="



#pragma ------------------------------------------------------------------------
#pragma -------------------------   首页热搜榜资讯   -----------------------------------

#pragma 首次加载:
//标签,默认第一个标签下的资讯
//http://yyapp.1yuaninfo.com/app/application/hotspot.php?act=default
//返回值:
//tag_arr 标签数组: {id=资讯类别id   classname=类别名称 }

//info_arr 资讯数组: {id 文章id, title标题, source来源, description描述, picurl单图缩略图, picarr多图和图集, posttime时间, keywords标签(空格间隔，现在就一个标签), picstate(资讯样式类型 1为左图，2为大图，3为三图，4为图集)}
//图片地址前拼接 http://yyfw.1yuaninfo.com/houtai/

//hot_arr 排行数组: {rname 名称,rlink链接 , pop_num 人气值}

//lastid 文章id

//参数 act=default
/** 热搜榜默认初始化接口*/
#define hotdefaultUrl   [NSString stringWithFormat:@"%@/app/application/hotspot.php",domainUrl]



#pragma 资讯标签点击切换新闻接口:
//http://yyapp.1yuaninfo.com/app/application/hotspot.php?act=classify&classify=12
//返回值  hot_arr (排行数组)   info_arr (资讯数组)  lastid=17046文章id
//参数  act=classify   classify=标签对应id
/** 点击标签加载对应新闻数据*/
#define newsUrl  [NSString stringWithFormat:@"%@/app/application/hotspot.php",domainUrl]


#pragma 换一批小标签接口
//http://yyapp.1yuaninfo.com/app/application/hotspot.php?act=change&changeid=1
//返回值: tag_arr(标签数组)  hot_arr (排行数组)  info_arr (资讯数组) lastid=17046文章id
//参数  act=change  changeid=1 就是默认, 2 ,3  轮回
/** 换一批小标签，同热搜初始化接口*/
#define changetagsUrl  [NSString stringWithFormat:@"%@/app/application/hotspot.php",domainUrl]

#pragma 热搜榜加载更多接口
//http://yyapp.1yuaninfo.com/app/application/hotspot.php?act=loadmorehot&lastid=数字&classid=类别
//返回值: info_arr (资讯数组) lastid=17046文章id
//参数 act=loadmorehot  lastid=数字   classid=类别
/** 热搜榜加载更多接口*/
#define hotnewsmoreUrl  [NSString stringWithFormat:@"%@/app/application/hotspot.php",domainUrl]


#pragma ------------------------------------------------------------------------
#pragma -------------------------   首页牛人榜资讯   -------------------------------
/**
 *  "id": "1",
 "niu_name": "胡说",
 "niu_introduce": " 小胡说的是八戒也不知道",
 "niu_tag": "小虎 八戒",
 "niu_img": "http://yyapp.1yuaninfo.com/uploads/image/20170801/niuren1.jpg",
 "niu_pop": "112",
 "niu_modtime": "11133111",
 "niu_follow": "1231",
 "niu_type": "0"
 
 "id": "6",
 "niu_id": null,
 "title": "宝兰高铁通车运营 中国高铁实现",
 "source": "壹元服务",
 "author": "admin",
 "keywords": "西藏 拉萨",
 "description": "今天，从陕西宝鸡到甘肃兰州的宝兰高铁将正式通车运营。",
 "picurl": "uploads/image/20170710/1499655302.png",
 "posttime": "1499650846"
 */


#pragma 牛人帮初始化接口
//http://yyapp.1yuaninfo.com/app/application/niu.php
//返回值: niu_arr 牛人列表数组  (id:牛人的id  niu_name:牛人的名称  niu_introduce:牛人介绍 niu_tag:牛人定位 niu_img:牛人图片(不用加前缀) niu_pop:牛人的人气值  niu_modtime:牛人最后更新时间  niu_follow:关注量  niu_type:推荐的牛人(不用管))
//niuart_arr 牛人观点数组  (id:牛人文章的id  niu_id:牛人id  title:牛人文章标题  source:牛人文章来源  author:文章作者  keywords:文章标签  description:文章描述  picurl:文章图片(需要加前缀)  posttime:文章发布时间)
//lastid(文章id)
//参数 无
/** 牛人帮初始化接口*/
#define niunewsdefaultUrl  [NSString stringWithFormat:@"%@/app/application/niu.php",domainUrl]


#pragma 牛人榜加载更多接口
//http://yyapp.1yuaninfo.com/app/application/niu.php?act=loadmoreniu&lastid=数字
//返回值: id(文章id), niu_id(牛人id), title(标题), source(来源), author(作者), keywords(标签(空格间隔)), description(描述), picurl(图片), posttime(添加时间)
//参数  act=loadmoreniu  lastid=数字
/** 牛人榜加载更多接口*/
#define niunewsmoreUrl  [NSString stringWithFormat:@"%@/app/application/niu.php",domainUrl]



#pragma ------------------------------------------------------------------------
#pragma -----------------------  频道界面的接口  ---------------------------------
#pragma 所有接口都一样，只是参数不同


#pragma 频道每个类型新闻的排行加载更多接口
//参数 rank_lastid 当前界面的最后一条排行数据的lastid  classid  act=rankmore
//http://yyapp.1yuaninfo.com/app/application/channel.php
#define rankMoreUrl  [NSString stringWithFormat:@"%@/app/application/channel.php",domainUrl]


#pragma 频道界面普通新闻资讯的接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=info&classid=CLASSID
//返回值 : "hangqing": 新闻数组 { "id": "17777",
//"title": 标题   "韩国国防部：明日临时部署4辆“萨德”发射车",
//"source": 来源  "壹元服务",
//"description": 描述  "",
//"picurl": 图片   "uploads/image/20170906/1504695396.png",
//"picarr": 图集[ {img:图片  descreption:描述 }],
//"posttime": 时间  "2017-09-06 17:14:30",
//"keywords": 标签  "",
//"picstate": 新闻样式   "1" }

//"rank_arr": 新闻排行数组 {
            //"id": "1",
            //"self_name": 排行标题  "股市1",
            //"self_link": 排行链接 "http://www.baidu.com",
            //"pop_value": 人气值 "321" },
//"lastid": "17777"
//参数：act=info   classid=
#define channelNewsUrl  [NSString stringWithFormat:@"%@/app/application/channel.php",domainUrl]



#pragma 频道列表新闻加载更多接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=infomore&classid=CLASSID&lastid=
//返回值："hangqing":"[ ]"  "lastid":""
//参数：act=infomore   classid=   lastid=


#pragma 新闻视频刷新接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=video
//返回值: "v_arr":视频数组 { id: "1341", "v_name": 视频标题, "v_picture": 视频图片, "v_hits": "点击量, "v_time": 时长, "v_url": 视频地址需拼接"uploads/media/20170906/1504696315.mp4", "v_tag": 视频标签空格隔开, "v_source": 视频来源, "v_modtime": 视频添加时间"2017-09-06 17:21:51", "v_sharUrl": 分享视频的地址, "delstate": "false", "deltime": ""}    lastid : 加载更多时的id
//参数  act=video


#pragma 新闻视频刷新接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=videomore&lastid=LASTID
//返回值: "v_arr":视频数组 { id: "1341", "v_name": 视频标题, "v_picture": 视频图片, "v_hits": "点击量, "v_time": 时长, "v_url": 视频地址需拼接"uploads/media/20170906/1504696315.mp4", "v_tag": 视频标签空格隔开, "v_source": 视频来源, "v_modtime": 视频添加时间"2017-09-06 17:21:51", "v_sharUrl": 分享视频的地址, "delstate": "false", "deltime": ""}    lastid : 加载更多时的id
//参数  act=videomore  lastid =




#pragma 新闻音乐刷新接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=music
//返回值: "m_arr":音乐数组 { "id": "254",
//"picurl":  音乐图片 "uploads/image/20170906/1504667396.jpg",
//"hits": 音乐点击量 "180",
//"sname": 歌曲名 "33",
//"singer": 歌手名 "444",
//"URL": 音乐地址  "uploads/media/20170906/1504675826.mp3",
//"posttime": 时间 "2017-09-06 11:01:49",
//"delstate": "false",
//"deltime": ""}
//lastid : 加载更多时的id
//参数  act=music



#pragma 新闻音乐更多接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=musicmore&lastid=LASTID
//返回值: "m_arr":音乐数组 { "id": "254",
//"picurl":  音乐图片 "uploads/image/20170906/1504667396.jpg",
//"hits": 音乐点击量 "180",
//"sname": 歌曲名 "33",
//"singer": 歌手名 "444",
//"URL": 音乐地址  "uploads/media/20170906/1504675826.mp3",
//"posttime": 时间 "2017-09-06 11:01:49",
//"delstate": "false",
//"deltime": ""}
//lastid : 加载更多时的id
//参数  act=musicmore  lastid =



#pragma 新闻演出刷新接口
//新闻演出刷新接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=show
//返回值:  "lb_arr" 轮播图数组: [{"picurl":图片地址（不需拼接）  "piclink":图片对应的网址（不需拼接）}]
//"tj_arr" 推荐数组: [{ "id": "1"拼接id形成网址 ,"indeximg": 拼接imgJointUrl"uploads/image/20170225/1488014998.png" }
//"xh_arr" 喜欢的列表: [{
                //   "id":         id         "301",
                //   "actionname": 标题         "主课上午",
                //   "palace":     地点         "北京天音",
                //   "actiontime": 时间         "2017-09-06 11:40:22",
                //   "indeximg":   图片         "uploads/image/20170906/1504671647.jpg",
                //   "tag":                 null,
                //   "price":      价格         "100元/张"}]
//   "lastid": "34"
//参数  act=show


//新闻演出加载更多接口
//http://yyapp.1yuaninfo.com/app/application/channel.php?act=showmore&lastid=LASTID
//"xh_arr" 喜欢的列表: [{
//   "id":         id         "301",
//   "actionname": 标题         "主课上午",
//   "palace":     地点         "北京天音",
//   "actiontime": 时间         "2017-09-06 11:40:22",
//   "indeximg":   图片         "uploads/image/20170906/1504671647.jpg",
//   "tag":                 null,
//   "price":      价格         "100元/张"}]
//   "lastid": "34"
//参数  act=showmore  lastid=



#pragma 频道产品  -----  按产品分类接口  按公司分类接口  接口一致，参数不一致
//http://yyapp.1yuaninfo.com/app/application/product.php?act=product 按产品分类
//http://yyapp.1yuaninfo.com/app/application/product.php?act=company 按公司分类
#define channelProductionUrl  [NSString stringWithFormat:@"%@/app/application/product.php",domainUrl]



#pragma 频道项目接口

//http://yyapp.1yuaninfo.com/app/application/project.php?act=xiangmu 项目推荐
//http://yyapp.1yuaninfo.com/app/application/project.php?act=moretj&lastid=LASTID   项目推荐加载更多
//http://yyapp.1yuaninfo.com/app/application/project.php?act=other&keyword=KEYWORD     38房产,39移民,40旅游,41教育,42文化,43科技,44汽车  刷新数据

//http://yyapp.1yuaninfo.com/app/application/project.php?act=moreother&keyword=KEYWORD&keyword=KEYWORD&lastid=LASTID  38房产,39移民,40旅游,41教育,42文化,43科技,44汽车  加载更多
/** 频道项目接口*/
#define projectUrl  [NSString stringWithFormat:@"%@/app/application/project.php",domainUrl]



#pragma 频道三找接口
//http://yyapp.1yuaninfo.com/app/application/tougu.php?act=tougu  投顾全部
//http://yyapp.1yuaninfo.com/app/application/tougu.php?act=touguchange 投顾推荐换一批
//http://yyapp.1yuaninfo.com/app/application/tougu.php?act=allmore&lastid=LASTID 投顾的全部数据上拉加载更多
//http://yyapp.1yuaninfo.com/app/application/tougu.php?act=notall&keyword=  投顾的子类刷新数据  1荐股/2工具/3方法
//http://yyapp.1yuaninfo.com/app/application/tougu.php?act=othermore&keyword=KEWORD&lastid=LISTID  投顾的子类加载更多的数据  keyword = 1荐股/2工具/3方法
/** 投顾接口*/
#define adviserUrl  [NSString stringWithFormat:@"%@/app/application/tougu.php",domainUrl]


//http://yyapp.1yuaninfo.com/app/application/quanshang.php?act=quanshang  券商全部
//http://yyapp.1yuaninfo.com/app/application/quanshang.php?act=qschange  券商推荐换一批
//http://yyapp.1yuaninfo.com/app/application/quanshang.php?act=allmore&lastid=LASTID  券商加载更多
//http://yyapp.1yuaninfo.com/app/application/quanshang.php?act=notall&keyword= 券商子类的刷新数据  keyword = 1 QDII/QFII 2 交易 3 资管
//http://yyapp.1yuaninfo.com/app/application/quanshang.php?act=othermore&keyword=KEYWORD&lastid=LASTID   券商子类的加载更多  keyword = QDII/QFII 2 交易 3 资管

/** 券商接口*/
#define brokerUrl  [NSString stringWithFormat:@"%@/app/application/quanshang.php",domainUrl]


//http://yyapp.1yuaninfo.com/app/application/jijin.php?act=jijin  基金全部
//http://yyapp.1yuaninfo.com/app/application/jijin.php?act=jjchange 基金推荐换一批
//http://yyapp.1yuaninfo.com/app/application/project.php?act=allmore&lastid=LASTID  基金全部加载更多
//http://yyapp.1yuaninfo.com/app/application/project.php?act=notall&keyword=KEYWPRD   基金子类的刷新数据    keyword = 1 股票型 2 货币型 3 债券型
//http://yyapp.1yuaninfo.com/app/application/project.php?act=othermore&keyword=KEYWORD&lastid=LASTID  基金子类的加载更多数据  keyword = 1 股票型 2 货币型 3 债券型
/** 基金接口*/
#define fundUrl  [NSString stringWithFormat:@"%@/app/application/jijin.php",domainUrl]

//http://yyapp.1yuaninfo.com/app/application/company_info.php?comid=
/** 三找公司详情的接口*/
#define companyDetailUrl [NSString stringWithFormat:@"%@/app/application/company_info.php",domainUrl]




#pragma ------------------------------------------------------------------------
#pragma -----------------------  公社界面的接口  ---------------------------------
#pragma 公社接口一致  参数不同
//轮播图:http://yyapp.1yuaninfo.com/app/application/commune.php?act=rollpic
#define communityUrl   [NSString stringWithFormat:@"%@/app/application/commune.php",domainUrl]


#pragma 自媒体轮播图接口
//轮播图:http://yyapp.1yuaninfo.com/app/application/commune.php?act=rollpic
//返回值: {"lb_arr":[ ]}
//参数:  act=rollpic

#pragma 牛人推荐接口  同首页牛人榜

#pragma 更多牛人的接口
//http://yyapp.1yuaninfo.com/app/application/commune.php?act=niumore


#pragma 视频接口
//http://yyapp.1yuaninfo.com/app/application/commune.php?act=cvideo
//返回值：{"v_arr":[],"lastid":null}
//参数：act=cvideo


#pragma 公社视频加载更多接口
//http://yyapp.1yuaninfo.com/app/application/commune.php?act=cvideomore&lastid=LASTID
//返回值:
//参数:  act=cvideomore   lastid=LASTID

#pragma 我的问答接口
//http://yyapp.1yuaninfo.com/app/application/commune.php?act=wenda&userid=USERID
//返回值:
//参数: act=wenda   userid=USERID

#pragma 更多问答接口
//http://yyapp.1yuaninfo.com/app/application/commune.php?act=wenda&userid=USERID&lastid=LASTID
//返回值:
//参数: act=wenda   userid=USERID  lastid=LASTID




#pragma ------------------------------------------------------------------------
#pragma -----------------------  我的界面的接口  ---------------------------------

/** 修改个人信息*/

//头像http://yyapp.1yuaninfo.com/app/application/updateUserHead.php
//参数: file 图片参数  userid
#define mineChangeIconUrl  [NSString stringWithFormat:@"%@/app/application/updateUserHead.php",domainUrl]




#define mineChangeUserInfoUrl  [NSString stringWithFormat:@"%@/app/application/updateUserInfo.php",domainUrl]
//                        ||       ||       ||
//                        ||  全    ||   相   ||  更改个人信息
//                        ||       ||       ||   除头像接口特殊
//                        ||  部    ||   同   ||  其他都是参数不同
//                        ||       ||       ||

#pragma 昵称
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=username&username=老王
//参数: act = username  username = 老王  userid

#pragma 股龄
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=guling&guling=10
//参数:act=guling   guling=10   userid

#pragma 资金量
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=capital&capital=10
//参数:act=capital  capital=10  userid

#pragma 邮箱
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=email&email=qq@aa.con
//参数:act=email    email=xxx@qq.com   userid

#pragma 绑定QQ
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=qqnum&qqnum=101111
//参数:act=qqnum    qqnum=asf87gyfg7sdfgs7yga98  userid

#pragma 绑定微博
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=weibo&weibo=字符串
//参数:act=weibo    weibo=dgs89ud89gsfgus89fgus   userid

#pragma 绑定微信
//http://yyapp.1yuaninfo.com/app/application/updateUserInfo.php?act=weixin&weixin=字符串
//参数:act=weixin   weixin=gsdf8gu9fd9s08gsdfgs8  userid




#pragma 修改手机接口：手机号、验证码验证
//发验证码到新手机号
//http://yyapp.1yuaninfo.com/app/application/register.php?keyword=reg&mobile=
//参数 mobile 手机号,  keyword=reg
//返回值 status:1 成功 status:0 失败 3 失败,已经注册
#define mineChangeTelGetYzmUrl  [NSString stringWithFormat:@"%@/app/application/register.php",domainUrl]


#pragma 验证手机号
//http://yyapp.1yuaninfo.com/app/application/validate.php?mobile=17090028712&yzm=5785010
//参数 mobile 手机号,   yzm 验证码
//返回值 status:0 不能为空,1成功,2插入数据库失败,3验证码超时,4验证码错误
#define mineChangeTelUrl  [NSString stringWithFormat:@"%@/app/application/validate.php",domainUrl]


#pragma 修改密码接口：旧密码、新密码验证
//http://yyapp.1yuaninfo.com/app/application/mod_pwd.php?userid=USERID&oldpwd=pwd& newpwd=pwd
//参数 userid  oldpwd=旧密码   newpwd=新密码
//返回值 states  0 旧密码错误  1 修改成功
#define mineChangePwdUrl  [NSString stringWithFormat:@"%@/app/application/validate.php",domainUrl]



#pragma ------------------------------------------------------------------------
#pragma mark  积分商城  --------------------------------------------------
//返回值 ： hot_arr:[]   tj_arr:[]
//http://yyapp.1yuaninfo.com/app/application/shoppingmall.php  act=goods
#define shopUrl  [NSString stringWithFormat:@"%@/app/application/shoppingmall.php",domainUrl]

#pragma mark  积分规则静态页
#define integrationRuleUrl @"http://yyapp.1yuaninfo.com/app/application/score.php"

//http://yyapp.1yuaninfo.com/app/application/userintegral.php? userid=1499064765j6qavy&act=inall
#define inOutHistoryUrl    [NSString stringWithFormat:@"%@/app/application/userintegral.php",domainUrl]



#pragma mark  IAP 内购给后台发送收据 --------------------------------------

//http://yyapp.1yuaninfo.com/app/application/apple_pay.php  apple_receipt

#define IAPReceiptUrl  [NSString stringWithFormat:@"%@/app/application/apple_pay.php",domainUrl]


#pragma mark  跟自己后台生成预支付订单信息
//yyapp.1yuaninfo.com/app/application/applepay/pre_info.php
//参数  productid  type=商品类型1会员2特色3三找  userid=
//返回  state 1成功0失败
#define preIapOrderUrl  [NSString stringWithFormat:@"%@/app/application/applepay/pre_info.php",domainUrl]



//文章收藏列表查询接口
//http://yyapp.1yuaninfo.com/app/application/usercollect.php?userid=1499064765j6qavy&act=query
//返回值 ： "usercollect": [
//{
//    "id": "62",
//    "col_uid": "1499064765j6qavy",
//    "col_img": "http://yyapp.1yuaninfo.com/app/houtai/uploads/image/20170920/1505894513.jpg",
//    "col_title": "北京小户型新房价格上月重现涨势1",
//    "col_id": "16426",
//    "col_type": "1",
//    "col_time": "2017-09-28 14:30:11",
//    "col_state": "0",
//    "col_deltime": null
//}],
//"lastid": "58"
#pragma 文章收藏列表查询接口  userid=1499064765j6qavy&act=query
#define collectionUrl  [NSString stringWithFormat:@"%@/app/application/usercollect.php",domainUrl]

//添加文章到收藏列表  userid=1499064765j6qavy&act=add&type=1&arid=18546
//删除收藏列表文章  userid=1499064765j6qavy&act=del&colid=7 根据收藏表的id删除
//添加 删除是返回值 1 成功 0失败 收藏状态 1有收藏0 没收藏
//类型:1资讯文章,2资讯视频3牛人文章4公社视频5项目
//查询状态  act=collectstate&id=18588&col_type=1&userid=1499064765j6qavy 根据文章的原始id查询文章有没有被收藏  在文章详情页调用的 未收藏返回state=0 已收藏则返回该文章在收藏表的id  方便在文章详情页取消收藏（因为取消收藏是用收藏表的id删除的）



//我的推送记录接口
//http://yyapp.1yuaninfo.com/app/application/week_moon_list.php
//参数   act =  week周刊   month月刊
//加载更多直接加个参数lastid
#pragma 我的推送记录接口
#define periodUrl  [NSString stringWithFormat:@"%@/app/application/week_moon_list.php",domainUrl]




#pragma ------------------------------------------------------------------------
#pragma mark  ------------------- 个人中心部分固定页面静态链接 ----------------------

#define appleId  @"1266188538"

/** 用户协议与声明*/
#define userProtocolUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/agreement.html"

/** 壹元介绍*/
#define appIntroduceUrl  @"http://yyapp.1yuaninfo.com/app/yyfwapp/announcement.html"


#endif /* API_h */
