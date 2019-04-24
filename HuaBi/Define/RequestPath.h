//
//  RequestPath.h
//  jys
//
//  Created by 周勇 on 2017/4/17.
//  Copyright © 2017年 前海数交所. All rights reserved.
//

#ifndef RequestPath_h
#define RequestPath_h

/**
 测试域名：test.yzcet.com
 正式域名：www.yzcet.com
 */

//测试域名
#define kBasePath @"http://test.hbdaex.com"
//
//正式域名
//#define kBasePath @"https://www.hbdaex.com"

//全局权限keyCode
#define kKeyCode @"G0S57a7aADHWIhx0Beluj2chZENHVCd6R8Vn9MeqetVsLLkr9jvdk"

#pragma mark - HTML_LINK

#define AccountManage @"/Mobile/AccountManage/account_all"

#define widthdraw @"/Mobile/AccountManage/widthdraw"

#define bank @"/Mobile/AccountManage/bank"

#define new_name_operation @"/Mobile/Set/new_name_operation"

#define Ctrade @"/Mobile/entrust/Ctrade"

#define helpCenter @"/Mobile/Help/helpCenter"

#define about @"/Mobile/Set/about"

#define contact @"/Mobile/Help/contact"

#define qrcode6 @"/Mobile/User/qrcode6"

#define real_name @"/Mobile/Set/real_name"
//首页文章
#define art_details @"/Mobile/art/details/id"
//首页涨幅榜
#define icon_info_currency @"/Mobile/Entrust/icon_info/currency"
//交易记录
#define icon_history_record @"/Mobile/AccountManage/record_history"
//转入
#define icon_history_in @"/Mobile/Pay/bpay"
//转出
#define icon_history_out @"/Mobile/Pay/tcoin"
//兑换记录
#define icon_exchange_record @"/Mobile/Pay/wallet_record"

#define bcbcom @"http://d.bcbcom.club/q1/"

//Mobile/Set/real_name  基本信息
//Mobile/AccountManage/account_all 我的资产
//Mobile/AccountManage/widthdraw 财务日志
//AccountManage/bank  安全设置
//Mobile/Set/new_name_operation 实名认证
//Mobile/entrust/Ctrade C2C交易
//Mobile/Help/helpCenter 帮助中心
//Mobile/Set/about      关于我们
//Mobile/Help/contact   联系我们
//Mobile/User/qrcode6   我的邀约二维码

//http://d.bcbcom.club/qf app下载
//Mobile/Entrust/icon_info/currency/54 行情详情

#define exchange_record @"/Mobile/entrust/recent_record"

#define operation_des @"/Mobile/art/details/id/664"

#pragma mark - 登录注册
//发送手机验证码
#define kSenderSMS @"Api/Account/sendsms"
//注册
#define kUserRegister @"/Api/Account/mbregister"
//登录
#define kUserLogin @"/Api/account/login"
//发送邮箱验证码
#define KSenderEmail @"/api/account/sendemail"
//找回密码
#define kfindPassword @"mb_index/forgetpwd"
//退出登录
#define kLoginOut @"/api/account/logout"
//修改登录密码
#define kModifyLoginPwd @"district/update_loginpdw"
//修改交易密码
#define kModifyDealPwd @"district/update_paypdw"
//邮箱绑定
#define kBoundEmal @"/api/SetUp/upd_email"
//手势密码验证
#define kGesturePwdCheck @"/api/SetUp/chk_login_pwd"

//app注册教程
#define kAppRegisterLink @"/api/about/app_reg" 

//服务条款
#define kAppServiceRule @"/api/about/app_agree"


//扫一扫
#define kScanForLogin @"mb_index/scanlogin"


//自动登录
#define kAutoLogin @"/api/account/auto_login"
//总资产
#define kProperty @"/api/AccountManage/account_all"





#pragma mark - 购物车
//添加到购物车
#define kAddToCart @"mb_cart/add"
//删除购物车
#define kDeleteCart @"mb_cart/delete"
//购物车列表
#define kCartList @"mb_cart/list"
//购物车增加减少数量
#define kCartGoodsCountChange @"mb_cart/update"
//购物车猜你喜欢
#define kCartGuessLike @"mb_cart/guess_like"

