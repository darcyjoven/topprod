/*
================================================================================
檔案代號:poi_file
檔案名稱:料件价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poi_file
(
poi01       varchar2(6) DEFAULT ' ' NOT NULL, /*价格条件*/
poi02       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
poi03       varchar2(255),           /*備注                                   */
poi04       varchar2(4),             /*税种                                   */
poi05       number(9,4),             /*税率                                   */
poidate     date,                    /*最近更改日                             */
poigrup     varchar2(10),            /*资料所有部门                           */
poimodu     varchar2(10),            /*资料更改者                             */
poiuser     varchar2(10),            /*资料所有者                             */
poioriu     varchar2(10),            /*资料建立者                             */
poiorig     varchar2(10)             /*资料建立部门                           */
);

alter table poi_file add  constraint poi_pk primary key  (poi01,poi02) enable validate;
grant select on poi_file to tiptopgp;
grant update on poi_file to tiptopgp;
grant delete on poi_file to tiptopgp;
grant insert on poi_file to tiptopgp;
grant index on poi_file to public;
grant select on poi_file to ods;
