/*
================================================================================
檔案代號:hrcka_file
檔案名稱:人员群组单身档
檔案目的:人员群组单身档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrcka_file
(
hrcka01     varchar2(20) NOT NULL,   /*群组编号                               */
hrcka02     number(5) NOT NULL,      /*序号                                   */
hrcka03     varchar2(20),            /*过滤字段1                              */
hrcka04     varchar2(2),             /*条件1                                  */
hrcka05     varchar2(60),            /*值1                                    */
hrcka06     varchar2(20),            /*过滤字段2                              */
hrcka07     varchar2(2),             /*条件2                                  */
hrcka08     varchar2(60),            /*值2                                    */
hrcka09     varchar2(20),            /*过滤字段3                              */
hrcka10     varchar2(2),             /*条件3                                  */
hrcka11     varchar2(60),            /*值3                                    */
hrcka12     varchar2(20),            /*过滤字段4                              */
hrcka13     varchar2(2),             /*条件4                                  */
hrcka14     varchar2(60),            /*值4                                    */
hrcka15     varchar2(255)            /*备注                                   */
);

create unique index tpc_hraca01 on hrcka_file (hrcka01,hrcka02);
alter table hrcka_file add  constraint tpc_hrcka_pk primary key  (hrcka01,hrcka02) enable validate;
grant select on hrcka_file to tiptopgp;
grant update on hrcka_file to tiptopgp;
grant delete on hrcka_file to tiptopgp;
grant insert on hrcka_file to tiptopgp;
grant index on hrcka_file to public;
grant select on hrcka_file to ods;
