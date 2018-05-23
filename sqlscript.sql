##hashtag-------->hashtag
insert into hashtag.hashtag
select * from HR_HASHTAG.hashtag;


##external_content------->external_content
insert into external_content.external_content(id,title,domain,original_url,icon_url,first_image_url,author,pub_date,summary,content)
select id,title,domain,original_url,icon_url,first_image_url,author,pub_date,summary,content 
from HR_SLP.external_content;


##learning_path------------>learning_play
insert into learning_play.learning_play (id,title,description,creator,recommended,recommended_date,learning_play.learning_play.created_date,last_modified_date) 
select max(id),title,description,hex(u.user_id),recommended,recommended_date,max(create_date),max(modified_date)
from HR_SLP.learning_path lp
left join uaa.cg_user u on u.employee_id COLLATE utf8_unicode_ci =lp.employee_id COLLATE utf8_unicode_ci
group by recommended,title,description,u.user_id,recommended_date;


##learning_hashtag_rel--------->learning_play_hashtag
insert into learning_play.learning_play_hashtag (id,learning_play_id,hashtag_title,created_date,last_modified_date)
SELECT lhr.id,lhr.learning_path_id,ha.title,lhr.sys_created_date,lhr.create_date FROM HR_SLP.learning_hashtag_rel lhr 
left join HR_SLP.learning_path lp 
on lp.id = lhr.learning_path_id
left join HR_HASHTAG.hashtag ha on ha.id=lhr.hashtag_id
where ha.title is not null;



##learning_content_rel--------->learning_play_content


#1).drop temp table
drop temporary table if exists learning_play.temp_table;
#2).create temp table
CREATE TEMPORARY TABLE learning_play.temp_table (
  `id` bigint(20) auto_increment,
  `learning_play_id` bigint(20) unsigned zerofill NOT NULL default 0, 
  `content_type` tinyint(4) NOT NULL,
  `content_ref_id` bigint(20) unsigned zerofill NOT NULL,
  `content_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_icon_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_img_url` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_link` varchar(2048) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_order` int(11) DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_modified_date` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uc_lp_type_refid` (`learning_play_id`,`content_type`,`content_ref_id`)
);
#3).insert data to temp table（type=4 and type=1）
# type= 4  -- enternal content
insert into learning_play.temp_table(learning_play_id,content_type,content_ref_id,content_title,content_icon_url,content_img_url,content_link,content_order,created_date,last_modified_date)
SELECT
	lcr.learning_path_id,
    lcr.content_type_id content_type,
    lcr.entity_id as content_ref_id,
	ec.title tile,
	ec.icon_url content_icon_url,
    ec.first_image_url content_image_url,
	ec.original_url content_link,
    lcr.order content_order,
	lcr.sys_created_date create_date,
	lcr.create_date last_mofified_date
FROM
    HR_SLP.learningpath_content_rel lcr
left join HR_SLP.external_content ec 
on lcr.entity_id=ec.id
where lcr.content_type_id='4' and ec.id is not null;

#type= 1 --news 
insert into learning_play.temp_table(learning_play_id,content_type,content_ref_id,content_title,content_img_url,content_order,created_date,last_modified_date)
SELECT
	lcr.learning_path_id,
    lcr.content_type_id content_type,
    lcr.entity_id as content_ref_id,
	n.title tile,
    n.imageLocation content_image_url,
	lcr.order content_order,
	lcr.sys_created_date create_date,
	lcr.create_date last_mofified_date
FROM
    HR_SLP.learningpath_content_rel lcr
left join hr.news n 
on lcr.entity_id=n.id
where lcr.content_type_id='1' and n.id is not null;

#4).insert date to learning_play_conetent
insert into learning_play.learning_play_content(id,learning_play_id,content_type,content_ref_id,content_title,content_img_url,content_link,content_order,created_date,last_modified_date)
select id,learning_play_id,content_type,content_ref_id,content_title,content_img_url,content_link,content_order,created_date,last_modified_date from learning_play.temp_table;

#5).drop temp table
drop temporary table if exists learning_play.temp_table;


##rate------>learning_play_rating
insert into learning_play.learning_play_rating(id,learning_play_id,rating,rater,created_date,last_modified_date) 
select lpt.id,lpt.learning_path_id,lpt.rate,hex(uc.user_id),lpt.create_date,lpt.modified_date from HR_SLP.rate lpt 
left join uaa.cg_user uc on uc.employee_id COLLATE utf8_unicode_ci=lpt.employee_id COLLATE utf8_unicode_ci where uc.employee_id is not null; 


