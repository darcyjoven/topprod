/*
================================================================================
檔案代號:vba_file
檔案名稱:aps(存貨預配紀錄)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vba_file
(
vba01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vba02       varchar2(60) DEFAULT ' ' NOT NULL, /*配给对象*/
vba03       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
vba04       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
vba05       number(15,3),            /*分配量                                 */
vba06       number(15,3),            /*需求数量                               */
vba07       number(1),               /*原物料存货                             */
vba08       varchar2(60),            /*库房位置                               */
vba09       number(1),               /*是否锁定                               */
vba10       number(1),               /*是否为需求订单                         */
vba11       varchar2(60),            /*APS保留字段文字                        */
vba12       varchar2(60),            /*APS保留字段文字                        */
vba13       varchar2(60),            /*APS保留字段文字                        */
vba14       number(9),               /*APS保留字段数值                        */
vba15       number(18,8),            /*APS保留字段浮点数                      */
vba16       number(18,8),            /*APS保留字段浮点数                      */
vba17       date,                    /*APS保留字段日期                        */
vba18       date,                    /*APS保留字段日期                        */
vbalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbaplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vba_file add  constraint vba_pk primary key  (vbalegal,vbaplant,vba01,vba02,vba03,vba04) enable validate;
grant select on vba_file to tiptopgp;
grant update on vba_file to tiptopgp;
grant delete on vba_file to tiptopgp;
grant insert on vba_file to tiptopgp;
grant index on vba_file to public;
grant select on vba_file to ods;