#pragma mark - 首页
//banner
#define kMainBanner @"/mobile/index.php?act=mb_index&op=banner"
//新闻
#define kMainNews @"/mobile/index.php?act=mb_index&op=news"
//首页7图
#define kMain7Pic @"/mobile/index.php?act=mb_index&op=imagespecial"
//首页上面列表
#define kMainGoodList @"mb_index/goodslist"
//首页搜索返回链接
#define kMainSearchUrl @"mb_index/search"

//首页专区
#define kMainSpecial @"mb_index/specialblock"
//热门市场  多图
#define kHotMarket @"mb_index/hotmarket"
//分类10个链接
#define kMain10Links @"mb_index/classlinks"

//分类链接
#define kMainCategory @"mb_index/shopclass"



//商户
#define kStoreList @"mb_store/nearby_store"
//搜索店铺
#define kSearchStore @"mb_store/nearby_store"
//商户轮播图
#define kStoreBanner @"mb_store/storeBanner"
//商户分类
#define kStoreCategory @"mb_store/storeList"









//地址
//地址列表
#define kAddressList @"mb_member_address/address_list"
//编辑地址
#define kEditAddress @"mb_member_address/address_edit"
//添加地址
#define kAddAddress @"mb_member_address/address_add"
//删除地址
#define kDeleteAddress @"mb_member_address/address_del"
//设为默认地址
#define kSetDefaulAddress @"mb_member_address/is_default"


//商品收藏列表
#define kFavorGoodsList @"mb_member_favorites/favorites_list"
//店铺列表
#define kFavorStoreList @"mb_member_favorites/favorites_list"
//删除收藏
#define kDeleteFavor @"mb_member_favorites/favorites_del"

//获取收藏信息
#define kCollectCount @"mb_index/collect_number"



//邀请奖励列表
#define kGetAwardList @"/api/AccountManage/award_list"
//获取邀请url及邀请规则
#define kGetInviteUrl  @"/api/AccountManage/invite_rule"
//获取邀请二维码
#define kGetQRView @"/api/AccountManage/qrcode"
//获取邀请人列表
#define kGetInviteList @"/api/AccountManage/invite_list"
//发送邀请email
#define kSenderInviteEmail @"/api/AccountManage/do_invite"











//分类ID取列表
#define kArtIndex @"/api/art/index"
//文章详情
#define kArtDetail @"/api/art/details"
//文章搜索
#define kArtSearch @"/api/art/search"




//帮助中心
#define kHelpList @"/api/SetUp/help"
//根据文章id获取帮助详情
#define kHeplDetail @"/api/SetUp/get_article"


#pragma mark - 商圈

//发布动态
#define kDistrictPublish @"district/publish"
//获取动态列表
#define kGetDistrictList @"/Api/district/read"

//获取粉丝//关注列表
#define kGetFollows @"district/get_member_follow"
//获取用户资料
#define kGetCircleInfo @"District/members"
//修改用户头像
#define kChangeAvatar @"district/update_headpic"
//关注/取消关注
#define kFollowAction @"district/follows"

//点赞操作
#define kLikeAction @"district/to_like"

#define kCommentList @"district/comment_get"

//评论操作
#define kCommentAction @"district/comment_push"
//删除动态
#define kDeleteDistrict @"district/district_remove"

//搜索动态
#define kSearchDistrict @"district/search"


#pragma mark - 环信
/**  搜索好友  */
#define kSearchUser @"district/searchUser"
//环信好友列表
#define kEMFriendList @"district/friendList"
//添加好友申请
#define kEMAddFriendRequest @"district/friendApplicationAdd"
//好友申请列表
#define kEMFriendRequestList @"district/friendApplicationList"
//同意添加好友
#define kEMAcceptFriendRequest @"district/applicationStatus"
//删除好友申请记录
#define kEMDeleteFrinedRequest @"district/delFriend"

