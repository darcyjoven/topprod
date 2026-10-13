/*
================================================================================
檔案代號:voh_file
檔案名稱:aps(製令製程內容)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table voh_file
(
voh00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
voh01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
voh02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
voh03       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
voh04       number(1),               /*是否数量变更                           */
voh05       number(1),               /*是否日期变更                           */
voh06       number(1),               /*是否使用工单工艺资料                   */
voh07       varchar2(1),             /*变更码                                 */
voh08       varchar2(60),            /*APS保留字段文字                        */
voh09       varchar2(60),            /*APS保留字段文字                        */
voh10       varchar2(60),            /*APS保留字段文字                        */
voh11       number(9),               /*APS保留字段数值                        */
voh12       number(18,8),            /*APS保留字段浮点数                      */
voh13       number(18,8),            /*APS保留字段浮点数                      */
voh14       date,                    /*APS保留字段日期                        */
voh15       date,                    /*APS保留字段日期                        */
vohlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vohplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table voh_file add  constraint voh_pk primary key  (voh00,voh01,voh02,voh03) enable validate;
grant select on voh_file to tiptopgp;
grant update on voh_file to tiptopgp;
grant delete on voh_file to tiptopgp;
grant insert on voh_file to tiptopgp;
grant index on voh_file to public;
grant select on voh_file to ods;
