/*
================================================================================
檔案代號:hraqa_file
檔案名稱:职称
檔案目的:
上游檔案:hraq_file
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hraqa_file
(
hraqa01     number(5) NOT NULL,      /*项次                                   */
hraqa02     varchar2(100),           /*职称类别                               */
hraqa03     varchar2(100),           /*职称名称                               */
hraqa04     varchar2(20),            /*职称等级编码                           */
hraqa05     varchar2(100),           /*备注                                   */
hraqaacti   varchar2(1),             /*资料有效码                             */
hraqauser   varchar2(10),            /*资料所有者                             */
hraqagrup   varchar2(10),            /*资料所有群                             */
hraqamodu   varchar2(10),            /*资料更改者                             */
hraqadate   date,                    /*最近修改日                             */
hraqaoriu   varchar2(10),            /*资料建立者                             */
hraqaorig   varchar2(10),            /*资料建立部门                           */
hraqa06     varchar2(20)             /*职称编码                               */
);

alter table hraqa_file add  constraint tpc_hraqa_pk primary key  (hraqa01) enable validate;
grant select on hraqa_file to tiptopgp;
grant update on hraqa_file to tiptopgp;
grant delete on hraqa_file to tiptopgp;
grant insert on hraqa_file to tiptopgp;
grant index on hraqa_file to public;
grant select on hraqa_file to ods;
