/*
================================================================================
檔案代號:boh_file
檔案名稱:固定属性变更单身档
檔案目的:固定属性变更单身档 双档单身
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table boh_file
(
boh01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
boh02       number(10) DEFAULT '0' NOT NULL, /*固定属性项次*/
boh03       varchar2(40) DEFAULT ' ' NOT NULL, /*原主件款式*/
boh04       varchar2(20) NOT NULL,   /*原特性代码                             */
boh05       varchar2(40) DEFAULT ' ' NOT NULL, /*原元件款式*/
boh06       varchar2(10) DEFAULT ' ' NOT NULL, /*属性编号*/
boh07       varchar2(20),            /*原属性值/主件属性代码                  */
boh08       date,                    /*原生效日期                             */
boh09       date,                    /*原失效日期                             */
boh10       varchar2(1),             /*原固定属性类型                         */
boh11       varchar2(1) DEFAULT ' ' NOT NULL, /*变更方式*/
boh12       varchar2(20),            /*新属性值/主件属性代码                  */
boh13       date,                    /*新生效日期                             */
boh14       date,                    /*新失效日期                             */
boh15       varchar2(1)              /*新固定属性类型                         */
);

alter table boh_file add  constraint boh_pk primary key  (boh01,boh02,boh03,boh04,boh05) enable validate;
grant select on boh_file to tiptopgp;
grant update on boh_file to tiptopgp;
grant delete on boh_file to tiptopgp;
grant insert on boh_file to tiptopgp;
grant index on boh_file to public;
grant select on boh_file to ods;
