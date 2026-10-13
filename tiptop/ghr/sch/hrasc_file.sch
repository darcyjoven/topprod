/*
================================================================================
檔案代號:hrasc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrasc_file
(
hrasc01     varchar2(50) NOT NULL,   /*职位编码                               */
hrasc02     number(5) NOT NULL,      /*项次                                   */
hrasc03     varchar2(255),           /*课程编号                               */
hrasc04     varchar2(20),            /*课程名称                               */
hrasc05     varchar2(20),            /*培训类别                               */
hrasc06     varchar2(20),            /*培训性质                               */
hrasc07     varchar2(200)            /*培训课程描述                           */
);

alter table hrasc_file add  constraint tpc_hrasc_pk primary key  (hrasc01,hrasc02) enable validate;
grant select on hrasc_file to tiptopgp;
grant update on hrasc_file to tiptopgp;
grant delete on hrasc_file to tiptopgp;
grant insert on hrasc_file to tiptopgp;
grant index on hrasc_file to public;
grant select on hrasc_file to ods;
