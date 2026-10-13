/*
================================================================================
檔案代號:vav_file
檔案名稱:APS 需求订单选配
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vav_file
(
vav01       varchar2(40) DEFAULT ' ' NOT NULL,
vav02       varchar2(40) DEFAULT ' ' NOT NULL,
vav03       varchar2(60) DEFAULT ' ' NOT NULL,
vav04       varchar2(60) DEFAULT ' ' NOT NULL,
vavplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vavlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vav05       varchar2(60),            /*APS保留字段文字                        */
vav06       varchar2(60),            /*APS保留字段文字                        */
vav07       varchar2(60),            /*APS保留字段文字                        */
vav08       number(9),               /*APS保留字段数值                        */
vav09       number(18,8),            /*APS保留字段浮点数                      */
vav10       number(18,8),            /*APS保留字段浮点数                      */
vav11       date,                    /*APS保留字段日期                        */
vav12       date                     /*APS保留字段日期                        */
);

alter table vav_file add  constraint vav_pk primary key  (vavlegal,vavplant,vav01,vav02,vav03,vav04) enable validate;
grant select on vav_file to tiptopgp;
grant update on vav_file to tiptopgp;
grant delete on vav_file to tiptopgp;
grant insert on vav_file to tiptopgp;
grant index on vav_file to public;
grant select on vav_file to ods;
