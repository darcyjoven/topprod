/*
================================================================================
檔案代號:hrasb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrasb_file
(
hrasb01     varchar2(50) NOT NULL,   /*职位编码                               */
hrasb02     number(5) NOT NULL,      /*项次                                   */
hrasb03     varchar2(255),           /*考核指标名称                           */
hrasb04     number(5,2),             /*权重                                   */
hrasb05     varchar2(20),            /*目标值                                 */
hrasb06     varchar2(200)            /*考核指标描述                           */
);

alter table hrasb_file add  constraint tpc_hrasb_pk primary key  (hrasb01,hrasb02) enable validate;
grant select on hrasb_file to tiptopgp;
grant update on hrasb_file to tiptopgp;
grant delete on hrasb_file to tiptopgp;
grant insert on hrasb_file to tiptopgp;
grant index on hrasb_file to public;
grant select on hrasb_file to ods;
