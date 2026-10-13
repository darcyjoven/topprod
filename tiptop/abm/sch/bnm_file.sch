/*
================================================================================
檔案代號:bnm_file
檔案名稱:料件承认申请单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bnm_file
(
bnm01       varchar2(20) DEFAULT ' ' NOT NULL, /*料件承认申请单号*/
bnm02       date,                    /*申请日期                               */
bnm03       varchar2(10),            /*申请人员                               */
bnm04       varchar2(10),            /*申请部门                               */
bnm05       varchar2(10),            /*承认厂商                               */
bnm06       varchar2(1),             /*承认状态                               */
bnm07       varchar2(1) DEFAULT 'N' NOT NULL, /*No Use*/
bnmdate     date,                    /*最近更改日                             */
bnmgrup     varchar2(10),            /*资料所有部门                           */
bnmmodu     varchar2(10),            /*资料更改者                             */
bnmuser     varchar2(10),            /*资料所有者                             */
bnmacti     varchar2(1),             /*资料有效码                             */
bnmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
bnmoriu     varchar2(10),            /*资料建立者                             */
bnmorig     varchar2(10),            /*资料建立部门                           */
bnm08       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
bnmmksg     varchar2(1) DEFAULT 'N' NOT NULL /*是否签核*/
);

alter table bnm_file add  constraint bnm_pk primary key  (bnm01) enable validate;
grant select on bnm_file to tiptopgp;
grant update on bnm_file to tiptopgp;
grant delete on bnm_file to tiptopgp;
grant insert on bnm_file to tiptopgp;
grant index on bnm_file to public;
grant select on bnm_file to ods;
