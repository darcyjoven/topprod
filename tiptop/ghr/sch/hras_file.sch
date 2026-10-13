/*
================================================================================
檔案代號:hras_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hras_file
(
hras01      varchar2(50) NOT NULL,   /*职位编码                               */
hras02      varchar2(20),            /*所属公司编码                           */
hras03      varchar2(20),            /*职务编码                               */
hras04      varchar2(100),           /*职位名称                               */
hras05      date,                    /*生效日期                               */
hras06      varchar2(10),            /*职位等级                               */
hras07      varchar2(1000),          /*描述                                   */
hras08      varchar2(10),            /*学历要求                               */
hras09      varchar2(10),            /*年龄要求                               */
hras10      varchar2(10),            /*性别要求                               */
hras11      varchar2(50),            /*专业背景                               */
hras12      varchar2(1000),          /*工作经验要求                           */
hras13      varchar2(100),           /*工作时间要求                           */
hrasacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrasuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrasgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrasmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrasdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrasoriu    varchar2(10),            /*资料建立者                             */
hrasorig    varchar2(10)             /*资料建立部门                           */
);

alter table hras_file add  constraint tpc_hras_pk primary key  (hras01) enable validate;
grant select on hras_file to tiptopgp;
grant update on hras_file to tiptopgp;
grant delete on hras_file to tiptopgp;
grant insert on hras_file to tiptopgp;
grant index on hras_file to public;
grant select on hras_file to ods;