//群列表
#define kEMGroupList @"district/HuanxinGroupList"
//删除群
#define kDeleteEMGroup @"district/HuanxinGroupDel"
//创建群
#define kCreateEMGroup @"district/addHuanxinGroup"
//修改群头像
#define kUpdateEMGroupAvatar @"district/update_huanxin_headpic"
//群成员列表
#define kEMGroupMemberList @"district/getGroupMember"



//获取标签
#define kGetTabs @"/api/AccountManage/get_tabs"
//获取行业
#define kGetProfession @"/api/AccountManage/get_profession"


//获取用户信息
#define kGetUserInfo @"district/memberinfo"


//修改个人资料
#define kUpdataProfile @"district/update_member_info"
//获取卖家信息
#define kGetSellerInfo @"mb_index/getSellerInfo"

//获取商家推荐商品列表
#define kGetRecommendGoodsList @"district/recommendgoods"


//删除评论
#define kDeleteComment @"district/district_comment_remove"

//获取国家
#define kCountrylist @"/Api/Account/countrylist"
//注册
#define kUserRegisterPhone @"/Api/Account/phoneAddReg"
#define kUserRegisterEmail @"/Api/Account/emailAddReg"

//获取群组列表
#define kGetGroup @"/district/group"
//商圈城市列表
#define kGetGroupCityList @"district/citylist"
//获取商圈信息
#define kGetGroupInfo @"district/group"

//发现列表
#define kDiscoverArticleList @"mb_index/getFindArticle"

//关注列表
#define kAttentionList @"District/followlist"

//反馈
#define kFeedBack @"district/feedback_add"
//登出接口
#define loginOut @"Api/Account/logout"
//基本信息
#define memberinfo @"/Api/Account/memberinfo"
//首页
#define index_list @"/Api/Index/index"
//行情
#define quotation_list @"/Api/Trade/quotation1"

#define quotation_detail @"/Api/Trade/quotation"

//我的推荐
#define recommand @"/Api/AccountManage/myinvitation"

#define recommandAB @"/Api/AccountManage/myinvitecount"

#define recommand @"/Api/AccountManage/myinvitation"

#define bonus @"/Api/AccountManage/mybonus"
//挖矿记录
#define mine @"/Api/AccountManage/getOre"
//我的资产
#define mine_myasset @"/Api/AccountManage/account_all"

#define mine_myasset_detail @"/Api/AccountManage/accent_list"

#define mine_myasset_cancel @"/Api/Depute/cancel"

#define mine_myasset_getscale @"/Api/AccountManage/currency_cny"

#define mine_myasset_bi_to_bi @"/Api/AccountManage/bi_to_bi"

//财务日志
#define mine_widthdraw @"/Api/AccountManage/getCurrencyUserStream"
//实名认证
#define name_operation @"/Api/Set/new_name_operation"

#define name_paymode @"/Api/Entrust/admin_way"

#define name_addpaymode @"/Api/Entrust/addPayment"

#define name_banklist @"/Api/Entrust/getBankList"

#define register_agreement @"/Mobile/Art/details/team_id/154"

//
#define new_detail @"/Api/art/index"
//获取交易记录
#define new_c2c_list @"/Api/Entrust/getCOrderList"
//
#define taketokenlist @"/Api/Wallet/currencyList"
//提币
//提币第一步，验证提交信息
#define validateTakeCoin @"/Api/Wallet/validateTakeCoin"
//第二步：验证易盾滑动验证
#define validateYiDun @"/Api/Wallet/validateYiDun"
//第三步：验证支付密码
#define validatePayPwd @"/Api/Wallet/validatePayPwd"
//第四步：提币发送短信验证码
#define tcoinSandPhone @"/Api/Wallet/tcoinSandPhone"
//提币第五步，提交提币信息
#define submitTakeCoin @"/Api/Wallet/submitTakeCoin"
#define wallet_record @"/Api/Wallet/wallet_record"
#define get_address_list @"/Api/Wallet/get_address_list"

#endif /* RequestPath_h */
