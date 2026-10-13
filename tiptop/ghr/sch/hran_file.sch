/*
================================================================================
檔案代號:hran_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hran_file
(
hran01      varchar2(20) NOT NULL,   /*所属公司ID                             */
hran02      varchar2(1),             /*是否自动点名                           */
hran03      varchar2(10),            /*薪资开账年                             */
hran04      varchar2(20),            /*薪资开账月                             */
hran05      varchar2(10),            /*直接试用期月数                         */
hran06      varchar2(10),            /*间接试用期月数                         */
hranacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hranuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrangrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hranmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrandate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hranoriu    varchar2(10),            /*资料建立者                             */
hranorig    varchar2(10)             /*资料建立部门                           */
);

alter table hran_file add  constraint tpc_hran_pk primary key  (hran01) enable validate;
grant select on hran_file to tiptopgp;
grant update on hran_file to tiptopgp;
grant delete on hran_file to tiptopgp;
grant insert on hran_file to tiptopgp;
grant index on hran_file to public;
grant select on hran_file to ods;