#HR_SLP.my_saved -->111 my_saved.my_saved;
#type= 1 --news 
insert into my_saved.my_saved(id,owner,entity_type,entity_id,created_date,last_modified_date,title,url)
select max(ms.id),hex(uc.user_id) uid,ms.type,ms.entity_id,ms.create_date,ms.modified_date,ln.title,ln.imageLocation from HR_SLP.my_saved  ms
		left join uaa.cg_user  uc on ms.employee_id COLLATE utf8_unicode_ci= uc.employee_id COLLATE utf8_unicode_ci left join hr.news ln on ln.id=ms.entity_id  where ms.type ="1" and uc.employee_id is not null
		group by ms.entity_id,ln.title,ln.imageLocation,uid;


# type= 2 --learning path
	insert into my_saved.my_saved(id,owner,entity_type,entity_id,created_date,last_modified_date,title)
		select max(ms.id),hex(uc.user_id) uid,ms.type,ms.entity_id,ms.create_date,ms.modified_date,lp.title from HR_SLP.my_saved  ms
		left join uaa.cg_user  uc on ms.employee_id COLLATE utf8_unicode_ci = uc.employee_id COLLATE utf8_unicode_ci left join HR_SLP.learning_path lp on lp.id=ms.entity_id  where ms.type ="2" and uc.employee_id is not null
		group by ms.entity_id,lp.title,uid; 

# type= 4  -- enternal content
		insert into my_saved.my_saved(id,owner,entity_type,entity_id,created_date,last_modified_date,title,icon_url,first_image_url,url)
		select max(ms.id),hex(uc.user_id) uid,ms.type,ms.entity_id,ms.create_date,ms.modified_date,ec.title,ec.icon_url,ec.first_image_url,ec.original_url from HR_SLP.my_saved  ms
		left join uaa.cg_user  uc on ms.employee_id COLLATE utf8_unicode_ci = uc.employee_id COLLATE utf8_unicode_ci left join HR_SLP.external_content ec on ec.id=ms.entity_id  where ms.type ="4" and uc.employee_id is not null
		group by uid,ms.entity_id,ec.title,ec.icon_url,ec.first_image_url,ec.original_url; 


# user-interests
insert into user.interests (id,user_id,title,create_date,modified_date) 
select id,hex(u.user_id),title,create_date,modified_date
from hr_user.interests i
left join uaa.cg_user u on u.global_id COLLATE utf8_unicode_ci =i.employee_id COLLATE utf8_unicode_ci;


#1. notification_msg
INSERT INTO HR_NOTIFICATION.notification_msg (id,description,message,action_ref,action_url,module)
SELECT hm.id,hm.description,hm.message,hm.action_ref,hm.action_url,hm.module FROM hr.notification_msg hm ;

# 2. login_device  
INSERT INTO HR_NOTIFICATION.login_device (id,employeeId,deviceId,deviceToken,deviceType)
SELECT hd.id,hex(uc.user_id),hd.deviceId,hd.deviceToken,hd.deviceType FROM hr.login_device hd 
LEFT JOIN uaa.cg_user  uc ON hd.employeeId COLLATE utf8_unicode_ci = uc.global_id COLLATE utf8_unicode_ci 
WHERE hd.employeeId is not null and uc.user_id is not null and hd.employeeId  not like "%_FS";
	# for production  now useing table is  hr.login_device_v2
	#INSERT INTO HR_NOTIFICATION.login_device (id,employeeId,deviceId,deviceToken,deviceType)
	#SELECT hd.id,hex(uc.user_id),hd.deviceId,hd.deviceToken,hd.deviceType FROM hr.login_device_v2 hd 
	#LEFT JOIN uaa.cg_user  uc ON hd.employeeId COLLATE utf8_unicode_ci = uc.global_id COLLATE utf8_unicode_ci 
	#WHERE hd.employeeId is not null and uc.user_id is not null and hd.employeeId  not like "%_FS";

#3. notification_icon 
INSERT INTO HR_NOTIFICATION.notification_icon (id,employeeId,createTime)
SELECT hd.id,hex(uc.user_id) as employeeId,hd.createTime FROM hr.notification_icon hd 
LEFT JOIN uaa.cg_user  uc ON hd.employeeId COLLATE utf8_unicode_ci = uc.global_id  COLLATE utf8_unicode_ci
WHERE hd.employeeId is not null and uc.user_id is not null and hd.employeeId  not like "%_FS" ;


#4. notifications
INSERT INTO HR_NOTIFICATION.notifications(id,employee_id,notif_msg_id,json_data,msg_type,created_dt,sent_dt)
SELECT  hrn.id,hex(uc.user_id),hrn.notif_msg_id,hrn.json_data,hrn.msg_type,hrn.created_dt,hrn.sent_dt FROM hr.emp_notification_v2  hrn 
left join uaa.cg_user  uc on hrn.employee_id COLLATE utf8_unicode_ci = uc.global_id COLLATE utf8_unicode_ci WHERE hrn.employee_id is not null and uc.user_id is not null;


#hr_search.history->search.history  
insert into search.history(id, user_id, search_content, search_times, created_date)
select id, employee_id as user_id, search_content, time as search_times, sys_create_date as created_date from hr_search.history






