/*
================================================================================
檔案代號:hrbb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbb_file
(
hrbb00      varchar2(20) NOT NULL,   /*员工奖惩编号                           */
hrbb01      varchar2(20),            /*员工ID                                 */
hrbb02      varchar2(20),            /*奖惩类别编码                           */
hrbb03      varchar2(20),            /*奖惩编码                               */
hrbb04      number(5),               /*奖惩次数                               */
hrbb05      date,                    /*记录日期                               */
hrbb06      date,                    /*生效日期                               */
hrbb07      varchar2(1),             /*是否计入薪资                           */
hrbb08      varchar2(100),           /*薪资月                                 */
hrbb09      varchar2(2),             /*薪资开账期间                           */
hrbb10      varchar2(4),             /*失效薪资年                             */
hrbb11      varchar2(2),             /*失效薪资期间                           */
hrbbacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbbuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbbgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbbmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbbdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbboriu    varchar2(10),            /*资料建立者                             */
hrbborig    varchar2(10),            /*资料建立部门                           */
hrbb12      number(15,2)             /*奖惩金额                               */
);

alter table hrbb_file add  constraint tpc_hrbb_pk primary key  (hrbb00) enable validate;
grant select on hrbb_file to tiptopgp;
grant update on hrbb_file to tiptopgp;
grant delete on hrbb_file to tiptopgp;
grant insert on hrbb_file to tiptopgp;
grant index on hrbb_file to public;
grant select on hrbb_file to ods;
