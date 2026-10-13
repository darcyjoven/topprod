/*
================================================================================
檔案代號:vbj_file
檔案名稱:工模具主檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbj_file
(
vbj01       varchar2(60) NOT NULL,   /*工模具编号                             */
vbj02       varchar2(60),            /*工模具名称                             */
vbj03       varchar2(60),            /*工模具描述                             */
vbj04       number(1),               /*状态                                   */
vbj05       varchar2(60),            /*上次维护人员                           */
vbj06       date,                    /*上次异动时间                           */
vbj07       number(9),               /*累计使用次数                           */
vbj08       number(9),               /*累计使用时间                           */
vbj09       number(9),               /*累计加工数量                           */
vbj10       date,                    /*前期维修时间                           */
vbj11       number(9),               /*累计维修次数                           */
vbj12       date,                    /*生效日                                 */
vbj13       date,                    /*失效日                                 */
vbj14       varchar2(60),            /*工模具大类编号                         */
vbj15       varchar2(60),            /*APS保留字段文字                        */
vbj16       varchar2(60),            /*APS保留字段文字                        */
vbj17       varchar2(60),            /*APS保留字段文字                        */
vbj18       number(9),               /*APS保留字段数值                        */
vbj19       number(18,8),            /*APS保留字段浮点数                      */
vbj20       number(18,8),            /*APS保留字段浮点数                      */
vbj21       date,                    /*APS保留字段日期                        */
vbj22       date,                    /*APS保留字段日期                        */
vbjlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vbjplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vbj_file add  constraint vbj_pk primary key  (vbjlegal,vbjplant,vbj01) enable validate;
grant select on vbj_file to tiptopgp;
grant update on vbj_file to tiptopgp;
grant delete on vbj_file to tiptopgp;
grant insert on vbj_file to tiptopgp;
grant index on vbj_file to public;
grant select on vbj_file to ods;
