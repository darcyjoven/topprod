/*
================================================================================
檔案代號:idw_file
檔案名稱:ICD制造通知单第二单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idw_file
(
idw01       varchar2(16) DEFAULT ' ' NOT NULL, /*制造通知单号*/
idw02       number(5) DEFAULT '0' NOT NULL, /*项次*/
idw03       number(5) DEFAULT '0' NOT NULL, /*序号*/
idw04       varchar2(3),             /*刻号                                   */
idw05       varchar2(5),             /*BIN                                    */
idw06       varchar2(255),           /*BIN值名称                              */
idw07       varchar2(1) DEFAULT '0' NOT NULL, /*BIN值属性*/
idw08       number(15,3) DEFAULT '0' NOT NULL, /*未备置量(片)*/
idw09       number(15,3) DEFAULT '0' NOT NULL, /*未备置量(DIE)*/
idw10       varchar2(40),            /*料号                                   */
idw11       varchar2(120),           /*品名                                   */
idw12       varchar2(40),            /*完工料号                               */
idw13       varchar2(1) DEFAULT 'N' NOT NULL, /*选择*/
idwlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
idwplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create unique index idw_01 on idw_file (idw01,idw02,idw03);
alter table idw_file add  constraint idw_pk primary key  (idw01,idw02,idw03) enable validate;
grant select on idw_file to tiptopgp;
grant update on idw_file to tiptopgp;
grant delete on idw_file to tiptopgp;
grant insert on idw_file to tiptopgp;
grant index on idw_file to public;
grant select on idw_file to ods;
